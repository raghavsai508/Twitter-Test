//
//  UserTimelineParser.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "UserTimelineParser.h"
#import "UserTimeLineModel.h"

@interface UserTimelineParser ()


@end

@implementation UserTimelineParser


- (NSMutableArray *)parseUserTimelineData:(NSArray *)dataArray
{
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dictionary in dataArray)
    {
        UserTimeLineModel *userModel = [[UserTimeLineModel alloc] init];
        [self setupMessageInfo:userModel withData:dictionary];
        [parsedArray addObject:userModel];
    }
    return parsedArray;
}

#pragma mark - Helper methods
- (void)setupUserInfo:(UserTimeLineModel *)userModel withData:(NSDictionary *)dictionary
{
    userModel.userInfo = [[UserInfo alloc] init];
    userModel.userInfo.username = [dictionary valueForKeyPath:@"user.name"];
    userModel.userInfo.userID = [[dictionary valueForKey:@"id"] integerValue];
    userModel.userInfo.user_screen_name = [dictionary valueForKeyPath:@"user.screen_name"];
    userModel.userInfo.user_profile_image_url = [dictionary valueForKeyPath:@"user.profile_image_url_https"];
}

- (void)setupMessageInfo:(UserTimeLineModel *)userModel withData:(NSDictionary *)dictionary
{
    NSDictionary *userDict = dictionary;
    if([dictionary valueForKey:@"retweeted_status"])
        userDict = (NSDictionary *)[dictionary valueForKey:@"retweeted_status"];
    [self populateMessageInfo:userModel withData:userDict];
    [self setupMediaInfo:userModel withData:userDict];
    [self setupUserInfo:userModel withData:userDict];
}

- (void)populateMessageInfo:(UserTimeLineModel *)userModel withData:(NSDictionary *)userDict
{
    userModel.messageInfo = [[MessageInfo alloc] init];
    userModel.messageInfo.message = [userDict valueForKey:@"text"];
    userModel.messageInfo.message_time_of_tweet = [self convertDate:[userDict valueForKey:@"created_at"]];
    userModel.messageInfo.message_favorite_count = [[userDict valueForKey:@"favorite_count"] integerValue];
    userModel.messageInfo.message_retweet_count = [[userDict valueForKey:@"retweet_count"] integerValue];
}

- (void)setupMediaInfo:(UserTimeLineModel *)userModel withData:(NSDictionary *)dictionary
{
    NSArray *mediaArray = [dictionary valueForKeyPath:@"entities.media"];
    if(mediaArray.count>0)
    {
        NSDictionary *mediaDictionary = [self mediaURL:mediaArray];
        if(mediaDictionary)
        {
            userModel.mediaInfo = [[MediaInfo alloc] init];
            userModel.mediaInfo.mediaURL = [mediaDictionary valueForKey:@"media_url_https"];
            userModel.mediaInfo.mediaWidth = [[mediaDictionary valueForKeyPath:@"sizes.small.w"] integerValue];
            userModel.mediaInfo.mediaHeight = [[mediaDictionary valueForKeyPath:@"sizes.small.h"] integerValue];
        }
    }
}

- (NSDictionary *)mediaURL:(NSArray *)mediaArray
{
    for(NSDictionary *dictionary in mediaArray)
    {
        if([[dictionary valueForKey:@"type"] isEqualToString:@"photo"])
            return dictionary;
    }
    return nil;
}

#pragma mark - Utility methods
- (NSString *)convertDate:(NSString *)dateString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE LLL dd HH:mm:ss Z yyyy"];
    date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *convertedDate = [formatter stringFromDate:date];
    return convertedDate;
}

@end
