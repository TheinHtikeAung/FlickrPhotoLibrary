//
//  MapAnnotation.h
//  MapViewEx
//
//  Created by Thein Htike Aung on 6/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>{
    NSString *title;
    CLLocationCoordinate2D coordinate;
    
}

@property(nonatomic,readwrite) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;

-(id) initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString*)t;

@end
