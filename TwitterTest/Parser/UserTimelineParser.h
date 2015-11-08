//
//  UserTimelineParser.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTimelineParser : NSObject

- (NSMutableArray *)parseUserTimelineData:(NSArray *)dataArray;

@end
