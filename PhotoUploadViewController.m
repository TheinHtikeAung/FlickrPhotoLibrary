//
//  PhotoUploadViewController.m
//  SA Flickr
//
//  Created by Thein Htike Aung on 8/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "PhotoUploadViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "MapViewController.h"


@interface PhotoUploadViewController ()

@end

@implementation PhotoUploadViewController

@synthesize imageView, popoverLocal, btnTakeFromLibrary, txtLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setToolbarHidden:NO animated:YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnShare:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Share to Facebook", @"Share to Twitter", @"Share By Email", nil];
    
    [actionSheet showInView:self.view];
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
        
        [controller setInitialText:[self prepareInitialText]];
        
    //    [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,@"b"]]];
        //        [controller addImage:[UIImage imageNamed:@"ISSLogo.jpg"]];
        
        [controller addImage:imageView.image];
        
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
        
        [controller setInitialText:[self prepareInitialText]];
       // [controller addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,@"b"]]];
        [controller addImage:imageView.image];
        
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
        //    UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
    
        
        NSData *imageData = UIImageJPEGRepresentation(imageView.image, 1.0);

        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"photo"];
        
        NSString *emailBody = @"[self prepareInitialText]";
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

- (IBAction)goToMap:(id)sender {
    
    MapViewController *map=[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        
    [self.navigationController pushViewController:map animated:YES];
//    [[self navigationController] setToolbarHidden:NO animated:YES];
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

-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if((UIBarButtonItem *) sender == btnTakeFromLibrary) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            
            //        [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
            popover.popoverContentSize = CGSizeMake(300.0f, 300.0f);
            
            [popover presentPopoverFromBarButtonItem:btnTakeFromLibrary permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
//            [popover presentPopoverFromRect:CGRectMake(0,0,1,1) inView:btnTakeFromLibrary permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
            
            self.popoverLocal = popover;
            
            //      [self.popoverLocal presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        } else {
            [self presentViewController:picker animated:YES completion:nil];
        }

	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
	}
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
        
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

-(void) viewWillAppear:(BOOL)animated{
    
    [[self navigationController] setToolbarHidden:NO animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[self navigationController] setToolbarHidden:YES animated:YES];
    }
    [super viewWillDisappear:animated];
}

-(NSString*)prepareInitialText{
    
    if(![txtLocation.text isEqualToString:@"-"] && ![txtLocation.text isEqualToString:@""]){
        return [NSString stringWithFormat:@"via SA Flickr, location : %@",txtLocation.text];
    }
    
    return @"via SA Flickr";
}

@end
