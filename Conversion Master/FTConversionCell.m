//
//  FTConversionCell.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/25/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTConversionCell.h"

@implementation FTConversionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialization code
        NSLog(@"Called initWithFram on Conversion Cell");
    }
    
    return self;
}

- (void)awakeFromNib
{
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor yellowColor];
    self.selectedBackgroundView = selectionColor;
}

@end
