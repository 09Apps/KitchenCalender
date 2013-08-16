//
//  MBShowBillVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/1/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBKCModel.h"

@interface MBShowBillVC : UITableViewController

@property  NSInteger billtype;
@property (retain, nonatomic) NSDate* frmdt;
@property (retain, nonatomic) NSDate* todt;
@property (strong, nonatomic) MBKCModel* model;
@property (strong, nonatomic) NSArray* billarray;
@property (strong, nonatomic) NSArray* element;



@end
