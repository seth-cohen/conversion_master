//
//  FTConversionIpadViewController.m
//  Conversion Master
//
//  Created by Seth Cohen on 7/3/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTConversionIpadViewController.h"
#import "FTConverter.h"
#import "FTConversionCell.h"
#import "FTScientificInputViewController.h"

@interface FTConversionIpadViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property FTConverter *converter;
@property NSArray *units;
@property NSMutableArray *values;
@property FTScientificInputViewController *keyboardController;

@end

@implementation FTConversionIpadViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // get the preferences and load significant digits
        _sigFigs = 4;
        // set notification to know when the textField value changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:_textField];
        
        // set the custom keyboard input view
        // needs to be member variable due to ARC, view gets retained but delegate disappers
        _keyboardController = [[FTScientificInputViewController alloc] initWithNibName: nil bundle:nil];
        _textField.delegate = self.keyboardController;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    // set the default selected row to get highlighting
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionNone];
    
    self.textField.inputView = self.keyboardController.view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Unit Select Delegate
- (void) unitWasSelected:(NSString *)unitName {
    // set the title and the unit type
    self.currentUnitType = unitName;
    self.title = [NSString stringWithFormat:@"Converting - %@",self.currentUnitType];
    
    // refresh the data
    [self loadTypeDataFromResource:[self.currentUnitType stringByAppendingString:@"_data"]];
    [self.tableView reloadData];
    
    [self highlightRowAtIndex:[self.units indexOfObject:self.basis]];
}

#pragma mark - Data Conversion
- (void) loadTypeDataFromResource:(NSString *) fileName
{
    NSError *error = nil;
    NSURL *resourceFile = [[NSBundle mainBundle] URLForResource:[fileName lowercaseString] withExtension:@"plist"];
    
    NSData *resourceData = [NSData dataWithContentsOfURL:resourceFile options:0 error:&error];
    if (resourceData) {
        NSDictionary* resources = [NSPropertyListSerialization propertyListWithData:resourceData options:0 format:NULL error:&error];
        ConverterType converterType = [self.currentUnitType isEqualToString:@"Temperature"] ? GAIN_OFFSET : GAIN;
        if (resources) {
            NSDictionary *dataMap = resources[@"map"];
            self.units = [[dataMap allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            self.converter = [FTConverter converterWithMap:[dataMap mutableCopy] type:converterType] ;
            self.values = [[NSMutableArray alloc] initWithCapacity:[self.units count]];
            
            self.basis = self.units[0];//resources[@"basis"];
            
            [self convertAllFromValue:[self.textField.text doubleValue]];
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
    
    for (NSString *unitTo in self.units) {
        tempValue = [self.converter convertValue:value from:self.basis to:unitTo];
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
    
    /*
     NSNumberFormatter *doubleValF = [[NSNumberFormatter alloc] init];
     [doubleValF setNumberStyle:NSNumberFormatterDecimalStyle];
     [doubleValF setRoundingMode:NSNumberFormatterRoundHalfUp];
     
     doubleValF.usesGroupingSeparator = NO;
     doubleValF.minimumSignificantDigits = n;
     doubleValF.maximumSignificantDigits = n;
     doubleValF.usesSignificantDigits = YES;
     
     NSNumber *numberDouble = [NSNumber numberWithDouble:num];
     NSString *stringDouble = [doubleValF stringFromNumber:numberDouble];
     double retVal = [stringDouble doubleValue];
     return retVal;
     */
}

-(void) textChanged:(NSNotification *) notification
{
    if (notification.object == self.textField) {
        double value = [self.textField.text doubleValue];
        [self convertAllFromValue:value];
    }
    [self.tableView reloadData];
    
    [self highlightRowAtIndex:[self.units indexOfObject:self.basis]];
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

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.basis = self.units[indexPath.row];
    
    double value = [self.textField.text doubleValue];
    [self convertAllFromValue:value];
    [tableView reloadData];
    
    [self highlightRowAtIndex:indexPath.row];
}

- (void) highlightRowAtIndex:(NSInteger) index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:YES];
}

#pragma mark - Split View Delegate
- (bool) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
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
