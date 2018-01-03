//
//  UIImage+AsyncLoading.m
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/22/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//

#import "UIImage+AsyncLoading.h"

@implementation UIImage (AsyncLoading)

//Responsible for asynchronously loading the image from the provided URL
+ (void) asyncLoadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback( [UIImage imageWithData:imageData]);
        });
    });
}

@end
