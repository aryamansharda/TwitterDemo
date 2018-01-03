//
//  ImageCache.m
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/22/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//

#import "ImageCache.h"

static ImageCache *sharedInstance;
@implementation ImageCache

//Singleton
+ (ImageCache *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageCache alloc] init];
    });
    return sharedInstance;
}

//Initialize cache
- (instancetype)init {
    self = [super init]; 
    if (self) {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

//Add image to cache
- (void)cacheImage:(UIImage *)image forKey:(NSString*)key {
    [self.imageCache setObject:image forKey:key];
}

//Retrieve image from cache
- (UIImage *)getCachedImageForKey:(NSString*)key {
    return [self.imageCache objectForKey:key];
}

@end
