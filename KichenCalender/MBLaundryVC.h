//
//  MBLaundryVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/17/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBKCModel.h"
#import "MBAddLaundryDVC.h"

@interface MBLaundryVC : UITableViewController <MBAddLaundryDVCDelegate>

@property(nonatomic,retain) MBKCModel* model;
//@property NSInteger sect;
@property (strong, nonatomic) NSMutableArray* countarr;
@property (strong, nonatomic) NSMutableArray* ratearr;

@end
