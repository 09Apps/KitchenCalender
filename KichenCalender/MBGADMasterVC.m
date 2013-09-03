//
//  MBGADMasterVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 9/3/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBGADMasterVC.h"

@interface MBGADMasterVC ()

@end

@implementation MBGADMasterVC

-(id)init {
    if (self = [super init]) {
        adBanner_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        adBanner_.frame = CGRectMake(0.0,
                                       self.view.frame.size.height -
                                       (adBanner_.frame.size.height * 1.9),
                                       adBanner_.frame.size.width,
                                       adBanner_.frame.size.height);
        // Has an ad request already been made
        isLoaded_ = NO;
    }
    return self;
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(MBGADMasterVC *)singleton
{
    static dispatch_once_t pred;
    static MBGADMasterVC *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[MBGADMasterVC alloc] init];
    });
    return shared;
}

-(void)resetAdView:(UIViewController *)rootViewController
{
    // Always keep track of currentDelegate for notification forwarding
    currentDelegate_ = rootViewController;
    
    // Ad already requested, simply add it into the view
    if (isLoaded_)
    {
        adBanner_.rootViewController = rootViewController;
        [rootViewController.view addSubview:adBanner_];
    } else
    {
        adBanner_.delegate = self;
        adBanner_.rootViewController = rootViewController;
        adBanner_.adUnitID = @"9485df067fc5469e";
//        adBanner_.adUnitID = @"a152204863d59fa";
        GADRequest *request = [GADRequest request];
        request.testDevices = [NSArray arrayWithObjects:@"946efa89ffd0e71731193b8aba42422c", GAD_SIMULATOR_ID, nil];
//        request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
        [adBanner_ loadRequest:request];
        [rootViewController.view addSubview:adBanner_];
        isLoaded_ = YES;
    }
}

@end
