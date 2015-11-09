//
//  MessageInfo.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfo : NSObject

/* This property holds tweet or re-tweeted message  */
@property (nonatomic, strong) NSString          *message;

/* This property holds the time of tweet in string format. */
@property (nonatomic, strong) NSString          *message_time_of_tweet;

/* This property holds the tweet favorite or likes count. */
@property (nonatomic, assign) NSInteger         message_favorite_count;

/* This property holds the retweet count. */
@property (nonatomic, assign) NSInteger         message_retweet_count;

/* This property holds an array of User Mentions in the tweet. */
@property (nonatomic, strong) NSMutableArray    *message_User_Mentions;

@end
