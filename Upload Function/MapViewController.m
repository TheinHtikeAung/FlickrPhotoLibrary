//
//  MapViewController.m
//  SA Flickr
//
//  Created by Thein Htike Aung on 13/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//


#import "MapViewController.h"
#import "MapAnnotation.h"
#import "PhotoUploadViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize txtLocation, mapView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) annotateMap:(CLLocationCoordinate2D) newCoordinate title:(NSString*) title{
    MapAnnotation *ma=[[MapAnnotation alloc] initWithCoordinate:newCoordinate title:title];
    [mapView addAnnotation:ma];
    [mapView setCenterCoordinate:newCoordinate animated:YES];
    
    return;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    NSLog(@"did Update Location");
    CLLocation *firstPlacement=[locations lastObject];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:firstPlacement completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks)
        {
            NSString *addressTxt =[NSString stringWithFormat:@"%@ %@,%@ %@",
                                   [placemark subThoroughfare],[placemark thoroughfare],
                                   [placemark locality], [placemark administrativeArea]];
            
            [self annotateMap:firstPlacement.coordinate title:addressTxt];
            txtLocation.text=addressTxt;
                    }
    }];
    
    [locationManager stopUpdatingLocation];
    
}
 

// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
  
}
/*
-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:kGeoCodingString,pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return [locationString substringFromIndex:6];
    
 
}
 */

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}

-(void)currentLocatoin{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    CLGeocoder *geoCoder=[[CLGeocoder alloc]init];
    [geoCoder geocodeAddressString:txtLocation.text completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *firstPlacement =[placemarks objectAtIndex:0];
        [self annotateMap:firstPlacement.location.coordinate title:txtLocation.text];
        
        if(error){
            NSLog(@"Error: %@",[error description]);
        }
    }
     
    ];
    
    [searchBar resignFirstResponder];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [[self navigationController] setToolbarHidden:YES animated:YES];
    [self currentLocatoin];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        NSMutableArray* navArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];

        PhotoUploadViewController *photo=[navArray lastObject];
        photo.txtLocation.text=txtLocation.text;
        
    }
    [super viewWillDisappear:animated];
}

@end
