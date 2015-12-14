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
#define IMP_WEAK_SELF(type) __weak type *weak_self=self;

static ViewController   *stationSelf = nil;

@interface ViewController ()
{
   
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
    
    
    IMP_WEAK_SELF(ViewController);
    self.player.ktouchEvent = ^(TAGPlayerStatus status){
    
        if (weak_self.playingDemoSong) {
            [weak_self playTmpSong:nil];
        }else{
            if ([Tool getAutoPlaying]) {
                NSString *str = [NSString stringWithFormat:@"%zd",[Tool getNowHour]];
                str = [str stringByReplacingOccurrencesOfString:@"0" withString:@""];
                [[PlaySongListVC shareSonglist] getAutoModel_Next_Song:str];
            }else{
               [Tool getNextSongName];
            }
            
        }
        
    };
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
    
}


// 接收远程控制事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
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
    
    _playingDemoSong = YES;
    
    NSURL *nameStr = [Tool getAppSongName:@"实例音乐Demo - 纯音乐版" type:@"mp3"];
    [self.player PlayerName:nameStr];
    
    [self SongName:@"实例音乐Demo - 纯音乐版"];
}
//自动手动切换
- (IBAction)auteOrYourEvent:(UISegmentedControl *)sender {
    
    [self.player stopSong];
    
    if (sender.selectedSegmentIndex == 0) {
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
        
        [Tool playSongAuto];
        //设定定时器
        self.timer=[NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(qidongdingshi) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate date]];
        
        [self.timer fire]; // 触发
    }
}
- (void)qidongdingshi
{
    if (self.player.musicPlayer.isPlaying) {
        
    }else{
        [Tool playSongAuto];
    }
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
