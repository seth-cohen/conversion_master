//
//  FTConversionViewController.h
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface FTConversionViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate>

@property NSString *currentUnitType;
@property NSString *basis;
@property int sigFigs;

@property GADBannerView *bannerAd;

@end
