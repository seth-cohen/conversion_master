//
//  FTUnitSelectDelegate.h
//  Conversion Master
//
//  Created by Seth Cohen on 7/3/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FTUnitSelectDelegate <NSObject>
@required
- (void) unitWasSelected:(NSString *) unitName;
@end
