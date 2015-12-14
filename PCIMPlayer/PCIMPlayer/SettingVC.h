//
//  SettingVC.h
//  PCIMPlayer
//
//  Created by bai on 15/12/9.
//  Copyright © 2015年 PCIMPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingVC : UIViewController

+ (instancetype )shareSetting;


@property (nonatomic, strong)NSMutableArray *TimeArray;

- (void)showVc;
- (void)dismissVc;

@end
