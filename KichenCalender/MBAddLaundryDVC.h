//
//  MBAddLaundryDVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/31/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBGADMasterVC.h"

@class MBAddLaundryDVC;

@protocol MBAddLaundryDVCDelegate <NSObject>
- (void)addLaundry:(MBAddLaundryDVC *)controller didFinishAddingException:(NSDictionary *)item;
@end

@interface MBAddLaundryDVC : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *txtfld;
@property (strong, nonatomic) UISegmentedControl* segcontrol;
@property (nonatomic,strong) NSMutableDictionary* ctdict;

@property (nonatomic, weak) id <MBAddLaundryDVCDelegate> delegate;
@property (weak, nonatomic) MBGADMasterVC* shared;

@property BOOL isaddedflag;
@property BOOL isDateAddedFlag;

@end

