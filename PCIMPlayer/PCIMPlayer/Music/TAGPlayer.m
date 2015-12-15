//
//  TAGPlayer.m
//  TAGMusic
//
//  Created by bai on 15/12/8.
//  Copyright © 2015年 TAGMusic. All rights reserved.
//

#import "TAGPlayer.h"
#import "Tool.h"
#import "PlaySongListVC.h"
#import "ViewController.h"
static TAGPlayer *staticSelf = nil;


@interface TAGPlayer()

@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, assign) float allTime;

@end




@implementation TAGPlayer


#pragma mark - init

- (void)setupLockScreenSongInfos
{
    // 设置锁屏歌曲专辑图片
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"Qidong.png"]];
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = @{
                                                              MPMediaItemPropertyPlaybackDuration:@(_musicPlayer.duration),
                                                              MPMediaItemPropertyTitle:@"凤凰八音",
                                                              MPMediaItemPropertyArtist:@"凤凰八音",
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

    [self.musicPlayer prepareToPlay];
    
    self.musicPlayer.volume = 0.0;
    
    [self.play_Button setImage:[UIImage imageNamed:@"player_btn_pause_normal.png"] forState:UIControlStateNormal];
    [self.play_Button setImage:[UIImage imageNamed:@"player_btn_pause_highlight.png"] forState:UIControlStateHighlighted];
    //设定定时器
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(show) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate date]];
    
    [self.timer fire]; // 触发
    
    [self updatePlayOrPauseBtn:YES];
    
    // 3. 设置音频支持后台播放
    [self setAudio2SupportBackgroundPlay];
    // 4. 设置锁屏歌曲信息
    [self setupLockScreenSongInfos];
    
    if ([[ViewController shareVC] MyappComeSleep]) {
        return;
    }
    
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
- (void)stopSong{
    
    [self.musicPlayer stop];
    
    
    [self.play_Button setImage:[UIImage imageNamed:@"player_btn_play_normal.png"] forState:UIControlStateNormal];
    [self.play_Button setImage:[UIImage imageNamed:@"player_btn_play_highlight.png"] forState:UIControlStateHighlighted];
    
    // 暂停定时器
    self.timer.fireDate = [NSDate distantFuture];
    
    [self updatePlayOrPauseBtn:NO];
    
    
    self.allTime = 0;
    
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

#pragma mark 定时器设定
-(void)show
{
    NSString *currentTimeStr=[NSString stringWithFormat:@"%02d:%02d",(int)self.musicPlayer.currentTime/60,(int)self.musicPlayer.currentTime%60];
    NSString *totalTime =[NSString stringWithFormat:@"%02d:%02d",(int)self.musicPlayer.duration/60,(int)self.musicPlayer.duration%60];
    self.currentTime.text = [NSString stringWithFormat:@"%@/%@",currentTimeStr,totalTime];
    
    //音量逻辑
    /**
     音效渐强渐弱规则：
     1、将音量分为0-100值；
     2、每个时间段音乐播放时间分3个阶段：开始【前10秒钟】，正常播放、结尾【后10秒钟】
     3、 开始（从0 - 100渐强），正常播放（保持）、结尾（从100 - 0渐弱）
     */

    //音量逐渐变大
    
    if ([[Tool getyinxiao] boolValue]) {
        if (self.musicPlayer.currentTime >= 0 && self.musicPlayer.currentTime <= 10) {
            self.musicPlayer.volume = self.musicPlayer.currentTime/10;
        }else if (self.musicPlayer.duration - self.musicPlayer.currentTime <= 10){
            self.musicPlayer.volume = (self.musicPlayer.duration - self.musicPlayer.currentTime)/10;
        }
    }else{
        if (self.musicPlayer.volume < 1) {
            self.musicPlayer.volume = 1;
        }
    }
    
//    NSLog(@"\n play = %0.2f   |||||||  volum = %0.2f \n",self.musicPlayer.currentTime ,self.musicPlayer.volume);
    
    CGFloat value =self.musicPlayer.currentTime/self.musicPlayer.duration;
    
    if (value>0.99) {
        
        [self stopSong];
        
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
