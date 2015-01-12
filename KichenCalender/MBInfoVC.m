//
//  MBInfoVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/27/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBInfoVC.h"

@interface MBInfoVC ()

@end

@implementation MBInfoVC

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
    // Do any additional setup after loading the view from its nib.
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width, 600);
    self.navigationItem.title = @"Info";
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"board_back.png"]];
    UIImage *image = [UIImage imageNamed: @"NavBar-Wood.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)FBClicked:(UIButton *)sender
{
/*    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/KitchenCalendar"]]; */
    
    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/618157821568008"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com"]];
    }
}
- (IBAction)LinkedInClicked:(UIButton *)sender
{
/* It is actually Twitter button
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.linkedin.com/pub/swapnil-09apps/80/947/817"]];
  updated code */
 //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter:///user?screen_name=09Apps"]];
    
    NSURL *twitterURL = [NSURL URLWithString:@"twitter:///user?screen_name=09Apps"];
    
    if ([[UIApplication sharedApplication] canOpenURL:twitterURL])
    {
        [[UIApplication sharedApplication] openURL:twitterURL];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com"]];
    }

    
}
- (IBAction)WWWpressed:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.09apps.com/"]];
}

- (IBAction)AppStoreClicked:(UIButton *)sender
{    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/id699394136";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:templateReviewURLiOS7]];
    }
    else
    {
        NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=699394136";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:templateReviewURL]];
    }
}

- (IBAction)EmailClicked:(UIButton *)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setToRecipients:[NSArray arrayWithObjects: @"contact@09apps.com",nil]];
    
    [mailComposer setSubject:[NSString stringWithFormat: @"Kitchen Calender iOS"]];
    
    [self presentViewController:mailComposer animated:YES completion:nil];

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error

{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
