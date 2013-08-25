//
//  MBViewController.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/14/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
