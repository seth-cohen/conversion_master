//
//  FTUnitSelectViewController.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTUnitSelectViewController.h"
#import "FTConversionViewController.h"

@interface FTUnitSelectViewController ()

@end

@implementation FTUnitSelectViewController

- (void) loadInitialData
{
    self.unitTypes = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    NSURL *resourceFile = [[NSBundle mainBundle] URLForResource:@"unit_types" withExtension:@"plist"];
    
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInitialData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"unitSelected"]) {
        FTConversionViewController *destination = (FTConversionViewController *) [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        NSString *selectedItem = self.unitTypes[indexPath.row];
        
        NSLog(@"Selected Item Name: %@", selectedItem);
        destination.currentUnitType = [selectedItem copy];
    }
}

#pragma mark Collection View Data Source

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.unitTypes count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FTUnitSelectCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"TypeCell"
                                    forIndexPath:indexPath];
    
    cell.label.text = [self.unitTypes objectAtIndex:indexPath.row];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
