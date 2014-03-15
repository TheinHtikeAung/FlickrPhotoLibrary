//
//  PhotoDetailViewController.h
//  SA Flickr
//
//  Created by Thein Htike Aung on 7/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class FlickrPhoto;
@interface PhotoDetailViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) FlickrPhoto *flickrPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *detailPhotoView;
@property (strong, nonatomic) IBOutlet UILabel *txtTitle;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)postToFacebook:(id)sender;
- (IBAction)postToTwitter:(id)sender;
- (IBAction)shareByEmail:(id)sender;
- (IBAction)playMusic:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
- (IBAction)shareButtonAction:(id)sender;
- (IBAction)addToFavorite:(id)sender;
- (IBAction)handleSwipeLeft:(id)sender;
- (IBAction)handleDoubleTap:(id)sender;

@end
