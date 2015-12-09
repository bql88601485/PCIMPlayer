//
//  TAGPlayer.m
//  TAGMusic
//
//  Created by bai on 15/12/8.
//  Copyright © 2015年 TAGMusic. All rights reserved.
//

#import "TAGPlayer.h"
static TAGPlayer *staticSelf = nil;


@interface TAGPlayer()

@property (nonatomic, strong) AVAudioPlayer* musicPlayer;
@property (nonatomic, strong) NSTimer* timer;

@end


@implementation TAGPlayer


#pragma mark - init

- (void)setupLockScreenSongInfos
{
    // 设置锁屏歌曲专辑图片
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"红颜劫.jpg"]];
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = @{
                                                              MPMediaItemPropertyPlaybackDuration:@(_musicPlayer.duration),
                                                              MPMediaItemPropertyTitle:@"红颜劫",
                                                              MPMediaItemPropertyArtist:@"姚贝娜",
                                                              MPMediaItemPropertyArtwork:artWork,
                                                              MPNowPlayingInfoPropertyPlaybackRate:@(1.0f)
                                                              };
}


- (void)setAudio2SupportBackgroundPlay
{
    UIDevice *device = [UIDevice currentDevice];
    
    if (![device respondsToSelector:@selector(isMultitaskingSupported)]) {
        NSLog(@"Unsupported device!");
        return;
    }
    
    if (!device.multitaskingSupported) {
        NSLog(@"Unsupported multiTasking!");
        return;
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error;
    
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
}


- (void)initAllObject:(NSURL *)playUrl{
    
    NSError* error=nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:playUrl error:&error];
    
    self.musicPlayer = player;
    
    self.musicPlayer.delegate = self;
    
    self.musicPlayer.enableRate = YES;

    // 3. 设置音频支持后台播放
    [self setAudio2SupportBackgroundPlay];
    // 4. 设置锁屏歌曲信息
    [self setupLockScreenSongInfos];
    
    [self playOrPause:nil];
}

+ (instancetype )shareTAGPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticSelf = [[TAGPlayer alloc] init];
    });
    
    return staticSelf;
}
/*****************************************************************************************/

#pragma mark - 功能

- (void)updatePlayOrPauseBtn:(BOOL)isPlaying
{
    
}

- (void )playOrPause:(id)sender {
    
    // 重置播放速率
    self.musicPlayer.rate = 1;
    
    if (self.musicPlayer.isPlaying) {
        // 正在播放，则暂停，并更新button
        [self.musicPlayer pause];
        
        
        [self.play_Button setImage:[UIImage imageNamed:@"player_btn_play_normal.png"] forState:UIControlStateNormal];
        [self.play_Button setImage:[UIImage imageNamed:@"player_btn_play_highlight.png"] forState:UIControlStateHighlighted];
        
        // 暂停定时器
        self.timer.fireDate = [NSDate distantFuture];
        
        [self updatePlayOrPauseBtn:NO];
    } else {
        [self.musicPlayer play];
        [self.play_Button setImage:[UIImage imageNamed:@"player_btn_pause_normal.png"] forState:UIControlStateNormal];
        [self.play_Button setImage:[UIImage imageNamed:@"player_btn_pause_highlight.png"] forState:UIControlStateHighlighted];
        //设定定时器
        self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(show) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate date]];
        
        [self.timer fire]; // 触发
        
        [self updatePlayOrPauseBtn:YES];
    }
}


// 接收远程控制事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playOrPause:nil];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark 定时器设定
-(void)show
{
    NSString *currentTimeStr=[NSString stringWithFormat:@"%02d:%02d",(int)self.musicPlayer.currentTime/60,(int)self.musicPlayer.currentTime%60];
     NSString *totalTime =[NSString stringWithFormat:@"%02d:%02d",(int)self.musicPlayer.duration/60,(int)self.musicPlayer.duration%60];
    self.currentTime.text = [NSString stringWithFormat:@"%@/%@",currentTimeStr,totalTime];
    
    CGFloat value =self.musicPlayer.currentTime/self.musicPlayer.duration;
    if (value>0.999) {
        [self nextButtonClick];
    }
}

- (void)nextButtonClick {
    if (self.ktouchEvent) {
        self.ktouchEvent(TAGPlayerStatus_Next);
    }
}


#pragma mark 加载音乐
- (void)PlayerName:(NSURL *)playerUrl
{
    [self initAllObject:playerUrl];
}

#pragma mark - muscidelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self updatePlayOrPauseBtn:NO];
    }
}

@end
