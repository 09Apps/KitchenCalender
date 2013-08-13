//
//  MBPaperViewController.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/12/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBKCModel.h"

@interface MBPaperViewController : UITableViewController <UITextFieldDelegate>

@property(nonatomic,retain) MBKCModel* model;
@property NSInteger sect;
@property BOOL ischangedflag;
@property(nonatomic,retain) NSMutableArray* papers;
@property(nonatomic,retain) NSString* currency;
@property(nonatomic,retain) UITextField* txtField;

@end
