//
//  PlaySongListVC.m
//  PCIMPlayer
//
//  Created by bai on 15/12/9.
//  Copyright © 2015年 PCIMPlayer. All rights reserved.
//

#import "PlaySongListVC.h"
#import "CLTree.h"
#import "Tool.h"
#import "RCToastView.h"
static PlaySongListVC *stataicSelf = nil;

@interface PlaySongListVC ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation PlaySongListVC

+ (instancetype )shareSonglist{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stataicSelf = [[PlaySongListVC alloc] initWithNibName:@"PlaySongListVC" bundle:nil];
        stataicSelf.selectPath = nil;
    });
    return stataicSelf;
}


//添加演示数据
-(void) addTestData{
    NSArray *array = [Tool getAllFileNames];
    
    NSString *topStr = nil;
    
    NSString *topTwoStr = nil;
    
    NSString *topThreeStr = nil;
    
    _dataArray = [[NSMutableArray alloc] init];
    
    CLTreeViewNode *node0 = nil;
    
    CLTreeViewNode *node1 = nil;
    NSMutableArray *node1Array = nil;
    CLTreeViewNode *node2 = nil;
    NSMutableArray *node2Array = nil;
    //分析数据
    for (NSString *str in array) {
        //排除
        if ([str isEqualToString:@".DS_Store"]) {
            continue;
        }
        NSArray *tmpArr = [str componentsSeparatedByString:@"/"];
        
        if (tmpArr.count == 1) {//首位
            if (nil == topStr) {
                topStr = [tmpArr firstObject];
                
                node0 = [[CLTreeViewNode alloc]init];
                node0.nodeLevel = 0;
                node0.type = 0;
                node0.sonNodes = nil;
                node0.isExpanded = FALSE;
                CLTreeView_LEVEL0_Model *tmp0 =[[CLTreeView_LEVEL0_Model alloc]init];
                tmp0.name = topStr;
                tmp0.headImgPath = @"contacts_collect.png";
                tmp0.headImgUrl = nil;
                node0.nodeData = tmp0;
                
            }else{
                if (![topStr isEqualToString:tmpArr.firstObject]) {//代表换文件夹了
                    
                    //最后一个入住
                    if (node1Array && node1 && node2Array) {
                        
                        CLTreeView_LEVEL1_Model *tmp1 =[[CLTreeView_LEVEL1_Model alloc]init];
                        tmp1.name = topTwoStr;
                        tmp1.sonCnt = [NSString stringWithFormat:@"%zd",node2Array.count];
                        node1.nodeData = tmp1;
                        node1.sonNodes = node2Array;
                        [node1Array addObject:node1];
                    }
                    
                    topTwoStr = nil;
                    topThreeStr = nil;
                    
                    node0.sonNodes = node1Array;
                    
                    [_dataArray addObject:node0];
                    
                    //TODO : 需要换文件夹了
                    topStr = [tmpArr firstObject];
                    
                    node0 = [[CLTreeViewNode alloc]init];
                    node0.nodeLevel = 0;
                    node0.type = 0;
                    node0.sonNodes = nil;
                    node0.isExpanded = FALSE;
                    CLTreeView_LEVEL0_Model *tmp0 =[[CLTreeView_LEVEL0_Model alloc]init];
                    tmp0.name = topStr;
                    tmp0.headImgPath = @"contacts_collect.png";
                    tmp0.headImgUrl = nil;
                    node0.nodeData = tmp0;
                }
            }
        }else if (tmpArr.count == 2){
            if (nil == topTwoStr) {
                
                node1Array = [[NSMutableArray alloc] init];
                
                topTwoStr = [tmpArr objectAtIndex:1];
                if ([topTwoStr isEqualToString:@".DS_Store"]) {
                    topTwoStr = nil;
                    continue;
                }
                
                node1 = [[CLTreeViewNode alloc]init];
                node1.nodeLevel = 1;
                node1.type = 1;
                node1.sonNodes = nil;
                node1.isExpanded = FALSE;
            }
            else{
                
                if (![topTwoStr isEqualToString:[tmpArr objectAtIndex:1]]) {
                    
                    topThreeStr = nil;
                    CLTreeView_LEVEL1_Model *tmp1 =[[CLTreeView_LEVEL1_Model alloc]init];
                    tmp1.name = topTwoStr;
                    tmp1.sonCnt = [NSString stringWithFormat:@"%zd",node2Array.count];
                    node1.nodeData = tmp1;
                    node1.sonNodes = node2Array;
                    [node1Array addObject:node1];
                    
                    //TODO : 需要更换文件夹
                    topTwoStr = [tmpArr objectAtIndex:1];
                    
                    node1 = [[CLTreeViewNode alloc]init];
                    node1.nodeLevel = 1;
                    node1.type = 1;
                    node1.sonNodes = nil;
                    node1.isExpanded = FALSE;
                }
                
                
            }
        }else if ([tmpArr count] == 3){
            
            if (topThreeStr == nil) {
                
                node2Array = [[NSMutableArray alloc] init];
                
                topThreeStr = [tmpArr objectAtIndex:2];
                if ([topThreeStr isEqualToString:@".DS_Store"]) {
                    topThreeStr = nil;
                    continue;
                }
            }
            else{
                topThreeStr = [tmpArr objectAtIndex:2];
            }
            
            node2 = [[CLTreeViewNode alloc]init];
            node2.nodeLevel = 2;
            node2.type = 2;
            node2.sonNodes = nil;
            node2.isExpanded = FALSE;
            CLTreeView_LEVEL2_Model *tmp9 =[[CLTreeView_LEVEL2_Model alloc]init];
            tmp9.name = topThreeStr;
            tmp9.signture = topTwoStr;
            tmp9.topName = topStr;
            tmp9.headImgPath = @"Qidong.png";
            tmp9.headImgUrl = nil;
            node2.nodeData = tmp9;
            node2.name = topThreeStr;
            [node2Array addObject:node2];
        }
    }
    
    
    
    //最后一个入住
    if (node1Array && node1 && node2Array && node0) {
        
        CLTreeView_LEVEL1_Model *tmp1 =[[CLTreeView_LEVEL1_Model alloc]init];
        tmp1.name = topTwoStr;
        tmp1.sonCnt = [NSString stringWithFormat:@"%zd",node2Array.count];
        node1.nodeData = tmp1;
        node1.sonNodes = node2Array;
        
        [node1Array addObject:node1];
        node0.sonNodes = node1Array;
        [_dataArray addObject:node0];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addTestData];//添加演示数据
    [self reloadDataForDisplayArray];//初始化将要显示的数据
//    [self reloadAllYINYUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action

- (IBAction)goBack:(id)sender {
    [UIView animateWithDuration:0.35 animations:^{
       
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        self.view.alpha = 0.2;
    }];
}


#pragma mark - tableview delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return _displayArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"level0cell";
    static NSString *indentifier1 = @"level1cell";
    static NSString *indentifier2 = @"level2cell";
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    if(node.type == 0){//类型为0的cell
        CLTreeView_LEVEL0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level0_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        return cell;
    }
    else if(node.type == 1){//类型为1的cell
        CLTreeView_LEVEL1_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level1_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
    else{//类型为2的cell
        CLTreeView_LEVEL2_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level2_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(CLTreeViewNode*)node{
    if(node.type == 0){
        CLTreeView_LEVEL0_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL0_Cell*)cell).name.text = nodeData.name;
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
    
    else if(node.type == 1){
        CLTreeView_LEVEL1_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL1_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL1_Cell*)cell).sonCount.text = nodeData.sonCnt;
    }
    
    else{
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL2_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL2_Cell*)cell).signture.text = nodeData.signture;
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 50;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"\n 下一站 = %ld",(long)indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];

    BOOL yy = [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
    if (!yy) {
        return;
    }
    if(node.type == 2){
        //处理叶子节点选中，此处需要自定义
        CLTreeView_LEVEL2_Model *objec = (id )node.nodeData;
        _songObjct = (id )node;
        
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@",objec.topName,objec.signture,objec.name];
        
        if (_kchangeSong) {
            
            _selectPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            
            [self goBack:nil];
            path = [Tool  getPlayName:path];
            self.kchangeSong(objec.name,path);
        }
    }
    else{
        CLTreeView_LEVEL0_Cell *cell = (CLTreeView_LEVEL0_Cell*)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.node.isExpanded ){
            [self rotateArrow:cell with:M_PI_2];
        }
        else{
            [self rotateArrow:cell with:0];
        }
    }
}

