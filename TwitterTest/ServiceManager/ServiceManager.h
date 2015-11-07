//
//  ServiceManager.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServiceManager : NSObject

typedef void(^dataBlock)(NSDictionary *, NSError *);


+ (instancetype)defaultServiceManager;
- (void)bearerTokenID:(dataBlock)tokenBlock;
- (void)userTimeLine:(NSString *)screenName withResponseData:(dataBlock)userTimeLineBlock;


@end
