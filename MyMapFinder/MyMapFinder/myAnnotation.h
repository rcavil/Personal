//
//  myAnnotation.h
//  MyMapFinder
//
//  Created by Ron Cavil on 5/5/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//3.1
@interface myAnnotation : NSObject
@property (strong, nonatomic) NSString *title;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;
@end



