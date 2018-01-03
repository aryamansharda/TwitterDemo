//
//  ImageCache.h
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/22/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCache : NSObject

//Image Cache instance
+ (ImageCache*)sharedInstance;

//Cache functions
- (void)cacheImage:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)getCachedImageForKey:(NSString*)key;

@property (nonatomic, strong) NSCache *imageCache;

@end
