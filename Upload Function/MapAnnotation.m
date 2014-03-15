//
//  MapAnnotation.m
//  MapViewEx
//
//  Created by Thein Htike Aung on 6/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation 
@synthesize coordinate, title;

-(id) initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString*)t{
    if(self=[super init]){
        coordinate=c;
        [self setTitle:t];
    }
    return self;
}
@end
