//
//  FlickrPhotoCell.h
//  FlickrSearch
//
//  Created by Fahim Farook on 24/7/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

@class FlickrPhoto;

@interface FlickrPhotoCell : UICollectionViewCell

@property (nonatomic, strong) FlickrPhoto *photo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
