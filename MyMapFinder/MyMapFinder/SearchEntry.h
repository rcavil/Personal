//
//  SearchEntry.h
//  MyMapFinder
//
//  Created by Ron on 4/26/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchEntry : NSObject

//Search Entry Class.  Just one property so far
{
    NSString *_entryName;
}

- (void) setEntryName:(NSString *)strEntryName;

- (NSString *) entryName;


//Declare static method used to prefill random entry values
+(SearchEntry *) AddDefaultEntry:(NSString *)strEntryName;


@end
