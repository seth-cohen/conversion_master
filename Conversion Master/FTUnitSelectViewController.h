//
//  FTUnitSelectViewController.h
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTUnitSelectCell.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface FTUnitSelectViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegate, GADBannerViewDelegate>

@property GADBannerView *bannerAd;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
