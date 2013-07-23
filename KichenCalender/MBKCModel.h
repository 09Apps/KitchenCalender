//
//  MBKCModel.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/18/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBKCModel : NSObject

@property (nonatomic,retain) NSString* sections;

- (NSArray*) getMilkDetails;
- (void) setMilkDetailsWithMilk1:(NSDictionary*)dict1 AndMilk2:(NSDictionary*)dict1;

@end
