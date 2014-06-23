//
//  FTConverter.h
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FTConverter <NSObject>

@property (weak) NSMutableDictionary *dataMap;

-(NSNumber *) convertValue:(double)value from:(NSString *)first to:(NSString *)second;

@end
