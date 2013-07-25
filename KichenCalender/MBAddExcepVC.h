//
//  MBAddExcepVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/25/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBAddExcepVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *qtylbl;
- (IBAction)qtyChanged:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UITextField *frmTxt;
@property (weak, nonatomic) IBOutlet UITextField *toTxt;
- (IBAction)touchedDateFld:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end
