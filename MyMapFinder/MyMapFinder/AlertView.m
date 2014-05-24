//
//  AlertView.m
//  MyMapFinder
//
//  Created by Ron on 5/24/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

+ (void) displayAlertView:(NSString *)title :(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}



@end
