//
//  ViewController.h
//  SA Flickr
//
//  Created by Thein Htike Aung on 6/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PhotoDetailViewController;

@interface ViewController : UIViewController <UITabBarDelegate, UISearchBarDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) PhotoDetailViewController *photoDetailViewController;
- (IBAction)playMusic:(id)sender;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
