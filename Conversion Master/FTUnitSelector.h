//
//  FTUnitSelector.h
//  Conversion Master
//
//  Created by Seth Cohen on 7/3/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTUnitSelector : NSObject
+ (instancetype) newUnitSelectorFromPlist:(NSString *) fileName;
- (instancetype) initFromPlist:(NSString *)fileName;
- (NSString *) unitAtIndex:(NSUInteger) index;
- (NSInteger) countOfUnitTypes;
@end
