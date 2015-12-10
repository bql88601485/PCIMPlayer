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



+ (NSString *)getNextSongName{
    
    
    NSString *name = nil;
    
    PlaySongListVC *songlist = [PlaySongListVC shareSonglist];
    
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

    return @"";
}

@end
