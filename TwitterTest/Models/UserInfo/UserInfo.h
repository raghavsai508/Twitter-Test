//
//  UserInfo.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, assign) NSInteger     userID;
@property (nonatomic, strong) NSString      *username;
@property (nonatomic, strong) NSString      *user_profile_image_url;
@property (nonatomic, strong) NSString      *user_screen_name;


@end
