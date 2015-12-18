//
//  ViewController.m
//  PCIMPlayer
//
//  Created by bai on 15/12/9.
//  Copyright © 2015年 PCIMPlayer. All rights reserved.
//

#import "ViewController.h"
#import "Tool.h"
#import "TAGPlayer.h"
#import "PlaySongListVC.h"
#import "SettingVC.h"
#import "MZTimerLabel.h"
#import "RCToastView.h"
#define IMP_WEAK_SELF(type) __weak type *weak_self=self;

static ViewController   *stationSelf = nil;

@interface ViewController ()<PlayEvent>
{
    
    float begntTIME;
}
@property (weak, nonatomic) IBOutlet UIButton *sesytemButton;
@property (weak, nonatomic) IBOutlet UIButton *playTmpButton;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *playingName;
@property (weak, nonatomic) IBOutlet UILabel *tmerTimeShow;
@property (weak, nonatomic) IBOutlet UILabel *palyingNewName;
@property (weak, nonatomic) IBOutlet UILabel *timeStr;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (strong, nonatomic)PlaySongListVC *list;

@property (strong, nonatomic) TAGPlayer *player;

@property (strong, nonatomic) SettingVC *setVC;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) BOOL demoPlaySong;



@property (strong, nonatomic) MZTimerLabel *daojiXunHuanDay;

@property (strong, nonatomic) MZTimerLabel *daojiJianGeDay;

@property (nonatomic, strong) UILabel *hiddenLable;

@end

@implementation ViewController


#pragma mark - init

+ (instancetype )shareVC{
    return stationSelf;
}

- (void)initAllItem{
   
    _sesytemButton.layer.cornerRadius = 4.0;
    [_sesytemButton.layer setMasksToBounds:YES];
    
    _playTmpButton.layer.cornerRadius = 4.0;
    [_playTmpButton.layer setMasksToBounds:YES];
    
    self.player.currentTime = self.timeStr;
    
    self.player.play_Button = self.playButton;
    
    self.player.deleagete = self;
}
- (void)backTouchEvent:(NSNumber *)status{
    if (self.playingDemoSong) {
        [self playTmpSong:nil];
    }
    else if (self.player.tagName == 1){
        [self demoSong];
    }
    else{
        if ([Tool getAutoPlaying]) {
            [[PlaySongListVC shareSonglist] getAutoModel_Next_Song:[PlaySongListVC shareSonglist].songNameAuto];
        }else{
            [Tool getNextSongName];
        }
        
    }
}

- (void)beginplayDaojishi{
    
    _TimeDjshi = [[MZTimerLabel alloc] initWithLabel:_showDaojishiTier andTimerType:MZTimerLabelTypeTimer];
    
    CGFloat time = [[[PlaySongListVC shareSonglist] playingTime] floatValue];
    _TimeDjshi.tag = 111;
    [_TimeDjshi setCountDownTime:time*60];
    _TimeDjshi.resetTimerAfterFinish = NO;
    _TimeDjshi.delegate = self;
    
    [_TimeDjshi  start];
    
    begntTIME = 0;
    
    
}
-(void)timerLabel:(MZTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType;{
    //音量逻辑
    /**
     音效渐强渐弱规则：
     1、将音量分为0-100值；
     2、每个时间段音乐播放时间分3个阶段：开始【前10秒钟】，正常播放、结尾【后10秒钟】
     3、 开始（从0 - 100渐强），正常播放（保持）、结尾（从100 - 0渐弱）
     */
    
    //音量逐渐变大
    if (timerLabel.tag == 111) {
        
        int hour = (int)(time/3600);
        int minute = (int)(time - hour*3600)/60;
        int second = time - hour*3600 - minute*60;
        if (begntTIME == 0) {
            if (self.player.musicPlayer.currentTime >= 0 && self.player.musicPlayer.currentTime <= 10) {
                self.player.musicPlayer.volume = self.player.musicPlayer.currentTime/10;
            }else{
                begntTIME = -1;
                if (self.player.musicPlayer.volume <= 1) {
                    self.player.musicPlayer.volume = 1;
                }
            }
        }else{
            if (hour == 0 && minute ==0 && second <= 10) {
                self.player.musicPlayer.volume = second/10;
            }
        }
        
        
    }
}
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    
    if (timerLabel.tag == 100) {//循环时间结束  进入休眠时间
        _MyappComeSleep = YES;
        _daojiJianGeDay = [[MZTimerLabel alloc] initWithLabel:_hiddenLable andTimerType:MZTimerLabelTypeTimer];
        _daojiJianGeDay.tag = 200;
        _daojiJianGeDay.delegate = self;
        _daojiJianGeDay.resetTimerAfterFinish = NO;
        
        CGFloat time = [[Tool getjiange] floatValue]*24*60*60;
        
        [_daojiJianGeDay setCountDownTime:time];
        
        
        [_daojiJianGeDay start];
        
        
    }
    else if (timerLabel.tag == 200){
        _MyappComeSleep = NO;
        [self demoSong];
        
    }
    else{
        if ([[Tool getbofangliebiaomoshi] intValue] == 1 && [[Tool getliebiaoneimoshi] intValue] == 1) {
            NSString *str = [NSString stringWithFormat:@"%@-%zd",[PlaySongListVC shareSonglist].songNameAuto,[PlaySongListVC shareSonglist].kplayRow + 1];
            
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"========================="];
        }
        //时间到了 需要停止播放 并做一系列存储功能
        [self.player stopSong];
        
        self.player.isStopPlay = YES;
        
        [self demoSong];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    stationSelf = self;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    _playingDemoSong = NO;
    
    self.player = [TAGPlayer shareTAGPlayer];
    
    [self initAllItem];
    
    
    if (nil == _list) {
        _list = [PlaySongListVC shareSonglist];
        _list.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        _list.view.alpha = 0.2;
        [self.view addSubview:_list.view];
    }
    if (nil == _setVC) {
        _setVC = [SettingVC shareSetting];
        _setVC.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        _setVC.view.alpha = 0.2;
        [self.view addSubview:_setVC.view];
    }
    
    IMP_WEAK_SELF(ViewController);
    _list.kchangeSong = ^(NSString *songName,NSString *path){
        
        if (weak_self.playingDemoSong) {
            [weak_self playTmpSong:nil];
        }else{
            NSURL* fileUrl=[NSURL fileURLWithPath:path];
            [weak_self.player PlayerName:fileUrl];
            [weak_self SongName:songName];
        }
    };
    
    
    if ([Tool getAutoPlaying]) {
        [_auteOrYourButton setSelectedSegmentIndex:1];
        [Tool setAutoPlaying:[NSNumber numberWithBool:YES]];
        [UIView animateWithDuration:0.35 animations:^{
            _bottomY.constant = -90;
        }];
    }
    
    
    //用于切换自动模式
    
    _hiddenLable = [[UILabel alloc] init];
    _hiddenLable.frame= CGRectMake(0, 0, 1, 1);
    _hiddenLable.backgroundColor = [UIColor clearColor];
    [_hiddenLable setTextColor:[UIColor clearColor]];
    [self.view addSubview:_hiddenLable];
    
    _MyappComeSleep = NO;
}


