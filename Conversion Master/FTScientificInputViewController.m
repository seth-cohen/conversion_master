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
- (IBAction)buttonTapped:(id)sender {
    NSString *text; // determine text for the button that was tapped
    
    text = [sender currentTitle];
    
    if ([self.textInput  respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        if ([self.textInput shouldChangeTextInRange:[self.textInput  selectedTextRange] replacementText:text]) {
            [self.textInput insertText:text];
        }
    } else if (self.fieldShouldChange) {
        NSRange range = [(UITextField *)self.textInput selectedRange];
        if ([[(UITextField *)self.textInput delegate] textField:(UITextField *)self.textInput shouldChangeCharactersInRange:range replacementString:text]) {
            [self.textInput insertText:text];
        }
    } else if (self.viewShouldChange) {
        NSRange range = [(UITextView *)self.textInput selectedRange];
        if ([[(UITextView *)self.textInput delegate] textView:(UITextView *)self.textInput shouldChangeTextInRange:range replacementText:text]) {
            [self.textInput insertText:text];
        }
    } else {
        [self.textInput insertText:text];
    }
}

- (IBAction)doneTapped
{
    [(UIResponder *)self.textInput resignFirstResponder];
}

@end
