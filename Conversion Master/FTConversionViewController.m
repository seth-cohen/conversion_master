//
//  FTConversionViewController.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTConversionViewController.h"
#import "FTConverterFactory.h"

@interface FTConversionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property id<FTConverter> converter;

@end

@implementation FTConversionViewController

- (void) loadTypeDataFromResource:(NSString *) fileName
{
    //self.dataMap = [[NSMutableDictionary alloc] init];
    
    NSError *error = nil;
    NSURL *resourceFile = [[NSBundle mainBundle] URLForResource:[fileName lowercaseString] withExtension:@"plist"];
    
    NSData *resourceData = [NSData dataWithContentsOfURL:resourceFile options:0 error:&error];
    if (resourceData) {
        NSDictionary* resources = [NSPropertyListSerialization propertyListWithData:resourceData options:0 format:NULL error:&error];
        if (resources) {
            self.dataMap = resources[@"map"];
            self.basis = resources[@"basis"];
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
        NSLog(@"load converter");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.text = self.currentUnitType;
    self.title = self.currentUnitType;
    
    [self loadTypeDataFromResource:[self.currentUnitType stringByAppendingString:@"_data"]];
    
    if (self.dataMap != nil){
        self.converter = [FTConverterFactory createWithMap:self.dataMap];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataMap count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = [self.dataMap allKeys][indexPath.row];
    NSString *current = [self.dataMap allKeys][indexPath.row];
    cell.textLabel.text = [[[self.converter convertValue:2.0 from:self.basis to:current] stringValue] stringByAppendingString:current];
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
