//
//  TCVideoPlayer.m
//  TCVideoPlayer
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import "TCVideoPlayer.h"
#import "TCVideoViewController.h"
#import "Constants.h"
#import "TCXMLParser.h"
#import "UIButton+Fade.h"

@interface TCVideoPlayer ()

@property (strong,nonatomic) TCVideoViewController* tcVideoViewController;

@end


@implementation TCVideoPlayer

- (void)playMedia:(NSString*)contentVideoUrl
       vastTagUrl:(NSString*)vastTagUrl showUpSecondForMidrollAd:(float)showUpSecondForMidrollAd {
    
    self.tcVideoViewController = [[TCVideoViewController alloc] initWithVastTagURL:vastTagUrl contentVideoURL:contentVideoUrl showUpSecondForMidrollAd:showUpSecondForMidrollAd];
    
    //Get windows
    NSArray* windows = [[UIApplication sharedApplication]windows];
    //Get rootVC from window
    UIViewController *rootVC = (windows.count > 0) ? [[windows objectAtIndex:0] rootViewController] : nil;
    //If all is ok, present the vc
    if (rootVC)
        [rootVC presentViewController:self.tcVideoViewController animated:YES completion:nil];
    else
        NSLog(@"Could not find root view controller");
    
    [self.tcVideoViewController.player play];
    
}

@end
