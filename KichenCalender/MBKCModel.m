//
//  MBKCModel.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/18/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBKCModel.h"


@implementation MBKCModel

- (NSArray*) getMilkDetails
{
    NSString* plistPath = [self getPlistPath:@"KCMilkPList"];
    
    //NSLog(@"plistPath %@",plistPath);
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %u", errorDesc, format);
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
            // set milk object count (sections) at array position 0.
            [milkbill addObject:obj];
        }
        
        //Counter 1 is Rs.
        if (counter == 1)
        {   
            // set milk object count (sections) at array position 1.
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
                NSInteger totdelcharge = 0;
                NSMutableDictionary* dict1 = [[NSMutableDictionary alloc]init];                
            
                // Get milk details
        
                NSString* ratestr = [mlkobj objectForKey:@"rate"];
                [dict1 setValue:ratestr forKey:@"rate"];
                
                [dict1 setValue:[mlkobj objectForKey:@"title"] forKey:@"title"];
            
                NSString* defrmdt = [mlkobj objectForKey:@"fromDate"];
                NSDate* dfrdt = [dformat dateFromString:defrmdt];

                NSString* dftostr = [mlkobj objectForKey:@"toDate"];
                
                if (dftostr == nil) {
                    dftostr = @"Dec 31, 2100";
                }
                
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
                    
                    // find number of months, used to calculate delivery charge
                    NSUInteger monthsct = (defaultdays/32);
                    
                    if (monthsct == 0 && defaultdays > 15) {
                        monthsct++;
                    }
                    
                    NSString* dstr = [mlkobj objectForKey:@"deliveryCharge"];
                    
                    totdelcharge = [dstr integerValue] * monthsct;
                    
                    double dfquant = [[mlkobj objectForKey:@"quantity"] doubleValue];
            
                    // Now get the exceptions data
                    NSArray* exceptions = [mlkobj objectForKey:@"exceptions"];

                    for (NSDictionary* exobj in exceptions)
                    {
                        NSString* frstr = [exobj objectForKey:@"fromDate"];
                        NSDate* exfrdt = exfrdt = [dformat dateFromString:frstr];

                        frstr = [exobj objectForKey:@"toDate"];
                        NSDate* extodt = [dformat dateFromString:frstr];
                
                        if ([dfeffectivefrmdt compare:extodt] == NSOrderedDescending  ||
                            [exfrdt compare:dfeffectivetodt] == NSOrderedDescending )
                        {
                            // Exception from date is later than Todate of bill date OR
                            // Exception to date is before bill from date
                            // Ignore this exception
                        }
                        else
                        {
                            NSDate* effectivefrmdt;
                            NSDate* effectivetodt;
                    
                            if ([exfrdt compare:dfeffectivefrmdt] == NSOrderedDescending)
                            {
                                // Means exception from date is later than bill from date
                                // so make it effective start date
                                effectivefrmdt = exfrdt;
                            }
                            else
                            {
                                // Bill from date is later than exception start date
                                // so make it effective start date
                                effectivefrmdt = dfeffectivefrmdt;
                            }
           
                            if ([extodt compare:dfeffectivetodt] == NSOrderedDescending)
                            {
                                effectivetodt = dfeffectivetodt;
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
                
                billamt = (totalQuantity * [ratestr doubleValue]);
                
                [dict1 setValue:[NSString stringWithFormat:@"%.2f",totalQuantity] forKey:@"quantity"];
                [dict1 setValue:[NSString stringWithFormat:@"%.2f",billamt] forKey:@"billamt"];

                NSString* delchgstr = [NSString stringWithFormat:@"%ld",(long)totdelcharge];
                [dict1 setValue:delchgstr forKey:@"deliveryCharge"];

                [eachmilk addObject:dict1];
                
                totalbill = totalbill + billamt + totdelcharge;
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

- (NSMutableArray*) getPaperDetails
{
    // Returns Array format = { currency, sections, {papers array}}
    NSString* plistPath = [self getPlistPath:@"KCPaperPList"];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into Dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %u", errorDesc, format);
    }
    
    NSMutableArray* catarray = [[NSMutableArray alloc] init];
    
    [catarray addObject:[temp objectForKey:@"currency"]];

    NSDictionary* dict = [[NSDictionary alloc] init];
    
    // Get newspaper data in array
        
    dict = [temp objectForKey:@"paper"];
        
    NSString* str = [dict objectForKey:@"sections"];
        
    self.sections = [str integerValue];
    [catarray addObject:str];
    [catarray addObject:[dict objectForKey:@"papers"]];

    return catarray;
}

- (NSMutableArray*) getLaundryDetails
{
    // Returns Array format = { currency, sections, {rates,counts}}
    NSString* plistPath = [self getPlistPath:@"KCLaundryPList"];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into Dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %u", errorDesc, format);
    }
    
    NSMutableArray* catarray = [[NSMutableArray alloc] init];
    
    [catarray addObject:[temp objectForKey:@"currency"]];
    
    NSDictionary* dict = [[NSDictionary alloc] init];
    
    // Get Laundry data
    dict = [temp objectForKey:@"laundry"];

    NSArray* counts =[dict objectForKey:@"counts"];
        
    self.sections = [counts count];
        
    [catarray addObject:[NSString stringWithFormat:@"%ld",(long)self.sections]];
        
    [catarray addObject:dict];

    return catarray;
}

- (void) setPaperDetails:(NSArray*)paper
{
    // User is saving data {currency, paper={sections,papers}}
    NSArray* keyarr = [[NSArray alloc] initWithObjects:@"currency", @"paper", nil];
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjects:paper forKeys:keyarr];
    
    NSString* plistPath = [self getPlistPath:@"KCPaperPList"];
    
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

- (void) setLaundryDetails:(NSDictionary*) dict
{
    // User is saving data {currency, paper={sections,papers}}
    NSArray* keyarr = [[NSArray alloc] initWithObjects:@"currency", @"laundry", nil];
    NSArray* valarr = [[NSArray alloc] initWithObjects:@"Rs.", dict, nil];
    
    NSDictionary* laundry = [[NSDictionary alloc] initWithObjects:valarr forKeys:keyarr];
    
    NSString* plistPath = [self getPlistPath:@"KCLaundryPList"];
    
    NSString *error = nil;
    
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:laundry format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
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

- (NSArray*) getLaundryBillFrom:(NSDate*)frmdt Till:(NSDate*)todt
{
    // Returns array of dictionary { deliverycharge, presscount, washcount, drycleancount, bleachcount, totalbill }
    
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    [dformat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSArray* laundry = [self getLaundryDetails];
    
    NSDictionary* ldict = [laundry objectAtIndex:2];
    
    NSArray *ratearr = [ldict objectForKey:@"rates"];
    
    NSMutableDictionary* returndict = [[NSMutableDictionary alloc]init];
    
    double laundrybill = 0;
    NSUInteger totpressct = 0;
    NSUInteger totwashct = 0;
    NSUInteger totdrycleanct = 0;
    NSUInteger totbleachct = 0;
    NSUInteger totsareect = 0;
    NSUInteger totstarchct = 0;
    NSUInteger totdelch = 0;
    NSUInteger notretct = 0;
    
    for (NSDictionary* ratedict in ratearr)
    {
        NSUInteger pressct = 0;
        NSUInteger washct = 0;
        NSUInteger drycleanct = 0;
        NSUInteger bleachct = 0;
        NSUInteger sareect = 0;
        NSUInteger starchct = 0;
        
        NSString* defrmdt = [ratedict objectForKey:@"fromDate"];
        NSDate* dfrdt = [dformat dateFromString:defrmdt];

        NSString* dftostr = [ratedict objectForKey:@"toDate"];
        
        if (dftostr == nil) {
            dftostr = @"Dec 31, 2100";
        }
        
        NSDate* dftodt = [dformat dateFromString:dftostr];
        
        if ([frmdt compare:dftodt] == NSOrderedDescending  ||
            [dfrdt compare:todt] == NSOrderedDescending )
        {
            // Rates from date is later than Todate of bill date OR
            // Rates to date is before bill from date
            // Ignore this rate
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
            
            // find number of months, used to calculate delivery charge
            NSUInteger defaultdays = [MBKCModel getNumberOfDaysFrom:dfeffectivefrmdt Till:dfeffectivetodt];
            NSUInteger monthsct = (defaultdays/32);

            if ((defaultdays - (monthsct*32)) > 15 )
            {
                monthsct++;
            }
            
            // Now get the laundry counts during this period
            NSArray *countarr = [ldict objectForKey:@"counts"];
            
            for (NSDictionary* ctdict in countarr)
            {
                NSString* ondt = [ctdict objectForKey:@"ondate"];
                NSDate* dondt = [dformat dateFromString:ondt];
                
                if (([dondt compare:dfeffectivefrmdt] != NSOrderedAscending) &&
                    ([dondt compare:dfeffectivetodt] != NSOrderedDescending) )
                {
                    // Means ondate is equal to or later than from date
                    // && ondate is less than or equal to to date
                    
                    pressct = pressct + [[ctdict objectForKey:@"press"] integerValue];
                    washct = washct + [[ctdict objectForKey:@"wash"] integerValue];
                    drycleanct = drycleanct + [[ctdict objectForKey:@"dryclean"] integerValue];
                    bleachct = bleachct + [[ctdict objectForKey:@"bleach"] integerValue];
                    sareect = sareect + [[ctdict objectForKey:@"saree"] integerValue];
                    starchct = starchct + [[ctdict objectForKey:@"starch"] integerValue];
                    
                    if ( [[ctdict objectForKey:@"returned"] integerValue] == 0)
                    {
                        notretct = notretct + [[ctdict objectForKey:@"totalcloth"] integerValue];
                    }
                }
            }
            
            if (pressct > 0)
            {
                double pressrt = [[ratedict objectForKey:@"press"] doubleValue];
                laundrybill = laundrybill + (pressct * pressrt);
            }
            
            if (washct > 0)
            {
                double washrt = [[ratedict objectForKey:@"wash"] doubleValue];
                laundrybill = laundrybill + (washct * washrt);          
            }
            
            if (drycleanct > 0)
            {
                double drycleanrt = [[ratedict objectForKey:@"dryclean"] doubleValue];
                laundrybill = laundrybill + (drycleanct * drycleanrt);           
            }
            
            if (bleachct > 0)
            {
                double bleachrt = [[ratedict objectForKey:@"bleach"] doubleValue];
                laundrybill = laundrybill + (bleachct * bleachrt);          
            }

            if (sareect > 0)
            {
                double sareert = [[ratedict objectForKey:@"saree"] doubleValue];
                laundrybill = laundrybill + (sareect * sareert);
            }

            if (starchct > 0)
            {
                double starchrt = [[ratedict objectForKey:@"starch"] doubleValue];
                laundrybill = laundrybill + (starchct * starchrt);
            }
            
            NSUInteger delcharge = [[ratedict objectForKey:@"deliveryCharge"] integerValue] * monthsct;
            totdelch = totdelch + delcharge;
        }
        
        totpressct = totpressct + pressct;
        totwashct = totwashct + washct;
        totdrycleanct = totdrycleanct + drycleanct;
        totbleachct = totbleachct + bleachct;
        totsareect = totsareect + sareect;
        totstarchct = totstarchct + starchct;
    }

    double totalbill = laundrybill + totdelch;
    
    [returndict setValue:@"Bill Details" forKey:@"title"];
    [returndict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)totdelch] forKey:@"deliveryCharge"];
    [returndict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)totpressct] forKey:@"presscount"];
    [returndict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)totwashct] forKey:@"washcount"];
    [returndict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)totdrycleanct] forKey:@"drycleancount"];
    [returndict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)totbleachct] forKey:@"bleachcount"];
    [returndict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)totsareect] forKey:@"sareecount"];
    [returndict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)totstarchct] forKey:@"starchcount"];
    [returndict setValue:[NSString stringWithFormat:@"%lu",(unsigned long)notretct] forKey:@"notreturncount"];
    [returndict setValue:[NSString stringWithFormat:@"%.2f",laundrybill] forKey:@"laundrybill"];
    [returndict setValue:[NSString stringWithFormat:@"%.2f",totalbill] forKey:@"totalbill"];
    
    // Actually dictionary can be used as return here, but to maintain uniform behavior with
    // milk & paper, create an array and return
    
    return [NSArray arrayWithObject:returndict] ;
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
    
    NSUInteger xtradays = interval - (wk*7); 
    
    NSInteger diffdays = gregday - frmday;  
       
    if (diffdays < 0)
    {
        diffdays = diffdays + 7;
    }
    
    if (xtradays > diffdays)
    {
        wk++;
    }

    return wk;
}

