//
//  ImagesContainer.h
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface ImagesContainer : NSObject

/* This method returns a singleton ImageContainer object
 * for storing the images. */
+(instancetype)sharedContainer;

/* This method returns an image from NSCache if exists. */
-(UIImage *)getImageForURL:(NSString *)imageURL;

/* This method stores an image in NSCache. */
- (void)setImageForURL:(NSString *)imageURL withImage:(UIImage *)image;

@end
