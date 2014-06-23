//
//  FTConverterFactory.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTConverterFactory.h"
#import "FTGainConverter.h"

@implementation FTConverterFactory

+(id <FTConverter>) createWithMap:(NSMutableDictionary *) dataMap
{
    id <FTConverter> converter;
    
    converter = [[FTGainConverter alloc] init];
    converter.dataMap = dataMap;
    
    return converter;
}

@end
