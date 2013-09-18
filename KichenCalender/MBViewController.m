//
//  MBViewController.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/14/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBViewController.h"
#import "MBInfoVC.h"

@interface MBViewController ()

@end

@implementation MBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Subscriptions";
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"board_back.png"]];
    UIImage *image = [UIImage imageNamed: @"NavBar-Wood.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIImage *confimg = [UIImage imageNamed:@"info.png"];
    
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithImage:confimg style:UIBarButtonItemStylePlain target:self action:@selector(gotoHelp)];

    self.navigationItem.rightBarButtonItem = helpButton;
    
/*  SPT use for mediation
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];

    bannerView_.adUnitID = @"9485df067fc5469e";
    bannerView_.rootViewController = self;
    bannerView_.hidden = YES;
    bannerView_.delegate = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:@"188DC48180E85703AAEE011991E21436", @"946efa89ffd0e71731193b8aba42422c", GAD_SIMULATOR_ID, nil];
    [bannerView_ loadRequest:request];
*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.shared = [MBGADMasterVC singleton];
    [self.shared resetAdView:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoHelp
{
    MBInfoVC* infoVC = [[MBInfoVC alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

/*  SPT use for mediation
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    bannerView_.frame = CGRectMake(0.0,
                                   self.view.frame.size.height -
                                   bannerView_.frame.size.height,
                                   bannerView_.frame.size.width,
                                   bannerView_.frame.size.height);
    bannerView_.hidden = NO;    
}


- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"didFailToReceiveAdWithError %@",error);
}
*/

@end
