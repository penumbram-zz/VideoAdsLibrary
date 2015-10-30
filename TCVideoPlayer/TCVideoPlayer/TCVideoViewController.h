//
//  TCVideoViewController.h
//  TCVideoPlayer
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "TCVideoControlsView.h"
#import "TCXMLParser.h"
#import "TCVideoControlsDelegate.h"
#import "RequestManager.h"

@interface TCVideoViewController : UIViewController <TCVideoControlsDelegate>

@property (retain,nonatomic) AVPlayer* player;
@property (retain,nonatomic) NSValue* pauseValue;
@property (retain,nonatomic) NSString* videoURL;


@property (nonatomic) BOOL didCallMidRollImpression;
@property (nonatomic) BOOL playingAd;

@property (nonatomic, retain) TCVideoControlsView *tcVideoControlsView;

- (id)initWithVastTagURL:(NSString*)vastTagUrl contentVideoURL:(NSString*)contentVideoUrl showUpSecondForMidrollAd:(float)showUpSecondForMidrollAd;

@end
