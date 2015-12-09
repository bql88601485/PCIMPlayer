//
//  Music.h
//  LJJMp3Player
//
//  Created by bai on 15-3-15.
//  Copyright (c) 2015年 LJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
@property(copy,nonatomic)NSString* musicName;
@property(copy,nonatomic)NSString* singerName;
@property(copy,nonatomic)NSString* type;
-(instancetype)initWithMusicName:(NSString*)musicname andSingerName:(NSString*)singername andType:(NSString*)Type;
@end
