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

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lblMessage;

- (void)configureCell:(UserTimeLineModel *)userModel;

@end
