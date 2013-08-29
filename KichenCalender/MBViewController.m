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
    
    _bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    _bannerView.delegate = self;
    _bannerView.hidden = YES;


    [self.view addSubview:_bannerView];
    
    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    
    UIImage *confimg = [UIImage imageNamed:@"info.png"];
    
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithImage:confimg style:UIBarButtonItemStylePlain target:self action:@selector(gotoHelp)];

    self.navigationItem.rightBarButtonItem = helpButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"bannerViewDidLoadAd");
//    CGRect bannerFrame = CGRectMake(0.0, (self.view.frame.size.height - 50), 0.0, 0.0);
    CGRect bannerFrame = CGRectMake(0.0, (self.view.frame.size.height - 100), 0.0, 0.0);    
    [self.bannerView setFrame:bannerFrame];
    self.bannerView.hidden = NO;
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Error receive ad: %@", error);
    self.bannerView.hidden = YES;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner
               willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}

- (void)gotoHelp
{
    MBInfoVC* infoVC = [[MBInfoVC alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
