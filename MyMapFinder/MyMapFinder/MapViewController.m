//
//  MapViewController.m
//  MyMapFinder
//
//  Created by Ron Cavil on 4/14/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "SearchEntryStore.h"
#import "SearchEntry.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mapSearchBar;


//View Related Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    [self zoomStart];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //Set first search entry and then search for it for initial launch
    if (appLaunched==false)
    {
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];

        appLaunched=true;
        [self changeSearchEntryItem:@"initial"];
    }
    else
    {        
      [self updateSearchEntryLabel];
      [self searchMapLogicMain:@"viewappeared"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//View Actions


- (IBAction)type:(id)sender
{
    //Change map appearances for 3 different map types
    if (_mapView.mapType == MKMapTypeStandard)
        _mapView.mapType = MKMapTypeSatellite;
    else if (_mapView.mapType == MKMapTypeSatellite)
        _mapView.mapType = MKMapTypeHybrid;
    else
        _mapView.mapType = MKMapTypeStandard;
}

- (IBAction)currentLocationBarButton:(UIBarButtonItem *)sender
{
    [self zoomStart];
}

- (IBAction)nextSearchEntryItem:(UIBarButtonItem *)sender
{
    //Go to next saved search item
    [self changeSearchEntryItem:@"next"];
}

- (IBAction)prevSearchEntryItem:(UIBarButtonItem *)sender
{
    //Go to previous saved search item
    [self changeSearchEntryItem:@"prev"];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
  {
    //perform a manual search based on user's input
    [searchBar resignFirstResponder];
    [self searchMapLogicMain:@"manualsearch"];
  }

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
  {
   //Cancel search bar keyboard
   [searchBar resignFirstResponder];
  }

//MapView Related Methods


- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    //user updated map location, perform search
    [self searchMapLogicMain:@"updateuserlocation"];
}

/*
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    [self searchMapLogicMain:@"finishloading"];
}
*/

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    [self searchMapLogicMain:@"finishloading"];
}


- (void) zoomStart
{
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 5000, 5000);
    
    [_mapView setRegion:region animated:NO];
    [self searchMapLogicMain:@"zoom"];

}


//Map search logic methods

- (void) searchMapLogicMain: (NSString *)action
{
    //main entry point to determine if a new search should be performed
    //if the location and search item are the same as previouslly
    //don't perform the same search again
    //if ok to perform a seach, call out the performActualMapSearch method
    
    float currentLongitude=_mapView.region.center.longitude;
    float currentLatitude=_mapView.region.center.latitude;
    NSString *currentSearchText=mapSearchBar.text;
    
    bool runSearch=false;
    
    if ([action isEqual:@"changesearchentry"])
    {
        runSearch=true;
    }
    else
    {
      //check to see if a new search: if location changed and a different search item taking place
        
        if ((currentLongitude !=prevSearchLongitude) ||  (currentLatitude!= prevSearchLatitude) || (![currentSearchText isEqualToString:prevSearchItem]))
        {
            runSearch=true;
        }
        
    }
    
    if (runSearch==true)
    {
        //New search
        prevSearchLongitude=currentLongitude;
        prevSearchLatitude=currentLatitude;
        prevSearchItem=currentSearchText;
        
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.region = _mapView.region;
        
        request.naturalLanguageQuery = currentSearchText;
        [self performActualMapSearch:request];
    }
    
}

- (SearchEntry *) getCurrentSearchEntry
{
    //Get the current saved search entry
    NSInteger intCurrentEntry=[[SearchEntryStore SharedStore] currentEntry];
    
    if (intCurrentEntry==-1)
    {
        [self changeSearchEntryItem:@"initial"];
        
        intCurrentEntry=[[SearchEntryStore SharedStore] currentEntry];
    }
    
    SearchEntry *searchEntryItem=[[SearchEntryStore SharedStore] EntryAtIndex:intCurrentEntry];

    return searchEntryItem;
}

- (void) performActualMapSearch: ( MKLocalSearchRequest *) request
{
    //routine that actually performs the map search
    [self clearMapAnnotations];
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         [self createMapAnnotations:response];
     }
     ];
    
}

- (IBAction)addSearchEntryBarButton:(UIBarButtonItem *)sender
{
   //Attempt to add new search item entry
    
    NSString *newEntryName = [mapSearchBar.text lowercaseString];
    
    if (newEntryName.length==0)
    {
        [self displayAlertView:@"New search entry is blank" :@"Add cancelled."];
    }
    
    else
    {
        //See if new entry already exists
        BOOL newEntryExists=[[SearchEntryStore SharedStore] searchEntryExists:(newEntryName)];
        
        if (newEntryExists==false)
        {
            [self addNewSearchEntry:newEntryName];
            
            NSString *outputString=[NSString stringWithFormat:@"New search entry %@ has been added",newEntryName];
            [self displayAlertView:outputString :@"Add completed."];
        }
        else
        {
            NSString *outputString=[NSString stringWithFormat:@"New search entry %@ already exists",newEntryName];
           [self displayAlertView:outputString :@"Add cancelled."];
        }
    }

}

//Search entry related

- (void) addNewSearchEntry:(NSString *)newEntryName
{
    //temp search entry variable that will be use to create a new search entry
    SearchEntry *tempEntry = [[SearchEntry alloc] init];
    [tempEntry setEntryName:newEntryName];
    
    //Add new search entry via Shared Store
    [[SearchEntryStore SharedStore] addEntry: tempEntry];
    
    //Sort search items with new entry
    [[SearchEntryStore SharedStore] sortSearchEntries];

}


- (void)changeSearchEntryItem:(NSString *)action
{
    //search entry text changes
    bool runSearch=false;

      if ([action isEqual:@"initial"])
      {
          [[SearchEntryStore SharedStore] incrementCurrentEntry];
          runSearch=false;
      }
    
      else if ([action isEqual:@"next"])
        {
          [[SearchEntryStore SharedStore] incrementCurrentEntry];
          runSearch=true;
        }
      else if ([action isEqual:@"prev"])
        {
          [[SearchEntryStore SharedStore] decrementCurrentEntry];
          runSearch=true;
        }
   
      //Update Search Entry Label
 
    [self updateSearchEntryLabel];
    
    
      //Perform Search if applicable
      if (runSearch==true)
        {
            [self searchMapLogicMain:@"changesearchentry"];
        }
}


- (void) updateSearchEntryLabel
{
    SearchEntry *searchEntryItem=[self getCurrentSearchEntry];
    mapSearchBar.text=searchEntryItem.entryName;
}

//Map anotations methods

- (void)createMapAnnotations: (MKLocalSearchResponse *)response
{
    //create a map annotation for each returned search results
    for (MKMapItem *item in response.mapItems)
    {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        
        annotation.coordinate = item.placemark.coordinate;
        annotation.title      = item.name;
        annotation.subtitle   = [NSString stringWithFormat:@"%@ %@ %@", item.placemark.subThoroughfare, item.placemark.thoroughfare,item.phoneNumber];
        [_mapView addAnnotation:annotation];
        
    }

}


- (void) clearMapAnnotations
{
 [_mapView removeAnnotations:[_mapView annotations]];
}


//Display alert view

- (void) displayAlertView:(NSString *)title :(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

@end


