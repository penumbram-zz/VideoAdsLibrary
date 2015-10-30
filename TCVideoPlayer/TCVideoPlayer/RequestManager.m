//
//  RequestManager.m
//  TCVideoPlayer
//
//  Created by Tolga Caner on 30/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

+ (id)sharedManager {
    static RequestManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        //custom initialization
    }
    return self;
}

//url call

- (void) callURL:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@ call is a success",urlString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ call is a failure",urlString);
    }];
    [operation start];
}


@end
