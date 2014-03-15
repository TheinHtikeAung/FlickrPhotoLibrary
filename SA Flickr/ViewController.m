//
//  ViewController.m
//  SA Flickr
//
//  Created by Thein Htike Aung on 6/8/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "ViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoCell.h"
#import "StackedGridLayout.h"
#import "PhotoDetailViewController.h"
#import "FavoriteMasterViewController.h"
#import "PhotoUploadViewController.h"

#import "Toast+UIView.h"

@interface ViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL isShowingActivity;

@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property(nonatomic, weak) IBOutlet UITextField *textField;
@property(nonatomic, strong) NSMutableDictionary *searchResults;
@property(nonatomic, strong) NSMutableArray *searches;
@property(nonatomic, strong) Flickr *flickr;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *layoutSelectionControl;

@property (nonatomic, strong) StackedGridLayout *layout3;


- (IBAction)shareButtonTapped:(id)sender;

@end

@implementation ViewController

@synthesize photoDetailViewController, audioPlayer;
@synthesize managedObjectContext;
@synthesize managedObjectModel, persistentStoreCoordinator;
@synthesize searchResults;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    ------ Audio Prepare Code  --------
    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:@"despicableMe2" withExtension:@"mp3"];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    [audioPlayer setNumberOfLoops:-1];
    
    //Make sure the system follows our playback status
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    //Load the audio into memory
    [audioPlayer prepareToPlay];
//    ----------------------------------------
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
 //   UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.textField setBackground:textFieldImage];
    
    // ---------------------------------------------------------------------
    

    self.searches = [@[] mutableCopy];
    self.searchResults = [@{} mutableCopy];
    
    self.flickr = [[Flickr alloc] init];
    
    self.layout3 = [[StackedGridLayout alloc] init];
    self.layout3.headerHeight = 0.0f;
    
    self.collectionView.collectionViewLayout = self.layout3;
    
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    
    //---------- Observer for "Music Play and Pause ----------------
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleMusic:) name:@"HandleMusic" object:nil];
    
    /*
    // create a toolbar to have two buttons in the right
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 133, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // create a standard "add" button
    UIBarButtonItem* bi = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:NULL];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];
    
    // create a spacer
    bi = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:bi];
    
    // create a standard "refresh" button
    bi = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];
    
    // stick the buttons in the toolbar
    [tools setItems:buttons animated:NO];
    
    
    // and put the toolbar in the nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
     */

    // Hide the toolbar
    [[self navigationController] setToolbarHidden:YES animated:YES];
    
//    _isShowingActivity = TRUE;
    [self showActivity];
    
}

-(void) handleMusic:(NSNotification*)notif{
    [self togglePlayPause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)shareButtonTapped:(id)sender {
    // TODO
}


#pragma mark - UITextFieldDelegate methods
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSString *searchTerm = self.searches[section];
    
    return [self.searchResults[searchTerm] count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {

    if ([self.searches count]==0) {
        return 0;
    }else{
        return 1;
    }
//    return [self.searches count];
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    */
    
    FlickrPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSString *searchTerm = self.searches[indexPath.section];
    
    FlickrPhoto *photo=self.searchResults[searchTerm][indexPath.item];
    
    //    NSString *searchTerm = self.searches[indexPath.section];
    
    //   FlickrPhoto *photo=self.searchResults[searchTerm][indexPath.item];
    
    if(!photo.thumbnail){
        /*
        NSString *searchURL = [Flickr flickrPhotoURLForFlickrPhoto:photo size:@"m"];
        //NSLog(@"%@",searchURL);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                  options:0
                                                    error:&error];
        UIImage *image = [UIImage imageWithData:imageData];
        photo.thumbnail = image;
        
        self.searchResults[searchTerm][indexPath.item]=photo;
*/
        
        [Flickr loadImageForPhoto:photo thumbnail:YES
				  completionBlock:^(UIImage *photoImage, NSError *error) {
                      
					  if (!error) {
						  dispatch_async(dispatch_get_main_queue(), ^{
                              NSLog(@"Testing Image detail photo");
                              
                              photo.thumbnail=photoImage;
                              self.searchResults[searchTerm][indexPath.item]=photo;
                              cell.photo = photo;
						  });
					  }
				  }];
        
    }else{
        cell.photo = photo;
    }

    
    
    /*
    if(!photo.thumbnail){
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        NSError *error = nil;
        
    //    NSString *searchTerm = self.searches[indexPath.section];
        
     //   FlickrPhoto *photo=self.searchResults[searchTerm][indexPath.item];

        NSString *searchURL = [Flickr flickrPhotoURLForFlickrPhoto:photo size:@"m"];
        //NSLog(@"%@",searchURL);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                  options:0
                                                    error:&error];
        UIImage *image = [UIImage imageWithData:imageData];
        photo.thumbnail = image;
        
        cell.photo = photo;
        cell.backgroundColor = [UIColor whiteColor];
        
        self.searchResults[searchTerm][indexPath.item]=cell.photo;
    });
    }
     */


    // --- Code string cutter for 'Title'
    /*
    if (![cell.photo.title isEqualToString:@""] && [cell.photo.title length]>20) {
        
        cell.lblTitle.text=[cell.photo.title substringWithRange:NSMakeRange(1, 20)];
    }else{
        cell.lblTitle.text=cell.photo.title;
    }
     */


    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoDetailViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"PhotoDetailViewController"];
    
    detail.managedObjectContext=self.managedObjectContext;
    
    // Transfer view
    FlickrPhoto *selectedPhoto = nil;
    NSString *searchTerm=self.searches[indexPath.section];
    
    selectedPhoto=self.searchResults[searchTerm][indexPath.item];
    detail.flickrPhoto=selectedPhoto;
    [self.navigationController pushViewController:detail animated:YES];
    
    [[self navigationController] setToolbarHidden:NO animated:YES];
    
 //   self.photoDetailViewController.flickrPhoto=photo;

 //   [self performSegueWithIdentifier:@"ShowDetail" sender:photo];
//    [self.navigationController pushViewController:self.photoDetailViewController animated:YES];

//    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{ self.window.rootViewController = photoDetailViewController; } completion:nil];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *searchTerm = self.searches[indexPath.section];
    FlickrPhoto *photo =self.searchResults[searchTerm][indexPath.row];
    // 2
    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    
    retval.height += 35; retval.width += 35;
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
//    top, left, bottom, right
//    return UIEdgeInsetsMake(10, 10, 10, 10);
    }

#pragma mark - StackedGridLayoutDelegate
- (NSInteger)collectionView:(UICollectionView*)cv
                     layout:(UICollectionViewLayout*)cvl
   numberOfColumnsInSection:(NSInteger)section
{
    return 3;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)cv
                        layout:(UICollectionViewLayout*)cvl
   itemInsetsForSectionAtIndex:(NSInteger)section
{
    //return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGSize)collectionView:(UICollectionView*)cv
                  layout:(UICollectionViewLayout*)cvl
    sizeForItemWithWidth:(CGFloat)width
             atIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchTerm = self.searches[indexPath.section];
    FlickrPhoto *photo =
	self.searchResults[searchTerm][indexPath.item];
    
    CGSize picSize = photo.thumbnail.size.width > 0.0f ?
	photo.thumbnail.size : CGSizeMake(100.0f, 100.0f);
//    picSize.height += 35.0f;
//    picSize.width += 35.0f;
    
    picSize.height += 0.0f;
    picSize.width += 0.0f;
    
    CGSize retval =
	CGSizeMake(width,
			   picSize.height * width / picSize.width);
    return retval;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        
        PhotoDetailViewController *flickrPhotoViewController = segue.destinationViewController;
        flickrPhotoViewController.flickrPhoto = sender;
    }
}

