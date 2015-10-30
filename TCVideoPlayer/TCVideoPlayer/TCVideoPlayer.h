//
//  TCVideoPlayer.h
//  TCVideoPlayer
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface TCVideoPlayer : NSObject

- (void) playMedia:(NSString*) contentVideoUrl vastTagUrl:(NSString*)vastTagUrl showUpSecondForMidrollAd:(float)showUpSecondForMidrollAd;

@end
