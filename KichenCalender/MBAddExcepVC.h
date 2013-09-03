//
//  MBAddExcepVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/25/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBGADMasterVC.h"

#define MILKCAT 3001
#define PAPERCAT 4001

@class MBAddExcepVC;

@protocol MBAddExcepVCDelegate <NSObject>
- (void)addExceptionVC:(MBAddExcepVC *)controller didFinishAddingException:(NSDictionary *)item;
@end

@interface MBAddExcepVC : UIViewController <UITextFieldDelegate,GADBannerViewDelegate>

@property (nonatomic, weak) id <MBAddExcepVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *qtylbl;
@property (weak, nonatomic) IBOutlet UITextField *frmTxt;
@property (weak, nonatomic) IBOutlet UITextField *toTxt;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) MBGADMasterVC* shared;
@property NSUInteger category;

- (IBAction)qtyChanged:(UIStepper *)sender;

@end
