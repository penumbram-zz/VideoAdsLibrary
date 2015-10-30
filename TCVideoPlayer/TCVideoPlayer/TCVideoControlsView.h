//
//  TCVideoControlsView.h
//  TCVideoPlayer
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PureLayout.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TCVideoControlsDelegate.h"

@interface TCVideoControlsView : UIView

@property (nonatomic, retain) UIButton *playPauseButton;
@property (nonatomic, retain) UIButton *skipButton;
@property (nonatomic, retain) UIProgressView *progressBar;
@property (nonatomic, assign) id <TCVideoControlsDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame;
- (void) addPeriodicTimeObserverToPlayer:(AVPlayer*)player;
- (void) removePeriodicTimeObserverFromPlayer:(AVPlayer*)player;

@end
