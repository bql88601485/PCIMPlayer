//
//  Music.m
//  LJJMp3Player
//
//  Created by bai on 15-3-15.
//  Copyright (c) 2015年 LJJ. All rights reserved.
//

#import "Music.h"

@implementation Music
-(instancetype)initWithMusicName:(NSString *)musicname andSingerName:(NSString *)singername andType:(NSString *)Type
{
    if (self=[super init]) {
        self.musicName=musicname;
        self.singerName=singername;
        self.type=Type;
    }
    return self;
}
@end
