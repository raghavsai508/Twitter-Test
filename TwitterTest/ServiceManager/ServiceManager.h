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

/* This method returns a singleton instance of the current class. */
+ (instancetype)defaultServiceManager;

/* This method is responsible for getting the token id from the server. */
- (void)bearerTokenID:(dataBlock)tokenBlock;

/* This method is responsible for getting the user time data. */
- (void)userTimeLine:(NSString *)screenName withResponseData:(dataBlock)userTimeLineBlock;


@end
