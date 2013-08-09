//
//  MBKCModel.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/18/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBKCModel : NSObject

@property NSInteger sections;

- (NSArray*) getMilkDetails;
- (void) setMilkDetails:(NSArray*)milk;
- (NSArray*) getMilkBillFrom:(NSDate*)frmdt Till:(NSDate*)todt;
+ (NSInteger)getNumberOfDaysFrom:(NSDate*)fromDt Till:(NSDate*)toDt;

@end