- (IBAction)playMusic:(id)sender{
    [self togglePlayPause];
}

// ---------------------   Play Background Music ---------------
- (void)playAudio {
    //Play the audio and set the button to represent the audio is playing
    [audioPlayer play];
//    [btnPlay setTitle:@"Pause" forState:UIControlStateNormal];
}
- (void)pauseAudio {
    //Pause the audio and set the button to represent the audio is paused
    [audioPlayer pause];
//    [btnPlay setTitle:@"Play" forState:UIControlStateNormal];
}
- (void)togglePlayPause {
    //Toggle if the music is playing or paused
    if (!self.audioPlayer.playing) {
        [self playAudio];
    } else if (self.audioPlayer.playing) {
        [self pauseAudio];
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store
 coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in
 application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SAFlickr" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SAFlickr.sqlite"];
    
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should
         not use this function in a shipping application, although it may be useful during
         development. If it is not possible to recover from the error, display an alert panel that
         instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object
         model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)showActivity{
    if (_isShowingActivity) {
      //  [_activityButton setTitle:@"Hide Activity" forState:UIControlStateNormal];
        [self.view makeToastActivity];
    } else {
      //  [_activityButton setTitle:@"Show Activity" forState:UIControlStateNormal];
        [self.view hideToastActivity];
    }
    _isShowingActivity = !_isShowingActivity;

}

#pragma Search Bar Delegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"Testing Search Bar End Editing");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSLog(@"Testing Search Bar");
    
    // 1
    [self showActivity];
    
    if(![self.searches containsObject:searchBar.text]) {
    
    //searched term, the result set of FlickrPhoto objects, and an error
    [self.flickr searchFlickrForTerm:searchBar.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if(results && [results count] > 0) {
            // 2
            //Checks to see if you have searched for this term before. If not, the term gets added to the front of the searches array and the results get stashed in the searchResults dictionary, with the key being the search term.
            
            if(![self.searches containsObject:searchTerm]) {
                
                NSLog(@"Found %d photos matching %@", [results count],searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results;
                
            }
            /*
            else{
                
                NSUInteger fooIndex = [self.searches indexOfObject: searchTerm];
                
                [self.searches removeObjectAtIndex:fooIndex];
                [self.searches insertObject:searchTerm atIndex:0];
                
            } */
            // 3
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Placeholder: reload collectionview data
                [self.collectionView reloadData];
                
                //  [self.collectionView reloadItemsAtIndexPaths:self.collectionView.indexPathsForVisibleItems];
                [self showActivity];
                
            });
             
            
        } else { // 1
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
        } }];
    }else{
        
        NSUInteger fooIndex = [self.searches indexOfObject: searchBar.text];
        
        [self.searches removeObjectAtIndex:fooIndex];
        [self.searches insertObject:searchBar.text atIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Placeholder: reload collectionview data
            [self.collectionView reloadData];
            
            //  [self.collectionView reloadItemsAtIndexPaths:self.collectionView.indexPathsForVisibleItems];
            [self showActivity];
            
        });
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // NSLog(@"offset: %f", offset.y);
    // NSLog(@"content.height: %f", size.height);
    // NSLog(@"bounds.height: %f", bounds.size.height);
    // NSLog(@"inset.top: %f", inset.top);
    // NSLog(@"inset.bottom: %f", inset.bottom);
    // NSLog(@"pos: %f of %f", y, h);
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        NSLog(@"load more rows");
    }
}

@end
