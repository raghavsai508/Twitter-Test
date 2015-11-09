//
//  TwitterDetailCell.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/8/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "TwitterDetailCell.h"
#import "UserTimeLineModel.h"
#import "ImagesContainer.h"
#import "TTTAttributedLabel.h"

@interface TwitterDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel                    *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel                    *lblHandle;
@property (weak, nonatomic) IBOutlet UIImageView                *tweetImageView;
@property (weak, nonatomic) IBOutlet UILabel                    *lblDatePosted;
@property (weak, nonatomic) IBOutlet UILabel                    *lblRetweetCount;
@property (weak, nonatomic) IBOutlet UILabel                    *lblFavoriteCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint         *widthHeightAspectConstraint;

@end

@implementation TwitterDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCell:(UserTimeLineModel *)userModel
{
    [self setupUserInfo:userModel];
    [self setupMessageInfo:userModel];
    [self setupMediaInfo:userModel];
    [self setupProfileImage:userModel];
}


- (void)setupUserInfo:(UserTimeLineModel *)userModel
{
    self.lblUsername.text = userModel.userInfo.username;
    self.lblHandle.text = userModel.userInfo.user_screen_name;
}

- (void)setupMessageInfo:(UserTimeLineModel *)userModel
{
    self.lblMessage.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.lblMessage.text = userModel.messageInfo.message;
    self.lblRetweetCount.text = [NSString stringWithFormat:@"%ld",(long)userModel.messageInfo.message_retweet_count];
    self.lblFavoriteCount.text = [NSString stringWithFormat:@"%ld",(long)userModel.messageInfo.message_favorite_count];
    self.lblDatePosted.text = userModel.messageInfo.message_time_of_tweet;
    [self setupUserMentions:userModel];
}

- (void)setupUserMentions:(UserTimeLineModel *)userModel
{
    self.lblMessage.linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    for(NSString *handle in userModel.messageInfo.message_User_Mentions)
    {
        NSRange range = [self.lblMessage.text rangeOfString:[NSString stringWithFormat:@"@%@",handle]];
        [self.lblMessage addLinkToURL:[NSURL URLWithString:handle] withRange:range];
    }
}

- (void)setupMediaInfo:(UserTimeLineModel *)userModel
{
    if(userModel.mediaInfo.mediaURL)
    {
        NSString *mediaURl = userModel.mediaInfo.mediaURL;
        [self setupTweetImageWithURL:mediaURl];
    }
    else
    {
        [self.tweetImageView removeConstraint:self.widthHeightAspectConstraint];
        self.tweetImageView.frame = CGRectMake(self.tweetImageView.frame.origin.x, self.tweetImageView.frame.origin.y, self.tweetImageView.frame.size.width, 0);
        [self.contentView layoutIfNeeded];
        [self.contentView setNeedsUpdateConstraints];
    }
}

- (void)setupProfileImage:(UserTimeLineModel *)userModel
{
    NSString *profileImage = userModel.userInfo.user_profile_image_url;
    [self setUpCellWithImageURL:profileImage];
}

// This method sets the image at each cell.
- (void)setUpCellWithImageURL:(NSString *)url
{
    UIImage* image = [[ImagesContainer sharedContainer] getImageForURL:url];
    
    if(image)
    {
        [self.btnProfile setImage:image forState:UIControlStateNormal];
        self.btnProfile.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
        [self fetchImageFromURL:url];
    
}

- (void)setupTweetImageWithURL:(NSString *)url
{
    UIImage* image = [[ImagesContainer sharedContainer] getImageForURL:url];
    
    if(image)
        self.tweetImageView.image = image;
    else
        [self fetchImageFromURLTweet:url];
}

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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
