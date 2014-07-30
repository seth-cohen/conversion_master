//
//  FTConversionIpadViewController.h
//  Conversion Master
//
//  Created by Seth Cohen on 7/3/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTUnitSelectDelegate.h"

@interface FTConversionIpadViewController : UIViewController <FTUnitSelectDelegate, UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate>

@property NSString *currentUnitType;
@property NSString *basis;
@property int sigFigs;

@end
