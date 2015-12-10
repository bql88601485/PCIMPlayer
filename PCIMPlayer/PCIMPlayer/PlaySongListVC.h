//
//  PlaySongListVC.h
//  PCIMPlayer
//
//  Created by bai on 15/12/9.
//  Copyright © 2015年 PCIMPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeSong)(NSString *songName,NSString *path);

@interface PlaySongListVC : UIViewController

@property (nonatomic, strong) ChangeSong kchangeSong;

+ (instancetype )shareSonglist;

@end
