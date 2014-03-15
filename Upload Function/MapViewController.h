//
//  MapViewController.h
//  SA Flickr
//
//  Created by Thein Htike Aung on 13/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//
#define kGeoCodingString @"http://maps.google.com/maps/geo?q=%f,%f&output=csv"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <UISearchBarDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *txtLocation;

@end
