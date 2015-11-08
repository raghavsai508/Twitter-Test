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

@property (nonatomic, strong) UserInfo      *userInfo;
@property (nonatomic, strong) MessageInfo   *messageInfo;
@property (nonatomic, strong) MediaInfo     *mediaInfo;

@end
