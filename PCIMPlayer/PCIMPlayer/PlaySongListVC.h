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
@end
