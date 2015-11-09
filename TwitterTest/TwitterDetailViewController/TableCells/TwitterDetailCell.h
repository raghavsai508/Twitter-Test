//
//  TwitterDetailCell.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/8/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserTimeLineModel;
@class TTTAttributedLabel;

@interface TwitterDetailCell : UITableViewCell

/* This property contains the user name and handle. */
@property (weak, nonatomic) IBOutlet UIView                     *userView;

/* This property holds the tweet message. */
@property (weak, nonatomic) IBOutlet TTTAttributedLabel         *lblMessage;

/* This property holds the user profile image. */
@property (weak, nonatomic) IBOutlet UIButton                   *btnProfile;

/* This method is reponsible for configuring the cell. */
- (void)configureCell:(UserTimeLineModel *)userModel;

@end
