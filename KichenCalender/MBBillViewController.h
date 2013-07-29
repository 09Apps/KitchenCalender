//
//  MBBillViewController.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/26/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBKCModel.h"

@interface MBBillViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *frmDte;
@property (weak, nonatomic) IBOutlet UITextField *toDte;
@property (weak, nonatomic) IBOutlet UILabel *quantitylbl;
@property (weak, nonatomic) IBOutlet UILabel *billbl;
@property (weak, nonatomic) IBOutlet UILabel *dayslbl;
@property (strong, nonatomic) MBKCModel* model;
@property NSInteger segment;
@property BOOL verified;
@end
