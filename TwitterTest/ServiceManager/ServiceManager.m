//
//  ServiceManager.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "ServiceManager.h"
#import "URLConfiguration.h"
#import "SystemLevelConstants.h"
#import "UserTimelineParser.h"
#import "AFNetworking.h"


NSString * const kGrantTypeKey              = @"grant_type";
NSString * const kGrantTypeValue            = @"client_credentials";

@interface ServiceManager()

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;


@end

@implementation ServiceManager


+ (instancetype)defaultServiceManager
{
    static ServiceManager *serviceManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        serviceManager = [[self alloc] init];
    });
    return serviceManager;
}


- (AFHTTPRequestOperationManager *)manager
{
    if(!_manager)
    {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];
    }
    
    return _manager;
}

- (void)bearerTokenID:(dataBlock)tokenBlock
{
    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [self.manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[self base64EncodeKeySecret]] forHTTPHeaderField:@"Authorization"];
    NSDictionary *bodyParameters = [[NSDictionary alloc] initWithObjectsAndKeys:kGrantTypeValue,kGrantTypeKey, nil];
    NSString *url = [URLConfiguration getURL:kResource_URL];

    [self postRequestCallWithURL:url andParameters:bodyParameters withDataBlock:tokenBlock];

}

- (void)userTimeLine:(NSString *)screenName withResponseData:(dataBlock)userTimeLineBlock
{
    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [self.manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",kAccessToken] forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@?screen_name=%@",[URLConfiguration getURL:kUserTimeline_URL],screenName];
    [self getRequestCallWithURL:url withDataBlock:userTimeLineBlock];
}



#pragma mark - Utility methods
- (void)getRequestCallWithURL:(NSString *)URL withDataBlock:(dataBlock)dataBlockValues
{
    [self.manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *reponseArray = (NSArray *)responseObject;
        UserTimelineParser *userParser = [[UserTimelineParser alloc] init];
        NSArray *parsedArray = [userParser parseUserTimelineData:reponseArray];
        NSDictionary *parsedDict = [[NSDictionary alloc] initWithObjectsAndKeys:parsedArray,@"user_timeline", nil];
        dataBlockValues(parsedDict,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dataBlockValues(operation.responseObject,error);
    }];
}


- (void)postRequestCallWithURL:(NSString *)URL andParameters:(NSDictionary *)params withDataBlock:(dataBlock)dataBlockValues
{
    [self.manager POST:URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *reponseDictionary = (NSDictionary *)responseObject;
        dataBlockValues(reponseDictionary,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dataBlockValues(operation.responseObject,error);
    }];
}


#pragma mark - Helper methods
- (NSString *)base64EncodeKeySecret
{
    NSString *consumerKey = [self twitterKeyValue:@"consumerKey"];
    NSString *consumerSecret = [self twitterKeyValue:@"consumerSecret"];
    NSString *toBeEncoded = [NSString stringWithFormat:@"%@:%@",consumerKey,consumerSecret];
    NSData *nsdata = [toBeEncoded dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedString = [nsdata base64EncodedStringWithOptions:0];
    return encodedString;
}


- (NSString *)twitterKeyValue:(NSString *)key
{
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TwitterKeys" ofType:@"plist"]];
    NSString *value = [dictRoot objectForKey:key];
    return value;
}

@end
