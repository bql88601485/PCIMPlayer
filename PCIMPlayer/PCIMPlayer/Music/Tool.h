//
//  Tool.h
//  LJJMp3Player
//
//  Created by bai on 15-3-14.
//  Copyright (c) 2015年 LJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
@interface Tool : NSObject
//高斯模糊效果
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
//圆形效果
+(void)ImageHandleWithImageView:(UIImageView*)imageView andImageName:(NSString*)imageName;

+(NSURL *)getAppSongName:(NSString *)playName type:(NSString *)type;


+ (NSString *)getHomeDirectoryPath;

+ (NSArray *) getAllFileNames;

+ (NSString *)getPlayName:(NSString *)songName;

+ (NSInteger )getNowHour;

+ (NSString *)getNextSongName;

+ (NSString *)getUpSongName;

+ (void)playSongAuto;

+ (void)setLastPlayName:(NSDictionary *)name;
+ (NSDictionary *)lastPlayName;

+ (void)setAutoPlaying:(NSNumber *)num;
+ (BOOL )getAutoPlaying;
//系统设置
+ (void)setMeiTianCishu:(NSString *)num;
+ (NSString *)getMeiTianCishu;

+ (void)setdiyici:(NSString *)num;
+ (NSString *)getdiyici;

+ (void)setdiyiciChang:(NSString *)num;
+ (NSString *)getdiyiciChang;

+ (void)setdierci:(NSString *)num;
+ (NSString *)getdierci;

+ (void)setdierciChang:(NSString *)num;
+ (NSString *)getdierciChang;

+ (void)setdisanci:(NSString *)num;
+ (NSString *)getdisanci;

+ (void)setdisanciChang:(NSString *)num;
+ (NSString *)getdisanciChang;

+ (void)setdisici:(NSString *)num;
+ (NSString *)getdisici;

+ (void)setdisiciChang:(NSString *)num;
+ (NSString *)getdisiciChang;

+ (void)setdiwuci:(NSString *)num;
+ (NSString *)getdiwuci;

+ (void)setdiwuciChang:(NSString *)num;
+ (NSString *)getdiwuciChang;

+ (void)setdiliuci:(NSString *)num;
+ (NSString *)getdiliuci;

+ (void)setdiliuciChang:(NSString *)num;
+ (NSString *)getdiliuciChang;

+ (void)setxunhuan:(NSString *)num;
+ (NSString *)getxunhuan;

+ (void)setjiange:(NSString *)num;
+ (NSString *)getjiange;

+ (void)setbofangliebiaomoshi:(NSString *)num;
+ (NSString *)getbofangliebiaomoshi;

+ (void)setliebiaoneimoshi:(NSString *)num;
+ (NSString *)getliebiaoneimoshi;

+ (void)setyinxiao:(NSString *)num;
+ (NSString *)getyinxiao;

@end
