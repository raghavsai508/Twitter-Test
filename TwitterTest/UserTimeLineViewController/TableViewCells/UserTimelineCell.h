//
//  UserTimelineCell.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTimeLineModel.h"

@class TTTAttributedLabel;

@interface UserTimelineCell : UITableViewCell

/* This property is responsible for holding the tweeted or re-tweeted message. */
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lblMessage;

/* This method is responsible for configuring the user model. */
- (void)configureCell:(UserTimeLineModel *)userModel;

@end
