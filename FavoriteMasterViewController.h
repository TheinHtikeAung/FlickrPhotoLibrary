//
//  FavoriteMasterViewController.h
//  SA Flickr
//
//  Created by Thein Htike Aung on 8/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface FavoriteMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)playMusic:(id)sender;

-(void)refreshDB;

@end
