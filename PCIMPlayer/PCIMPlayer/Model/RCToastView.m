//
//  RCToastView.m
//  Car
//
//  Created by bai on 15/11/12.
//  Copyright © 2015年 Qunar.com. All rights reserved.
//

#import "RCToastView.h"



#import "AppDelegate.h"
/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat CSToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat CSToastMinWidth            = 0.2;      // 20% of parent view height
static const CGFloat CSToastHorizontalPadding   = 10.0;
static const CGFloat CSToastVerticalPadding     = 10.0;
static const CGFloat CSToastCornerRadius        = 4.0;
static const CGFloat CSToastOpacity             = 0.8;
static const CGFloat CSToastFontSize            = 16.0;
static const CGFloat CSToastMaxTitleLines       = 0;
static const CGFloat CSToastMaxMessageLines     = 0;
static const CGFloat CSToastFadeDuration        = 0.5;

// shadow appearance
static const CGFloat CSToastShadowOpacity       = 0.8;
static const CGFloat CSToastShadowRadius        = 6.0;
static const CGSize  CSToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    CSToastDisplayShadow       = YES;

// display duration and position
static const CGFloat CSToastDefaultDuration     = 1.2;

// image view size
static const CGFloat CSToastImageViewWidth      = 80.0;
static const CGFloat CSToastImageViewHeight     = 80.0;


static UIView *_toastView;
static NSString *_message;

@implementation RCToastView
+ (UIWindow *)getKeyboardWindow
{
    UIWindow *keyboardWindow = nil;
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    if (windows.count > 1) {
        for (UIWindow *window in windows) {
            if (![NSStringFromClass([window class]) isEqualToString:NSStringFromClass([UIWindow class])]) {
                keyboardWindow = window;
                
                break;
            }
        }
    }
    return keyboardWindow;
}


#pragma mark - public methods
+ (void)showMessage:(NSString*)msg disappearAfterTime:(int)time
{
    NSString *newMessage = msg;
    UIWindow *window = [RCToastView getKeyboardWindow];
    
    if (!window) {
        window = [((AppDelegate *)[[UIApplication sharedApplication] delegate]) window];
    }
    
    if(_message.length > 0 && [_message isEqualToString:msg] && _toastView && _toastView.alpha > 0 )
    {
        return;
    }
    _message = newMessage;
    [_toastView removeFromSuperview];
    _toastView = nil;
    _toastView = [self viewForMessage:_message title:nil image:nil];
    _toastView.alpha = 0.0;
    
    CGPoint screenCenter = window.center;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
    {
        _toastView.transform = CGAffineTransformIdentity;
        CGAffineTransform transform;
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            _toastView.center = CGPointMake(screenCenter.x * 1.5, screenCenter.y);
            transform = CGAffineTransformRotate(_toastView.transform, -M_PI/2);
        }
        else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            _toastView.center = CGPointMake(screenCenter.x * 0.5, screenCenter.y);
            transform = CGAffineTransformRotate(_toastView.transform, M_PI/2);
        }
        else
        {
            _toastView.center = CGPointMake(screenCenter.x, screenCenter.y * 1.7);
            transform = CGAffineTransformIdentity;
        }
        _toastView.transform = transform;
    }
    else
    {
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
           [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            _toastView.center = CGPointMake(screenCenter.x, screenCenter.y * 1.5);
        }
        else
        {
            _toastView.center = CGPointMake(screenCenter.x, screenCenter.y * 1.7);
        }
    }
    
    
    [window addSubview:_toastView];
    [window bringSubviewToFront:_toastView];
    
    [UIView animateWithDuration:CSToastFadeDuration animations:^{
        _toastView.alpha = 1;
    }completion:^(BOOL finished) {
        [self performSelector:@selector(hide:) withObject:_toastView afterDelay:time];
    }];
}

+ (void)showMessage:(NSString*)msg
{
    [RCToastView showMessage:msg disappearAfterTime:CSToastDefaultDuration];
}

+ (void)hide:(UIView *)msgView
{
    [UIView animateWithDuration:CSToastFadeDuration  animations:^{
        msgView.alpha = 0.0;
    }completion:^(BOOL finished) {
        [msgView removeFromSuperview];
    }];
}


+ (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;
    
    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = CSToastShadowOpacity;
        wrapperView.layer.shadowRadius = CSToastShadowRadius;
        wrapperView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, CSToastImageViewWidth, CSToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = CSToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:CSToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((screenBounds.size.width * CSToastMaxWidth) - imageWidth, screenBounds.size.height * CSToastMaxHeight);
       
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:title];
        
        
        NSRange range = NSMakeRange(0, attrStr.length);
        
        NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段attributedString的属性字典
        // 计算文本的大小
        CGSize expectedSizeTitle = [title boundingRectWithSize:maxSizeTitle // 用于计算文本绘制时占据的矩形块
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                                   attributes:dic        // 文字的属性
                                              context:nil].size; // context上下文。
        
        titleLabel.frame = CGRectMake(0.0, 0.0, 200, 25);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:CSToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((screenBounds.size.width * CSToastMaxWidth) - imageWidth, screenBounds.size.height * CSToastMaxHeight);
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:message];
        
        
        NSRange range = NSMakeRange(0, attrStr.length);
        
        NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段attributedString的属性字典
        // 计算文本的大小
        CGSize expectedSizeMessage = [title boundingRectWithSize:maxSizeMessage // 用于计算文本绘制时占据的矩形块
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                                    attributes:dic        // 文字的属性
                                                       context:nil].size; // context上下文。

        messageLabel.frame = CGRectMake(0.0, 0.0, 200, 25);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = CSToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop = titleTop + titleHeight + CSToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    
    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding), (imageHeight + (CSToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

@end
