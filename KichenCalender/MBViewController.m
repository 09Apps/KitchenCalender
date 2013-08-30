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

- (void)gotoHelp
{
    MBInfoVC* infoVC = [[MBInfoVC alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
