//
//  MediaInfo.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaInfo : NSObject

@property (nonatomic, strong) NSString      *mediaURL;
@property (nonatomic, assign) NSInteger     mediaWidth;
@property (nonatomic, assign) NSInteger     mediaHeight;

@end
