//
//  ViewController.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "ViewController.h"
#import "SystemLevelConstants.h"
#import "ServiceManager.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) ServiceManager *serviceManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Initial setup methods
- (void)initialSetup
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.twitterTokenDelegate = self;
}


#pragma mark - TwitterTokenProtocol methods
- (void)twitterTokenDownloaded:(NSDictionary *)dataDictionary
{
    
    kAccessToken = [dataDictionary objectForKey:@"access_token"];
    self.serviceManager = [ServiceManager defaultServiceManager];
    [self.serviceManager userTimeLine:@"tim_cook" withResponseData:^(NSDictionary *dictionary, NSError *error) {
        NSLog(@"%@",dictionary);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
