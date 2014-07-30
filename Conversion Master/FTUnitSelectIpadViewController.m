//
//  FTUnitSelectTableViewController.m
//  Conversion Master
//
//  Created by Seth Cohen on 7/2/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTUnitSelectIpadViewController.h"
#import "FTUnitSelectIpadCell.h"
#import "FTUnitSelector.h"

@interface FTUnitSelectIpadViewController ()
@property FTUnitSelector *unitSelector;
@end

@implementation FTUnitSelectIpadViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.unitSelector = [FTUnitSelector newUnitSelectorFromPlist:@"unit_types"];
}

- (void)viewWillAppear:(BOOL)animated
{
    // set the default selected row to get highlighting
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionNone];
    
    // calling selectRowAtIndexPath does not trigger notifications or delegate calls
    // let's call it manually
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.unitSelector countOfUnitTypes];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FTUnitSelectIpadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnitSelectTableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.unitLabel.text = [self.unitSelector unitAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate){
        [self.delegate unitWasSelected:[self.unitSelector unitAtIndex:indexPath.row]];
    }
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
