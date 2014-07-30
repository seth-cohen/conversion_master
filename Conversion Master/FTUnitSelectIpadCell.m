//
//  FTUnitSelectTableViewCell.m
//  Conversion Master
//
//  Created by Seth Cohen on 7/3/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTUnitSelectIpadCell.h"

@implementation FTUnitSelectIpadCell

- (void)awakeFromNib
{
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor yellowColor];
    self.selectedBackgroundView = selectionColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
