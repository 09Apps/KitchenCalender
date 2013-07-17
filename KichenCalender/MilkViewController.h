//
//  MilkViewController.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/16/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MilkViewController : UITableViewController <UITextFieldDelegate>

@property(nonatomic,retain) UITextField* txtField;
@property(nonatomic,retain) NSMutableArray* milk1;
@property(nonatomic,retain) NSMutableArray* milk2;
@end
