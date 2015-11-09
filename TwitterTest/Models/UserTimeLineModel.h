//
//  UserTimeLineModel.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "MediaInfo.h"
#import "MessageInfo.h"

@interface UserTimeLineModel : NSObject

/* This property is responsible for holding the user information. */
@property (nonatomic, strong) UserInfo      *userInfo;

/* This property is responsible for holding the message or tweet 
 information. */
@property (nonatomic, strong) MessageInfo   *messageInfo;

/* This property is responsible for holding the Media Information. */
@property (nonatomic, strong) MediaInfo     *mediaInfo;

@end
