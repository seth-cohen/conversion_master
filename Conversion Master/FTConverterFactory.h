//
//  FTConverterFactory.h
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTConverter.h"

@interface FTConverterFactory : NSObject
+(id <FTConverter>) createWithMap:(NSMutableDictionary *) dataMap;
@end