- (NSArray*) getPaperBillFrom:(NSDate*)frmdt Till:(NSDate*)todt
{
    // returns array with these elements sections, Rs, total bill, {title,rate,delivery charge,quantity,bill amount}
    NSDateFormatter* dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"MMM dd, yyyy"];
    [dformat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
    NSMutableArray* paperbillarr = [[NSMutableArray alloc] init];
    NSMutableArray* paperdetails = [[NSMutableArray alloc] init];
    
    NSArray* paperarr = [self getPaperDetails];

    [paperbillarr addObject:[paperarr objectAtIndex:1]];  // sections
    [paperbillarr addObject:[paperarr objectAtIndex:0]];  // currency Rs.

    NSArray* papers = [[NSArray alloc] initWithArray:[paperarr objectAtIndex:2]];    
    
    double totalbill = 0;
    
    for (NSDictionary* dict in papers)
    {
        double billamt = 0;
        NSUInteger defaultdays = 0;
        NSUInteger dayind = 0;
        NSInteger devbill = 0;
        
        NSMutableDictionary* returndict1 = [[NSMutableDictionary alloc]init];
        
        [returndict1 setValue:[dict objectForKey:@"title"] forKey:@"title"];
                    
        NSString* defrmdt = [dict objectForKey:@"fromdate"];
        NSDate* dfrdt = [dformat dateFromString:defrmdt];
                    
        NSString* dftostr = [dict objectForKey:@"todate"];
        
        if (dftostr == nil) {
            dftostr = @"Dec 31, 2100";
        }
        
        NSDate* dftodt = [dformat dateFromString:dftostr];
        
        NSString* freqstr = [dict objectForKey:@"frequency"];
        BOOL isdaily = YES;
        
        if ([freqstr compare:@"weekly"] == NSOrderedSame)
        {
            isdaily = NO;
        }

        NSUInteger fridays = 0;
        NSUInteger saturdays = 0;
        NSUInteger sundays = 0;
        NSUInteger wkdays = 0;
                    
        if ([frmdt compare:dftodt] == NSOrderedDescending  ||
            [dfrdt compare:todt] == NSOrderedDescending )
        {
            // Paper from date is later than Todate of bill date OR
            // Paper to date is before bill from date
            // Ignore this paper
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
            
            // find number of months, used to calculate delivery charge
            NSUInteger monthsct = (defaultdays/32);

            if ((defaultdays - (monthsct*32)) > 15 ) {
                monthsct++;
            }
            
            devbill = [[dict objectForKey:@"deliverycharge"] integerValue] * monthsct;
            [returndict1 setValue:[NSString stringWithFormat:@"%ld",(long)devbill] forKey:@"deliveryCharge"];
            
            if (isdaily == YES)
            {
                // find fridays
                fridays = [MBKCModel getNumberOf:6 From:dfeffectivefrmdt Till:dfeffectivetodt];
                
                // find saturdays
                saturdays = [MBKCModel getNumberOf:7 From:dfeffectivefrmdt Till:dfeffectivetodt];
                
                // find SUndays
                sundays = [MBKCModel getNumberOf:1 From:dfeffectivefrmdt Till:dfeffectivetodt];
                
                // Rest are weekdays
                wkdays = defaultdays - saturdays - sundays - fridays;
            }
            else
            {
                dayind = [[dict objectForKey:@"sundayprice"] integerValue];
                wkdays = [MBKCModel getNumberOf:dayind From:dfeffectivefrmdt Till:dfeffectivetodt];
            }
            
            // Now get the exceptions data
            NSArray* exceptions = [dict objectForKey:@"exceptions"];
                        
            for (NSDictionary* exobj in exceptions)
            {
                NSString* frstr = [exobj objectForKey:@"fromDate"];
                NSDate* exfrdt = exfrdt = [dformat dateFromString:frstr];
                            
                frstr = [exobj objectForKey:@"toDate"];
                NSDate* extodt = [dformat dateFromString:frstr];
                            
                if ([dfeffectivefrmdt compare:extodt] == NSOrderedDescending  ||
                    [exfrdt compare:dfeffectivetodt] == NSOrderedDescending )
                {
                    // Exception from date is later than Todate of bill date OR
                    // Exception to date is before bill from date
                    // Ignore this exception
                }
                else
                {
                    NSDate* effectivefrmdt;
                    NSDate* effectivetodt;
                                
                    if ([exfrdt compare:dfeffectivefrmdt] == NSOrderedDescending)
                    {
                        // Means exception from date is later than bill from date
                        // so make it effective start date
                        effectivefrmdt = exfrdt;
                    }
                    else
                    {
                        // Bill from date is later than exception start date
                        // so make it effective start date
                        effectivefrmdt = dfeffectivefrmdt;
                    }
                                
                    if ([extodt compare:dfeffectivetodt] == NSOrderedDescending)
                    {
                        effectivetodt = dfeffectivetodt;
                    }
                    else
                    {
                        effectivetodt = extodt;
                    }
                                                    
                    if (isdaily == YES)
                    {
                        NSInteger exdays = [MBKCModel getNumberOfDaysFrom:effectivefrmdt Till:effectivetodt];

                        // find fridays
                        NSUInteger efffridays = [MBKCModel getNumberOf:6 From:effectivefrmdt Till:effectivetodt];
                        
                        // find saturdays
                        NSUInteger effsaturdays = [MBKCModel getNumberOf:7 From:effectivefrmdt Till:effectivetodt];
                        
                        // find SUndays                     
                        NSUInteger effsundays = [MBKCModel getNumberOf:1 From:effectivefrmdt Till:effectivetodt];
                        
                        // Rest are weekdays
                        NSUInteger effwkdays = exdays - effsaturdays - effsundays - efffridays;
                        
                        saturdays = saturdays - effsaturdays;
                    
                        sundays = sundays - effsundays;
                        
                        fridays = fridays - efffridays;
                    
                        wkdays = wkdays - effwkdays;
                    }
                    else
                    {
                        NSUInteger effwkdays = [MBKCModel getNumberOf:dayind From:effectivefrmdt Till:effectivetodt];
                        wkdays = wkdays - effwkdays;       
                    }
                }
            }
        }    
        if (isdaily == YES)
        {
            double sunprice = [[dict objectForKey:@"sundayprice"] doubleValue];
            double wkprice = [[dict objectForKey:@"weekdayprice"] doubleValue];
            double satprice = [[dict objectForKey:@"saturdayprice"] doubleValue];
            double friprice = [[dict objectForKey:@"fridayprice"] doubleValue];
            
            billamt = (friprice * fridays) + (satprice * saturdays) + (sunprice * sundays) + (wkprice * wkdays) ;
        }
        else
        {
            double wkprice = [[dict objectForKey:@"saturdayprice"] doubleValue];
            billamt = (wkprice * wkdays) ;
        }

        [returndict1 setValue:[NSString stringWithFormat:@"%.2f",billamt] forKey:@"billamt"];
        
        totalbill = totalbill + billamt + devbill;
                    
        [paperdetails addObject:returndict1];
    }
                
    [paperbillarr addObject:[NSString stringWithFormat:@"%.2f",totalbill]];
    [paperbillarr addObject:paperdetails];

    return paperbillarr;
}


     
@end
