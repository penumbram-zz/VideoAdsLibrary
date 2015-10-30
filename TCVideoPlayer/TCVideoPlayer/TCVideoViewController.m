//
//  TCVideoViewController.m
//  TCVideoPlayer
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import "TCVideoViewController.h"
#import "UIButton+Fade.h"
#import "Constants.h"

@interface TCVideoViewController ()

@property (strong,nonatomic) TCXMLParser* parser;

@end

@implementation TCVideoViewController

- (id)init
{
    self = [super init];
    if (self) {
        NSNumber *number = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:number forKey:@"orientation"];
    }
    return self;
}

- (id)initWithVastTagURL:(NSString*)vastTagUrl contentVideoURL:(NSString*)contentVideoUrl showUpSecondForMidrollAd:(float)showUpSecondForMidrollAd
{
    self = [self init];
    if(self) {
        //Parse VastTagURL
        self.parser = [[TCXMLParser alloc] init];
        [[self parser] parseXML:vastTagUrl];
        
        //Initialize Player with url
        NSURL *url = [NSURL URLWithString:contentVideoUrl];
        self.player = [[AVPlayer alloc]initWithURL:url];
        //get the layer of AVPlayer
        AVPlayerLayer* avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:[self player]];
        [[self view].layer addSublayer:avPlayerLayer];
        [self setVideoURL:contentVideoUrl];
        //set layer's frame to self
        avPlayerLayer.frame = [self view].layer.bounds;
        
        NSArray *time = [NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(((Float64)(int)showUpSecondForMidrollAd), 1)]];
        
        __block id observer = [[self player] addBoundaryTimeObserverForTimes:time queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) usingBlock:^{
            [[self player] removeTimeObserver:observer];
            [self playMidRollAd];
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tcVideoControlsView = [[TCVideoControlsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100.0)];
    [[self tcVideoControlsView] setDelegate:self];
//    [self tcVideoControlsView]
    [self.view addSubview:[self tcVideoControlsView]];
    [[self tcVideoControlsView] autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 10.0, 0) excludingEdge:ALEdgeTop];
    [[self tcVideoControlsView] autoSetDimensionsToSize:self.tcVideoControlsView.frame.size];
    [[self tcVideoControlsView] addPeriodicTimeObserverToPlayer:[self player]];
    [[[self tcVideoControlsView] skipButton] fadeOut];
    
}


-(void)prepareHalfTime{
    Float64 totalTime = CMTimeGetSeconds([[_player currentItem] duration]);
    NSArray *time = [NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(totalTime/2, 1)]];
    __weak typeof(self) weakSelf = self;
    __block id obs = [[self player] addBoundaryTimeObserverForTimes:time queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) usingBlock:^{
        [[weakSelf player] removeTimeObserver:obs];
        [[RequestManager sharedManager] callURL:[[weakSelf parser] midPointImpressionURL]];
        [weakSelf setDidCallMidRollImpression:YES];
    }];
}

//Controls

- (void) skip {
    [self resumeContentVideo];
    [self setPlayingAd:NO];
}

- (void) playPause {
    if ([[self player] rate] == 1.0) {
        [self changeToPause];
    }
    else {
        [self changeToPlay];
    }
}

- (void) changeToPause{
    [_player pause];
    [_tcVideoControlsView.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
}

- (void) changeToPlay{
    [_player play];
    [_tcVideoControlsView.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
}

//Controls


-(void) resumeContentVideo{
    [[self player] replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL URLWithString:_videoURL]]];
    [[[self player] currentItem] seekToTime:[[self pauseValue] CMTimeValue] completionHandler:^(BOOL finished){
        if (finished) {
            [[self player] play];
        }
        
    }];

    [_tcVideoControlsView.playPauseButton fadeIn];
    [_tcVideoControlsView.skipButton fadeOut];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[[self player] currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[[self player] currentItem]];
    
   
}

-(void) playMidRollAd {
    if ([self playingAd]) {
        return;
    }
    
    [self setPlayingAd:YES];
    [self setDidCallMidRollImpression:NO];
    [self setPauseValue:[NSValue valueWithCMTime:[self.player currentTime]]];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tcVideoControlsView.playPauseButton fadeOut];
    });
    
    [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[_parser mediaFileURL]]]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    
    NSArray *time = [NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds((Float64)SKIP_AVAILABLE_IN_SECONDS, 1)]];
    
    
    __block id obs = [[self player] addBoundaryTimeObserverForTimes:time queue:dispatch_get_main_queue() usingBlock:^{
        [[self player] removeTimeObserver:obs];
        [self.tcVideoControlsView.skipButton fadeIn];
        [self prepareHalfTime];
    }];
    
    [[RequestManager sharedManager] callURL:[_parser firstImpressionURL]];
    [self.player play];
}


// video finish hooks
-(void)adDidFinishPlaying:(NSNotification *) notification {
    [self resumeContentVideo];
    [self setPlayingAd:NO];
}

-(void)contentDidFinishPlaying:(NSNotification *) notification {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[self tcVideoControlsView] removePeriodicTimeObserverFromPlayer:[self player]];
}
// video finish hooks



//Landscape Left

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskLandscape;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotate {
    return NO;
}

//Landscape Left

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
