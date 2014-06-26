//
//  FTConversionViewController.h
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTConversionViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property NSString *currentUnitType;
@property NSString *basis;
@property int sigFigs;

@end
