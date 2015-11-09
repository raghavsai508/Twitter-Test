//
//  ViewController.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterToken.h"

@interface UserTimelineViewController : UIViewController<TwitterTokenProtocol>

@property (nonatomic, strong) NSString *screen_name;

@end

