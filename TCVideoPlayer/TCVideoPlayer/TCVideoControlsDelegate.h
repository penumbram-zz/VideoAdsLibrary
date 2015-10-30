//
//  TCVideoControlsDelegate.h
//  TCVideoPlayer
//
//  Created by Tolga Caner on 30/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCVideoControlsDelegate <NSObject>

-(void)skip;
-(void)playPause;

@end
