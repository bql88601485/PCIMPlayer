//
//  Tool.m
//  LJJMp3Player
//
//  Created by bai on 15-3-14.
//  Copyright (c) 2015年 LJJ. All rights reserved.
//

#import "Tool.h"
#import "PlaySongListVC.h"
#import "CLTree.h"
#import "SettingVC.h"
#import "ViewController.h"
#import "TAGPlayer.h"
#define KEY_USER_LAST_SONG_NAME @"KEY_USER_LAST_SONG_NAME"

@implementation Tool
+(void)ImageHandleWithImageView:(UIImageView *)imageView andImageName:(NSString *)imageName
{
    [imageView setImage:[UIImage imageNamed:imageName]];
    imageView.layer.cornerRadius=90;
    imageView.layer.borderWidth=10.0;
    imageView.layer.borderColor=[UIColor  blackColor].CGColor;
    imageView.clipsToBounds=YES;
}
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+(NSURL *)getAppSongName:(NSString *)playName type:(NSString *)type{
    
    NSBundle* bund=[NSBundle mainBundle];
    NSString* filepath=[bund pathForResource:playName ofType:type];
    NSURL* fileUrl=[NSURL fileURLWithPath:filepath];
    return fileUrl;
}

+ (NSString *)getHomeDirectoryPath{

    // 获得此程序的沙盒路径
    
    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 获取Documents路
    NSString *documentsDirectory = [patchs objectAtIndex:0];
    
    NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"PCIMPlayer"]];
    
    return fileDirectory;
}
+ (NSString *)getPlayName:(NSString *)songName{
    
    NSString *sonName1 = [NSString stringWithFormat:@"%@/%@",[Tool getHomeDirectoryPath],songName];
 
    return sonName1;
}
//os - 获取沙盒目录下的所有文件
+ (NSArray *) getAllFileNames
{
    NSString *fileDirectory = [Tool getHomeDirectoryPath];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:fileDirectory error:nil];
    
    return files;
}
+ (NSInteger )getNowHour{

    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:now];
    NSInteger hour = [dateComponent hour];
    
    if ([dateComponent minute] >= 0 && [dateComponent minute] <= 1) {
        return hour;
    }
    return -1;
    
}

+ (void)playSongAuto{
    
    PlaySongListVC *songlist = [PlaySongListVC shareSonglist];
    
    for (int i=0;i<[[Tool getMeiTianCishu] intValue];i++) {
        NSString *str = [[[SettingVC shareSetting] TimeArray] objectAtIndex:i];
        str = [[str componentsSeparatedByString:@":"] firstObject];
        if ([str intValue] == [Tool getNowHour]) {
            [PlaySongListVC  shareSonglist].kplayRow = 0;
            [TAGPlayer shareTAGPlayer].isStopPlay = NO;
            songlist.songNameAuto = str;
            switch (i) {
                case 0:
                    songlist.playingTime = [Tool getdiyiciChang];
                    break;
                case 1:
                    songlist.playingTime = [Tool getdierciChang];
                    break;
                case 2:
                    songlist.playingTime = [Tool getdisanciChang];
                    break;
                case 3:
                    songlist.playingTime = [Tool getdisiciChang];
                    break;
                case 4:
                    songlist.playingTime = [Tool getdiwuciChang];
                    break;
                case 5:
                    songlist.playingTime = [Tool getdiliuciChang];
                    break;
                default:
                    break;
            }
            
            
            [[ViewController shareVC] beginplayDaojishi];
            
            
            if ([[Tool getbofangliebiaomoshi] intValue] == 1 && [[Tool getliebiaoneimoshi] intValue] == 1){
            
                NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"========================="];
                if (str1) {
                    
                    NSArray *array = [str1 componentsSeparatedByString:@"-"];
                    
                    if ([[array firstObject] isEqualToString:str]) {
                        [PlaySongListVC shareSonglist].kplayRow = [[array objectAtIndex:1] intValue];
                    }
                }
            }
            
            
            [songlist getAutoModel_Next_Song:str];
            
            return;
        }
    }
    
    
}

