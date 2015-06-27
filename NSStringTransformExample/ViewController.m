//
//  ViewController.m
//  NSStringTransformExample
//
//  Created by Harshita on 27/06/15.
//  Copyright © 2015 Harshita. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *emojiDescription;
@property (weak, nonatomic) IBOutlet UITextField *emojiInput;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emojiInput.delegate = self;
    [self.emojiInput becomeFirstResponder];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark

-(void)updateEmojiDescription:(NSString*)emoji{
    
    NSString* emoDescription = [emoji stringByApplyingTransform:NSStringTransformToUnicodeName reverse:NO];
    
    NSString * start = @"{";
    NSString * end   = @"}";
    NSScanner* scanner = [NSScanner scannerWithString:emoDescription];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            [self.emojiDescription setText:result];
        }
    }else{
        [self.emojiDescription setText:@""];
    }
}

#pragma mark

// https://gist.github.com/cihancimen/4146056
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

#pragma mark - UITextField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length == 0){
        [self updateEmojiDescription:@""];
        return YES;
    }
    
    if([self stringContainsEmoji:string]){
        textField.text = string;
        [self updateEmojiDescription:string];
    }
    return NO;
}


@end
