//
//  FTConverter.h
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ConverterType) { GAIN, GAIN_OFFSET } ;

@interface FTConverter: NSObject

@property NSMutableDictionary *dataMap;

+(instancetype) converterWithMap:(NSMutableDictionary *) dataMap type:(ConverterType) type;
-(NSNumber *) convertValue:(double)value from:(NSString *)first to:(NSString *)second;

@end
