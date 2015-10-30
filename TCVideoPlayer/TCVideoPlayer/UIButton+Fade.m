//
//  UIButton+UIButton_Fade.m
//  TCVideoPlayer
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import "UIButton+Fade.h"

@implementation UIButton (Fade)

-(void) fadeIn  {
    [self setAlpha:0.0f];
    [self setEnabled:NO];
    [self setHidden:NO];
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{self.alpha = 1.0;} completion:^(BOOL finished){
        [self setEnabled:YES];
    }];
}

-(void) fadeOut {
    [self setAlpha:1.0f];
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{self.alpha = 0.0;} completion:^(BOOL finished){
        [self setHidden:YES];
        [self setEnabled:NO];
    }];
}

@end
