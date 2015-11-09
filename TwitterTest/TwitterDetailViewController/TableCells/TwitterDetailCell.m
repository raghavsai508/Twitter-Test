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

/* This property holds the user name. */
@property (weak, nonatomic) IBOutlet UILabel                    *lblUsername;

/* This property holds the handle or screen name. */
@property (weak, nonatomic) IBOutlet UILabel                    *lblHandle;

/* This property holds the tweet image */
@property (weak, nonatomic) IBOutlet UIImageView                *tweetImageView;

/* This property holds the tweet posted date. */
@property (weak, nonatomic) IBOutlet UILabel                    *lblDatePosted;

/* This property holds the retweet count. */
@property (weak, nonatomic) IBOutlet UILabel                    *lblRetweetCount;

/* This property holds the likes or favorite count.  */
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

/* This method is responsible for setting the user information. */
- (void)setupUserInfo:(UserTimeLineModel *)userModel
{
    self.lblUsername.text = userModel.userInfo.username;
    self.lblHandle.text = [NSString stringWithFormat:@"@%@",userModel.userInfo.user_screen_name];
}

/* This method is responsible for setting up the tweet message. */

- (void)setupMessageInfo:(UserTimeLineModel *)userModel
{
    self.lblMessage.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.lblMessage.text = userModel.messageInfo.message;
    self.lblRetweetCount.text = [NSString stringWithFormat:@"%ld",(long)userModel.messageInfo.message_retweet_count];
    self.lblFavoriteCount.text = [NSString stringWithFormat:@"%ld",(long)userModel.messageInfo.message_favorite_count];
    self.lblDatePosted.text = userModel.messageInfo.message_time_of_tweet;
    [self setupUserMentions:userModel];
}

/* This method is responsible for setting up the user mentions in the message. */
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

/* This method is responsible for setting up media information. */
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

/* This method sets the tweet image at each cell. */

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
