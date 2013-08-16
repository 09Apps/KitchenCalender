//
//  MBKCModel.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/18/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PAPERCAT 1001
#define LAUNDRYCAT 2001
#define ADDSECTIONTAG 100
#define SAVEDATAG 200

@interface MBKCModel : NSObject

@property NSInteger sections;

//milk methods
- (NSArray*) getMilkDetails;
- (void) setMilkDetails:(NSArray*)milk;
- (NSArray*) getMilkBillFrom:(NSDate*)frmdt Till:(NSDate*)todt;

//Paper, Laundry methods
- (NSArray*) getOtherDetails:(NSInteger) category;
- (void) setPaperDetails:(NSArray*)paper;
- (NSArray*) getPaperBillFrom:(NSDate*)frmdt Till:(NSDate*)todt;

//General methods
+ (NSInteger)getNumberOfDaysFrom:(NSDate*)fromDt Till:(NSDate*)toDt;
+ (NSUInteger)getNumberOf:(NSUInteger)gregday From:(NSDate*)fromDt Till:(NSDate*)toDt;

@end
