//
//  RequestManager.h
//  TCVideoPlayer
//
//  Created by Tolga Caner on 30/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface RequestManager : NSObject

@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedManager;

- (void) callURL:(NSString*)urlString;

@end
