//
//  TwitterEngine.h
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/24/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>

@interface TwitterEngine : NSObject

+ (void) loadTrendingTopics:(void (^)(NSMutableArray *trendingTopics)) callback;
+ (void) loadImages:(NSString *)searchPhrase withMaxID:(NSString *)maxID withCallback:(void (^)(NSArray *statuses)) callback;

@end
