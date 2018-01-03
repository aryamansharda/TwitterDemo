//
//  UIImage+AsyncLoading.h
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/22/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface UIImage (AsyncLoading)

+ (void) asyncLoadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback;

@end
