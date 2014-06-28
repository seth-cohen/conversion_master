//
//  FTConversionViewController.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTConversionViewController.h"
#import "FTConverter.h"
#import "FTConversionCell.h"
#import "FTScientificInputViewController.h"

@interface FTConversionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property FTConverter *converter;
@property NSArray *units;
@property NSMutableArray *values;

@property FTScientificInputViewController *keyboardController;
@end

@implementation FTConversionViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // get the preferences and load significant digits
        _sigFigs = 4;
        
        // set the custom keyboard input view
        // needs to be member variable due to ARC, view gets retained but delegate disappers
        _keyboardController = [[FTScientificInputViewController alloc] initWithNibName: nil bundle:nil];
        _textField.delegate = self.keyboardController;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // set the default selected row to get highlighting
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionNone];
    
    self.textField.inputView = self.keyboardController.view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField.text = [@1.0 stringValue];
    self.title = self.currentUnitType;
    
    [self loadTypeDataFromResource:[self.currentUnitType stringByAppendingString:@"_data"]];
    //[self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Conversion

- (void) loadTypeDataFromResource:(NSString *) fileName
{
    NSError *error = nil;
    NSURL *resourceFile = [[NSBundle mainBundle] URLForResource:[fileName lowercaseString] withExtension:@"plist"];
    
    NSData *resourceData = [NSData dataWithContentsOfURL:resourceFile options:0 error:&error];
    if (resourceData) {
        NSDictionary* resources = [NSPropertyListSerialization propertyListWithData:resourceData options:0 format:NULL error:&error];
        if (resources) {
            NSDictionary *dataMap = resources[@"map"];
            self.units = [[dataMap allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            self.converter = [FTConverter converterWithMap:[dataMap mutableCopy]] ;
            self.values = [[NSMutableArray alloc] initWithCapacity:[self.units count]];
            
            self.basis = resources[@"basis"];
            
            [self convertAllFromValue:1.0];
        } else {
            NSLog(@"Error: Could not read plist data from %@: %@", resourceFile, error);
        }
    } else {
        NSLog(@"Error: Could not read file data at %@: %@", resourceFile, error);
    }
}

- (void) convertAllFromValue:(double) value
{
    int i = 0;
    NSNumber *tempValue;
    
    for (NSString *unitFrom in self.units) {
        tempValue = [self.converter convertValue:value from:unitFrom to:self.basis];
        double doubleWithSigFigs = [self round:[tempValue doubleValue] toSignificantFigures:self.sigFigs];
        
        [self.values setObject:[NSNumber numberWithDouble:doubleWithSigFigs] atIndexedSubscript:i];
        ++i;
    }
}

-(double) round:(double)num toSignificantFigures:(int)n {
    if(num == 0) {
        return 0;
    }
    
    double d = ceil(log10(num < 0 ? -num: num));
    int power = n - (int) d;
    
    double magnitude = pow(10, power);
    long shifted = round(num*magnitude);
    return shifted/magnitude;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.units count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FTConversionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.valueLabel.text = [self.values[indexPath.row] stringValue];
    cell.unitLabel.text = [@":" stringByAppendingString: self.units[indexPath.row]];
    
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
