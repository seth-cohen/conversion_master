//
//  FTScientificInputViewController.h
//  Conversion Master
//
//  Created by Seth Cohen on 6/25/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTScientificInputViewController : UIViewController
<UITextFieldDelegate, UIInputViewAudioFeedback>

@property (weak, nonatomic) IBOutlet UIButton *button_1;
@property (weak, nonatomic) IBOutlet UIButton *button_2;
@property (weak, nonatomic) IBOutlet UIButton *button_3;
@property (weak, nonatomic) IBOutlet UIButton *button_4;
@property (weak, nonatomic) IBOutlet UIButton *button_5;
@property (weak, nonatomic) IBOutlet UIButton *button_6;
@property (weak, nonatomic) IBOutlet UIButton *button_7;
@property (weak, nonatomic) IBOutlet UIButton *button_8;
@property (weak, nonatomic) IBOutlet UIButton *button_9;
@property (weak, nonatomic) IBOutlet UIButton *button_0;
@property (weak, nonatomic) IBOutlet UIButton *button_exp;
@property (weak, nonatomic) IBOutlet UIButton *button_done;
@property (weak, nonatomic) IBOutlet UIButton *button_left;
@property (weak, nonatomic) IBOutlet UIButton *button_right;
@property (weak, nonatomic) IBOutlet UIButton *button_all;
@property (weak, nonatomic) IBOutlet UIButton *button_back;

@property (strong, nonatomic) IBOutlet UIView *viewContainer;

- (IBAction)buttonTapped:(id)sender;
- (IBAction)doneTapped;
- (IBAction)selectAllTapped;
- (IBAction)backTapped;
- (IBAction)directionTapped:(id)sender;
- (IBAction)expTapped;
- (IBAction)minusTapped;

@end
