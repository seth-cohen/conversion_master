//
//  FTConverter.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/25/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTConverter.h"
#import "FTGainConverter.h"
#import "FTGainOffsetConverter.h"

@implementation FTConverter

+(instancetype) converterWithMap:(NSMutableDictionary *) dataMap type:(ConverterType)type
{
    FTConverter *converter;
    
    if (type == GAIN) {
        converter = [[FTGainConverter alloc] init];
    }
    else if (type == GAIN_OFFSET) {
        converter = [[FTGainOffsetConverter alloc] init];
    }
    converter.dataMap = dataMap;
    
    return converter;
}

-(NSNumber *)convertValue:(double)value from:(NSString *)first to:(NSString *)second
{
    //do nothing;
    return @42;
}

@end
