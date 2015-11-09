//
//  ImagesContainer.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "ImagesContainer.h"
#import <UIKit/UITableView.h>

@interface ImagesContainer()

@property (nonatomic, strong) NSCache *imagesCache;

@end

@implementation ImagesContainer

+ (instancetype)sharedContainer
{
    static dispatch_once_t once_token;
    static ImagesContainer *imageInstance;
    dispatch_once(&once_token,^{
        imageInstance = [[self alloc]init];
        imageInstance.imagesCache = [[NSCache alloc] init];
    });
    return imageInstance;
}

- (UIImage *)getImageForURL:(NSString *)imageURL
{
    UIImage *returnImage;
    returnImage = [self.imagesCache objectForKey:imageURL];
    return returnImage;
}

- (void)setImageForURL:(NSString *)imageURL withImage:(UIImage *)image
{
    if(image)
        [self.imagesCache setObject:image forKey:imageURL];
}


@end
