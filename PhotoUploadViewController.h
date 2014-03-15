//
//  PhotoUploadViewController.h
//  SA Flickr
//
//  Created by Thein Htike Aung on 8/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PhotoUploadViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *popoverLocal;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnTakeFromLibrary;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnCamera;

@property (nonatomic, retain) IBOutlet UIImageView * imageView;

- (IBAction)playMusic:(id)sender;
- (IBAction)goToMap:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtLocation;

- (IBAction)btnShare:(id)sender;
-(IBAction) getPhoto:(id) sender;
@end
