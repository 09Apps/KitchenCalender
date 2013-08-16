//
//  MBKCModel.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/18/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBKCModel.h"


@implementation MBKCModel

- (NSArray*) getMilkDetails
{
    NSString* plistPath = [self getPlistPath:@"KCMilkPList"];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    NSMutableArray* milkarray = [[NSMutableArray alloc] init];
    
    NSString* str = [temp objectForKey:@"sections"];
    self.sections = [str integerValue];
    [milkarray addObject:str];
    
    str = [temp objectForKey:@"currency"];
    [milkarray addObject:str];
    
    [milkarray addObject:[temp objectForKey:@"milk"]];
    
    return milkarray;
}


- (void) setMilkDetails:(NSArray*)milk
{
    NSArray* keyarr = [[NSArray alloc] initWithObjects:@"sections", @"currency", @"milk", nil];
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjects:milk forKeys:keyarr];
    
    NSString* plistPath = [self getPlistPath:@"KCMilkPList"];
    
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
}

- (NSString*) getPlistPath:(NSString*) pListName
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filename = [pListName stringByAppendingString:@".plist"];
    
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:filename];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        NSError *err;
        // if not in documents, get property list from main bundle
        NSString* pBundlePath = [[NSBundle mainBundle] pathForResource:pListName ofType:@"plist"];
        
        // Copy Plist to document directory
        NSFileManager* manager = [NSFileManager defaultManager];
        [manager copyItemAtPath:pBundlePath toPath:plistPath error:&err];
        
        if(err)
        {
            NSLog(@"Error in saveData: %@", err);
            return pBundlePath;
        }
    }
    return plistPath;
}

- (NSArray*)getMilkBillFrom:(NSDate*)frmdt Till:(NSDate*)todt
{
    NSUInteger counter = 0;
    
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    [dformat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSMutableArray* milkbill = [[NSMutableArray alloc] init];
    
    NSArray* milk = self.getMilkDetails;
    
    for (id obj in milk)
    {
        double billamt = 0;
        
        if (counter == 0)
        {
            // set milk object count (sections) at array position 2.
            [milkbill addObject:obj];
        }
        
        //Counter 1 is Rs.
        if (counter == 1)
        {   
            // set milk object count (sections) at array position 2.
            [milkbill addObject:obj];
        }
        
        //Counter 2 is milk objects
        if (counter == 2)
        {
            NSMutableArray* eachmilk = [[NSMutableArray alloc] init];
            double totalbill = 0;
            
            for (NSDictionary* mlkobj in obj)
            {
                double totalQuantity = 0;
                NSInteger defaultdays = 0;
                NSMutableDictionary* dict1 = [[NSMutableDictionary alloc]init];                
            
                // Get milk details
        
                NSString* ratestr = [mlkobj objectForKey:@"rate"];
                [dict1 setValue:ratestr forKey:@"rate"];
                
                [dict1 setValue:[mlkobj objectForKey:@"title"] forKey:@"title"];
                
                NSString* delchgstr = [mlkobj objectForKey:@"deliveryCharge"];
                [dict1 setValue:delchgstr forKey:@"deliveryCharge"];
            
                NSString* defrmdt = [mlkobj objectForKey:@"fromDate"];
                NSDate* dfrdt = [dformat dateFromString:defrmdt];

                NSString* dftostr = [mlkobj objectForKey:@"toDate"]; 
                NSDate* dftodt = [dformat dateFromString:dftostr];
            
                if ([frmdt compare:dftodt] == NSOrderedDescending  ||
                    [dfrdt compare:todt] == NSOrderedDescending )
                {
                    // Exception from date is later than Todate of bill date OR
                    // Exception to date is before bill from date
                    // Ignore this exception
                }
                else
                {
                    NSDate* dfeffectivefrmdt;
                    NSDate* dfeffectivetodt;
                
                    if ([dfrdt compare:frmdt] == NSOrderedDescending)
                    {
                        // Means exception from date is later than bill from date
                        // so make it effective start date
                        dfeffectivefrmdt = dfrdt;
                    }
                    else
                    {
                        // Bill from date is later than exception start date
                        // so make it effective start date
                        dfeffectivefrmdt = frmdt;
                    }
                
                    if ([dftodt compare:todt] == NSOrderedDescending)
                    {
                        dfeffectivetodt = todt;
                    }
                    else
                    {
                        dfeffectivetodt = dftodt;
                    }
                
                    defaultdays = [MBKCModel getNumberOfDaysFrom:dfeffectivefrmdt Till:dfeffectivetodt];
                
                    double dfquant = [[mlkobj objectForKey:@"quantity"] doubleValue];
            
                    // Now get the exceptions data
                    NSArray* exceptions = [mlkobj objectForKey:@"exceptions"];

                    for (NSDictionary* exobj in exceptions)
                    {
                        NSString* frstr = [exobj objectForKey:@"fromDate"];
                        NSDate* exfrdt = exfrdt = [dformat dateFromString:frstr];

                        frstr = [exobj objectForKey:@"toDate"];
                        NSDate* extodt = [dformat dateFromString:frstr];
                
                        if ([frmdt compare:extodt] == NSOrderedDescending  ||
                            [exfrdt compare:todt] == NSOrderedDescending )
                        {
                            // Exception from date is later than Todate of bill date OR
                            // Exception to date is before bill from date
                            // Ignore this exception
                        }
                        else
                        {
                            NSDate* effectivefrmdt;
                            NSDate* effectivetodt;
                    
                            if ([exfrdt compare:frmdt] == NSOrderedDescending)
                            {
                                // Means exception from date is later than bill from date
                                // so make it effective start date
                                effectivefrmdt = exfrdt;
                            }
                            else
                            {
                                // Bill from date is later than exception start date
                                // so make it effective start date
                                effectivefrmdt = frmdt;
                            }
           
                            if ([extodt compare:todt] == NSOrderedDescending)
                            {
                                effectivetodt = todt;
                            }
                            else
                            {
                                effectivetodt = extodt;
                            }
                        
                            NSInteger exdays = [MBKCModel getNumberOfDaysFrom:effectivefrmdt Till:effectivetodt];
                        
                            defaultdays = defaultdays - exdays;  // Number of exception days
                            double exquant = [[exobj objectForKey:@"quantity"] doubleValue];
                        
                            totalQuantity = totalQuantity + (exdays * exquant);  // This is total quantity for exception                  
                        }
                    }
                
                    // Add default quantity now
                    totalQuantity = totalQuantity + (defaultdays * dfquant);                                        
                }
                
                billamt = (totalQuantity * [ratestr doubleValue]) + [delchgstr integerValue];
                
                totalbill = totalbill + billamt;
                
                [dict1 setValue:[NSString stringWithFormat:@"%.2f",totalQuantity] forKey:@"quantity"];
                [dict1 setValue:[NSString stringWithFormat:@"%.2f",billamt] forKey:@"billamt"];
                
                [eachmilk addObject:dict1];              
            }
            
            [milkbill addObject:[NSString stringWithFormat:@"%.2f",totalbill]];
            [milkbill addObject:eachmilk];
        }
        counter++;
    }
    
    return milkbill;
}

+ (NSInteger)getNumberOfDaysFrom:(NSDate*)fromDt Till:(NSDate*)toDt
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                            fromDate:fromDt
                                            toDate:toDt options:0];
    if ([components day] < 0)
    {
        return 0;
    }
    else
    {
        return ([components day]+1) ;
    }
}

