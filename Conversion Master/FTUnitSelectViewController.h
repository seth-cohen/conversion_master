//
//  FTUnitSelectViewController.h
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTUnitSelectCell.h"

@interface FTUnitSelectViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegate>

@property NSMutableArray *unitTypes;

@end
