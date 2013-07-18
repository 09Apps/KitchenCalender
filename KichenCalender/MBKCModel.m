//
//  MBKCModel.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 7/18/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "MBKCModel.h"

@implementation MBKCModel

- (NSDictionary*) getMilkDetails
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
    
    NSLog(@"pListPath %@",plistPath);
    
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
    
//    NSArray* arr = [temp allKeys];
    
//    for (id obj in arr)
//		NSLog(@"keys %@",obj);
    
    // assign values
    
    self.sections = [temp objectForKey:@"sections"];
    
    NSDictionary *dict = [temp objectForKey:@"milk1"];
    if (!dict)
    {
        NSLog(@"dict is null");
    }
    else
    {
        NSArray* nsa = [dict allValues];
        [nsa objectAtIndex:0];
    }
    
    return dict;
}

@end
