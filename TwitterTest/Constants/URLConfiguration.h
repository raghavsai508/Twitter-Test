//
//  URLConfiguration.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConfiguration : NSObject

/* This method returns an url for fetching data from server. */
+ (NSString *)getURL:(NSString *)appendURL;

@end
