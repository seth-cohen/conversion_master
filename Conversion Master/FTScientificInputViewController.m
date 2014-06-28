//
//  FTScientificInputViewController.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/25/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTScientificInputViewController.h"
#import "UITextField+CustomKeyboard.h"

@interface FTScientificInputViewController ()
@property BOOL fieldShouldChange;
@property BOOL viewShouldChange;
@property id<UITextInput> textInput;
@end

@implementation FTScientificInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CALayer *container = self.view.layer;
        container.borderWidth = 2.0f;
        container.borderColor = [UIColor blackColor].CGColor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkInput:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This is used to obtain the current text field/view that is now the first responder
- (void)checkInput:(NSNotification *)notification {
    UITextField *field = notification.object;
    
    if (field.inputView && self.view == field.inputView) {
        self.textInput = field;
        
        self.viewShouldChange = NO;
        self.fieldShouldChange = NO;
        if ([self.textInput isKindOfClass:[UITextField class]]) {
            id<UITextFieldDelegate> del = [(UITextField *)self.textInput delegate];
            if ([del respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                self.fieldShouldChange = YES;
            }
        } else if ([self.textInput isKindOfClass:[UITextView class]]) {
            id<UITextViewDelegate> del = [(UITextView *)self.textInput delegate];
            if ([del respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
                self.viewShouldChange = YES;
            }
        }
    }
}

#pragma mark - UIViewAudioFeedback
-(BOOL) enableInputClicksWhenVisible
{
    return YES;
}

#pragma mark - Text Input
- (IBAction)selectAllTapped
{
    UITextRange *range = [self.textInput textRangeFromPosition:self.textInput.beginningOfDocument toPosition:self.textInput.endOfDocument];
    
    [self.textInput setSelectedTextRange:range];
}

- (IBAction)backTapped {
    id<UITextInput> input = self.textInput;
    
    if ([input respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        UITextRange *range = [input selectedTextRange];
        if ([range.start isEqual:range.end]) {
            UITextPosition *newStart = [input positionFromPosition:range.start inDirection:UITextLayoutDirectionLeft offset:1];
            range = [input textRangeFromPosition:newStart toPosition:range.end];
        }
        if ([input shouldChangeTextInRange:range replacementText:@""]) {
            [input deleteBackward];
        }
    } else if (self.fieldShouldChange) {
        NSRange range = [(UITextField *)input selectedRange];
        if (range.length == 0) {
            if (range.location > 0) {
                range.location--;
                range.length = 1;
            }
        }
        if ([[(UITextField *)input delegate] textField:(UITextField *)input shouldChangeCharactersInRange:range replacementString:@""]) {
            [input deleteBackward];
        }
    } else if (self.viewShouldChange) {
        NSRange range = [(UITextView *)input selectedRange];
        if (range.length == 0) {
            if (range.location > 0) {
                range.location--;
                range.length = 1;
            }
        }
        if ([[(UITextView *)input delegate] textView:(UITextView *)input shouldChangeTextInRange:range replacementText:@""]) {
            [input deleteBackward];
        }
    } else {
        [input deleteBackward];
    }
}

- (IBAction)directionTapped:(id)sender {
    UITextLayoutDirection direction;
    if (sender == self.button_left) {
        direction = UITextLayoutDirectionLeft;
    }
    else if(sender == self.button_right) {
        direction = UITextLayoutDirectionRight;
    }
    
    id<UITextInput> input = self.textInput;
    
    UITextRange *selRange = input.selectedTextRange;
    UITextPosition *startPos = selRange.start;
    UITextPosition *newPos = [input positionFromPosition:startPos inDirection:direction offset:1];
    
    //make a 0 length range at position
    UITextRange *newRange = [input textRangeFromPosition:newPos toPosition:newPos];
    [input setSelectedTextRange:newRange];
}

- (IBAction)expTapped
{
    id<UITextInput> input = self.textInput;
    
    UITextRange *selRange = input.selectedTextRange;
    UITextPosition *startPos = selRange.start;
    
    //get all text and position of the cursor
    UITextRange *fullRange = [input textRangeFromPosition:[input beginningOfDocument] toPosition:[input endOfDocument]];
    NSString *text = [input textInRange:fullRange];
    NSInteger position = [input offsetFromPosition:[input beginningOfDocument] toPosition:startPos];
    
    // an 'e' cannot appear twice or be the first character in the string representing the double
    if ( position != 0 && ([text rangeOfString:@"e"].location == NSNotFound)) {
        [input insertText:@"e"];
    }
}

- (IBAction)minusTapped
{
    id<UITextInput> input = self.textInput;
    
    UITextRange *selRange = input.selectedTextRange;
    UITextPosition *startPos = selRange.start;
    
    //get all text and position of the cursor
    UITextRange *fullRange = [input textRangeFromPosition:[input beginningOfDocument] toPosition:[input endOfDocument]];
    NSString *text = [input textInRange:fullRange];
    NSInteger position = [input offsetFromPosition:[input beginningOfDocument] toPosition:startPos];
    
    // a '-' can only appear at beginning or after an e and there can only one before or after the 'e'
    if ( position == 0 || ([text rangeOfString:@"e"].location == position - 1)) {
        [input insertText:@"-"];
    }
}

- (IBAction)buttonTapped:(id)sender {
    id<UITextInput> input = self.textInput;
    
    NSString *text; // determine text for the button that was tapped
    text = [sender currentTitle];
    
    if ([input respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        if ([input shouldChangeTextInRange:[input selectedTextRange] replacementText:text]) {
            [input insertText:text];
        }
    } else if (self.fieldShouldChange) {
        NSRange range = [(UITextField *)input selectedRange];
        if ([[(UITextField *)input delegate] textField:(UITextField *)input shouldChangeCharactersInRange:range replacementString:text]) {
            [input insertText:text];
        }
    } else if (self.viewShouldChange) {
        NSRange range = [(UITextView *)input selectedRange];
        if ([[(UITextView *)input delegate] textView:(UITextView *)input shouldChangeTextInRange:range replacementText:text]) {
            [input insertText:text];
        }
    } else {
        [input insertText:text];
    }
}

- (IBAction)doneTapped
{
    [(UIResponder *)self.textInput resignFirstResponder];
}



@end
