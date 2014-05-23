//
//  MapViewController.h
//  MyMapFinder
//
//  Created by Ron Cavil on 4/14/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate>
{
    bool appLaunched;
    float prevSearchLongitude;
    float prevSearchLatitude;
    NSString * prevSearchItem;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Actions
- (IBAction)type:(id)sender;
- (IBAction)nextSearchEntryItem:(UIBarButtonItem *)sender;
- (IBAction)prevSearchEntryItem:(UIBarButtonItem *)sender;
- (IBAction)currentLocationBarButton:(UIBarButtonItem *)sender;
- (IBAction)addSearchEntryBarButton:(UIBarButtonItem *)sender;

// Properties
@property (weak, nonatomic) IBOutlet UISearchBar *mapSearchBar;

@end
