//
//  Favorite_Photos.h
//  SA Flickr
//
//  Created by Thein Htike Aung on 9/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite_Photos : NSManagedObject

@property (nonatomic, retain) NSNumber * photoID;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * title;
@property UIImage *image;

@end
