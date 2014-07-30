//
//  FTUnitSelector.m
//  Conversion Master
//
//  Created by Seth Cohen on 7/3/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTUnitSelector.h"

@interface FTUnitSelector ()
@property NSMutableArray *unitTypes;
@end

@implementation FTUnitSelector
+ (instancetype) newUnitSelectorFromPlist:(NSString *)fileName {
    return [[self alloc] initFromPlist:fileName];
}

- (instancetype) initFromPlist:(NSString *) fileName {
    self = [super init];
    
    if (self) {
        self.unitTypes = [[NSMutableArray alloc] init];
        
        NSError *error = nil;
        NSURL *resourceFile = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"plist"];
        
        NSData *resourceData = [NSData dataWithContentsOfURL:resourceFile options:0 error:&error];
        if (resourceData) {
            NSDictionary* resources = [NSPropertyListSerialization propertyListWithData:resourceData options:0 format:NULL error:&error];
            if (resources) {
                NSArray* myArray = resources[@"unitTypeArray"];
                for (NSString *name in myArray) {
                    [self.unitTypes addObject:name];
                }
            } else {
                NSLog(@"Error: Could not read plist data from %@: %@", resourceFile, error);
            }
        } else {
            NSLog(@"Error: Could not read file data at %@: %@", resourceFile, error);
        }
    }
    return self;
}

- (NSString *) unitAtIndex:(NSUInteger)index {
    if (index < [self.unitTypes count]) {
        return [self.unitTypes objectAtIndex:index];
    }
    return nil;
}

- (NSInteger) countOfUnitTypes {
    return [self.unitTypes count];
}
@end
