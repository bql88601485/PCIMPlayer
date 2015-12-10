//
//  RCToastView.h
//  Car
//
//  Created by bai on 15/11/12.
//  Copyright © 2015年 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define ToastViewMessage(message) [RCToastView showMessage:message]

@interface RCToastView : UIView

+ (void)showMessage:(NSString*)msg;

@end
