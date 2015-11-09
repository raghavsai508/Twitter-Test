//
//  UserTimelineCell.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "UserTimelineCell.h"
#import "ImagesContainer.h"
#import "TTTAttributedLabel.h"

@interface UserTimelineCell ()

@property (weak, nonatomic) IBOutlet UIImageView        *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel            *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel            *lblHandle;
@property (weak, nonatomic) IBOutlet UILabel            *lblDatePosted;

@end

@implementation UserTimelineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCell:(UserTimeLineModel *)userModel atIndexPath:(NSIndexPath *)indexPath
{
    [self setupUserInfo:userModel];
    [self setupTweetMessage:userModel];
    [self setupImages:userModel];
}

- (void)setupUserInfo:(UserTimeLineModel *)userModel
{
    self.lblUsername.text = userModel.userInfo.username;
    self.lblHandle.text = [NSString stringWithFormat:@"@%@",userModel.userInfo.user_screen_name];
}

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
}



@end
