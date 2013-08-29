//
//  MBViewController.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/14/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface MBViewController : UIViewController <ADBannerViewDelegate>

@property (strong, nonatomic) ADBannerView *bannerView;
@end
