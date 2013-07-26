//
//  MBAddExcepVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/25/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBAddExcepVC : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *qtylbl;
@property (weak, nonatomic) IBOutlet UITextField *frmTxt;
@property (weak, nonatomic) IBOutlet UITextField *toTxt;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

- (IBAction)qtyChanged:(UIStepper *)sender;
+ (NSInteger)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2;

@end
