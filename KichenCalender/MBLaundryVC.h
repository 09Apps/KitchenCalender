//
//  MBLaundryVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/17/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBKCModel.h"

@interface MBLaundryVC : UITableViewController

@property(nonatomic,retain) MBKCModel* model;
@property NSInteger sect;
@property (strong, nonatomic) NSMutableArray* countarr;
@property (strong, nonatomic) NSMutableArray* ratearr;

@end
