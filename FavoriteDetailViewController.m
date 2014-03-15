//
//  FavoriteDetailViewController.m
//  SA Flickr
//
//  Created by Thein Htike Aung on 9/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "FavoriteDetailViewController.h"

@interface FavoriteDetailViewController ()
@property NSString *oldComment;
@end

@implementation FavoriteDetailViewController

@synthesize managedObjectContext, favorite_Photos, btnSave, oldComment;
@synthesize txtTitle, imageView, txtComment;

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
	// Do any additional setup after loading the view.
    txtTitle.text= favorite_Photos.title;
    NSString *url=[favorite_Photos.photoURL stringByReplacingOccurrencesOfString:@"_s" withString:@"_b"];
    imageView.image = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: url]]];
    txtComment.text=favorite_Photos.comment;

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
    [self loadForSaveButton];
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    [self loadForSaveButton];
}

-(void)updateComment{
    
    self.favorite_Photos.comment=txtComment.text;
    
    NSError *error;
    if ([self.favorite_Photos.managedObjectContext hasChanges] && ![self.favorite_Photos.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-170, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+170, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [self loadForSaveButton];
        
        [textView resignFirstResponder];
        return NO;
    }

    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

-(void)loadForSaveButton{
    if(![oldComment isEqualToString:txtComment.text]){
        
        NSMutableArray *toolbarButtons = [self.toolbarItems mutableCopy];
        if (![toolbarButtons containsObject:self.btnSave]) {
            [toolbarButtons insertObject:self.btnSave atIndex:0];
            [self setToolbarItems:toolbarButtons animated:YES];
        }
    }
}

- (IBAction)playMusic:(id)sender {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HandleMusic" object:nil];
}

- (IBAction)updateComment:(id)sender {
    [self updateComment];
}

- (IBAction)deleteFavorite:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm delete action" message:@"Are you sure you want to delete this?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
    [alert show];
    
}

- (IBAction)handleSwipeLeft:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        
        [self.managedObjectContext deleteObject:self.favorite_Photos];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSMutableArray *toolbarButtons = [self.toolbarItems mutableCopy];
    
    [toolbarButtons removeObject:self.btnSave];
    [self setToolbarItems:toolbarButtons animated:YES];
    
    oldComment=favorite_Photos.comment;
}
@end
