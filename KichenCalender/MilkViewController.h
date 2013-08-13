//
//  MilkViewController.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/16/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBKCModel.h"
#import "MBExceptionVC.h"

@interface MilkViewController : UITableViewController <UITextFieldDelegate>
@property(nonatomic,retain) UITextField* txtField;
@property(nonatomic,retain) NSMutableArray* milk;
@property NSInteger sect;
@property BOOL ischangedflag;
@property(nonatomic,retain) NSString* currency;
@property(nonatomic,retain) MBKCModel* model;

@end
