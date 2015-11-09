//
//  UserTimelineImageCell.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "UserTimelineImageCell.h"
#import "ImagesContainer.h"
#import "TTTAttributedLabel.h"

@interface UserTimelineImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView            *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel                *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel                *lblHandle;
@property (weak, nonatomic) IBOutlet UILabel                *lblDatePosted;
@property (weak, nonatomic) IBOutlet UIImageView            *tweetImageView;

@end

@implementation UserTimelineImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCell:(UserTimeLineModel *)userModel
{
    [self setupUserInfo:userModel];
    [self setupTweetMessage:userModel];
    [self setupImages:userModel];
}

/* This method is responsible for setting the user information. */
- (void)setupUserInfo:(UserTimeLineModel *)userModel
{
    self.lblUsername.text = userModel.userInfo.username;
    self.lblHandle.text = [NSString stringWithFormat:@"@%@",userModel.userInfo.user_screen_name];
}

/* This method is responsible for setting up the tweet message. */
- (void)setupTweetMessage:(UserTimeLineModel *)userModel
{
    self.lblMessage.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.lblMessage.text = userModel.messageInfo.message;
    self.lblMessage.linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    self.lblDatePosted.text = [NSString stringWithFormat:@"%@",userModel.messageInfo.message_time_of_tweet] ;
}

- (void)setupImages:(UserTimeLineModel *)userModel
{
    NSString *userImageURL = userModel.userInfo.user_profile_image_url;
    [self setUpCellWithImageURL:userImageURL];
    NSString *tweetImageURL = userModel.mediaInfo.mediaURL;
    [self setupTweetImageWithURL:tweetImageURL];
}

/* This method sets the image at each cell. */
- (void)setUpCellWithImageURL:(NSString *)url
{
    UIImage* image = [[ImagesContainer sharedContainer] getImageForURL:url];
    
    if(image)
        self.userProfileImageView.image = image;
    else
        [self fetchImageFromURL:url];
    
}

/* This method sets the tweet image at each cell. */
- (void)setupTweetImageWithURL:(NSString *)url
{
    UIImage* image = [[ImagesContainer sharedContainer] getImageForURL:url];
    
    if(image)
        self.tweetImageView.image = image;
    else
        [self fetchImageFromURLTweet:url];
}

/* This method is responsible for fetching tweet image from the server and stores it in
 an Image Container. */
- (void)fetchImageFromURLTweet:(NSString *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ImagesContainer sharedContainer] setImageForURL:url withImage:image];
            [self setupTweetImageWithURL:url];
        });
        
    });
}

/* This method is responsible for fetching profile image from the server and stores it in
 an Image Container. */
- (void)fetchImageFromURL:(NSString *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ImagesContainer sharedContainer] setImageForURL:url withImage:image];
            [self setUpCellWithImageURL:url];
        });
        
    });
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.userProfileImageView.image = nil;
    self.tweetImageView.image = nil;
}


@end
