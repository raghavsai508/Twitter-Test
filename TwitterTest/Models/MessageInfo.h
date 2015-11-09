//
//  MessageInfo.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfo : NSObject

@property (nonatomic, strong) NSString          *message;
@property (nonatomic, strong) NSString          *message_time_of_tweet;
@property (nonatomic, assign) NSInteger         message_favorite_count;
@property (nonatomic, assign) NSInteger         message_retweet_count;
@property (nonatomic, strong) NSMutableArray    *message_User_Mentions;

@end
