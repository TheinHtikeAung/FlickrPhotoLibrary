//
//  FavoriteDetailViewController.h
//  SA Flickr
//
//  Created by Thein Htike Aung on 9/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorite_Photos.h"

@interface FavoriteDetailViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *txtTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtComment;

@property (nonatomic, strong) Favorite_Photos *favorite_Photos;
- (IBAction)playMusic:(id)sender;
- (IBAction)updateComment:(id)sender;
- (IBAction)deleteFavorite:(id)sender;
- (IBAction)handleSwipeLeft:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@end
