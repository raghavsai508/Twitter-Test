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

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lblMessage;


- (void)configureCell:(UserTimeLineModel *)userModel atIndexPath:(NSIndexPath *)indexPath;

@end
