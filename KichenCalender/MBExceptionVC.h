//
//  MBExceptionVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/25/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAddExcepVC.h"

@interface MBExceptionVC : UITableViewController <MBAddExcepVCDelegate>

@property (strong,nonatomic) NSMutableArray* exceptions;
@property NSUInteger category;

- (id)initWithException:(NSArray*) exceptions;

@end
