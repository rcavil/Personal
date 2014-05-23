//
//  SearchEntry.m
//  MyMapFinder
//
//  Created by Ron on 4/26/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import "SearchEntry.h"

@implementation SearchEntry

//Setters and Getters for search entry related information

- (void) setEntryName:(NSString *)strEntryName
{
    _entryName=strEntryName;
}

- (NSString *) entryName
{
    return _entryName;
}

+(SearchEntry*) AddDefaultEntry:(NSString *)strEntryName
{

    //temp entry variable
    SearchEntry *tempEntry = [[SearchEntry alloc] init];
    
    //NSString *entryName = [[NSString alloc] initWithFormat:@"%@", name];
    
    [tempEntry setEntryName:strEntryName];
    
    return tempEntry;

}

@end
