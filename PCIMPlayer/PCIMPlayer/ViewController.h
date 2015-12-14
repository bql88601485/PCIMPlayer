//
//  ViewController.h
//  PCIMPlayer
//
//  Created by bai on 15/12/9.
//  Copyright © 2015年 PCIMPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic , assign) BOOL  playingDemoSong;
@property (weak, nonatomic) IBOutlet UISegmentedControl *auteOrYourButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomY;
+ (instancetype )shareVC;

@end

