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
        // set notification to know when the textField value changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:_textField];
        
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
    // Create a view of the standard size at the bottom of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    self.bannerAd = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad unit ID.
    self.bannerAd.adUnitID = @"ca-app-pub-7789759883918325/1617344497";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    self.bannerAd.rootViewController = self;
    [self.view addSubview:self.bannerAd];
    
    // Initiate a generic request to load it with an ad.
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for
    // the simulator as well as any devices you want to receive test ads.
    request.testDevices = @[GAD_SIMULATOR_ID];
    self.bannerAd.delegate = self;
    [self.bannerAd loadRequest:request];
    
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
        ConverterType converterType = [self.currentUnitType isEqualToString:@"Temperature"] ? GAIN_OFFSET : GAIN;
        if (resources) {
            NSDictionary *dataMap = resources[@"map"];
            self.units = [[dataMap allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            self.converter = [FTConverter converterWithMap:[dataMap mutableCopy] type:converterType] ;
            self.values = [[NSMutableArray alloc] initWithCapacity:[self.units count]];
            
            self.basis = self.units[0];//resources[@"basis"];
            
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Google Ad Delegate

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"%@",error);
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    //[UIView beginAnimations:@"BannerSlide" context:nil];
    static bool frameSizeAdjusted = NO;
    if (!frameSizeAdjusted){
        bannerView.frame = CGRectMake(self.view.frame.size.width,
                                      self.view.frame.size.height - self.bannerAd.frame.size.height,
                                      bannerView.frame.size.width,
                                      bannerView.frame.size.height);
        
        NSLog(@"TableView Frame: %@", NSStringFromCGRect(self.tableView.frame));
        
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = tableFrame.size.height - self.bannerAd.frame.size.height;
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.tableView.frame = tableFrame;
                             [self.bannerAd setTransform:CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0)];
                         }
                         completion:^(BOOL finished) {
                             frameSizeAdjusted = YES;
                             NSLog(@"TableView Frame: %@", NSStringFromCGRect(self.tableView.frame));
                         }
         ];
    }
    
    //[UIView commitAnimations];
}


@end