- (NSArray*) getOtherDetails:(NSInteger)category
{
    // Returns Array format = { currency, sections, {papers array}}
    NSString* plistPath = [self getPlistPath:@"KCOtherPList"];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into Dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    NSMutableArray* catarray = [[NSMutableArray alloc] init];
    
    [catarray addObject:[temp objectForKey:@"currency"]];

    NSDictionary* dict = [[NSDictionary alloc] init];
    
    if (category == PAPERCAT)
    {
        // Get newspaper data in array
        
        dict = [temp objectForKey:@"paper"];
        
        NSString* str = [dict objectForKey:@"sections"];
        
        self.sections = [str integerValue];
        [catarray addObject:str];
        
        [catarray addObject:[dict objectForKey:@"papers"]];
    }
    else
    {
        // Get Laundry data
        dict = [temp objectForKey:@"laundry"];
    }
    
    [catarray addObject:dict];

    return catarray;
}

- (void) setPaperDetails:(NSArray*)paper
{
    // User is saving data {currency, paper={sections,papers}}
    NSArray* keyarr = [[NSArray alloc] initWithObjects:@"currency", @"paper", nil];
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjects:paper forKeys:keyarr];
    
    NSString* plistPath = [self getPlistPath:@"KCOtherPList"];
    
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
}

+ (NSUInteger)getNumberOf:(NSUInteger)gregday From:(NSDate*)fromDt Till:(NSDate*)toDt
{
    //Sunday in the Gregorian calendar is 1, Monday 2 .. and Saturday 7
    
    NSUInteger interval = [MBKCModel getNumberOfDaysFrom:fromDt Till:toDt];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Get the weekday component of the current date
    
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:fromDt];
    
    NSUInteger frmday = [weekdayComponents weekday];
    
    NSUInteger wk = interval/7;
    
//    NSLog(@"interval %d gregday %d wk %d",interval,gregday,wk);
    
    NSUInteger xtradays = interval - (wk*7);
//    NSLog(@"xtradays %d",xtradays);
    
    NSInteger diffdays = gregday - frmday;
//    NSLog(@"diffdays %d",diffdays);
    
    if (diffdays < 0)
    {
        diffdays = diffdays + 7;
//            NSLog(@"diffdays %d",diffdays);
    }
    
    if (xtradays >= diffdays)
    {
        wk++;
    }
//    NSLog(@"wk %d",wk);
    return wk;
}


@end