// 接收远程控制事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if ([Tool getAutoPlaying]) {
        return;
    }
    
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:
            {
                [self.player playOrPause: nil];
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
            {
                if (self.playingDemoSong) {
                    [self playTmpSong:nil];
                }else{
                    [Tool getNextSongName];
                }
                
            }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                if (self.playingDemoSong) {
                    [self playTmpSong:nil];
                }else{
                    [Tool getUpSongName];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setting
- (void)SongName:(NSString *)name{

    _palyingNewName.text = _playingName.text = [NSString stringWithFormat:@"正在播放：%@",name];

}

#pragma makr - action
//播放列表
- (IBAction)playSongList:(id)sender {
    
    [UIView animateWithDuration:0.35 animations:^{
        _list.view.alpha = 1;
        _list.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
    
}
//设置
- (IBAction)gotoSetting:(id)sender {
    [_setVC showVc];
}
//播放示例音乐
- (IBAction)playTmpSong:(id)sender {
    
    if ([Tool getAutoPlaying]) {
        return;
    }
    
    _playingDemoSong = YES;
    
    NSURL *nameStr = [Tool getAppSongName:@"实例音乐Demo - 纯音乐版" type:@"mp3"];
    [self.player PlayerName:nameStr];
    
    [self SongName:@"实例音乐Demo - 纯音乐版"];
}

//自动手动切换
- (IBAction)auteOrYourEvent:(UISegmentedControl *)sender {
    
    [self.player stopSong];
    
    if (sender.selectedSegmentIndex == 0) {
        
        self.player.tagName = 0;

        [Tool setAutoPlaying:[NSNumber numberWithBool:NO]];
        [UIView animateWithDuration:0.35 animations:^{
            _bottomY.constant = 10;
        }];
        
        // 暂停定时器
        self.timer.fireDate = [NSDate distantFuture];
        
    }else{
        [Tool setAutoPlaying:[NSNumber numberWithBool:YES]];
        [UIView animateWithDuration:0.35 animations:^{
            _bottomY.constant = -90;
        }];
        
        [self demoSong];
        
        //设定定时器
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        self.timer=[NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(qidongdingshi) userInfo:nil repeats:YES];
        [self.timer fire]; // 触发
        
        
        //触发循环天数
        _daojiXunHuanDay = [[MZTimerLabel alloc] initWithLabel:_hiddenLable andTimerType:MZTimerLabelTypeTimer];
        _daojiXunHuanDay.tag = 100;
        _daojiXunHuanDay.delegate = self;
        _daojiXunHuanDay.resetTimerAfterFinish = NO;
        
        CGFloat time = [[Tool getxunhuan] floatValue]*24*60*60;
        
        [_daojiXunHuanDay setCountDownTime:time];
        [_daojiXunHuanDay start];
    }
}
- (void)qidongdingshi
{
    NSLog(@"跟东吧 --- %@",[NSDate date]);
    
    if (_MyappComeSleep) {
        return;
    }
    
    if (self.player.musicPlayer.isPlaying && self.player.tagName != 1) {
   
    }else{
        [Tool playSongAuto];
    }
}
- (void)demoSong{
    
    NSLog(@"zala === ");
    
    NSURL *nameStr = [Tool getAppSongName:@"demodemo" type:@"mp3"];
    [self.player PlayerName:nameStr];
    
    [self SongName:@" "];
    
    self.player.tagName = 1;
}
//下一首
- (IBAction)NextButton:(id)sender {
    
    if (self.playingDemoSong) {
        [self playTmpSong:nil];
    }else{
        [Tool getNextSongName];
    }
    
}
//播放或者暂停
- (IBAction)playButtonEvent:(id)sender {
    
    if (self.player.musicPlayer) {
        [self.player playOrPause:nil];
    }else{
        [self playTmpSong:nil];
    }
    
}
//上一首
- (IBAction)upButtonEvent:(id)sender {
    if (self.playingDemoSong) {
        [self playTmpSong:nil];
    }else{
        [Tool getUpSongName];
    }
}
@end
