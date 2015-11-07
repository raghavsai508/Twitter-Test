//
//  URLConfiguration.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "URLConfiguration.h"

NSString * const kBase_URL              = @"https://api.twitter.com/";

@implementation URLConfiguration

+ (NSString *)getURL:(NSString *)appendURL
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kBase_URL,appendURL];
    return url;
}

@end
