//
//  UITextField+CustomKeyboard.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/27/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "UITextField+CustomKeyboard.h"

@implementation UITextField (CustomKeyboard)
- (NSRange)selectedRange {
    UITextRange *tr = [self selectedTextRange];
    
    NSInteger spos = [self offsetFromPosition:self.beginningOfDocument toPosition:tr.start];
    NSInteger epos = [self offsetFromPosition:self.beginningOfDocument toPosition:tr.end];
    
    return NSMakeRange(spos, epos - spos);
}
@end
