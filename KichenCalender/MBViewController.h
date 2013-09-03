//
//  MBViewController.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/14/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBGADMasterVC.h"
//#import "GADBannerView.h"

@interface MBViewController : UIViewController <GADBannerViewDelegate>
{
//    GADBannerView *bannerView_;
}

@property (weak, nonatomic) MBGADMasterVC* shared;

@end
