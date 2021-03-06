//
//  MBSetLaundryVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/19/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBGADMasterVC.h"

@interface MBSetLaundryVC : UITableViewController <UITextFieldDelegate>
@property(nonatomic,retain) UITextField* txtField;
@property BOOL ischangedflag;
@property NSInteger sect;
@property(nonatomic,retain) NSMutableArray* rates;

@property (weak, nonatomic) MBGADMasterVC* shared;

- (id)initWithRates:(NSMutableArray*) ratearr;

@end