/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void) rotateArrow:(CLTreeView_LEVEL0_Cell*) cell with:(double)degree{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}

/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableview reloadData];
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(BOOL ) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    
    if (self.view.frame.origin.y < 20) {
        _upIsOk = NO;
    }
    
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(cnt == row){
            node.isExpanded = !node.isExpanded;
            
            if (_upIsOk) {
                if (!node.isExpanded) {
                    node.isExpanded = YES;
                }
            }
        }
        ++cnt;
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(cnt == row){
                    if (_songObjct) {
                        for(CLTreeViewNode *nodeTmp in node2.sonNodes){
                            if ([nodeTmp.name isEqualToString:_songObjct.name]) {
                                ToastViewMessage(@"正在播放，暂时不能合并");
                                return NO;
                            }
                        }
                    }
                    
                    node2.isExpanded = !node2.isExpanded;
                    
                    if (_upIsOk) {
                        if (!node2.isExpanded) {
                            node2.isExpanded = YES;
                        }
                    }
                }
                ++cnt;
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                        ++cnt;
                    }
                }
            }
        }
    }
    
    int cha = (int )(_displayArray.count) - (int) (tmp.count);
    
    if (row < _selectPath.row) {
        _selectPath = [NSIndexPath indexPathForRow:_selectPath.row - cha inSection:0];
    }
    
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableview reloadData];
    
    return YES;
}

- (void)reloadAllYINYUE{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        for(CLTreeViewNode *node2 in node.sonNodes){
            [tmp addObject:node2];
            for(CLTreeViewNode *node3 in node2.sonNodes){
                [tmp addObject:node3];
            }
        }
    }
    _alldisplayArray = [NSArray arrayWithArray:tmp];
}

@end
