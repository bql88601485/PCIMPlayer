//
//  TAGPlayer.h
//  TAGMusic
//
//  Created by bai on 15/12/8.
//  Copyright © 2015年 TAGMusic. All rights reserved.
//
/**
 *  @author bai, 15-12-08 19:12:18
 *
 *  @brief 音乐播放器封装
 */
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSUInteger, TAGPlayerStatus) {
    TAGPlayerStatus_Old,
    TAGPlayerStatus_Next,
};

typedef void(^PlayEvent)(TAGPlayerStatus status);

@interface TAGPlayer : NSObject<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSInteger tag;

@property (nonatomic, strong) AVAudioPlayer* musicPlayer;

@property (nonatomic, strong) UIButton *play_Button;
@property (nonatomic, strong) UILabel *currentTime;

@property (nonatomic, strong) PlayEvent ktouchEvent;


+ (instancetype )shareTAGPlayer;

- (void)PlayerName:(NSURL *)playerUrl;

- (void )playOrPause:(id)sender;

- (void)stopSong;


@property (nonatomic, assign) BOOL  isStopPlay;

@end
