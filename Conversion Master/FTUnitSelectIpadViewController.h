//
//  FTUnitSelectTableViewController.h
//  Conversion Master
//
//  Created by Seth Cohen on 7/2/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTUnitSelectDelegate.h"

@interface FTUnitSelectIpadViewController : UITableViewController
@property id<FTUnitSelectDelegate> delegate;
@end
