//
//  ViewController.m
//  ATestProject
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import "ViewController.h"
#import "TCVideoPlayer/TCVideoPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnClickMeAction:(id)sender {
    NSLog(@"Test");
    TCVideoPlayer* tcVideoPlayer = [[TCVideoPlayer alloc] init];
    [tcVideoPlayer playMedia:@"http://www.sample-videos.com/video/mp4/240/big_buck_bunny_240p_1mb.mp4" vastTagUrl:@"http://ad4.liverail.com/?LR_PUBLISHER_ID=131899&LR_SCHEMA=vast3" showUpSecondForMidrollAd:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