+ (NSString *)getNextSongName{
    
    
    NSString *name = nil;
    
    PlaySongListVC *songlist = [PlaySongListVC shareSonglist];
    songlist.upIsOk = YES;
    if (YES) {
        
        NSInteger row = songlist.selectPath.row+1;
        if (row >= songlist.displayArray.count) {
            row = 0;
        }
        CLTreeViewNode *node = [songlist.displayArray objectAtIndex:row];
        
        if (node.nodeLevel == 0) {//下一个是首页//需要打开
            [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            row++;
            [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            row++;
        }else if(node.nodeLevel == 1){
            [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            row++;
        }
        [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    }

    return name;
}

+ (NSString *)getUpSongName{

    NSString *name = nil;
    
    PlaySongListVC *songlist = [PlaySongListVC shareSonglist];
    songlist.upIsOk = YES;
    if (YES) {
        
        NSInteger row = songlist.selectPath.row-1;
      
        CLTreeViewNode *node = [songlist.displayArray objectAtIndex:row];
        
        if (node.nodeLevel == 0) {//第一级  需要打开两次
            [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            row++;
            [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            node = [songlist.displayArray objectAtIndex:row];
            row += (node.sonNodes.count-1);
        }else if (node.nodeLevel == 1){
            row--;
            [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            node = [songlist.displayArray objectAtIndex:row];
            if (node.nodeLevel == 1) {
                row += (node.sonNodes.count);
            }else if(node.nodeLevel == 0){
                if (row == 0) {
                    row = songlist.displayArray.count - 1;
                    node = [songlist.displayArray objectAtIndex:row];
                    if (node.nodeLevel == 0) {
                        [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                        row += (node.sonNodes.count);
                        [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                        node = [songlist.displayArray objectAtIndex:row];
                        row += (node.sonNodes.count);
                    }
                }else{
                    row--;
                    node = [songlist.displayArray objectAtIndex:row];
                    [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                    row += (node.sonNodes.count);
                    node = [songlist.displayArray objectAtIndex:row];
                    if (node.nodeLevel == 1) {
                        [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                        row += (node.sonNodes.count);
                    }
                }
            }
        }
        [songlist tableView:songlist.tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    }
    
    return name;
}


#pragma mark - setter && getter
+ (void)setLastPlayName:(NSDictionary *)name{
    
    NSUserDefaults  *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:name forKey:KEY_USER_LAST_SONG_NAME];
    [ud synchronize];
}
+ (NSString *)lastPlayName{
    
    return @"";
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_LAST_SONG_NAME];
}

+ (void)setAutoPlaying:(NSNumber *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"papapapapapapapapapa"];
    [ud synchronize];
}
+ (BOOL )getAutoPlaying{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"papapapapapapapapapa"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"papapapapapapapapapa"] boolValue];
    }
    return NO;
}

#pragma mark -  系统设置

+ (void)setMeiTianCishu:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"111111111111111"];
    [ud synchronize];
}
+ (NSString *)getMeiTianCishu{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"111111111111111"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"111111111111111"];
    }
    return @"6";
}

+ (void)setdiyici:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"222222222222222"];
    [ud synchronize];
}
+ (NSString *)getdiyici{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"222222222222222"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"222222222222222"];
    }
    return @"06:00";
}

+ (void)setdiyiciChang:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"33333333333333"];
    [ud synchronize];
}
+ (NSString *)getdiyiciChang{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"33333333333333"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"33333333333333"];
    }
    return @"15";
}

+ (void)setdierci:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"4444444444444"];
    [ud synchronize];
}
+ (NSString *)getdierci{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"4444444444444"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"4444444444444"];
    }
    return @"10:00";
}

+ (void)setdierciChang:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"55555555555555"];
    [ud synchronize];
}
+ (NSString *)getdierciChang{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"55555555555555"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"55555555555555"];
    }
        return @"30";
}

+ (void)setdisanci:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"66666666666666"];
    [ud synchronize];
}
+ (NSString *)getdisanci{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"66666666666666"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"66666666666666"];
    }
        return @"12:00";
}

+ (void)setdisanciChang:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"7777777777777"];
    [ud synchronize];
}
+ (NSString *)getdisanciChang{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"7777777777777"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"7777777777777"];
    }
        return @"15";
}

+ (void)setdisici:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"88888888888888"];
    [ud synchronize];
}
+ (NSString *)getdisici{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"88888888888888"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"88888888888888"];
    }
            return @"16:00";
}

+ (void)setdisiciChang:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"999999999999"];
    [ud synchronize];
}
+ (NSString *)getdisiciChang{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"999999999999"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"999999999999"];
    }
    return @"30";
}

+ (void)setdiwuci:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"00000000000"];
    [ud synchronize];
}
+ (NSString *)getdiwuci{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"00000000000"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"00000000000"];
    }
    return @"18:00";
}

+ (void)setdiwuciChang:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"aaaaaaaaaaaaa"];
    [ud synchronize];
}
+ (NSString *)getdiwuciChang{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"aaaaaaaaaaaaa"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"aaaaaaaaaaaaa"];
    }
    return @"15";
}

+ (void)setdiliuci:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"bbbbbbbbbbbbbbb"];
    [ud synchronize];
}
+ (NSString *)getdiliuci{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"bbbbbbbbbbbbbbb"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"bbbbbbbbbbbbbbb"];
    }
    return @"21:00";
}

+ (void)setdiliuciChang:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"ccccccccccccccccc"];
    [ud synchronize];
}
+ (NSString *)getdiliuciChang{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ccccccccccccccccc"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"ccccccccccccccccc"];
    }
    return @"15";
}

+ (void)setxunhuan:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"ddddddddddddddddd"];
    [ud synchronize];
}
+ (NSString *)getxunhuan{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ddddddddddddddddd"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"ddddddddddddddddd"];
    }
    return @"7";
}

+ (void)setjiange:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"eeeeeeeeeeeeeee"];
    [ud synchronize];
}
+ (NSString *)getjiange{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"eeeeeeeeeeeeeee"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"eeeeeeeeeeeeeee"];
    }
    return @"1";
}

+ (void)setbofangliebiaomoshi:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"fffffffffffffff"];
    [ud synchronize];
}
+ (NSString *)getbofangliebiaomoshi{//1循环 ， 2 随机
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"fffffffffffffff"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"fffffffffffffff"];
    }
    return @"1";
}

+ (void)setliebiaoneimoshi:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"ggggggggggggggggggg"];
    [ud synchronize];
}
+ (NSString *)getliebiaoneimoshi{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ggggggggggggggggggg"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"ggggggggggggggggggg"];
    }
    return @"1";
}

+ (void)setyinxiao:(NSString *)num{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:num forKey:@"mmmmmmmmmmmmmmmmmmm"];
    [ud synchronize];
}
+ (NSString *)getyinxiao{//0 关闭 1 打开
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mmmmmmmmmmmmmmmmmmm"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"mmmmmmmmmmmmmmmmmmm"];
    }
    return @"0";
}



@end
