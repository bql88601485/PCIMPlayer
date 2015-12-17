//
//  PlaySongListVC.h
//  PCIMPlayer
//
//  Created by bai on 15/12/9.
//  Copyright © 2015年 PCIMPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTree.h"
typedef void(^ChangeSong)(NSString *songName,NSString *path);

@interface PlaySongListVC : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) ChangeSong kchangeSong;

@property(strong,nonatomic) NSMutableArray* dataArray; //保存全部数据的数组
@property(strong,nonatomic) NSArray *displayArray;   //保存要显示在界面上的数据的数组

@property(strong,nonatomic) NSArray *alldisplayArray;   //保存要显示在界面上的数据的数组

@property(strong,nonatomic) NSIndexPath *selectPath;

@property (strong, nonatomic) CLTreeViewNode *songObjct;


@property (assign, nonatomic) BOOL  upIsOk;

+ (instancetype )shareSonglist;


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;



//适应切换自动模式状态功能数据

@property (nonatomic, strong) NSArray *item_2_Array;
@property (nonatomic, strong) NSMutableArray *item_3_Array;
@property (nonatomic, strong) NSMutableArray *item_Tmp2_Array;

@property (nonatomic, assign) NSInteger kplayRow;

@property (nonatomic, strong) NSString *songNameAuto;

@property (nonatomic, strong) NSString *playingTime;

- (void)getAutoModel_Next_Song:(NSString *)top;

@property (nonatomic, strong) NSMutableArray *songlistName;

@end
