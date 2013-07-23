//
//  MBKCModel.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/18/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBKCModel.h"

@implementation MBKCModel

- (NSDictionary*) getMilkDetails:(NSInteger)counter
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
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"KCPList" ofType:@"plist"];
    }
    
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

    NSDictionary *dict;
    
    if(counter == 1)
        dict = [temp objectForKey:@"milk1"];
    else
        dict = [temp objectForKey:@"milk2"];        

////// Use to debug
//    NSArray* nsa = [dict allValues];
//    for (id obj in nsa)
//		NSLog(@"values %@",obj);
///////
    
    return dict;
}

- (void) setMilkDetailsWithMilk1:(NSDictionary*)dict1 AndMilk2:(NSDictionary*)dict2
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
        }

    }
    
    NSArray* dictarr = [[NSArray alloc] initWithObjects:self.sections, dict1, dict2, nil];
    NSArray* keyarr = [[NSArray alloc] initWithObjects:@"sections", @"milk1", @"milk2", nil];
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjects:dictarr forKeys:keyarr];
    
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


@end
