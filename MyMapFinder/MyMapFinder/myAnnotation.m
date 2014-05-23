//
//  myAnnotation.m
//  MyMapFinder
//
//  Created by Ron Cavil on 5/5/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import "myAnnotation.h"

@implementation myAnnotation

//3.2
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
    }
    return self;
}

@end


