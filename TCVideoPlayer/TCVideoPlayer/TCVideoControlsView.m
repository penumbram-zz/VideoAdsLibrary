//
//  TCVideoControlsView.m
//  TCVideoPlayer
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import "TCVideoControlsView.h"

@interface TCVideoControlsView ()

@property (nonatomic,weak) __block id periodicTimeObserver;

@end

@implementation TCVideoControlsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressBar.frame = CGRectMake(0, 0, 150.0, 2.0);
        _progressBar.backgroundColor = [UIColor whiteColor];
        _progressBar.progressTintColor = [UIColor blueColor];
        
        [self addSubview:_progressBar];
        
        [_progressBar autoCenterInSuperview];
        [_progressBar autoSetDimensionsToSize:_progressBar.frame.size];
        
        _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playPauseButton.frame = CGRectMake(0, 0, 54.0, 30.0);
        _playPauseButton.backgroundColor = [UIColor clearColor];
        [_playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self addSubview:_playPauseButton];
        
        [_playPauseButton autoSetDimensionsToSize:_playPauseButton.frame.size];
        [_playPauseButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_progressBar withOffset:10.0];
        [_playPauseButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0.0];
        
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(0, 0, 54.0, 30.0);
        _skipButton.backgroundColor = [UIColor clearColor];
        [_skipButton setTitle:@"Skip" forState:UIControlStateNormal];
        [self addSubview:_skipButton];
        
        [_skipButton autoSetDimensionsToSize:_skipButton.frame.size];
        [_skipButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_progressBar withOffset:10.0];
        [_skipButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0.0];
        
        
        [[self playPauseButton] addTarget:self action:@selector(playPauseAction) forControlEvents:UIControlEventTouchUpInside];
        [[self skipButton] addTarget:self action:@selector(btnSkipAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//IBActions

-(void)btnSkipAction{
    [[self delegate] skip];
}

-(void)playPauseAction
{
    [[self delegate] playPause];
}

//IBActions

-(void) addPeriodicTimeObserverToPlayer:(AVPlayer*)player {
    CMTime interval = CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC); // 1 second
    __weak typeof(player) weakPlayer = player;
    self.periodicTimeObserver = [player addPeriodicTimeObserverForInterval:interval queue:NULL usingBlock:^(CMTime time) {
        CMTime duration = [[weakPlayer currentItem] duration];
        float totalDuration = CMTimeGetSeconds(duration);
        float currentTime = CMTimeGetSeconds(time);
        float progress = currentTime/totalDuration;
        if (progress != progress) {
            progress = 0.0;
        }
        [[self progressBar] setProgress:progress];
    }];
}

- (void) removePeriodicTimeObserverFromPlayer:(AVPlayer*)player {
    [player removeTimeObserver:self.periodicTimeObserver];
}

@end
