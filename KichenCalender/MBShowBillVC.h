//
//  MBShowBillVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/1/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBShowBillVC : UITableViewController

@property NSInteger billtype;
@property (strong, nonatomic) NSDate* frmdt;
@property (strong, nonatomic) NSDate* todt;
@end
