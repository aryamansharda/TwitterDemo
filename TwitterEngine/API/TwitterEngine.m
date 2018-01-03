//
//  TwitterEngine.m
//  TwitterEngine
//
//  Created by Aryaman Sharda on 10/24/17.
//  Copyright © 2017 Aryaman Sharda. All rights reserved.
//

#import "TwitterEngine.h"

@implementation TwitterEngine

+ (void) loadTrendingTopics:(void (^)(NSMutableArray *topics)) callback {
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/trends/place.json";
    
    //Finding Trending Topics in SF
    NSDictionary *params = @{ @"id" : @"2487956" };
    
    NSError *clientError;
    NSURLRequest *request = [client URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    
    if (request) {
        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSMutableArray *trendingTopics = [[NSMutableArray alloc] init];
            if (data) {
                NSError *jsonError;
                NSDictionary *trends = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError][0] objectForKey:@"trends"];
                
                for (NSDictionary *trend in trends) {
                    [trendingTopics addObject:[trend valueForKey:@"name"]];
                }

            } else {
                NSLog(@"Error: %@", connectionError);
            }
            
            callback(trendingTopics);
        }];
    } else {
        NSLog(@"Error: %@", clientError);
    }
}

+ (void)loadImages:(NSString *)searchPhrase withMaxID:(NSString *)maxID withCallback:(void (^)(NSArray *statuses))callback {
    //Call to Twitter API asking for the maximum of 100 statuses to be returned
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/search/tweets.json";
    
    //max_id field used to ensure new images are beign returned by Twitter
    NSDictionary *params  = @{
        @"q" : [searchPhrase stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],
        @"include_entities" : @"true",
        @"filter" : @"images",
        @"result_type" : @"recent",
        @"count": @"15",
        @"max_id": [NSString stringWithFormat:@"%@", maxID]
    };
    
    NSError *clientError;
    NSURLRequest *request = [client URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    if (request) {
        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (data) {
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSArray *statuses = json[@"statuses"];
                callback(statuses);
            } else {
                NSLog(@"Error: %@", connectionError);
            }
        }];
    } else {
        NSLog(@"Error: %@", clientError);
    }
}

@end
