//
//  FTUnitSelectCell.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTUnitSelectCell.h"

@implementation FTUnitSelectCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialization code
        NSLog(@"Called initWithFram on UnitCell");
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor
                              colorWithRed:0xB2/255.0f
                              green:0xB2/255.0f
                              blue:0x00/255.0f
                              alpha:1].CGColor;
    return;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
