//
//  MBBillViewController.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/26/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBBillViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *frmDte;
@property (weak, nonatomic) IBOutlet UITextField *toDte;
@property (strong, nonatomic) IBOutlet NSDate *nsdatefrm;
@property (strong, nonatomic) IBOutlet NSDate *nsdateto;
@property NSInteger segment;

@end
