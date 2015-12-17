//
//  ViewController.h
//  PCIMPlayer
//
//  Created by bai on 15/12/9.
//  Copyright © 2015年 PCIMPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"
@interface ViewController : UIViewController<MZTimerLabelDelegate>

@property (nonatomic , assign) BOOL  playingDemoSong;
@property (weak, nonatomic) IBOutlet UISegmentedControl *auteOrYourButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomY;

@property (strong, nonatomic) MZTimerLabel *TimeDjshi;

@property (weak, nonatomic) IBOutlet UILabel *showDaojishiTier;


@property (assign, nonatomic) BOOL  MyappComeSleep;


+ (instancetype )shareVC;

- (void)beginplayDaojishi;

- (void)findeWenjianError;

@end

