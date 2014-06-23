//
//  FTGainConverter.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTGainConverter.h"


@implementation FTGainConverter
@ synthesize dataMap;

-(NSNumber *) convertValue:(double)value from:(NSString *)first to:(NSString *)second
{
    @try {
        // convert value to basis
        double factor = [[self.dataMap objectForKey:first] doubleValue];
        double result = value/factor;
        
        // convert from base to final
        factor = [[self.dataMap objectForKey:second] doubleValue];
        result = result*factor;
        
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
