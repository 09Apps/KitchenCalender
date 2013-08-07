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
    NSString* plistPath = [self getPlistPath];
    
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
    
    self.sections = [temp objectForKey:@"sections"];
    
    NSDictionary* dict1 = [temp objectForKey:@"milk1"];
    NSDictionary* dict2 = [temp objectForKey:@"milk2"];
    
    ////// Use to debug
    //    NSArray* nsa = [dict1 allValues];
    //    for (id obj in nsa)
    //		NSLog(@"model values %@",obj);
    ///////
    
    return [NSArray arrayWithObjects:dict1, dict2, self.sections, nil];
}


- (void) setMilkDetailsWithMilk1:(NSDictionary*)dict1 AndMilk2:(NSDictionary*)dict2
{
    
    NSArray* keyarr = [[NSArray alloc] initWithObjects:@"sections", @"milk1", @"milk2", nil];
    NSArray* dictarr = [[NSArray alloc] initWithObjects:self.sections, dict1, dict2, nil];
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjects:dictarr forKeys:keyarr];
    
    NSString* plistPath = [self getPlistPath];
    
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

- (NSString*) getPlistPath
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"KCPList.plist"];

    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        NSError *err;
        // if not in documents, get property list from main bundle
        NSString* pBundlePath = [[NSBundle mainBundle] pathForResource:@"KCPList" ofType:@"plist"];
        
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
    
    NSArray* milk = self.getMilkDetails;
    NSMutableArray* milkbill = [[NSMutableArray alloc] init];
    
    for (id mlkobj in milk)
    {
        NSMutableDictionary* dict1 = [[NSMutableDictionary alloc]init];
        double billamt = 0;
        
        if (counter == 2)
        {
            // set milk object count (sections) at array position 2.
            [milkbill setObject:mlkobj atIndexedSubscript:counter];
        }
        else
        {
            double totalQuantity = 0;
            NSInteger defaultdays = 0;
            
            // Get milk details
            
            NSString* ratestr = [mlkobj objectForKey:@"rate"];
            
            [dict1 setValue:[mlkobj objectForKey:@"title"] forKey:@"title"];
            [dict1 setValue:ratestr forKey:@"rate"];
            [dict1 setValue:[mlkobj objectForKey:@"deliveryCharge"] forKey:@"deliveryCharge"];
            
            NSString* defrmdt = [mlkobj objectForKey:@"fromDate"];
            NSDate* dfrdt = [dformat dateFromString:defrmdt];

//            NSString* dftostr = [mlkobj objectForKey:@"toDate"]; // implement this!!
//            NSDate* dftodt = [dformat dateFromString:dftostr];
            
            NSDate* dftodt = [NSDate date];
            
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

                for (id exobj in exceptions)
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
            
            billamt = totalQuantity * [ratestr doubleValue];
            
            NSLog(@"billamt %.2f",billamt);
            
            [dict1 setValue:[NSString stringWithFormat:@"%.2f",totalQuantity] forKey:@"quantity"];
            [dict1 setValue:[NSString stringWithFormat:@"%.2f",totalQuantity] forKey:@"billamt"];            
        }
        
        [milkbill setObject:dict1 atIndexedSubscript:counter];
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
    return ([components day]+1) ;
}

@end
