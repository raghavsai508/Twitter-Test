//
//  UserInfo.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/* This property holds UserID of a user.  */
@property (nonatomic, assign) NSInteger     userID;

/* This property holds UserName of a user.  */
@property (nonatomic, strong) NSString      *username;

/* This property holds Profile Image URL of a user.  */
@property (nonatomic, strong) NSString      *user_profile_image_url;

/* This property holds Sceen Name of a user.  */
@property (nonatomic, strong) NSString      *user_screen_name;


@end
