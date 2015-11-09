//
//  TwitterTokenProtocol.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwitterTokenProtocol <NSObject>

/* This delegate method is fired after the token has bee downloaded. */
- (void)twitterTokenDownloaded:(NSDictionary *)dataDictionary;

@end

@interface TwitterToken : NSObject

@end
