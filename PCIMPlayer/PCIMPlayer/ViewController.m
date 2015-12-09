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
#define IMP_WEAK_SELF(type) __weak type *weak_self=self;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sesytemButton;
@property (weak, nonatomic) IBOutlet UIButton *playTmpButton;

@property (weak, nonatomic) IBOutlet UIButton *playButton;


@property (weak, nonatomic) IBOutlet UILabel *playingName;
@property (weak, nonatomic) IBOutlet UILabel *tmerTimeShow;
@property (weak, nonatomic) IBOutlet UILabel *palyingNewName;
@property (weak, nonatomic) IBOutlet UILabel *timeStr;


@property (weak, nonatomic) IBOutlet UISegmentedControl *auteOrYourButton;


@property (weak, nonatomic) IBOutlet UIImageView *logoImage;


@property (strong, nonatomic) TAGPlayer *player;

@end

@implementation ViewController


#pragma mark - init

- (void)initAllItem{
   
    _sesytemButton.layer.cornerRadius = 4.0;
    [_sesytemButton.layer setMasksToBounds:YES];
    
    _playTmpButton.layer.cornerRadius = 4.0;
    [_playTmpButton.layer setMasksToBounds:YES];
    
    self.player.currentTime = self.timeStr;
    
    self.player.play_Button = self.playButton;
    
    IMP_WEAK_SELF(ViewController);
    self.player.ktouchEvent = ^(TAGPlayerStatus status){
    
        [weak_self playTmpSong:nil];
    
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    self.player = [TAGPlayer shareTAGPlayer];
    
    [self initAllItem];
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
    
    PlaySongListVC *list = [[PlaySongListVC alloc] initWithNibName:@"PlaySongListVC" bundle:nil];
    
    [self presentViewController:list animated:YES completion:^{
        
    }];
    
}
//设置
- (IBAction)gotoSetting:(id)sender {


}
//播放示例音乐
- (IBAction)playTmpSong:(id)sender {
    
    NSURL *nameStr = [Tool getAppSongName:@"红颜劫" type:@"mp3"];
    [self.player PlayerName:nameStr];
    
    [self SongName:@"红颜劫"];
}
//自动手动切换
- (IBAction)auteOrYourEvent:(id)sender {
    
    
}
//下一首
- (IBAction)NextButton:(id)sender {
    
    
}
//播放或者暂停
- (IBAction)playButtonEvent:(id)sender {
    
    [self.player playOrPause:nil];
}
//上一首
- (IBAction)upButtonEvent:(id)sender {
    
    
}
@end
