//
//  FTUnitSelectViewController.m
//  Conversion Master
//
//  Created by Seth Cohen on 6/22/14.
//  Copyright (c) 2014 Seth Cohen. All rights reserved.
//

#import "FTUnitSelectViewController.h"
#import "FTConversionViewController.h"
#import "FTUnitSelector.h"

@interface FTUnitSelectViewController ()
@property FTUnitSelector *unitSelector;
@end

@implementation FTUnitSelectViewController

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
    
    self.unitSelector = [FTUnitSelector newUnitSelectorFromPlist:@"unit_types"];
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
        NSString *selectedItem = [self.unitSelector unitAtIndex:indexPath.row];
        
        NSLog(@"Selected Item Name: %@", selectedItem);
        destination.currentUnitType = selectedItem;
    }
}


#pragma mark Collection View Data Source

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.unitSelector countOfUnitTypes];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FTUnitSelectCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"TypeCell"
                                    forIndexPath:indexPath];
    
    cell.label.text = [self.unitSelector unitAtIndex:indexPath.row];
    return cell;
}

#pragma mark Google Ad Delegate

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"%@", error);
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    //[UIView beginAnimations:@"BannerSlide" context:nil];
    static bool frameSizeAdjusted = NO;
    if (!frameSizeAdjusted){
        bannerView.frame = CGRectMake(self.view.frame.size.width,
                                      self.view.frame.size.height - self.bannerAd.frame.size.height,
                                      bannerView.frame.size.width,
                                      bannerView.frame.size.height);
        
        CGRect collectionFrame = self.collectionView.frame;
        collectionFrame.size.height = collectionFrame.size.height - self.bannerAd.frame.size.height;
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.collectionView.frame = collectionFrame;
                             [self.bannerAd setTransform:CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0)];
                         }
                         completion:^(BOOL finished) {
                             frameSizeAdjusted = YES;
                         }
         ];
    }
    
    //[UIView commitAnimations];
}

@end
