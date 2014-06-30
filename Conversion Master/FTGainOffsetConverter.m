//
//  FTGainOffsetConverter.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/29/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTGainOffsetConverter.h"

@implementation FTGainOffsetConverter

-(NSNumber *) convertValue:(double)value from:(NSString *)first to:(NSString *)second
{
    @try {        
        // convert value to basis
        // get the factor and the offset [string should be formatted "factor|offset"
        NSArray *splitString = [[self.dataMap objectForKey:first] componentsSeparatedByString:@"|"];
        double factor = [splitString[0] doubleValue];
        double offset = [splitString[1] doubleValue];
        double result = (value+offset)/factor;
        
        // convert from base to final
        splitString = [[self.dataMap objectForKey:second]  componentsSeparatedByString:@"|"];
        factor = [splitString[0] doubleValue];
        offset = [splitString[1] doubleValue];
        result = result*factor-offset;
        
        return [NSNumber numberWithDouble:result];
    }
    
    @catch ( NSException *e ) {
        // Print exception information
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", e.name);
        NSLog( @"Reason: %@", e.reason );
    }
    return nil;
}

@end
