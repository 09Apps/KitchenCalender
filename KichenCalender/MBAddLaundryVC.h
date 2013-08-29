//
//  MBAddLaundryVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/20/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBAddLaundryVC;

@protocol MBAddLaundryVCDelegate <NSObject>
- (void)addLaundry:(MBAddLaundryVC *)controller didFinishAddingException:(NSDictionary *)item;
@end

@interface MBAddLaundryVC : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtfld;

@property (nonatomic,strong) NSMutableDictionary* ctdict;

@property (nonatomic, weak) id <MBAddLaundryVCDelegate> delegate;
@property BOOL isaddedflag;

@end
