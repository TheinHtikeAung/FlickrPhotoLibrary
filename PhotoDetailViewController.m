//
//  PhotoDetailViewController.m
//  SA Flickr
//
//  Created by Thein Htike Aung on 7/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "Flickr.h"
#import "PhotoDetailViewController.h"
#import "FlickrPhoto.h"
#import "PhotoUploadViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "FavoriteMasterViewController.h"
#import "Favorite_Photos.h"
#import "AppDelegate.h"
#import "Toast+UIView.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

@synthesize flickrPhoto;
@synthesize btnPlay;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)done:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}


- (void)viewDidAppear:(BOOL)animated{
    
//    NSLog(@"Detail View started");
    
    self.txtTitle.text=self.flickrPhoto.title;
    
    if (self.flickrPhoto.largeImage) {
        
//        NSLog(@"Large Image loaded !");
//        CGSize newSize=[self makeSize:self.flickrPhoto.largeImage.size fitInSize:self.detailPhotoView.image.size];
        
        //self.detailPhotoView. size=newSize;
//        self.detailPhotoView.frame = CGRectMake(0.0f, 0.0f,50.0f, 50.0f);
//        
//        self.detailPhotoView.contentMode = UIViewContentModeBottomLeft;
//        self.detailPhotoView.clipsToBounds = YES;
//        
        self.detailPhotoView.image = self.flickrPhoto.largeImage;
        
        

    } else {
        
        self.detailPhotoView.image = self.flickrPhoto.thumbnail;
        
        [Flickr loadImageForPhoto:self.flickrPhoto thumbnail:NO
				  completionBlock:^(UIImage *photoImage, NSError *error) {
                      
					  if (!error) {
						  dispatch_async(dispatch_get_main_queue(), ^{
                              NSLog(@"Testing Image detail photo");
                              
                              /*
                              CGRect frame= self.detailPhotoView.frame;
                              self.detailPhotoView.frame = frame;
                               */
                              
							  self.detailPhotoView.image = self.flickrPhoto.largeImage;

						  });
					  }
				  }];
    }
}

- (CGSize)makeSize:(CGSize)originalSize fitInSize:(CGSize)boxSize
{
    float widthScale = 0;
    float heightScale = 0;
    
    widthScale = boxSize.width/originalSize.width;
    heightScale = boxSize.height/originalSize.height;
    
    float scale = MIN(widthScale, heightScale);
    
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    return newSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postToFacebook:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancelled");
            } else
            {
                NSLog(@"Done");
            }
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        [controller setInitialText:@" via SA Flickr"];
        [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,@"b"]]];
//        [controller addImage:[UIImage imageNamed:@"ISSLogo.jpg"]];
        
        [controller addImage:flickrPhoto.largeImage];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else{
        NSLog(@"UnAvailable");
    }

}

- (IBAction)postToTwitter:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancelled");
            } else
            {
                NSLog(@"Done");
            }
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        [controller setInitialText:@" via SA Flickr"];
                [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,@"b"]]];
        [controller addImage:flickrPhoto.largeImage];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else{
        NSLog(@"UnAvailable");
    }

}

- (IBAction)shareByEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"A Message from SA Flickr"];
   //     NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        
    //    [mailer setToRecipients:toRecipients];
   //     UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
        
        NSData *imageData = UIImagePNGRepresentation(flickrPhoto.largeImage);
        [mailer addAttachmentData:imageData mimeType:@"image/jpg" fileName:flickrPhoto.title];
  
        NSString *emailBody = flickrPhoto.title;
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Plesae login to your mail."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];

    }}

- (IBAction)playMusic:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HandleMusic" object:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)shareButtonAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Share to Facebook", @"Share to Twitter", @"Share By Email", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)addToFavorite:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add to Favorite" message:@"Type comment" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (IBAction)handleSwipeLeft:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handleDoubleTap:(id)sender {
    [self addToFavorite:sender];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==1){
        
    Favorite_Photos *favoritePhotos=[NSEntityDescription
                                     insertNewObjectForEntityForName:@"Favorite_Photos" inManagedObjectContext:managedObjectContext];
    
    favoritePhotos.photoID=[NSNumber numberWithLongLong:flickrPhoto.photoID];
    favoritePhotos.photoURL=[NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,@"s"];
    favoritePhotos.comment=[[alertView textFieldAtIndex:0] text];
    favoritePhotos.title=flickrPhoto.title;
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    [self showToast];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.needRefresh = true;
        
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%i", buttonIndex);
    
    switch (buttonIndex) {
        case 1:
            [self postToFacebook:nil];
            break;
            
        case 2:
            [self postToTwitter:nil];
            break;
            
        case 3:
            [self shareByEmail:nil];
            break;
            
        default:
            break;
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
            [[self navigationController] setToolbarHidden:YES animated:YES];
    }
    [super viewWillDisappear:animated];
}

-(void) showToast{
    
    // Show an imageView as toast, on center at point (110,110)
    UIImageView *toastView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite.png"]];
    
    [self.view showToast:toastView
                duration:2.0
                position:[NSValue valueWithCGPoint:CGPointMake(384, 384)]]; // wrap CGPoint in an NSValue object
    /*
    [self.view makeToast:@"Image is successfully added to Favorite List."
                duration:3.0
                position:@"center"
                   image:[UIImage imageNamed:@"favorite.png"]];
     */
}

@end
