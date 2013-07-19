//
//  MilkViewController.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/16/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBKCModel.h"

@interface MilkViewController : UITableViewController <UITextFieldDelegate>

@property(nonatomic,retain) UITextField* txtField;
@property(nonatomic,retain) NSMutableDictionary* milk1;
@property(nonatomic,retain) NSMutableDictionary* milk2;
@property(nonatomic,retain) MBKCModel* model;

@end
