//
//  SettingVC.m
//  PCIMPlayer
//
//  Created by bai on 15/12/9.
//  Copyright © 2015年 PCIMPlayer. All rights reserved.
//

#import "SettingVC.h"
#import "Tool.h"
#import "MyPickerView.h"
#import "RCToastView.h"

typedef struct MYd {
    __unsafe_unretained UITextField *select;
    NSInteger tag;
}MYd;

static SettingVC *staticSelf = nil;

@interface SettingVC ()<UITextFieldDelegate,MyPickerViewDataSource,MyPickerViewDelegate>
{
    NSMutableArray * nibObjects;
    
    BOOL ShowPicker;
    NSIndexPath *ShowIndex;
    
    MyPickerView *typePicker;
    NSMutableArray *sectionName;
    NSInteger cellNumber;

    MYd selectTxt;
}

@property (weak, nonatomic) IBOutlet UITableView *setTablevewi;



@end

@implementation SettingVC

+ (instancetype )shareSetting{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticSelf = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
    });
    return staticSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *tmp = [[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:nil options:nil];
    nibObjects = [[NSMutableArray alloc] initWithArray:tmp];
    
    
    ShowPicker=NO;
    ShowIndex=[NSIndexPath indexPathForRow:100 inSection:100];
    cellNumber=16;
    if (typePicker == nil) {
        typePicker = [[MyPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        typePicker.delegate = self;
        typePicker.dataSource=self;
    }
    
    _setTablevewi.backgroundView=nil;
    
    _TimeArray = [NSMutableArray arrayWithObjects:[Tool getdiyici],[Tool getdierci],[Tool getdisanci],[Tool getdisici],[Tool getdiwuci],[Tool getdiliuci], nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self setEditing:NO animated:YES];
    [self dismissVc];
}

- (void)showVc{
    [UIView animateWithDuration:0.35 animations:^{
        self.view.alpha = 1.0;
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
- (void)dismissVc{
    [UIView animateWithDuration:0.35 animations:^{
        self.view.alpha = 0.2;
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    
    _TimeArray = [NSMutableArray arrayWithObjects:[Tool getdiyici],[Tool getdierci],[Tool getdisanci],[Tool getdisici],[Tool getdiwuci],[Tool getdiliuci], nil];
    
}


#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (ShowPicker&&[indexPath isEqual:ShowIndex]) {
        return 216.0f;
    }else{
        
        
        UITableViewCell *dcell = [self tableView:_setTablevewi cellForRowAtIndexPath:indexPath];
        
        return dcell.frame.size.height;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (ShowPicker&&[indexPath isEqual:ShowIndex] ) {
        
        static NSString *Cellid=@"cellid000";
        
        UITableViewCell *cell1=[_setTablevewi dequeueReusableCellWithIdentifier:Cellid];
        if (cell1==nil) {
            cell1=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellid];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell1.contentView addSubview:typePicker];
        return cell1;
        
    }
    else{
     
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            if (ShowIndex) {
                if (ShowIndex.row < indexPath.row) {
                    cell = [nibObjects objectAtIndex:indexPath.row-1];
                }else{
                    cell = [nibObjects objectAtIndex:indexPath.row];
                }
            }else{
                cell = [nibObjects objectAtIndex:indexPath.row];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0 || indexPath.row == 8 || indexPath.row == 11
            || indexPath.row == 14) {
            return cell;
        }
        NSInteger tag = 100 + indexPath.row;
        
        UITextField *text1 = (id )[cell viewWithTag:tag];
        UITextField *text2 = (id )[cell viewWithTag:tag*100];
        
        if ([text1 isKindOfClass:[UITextField   class]]) {
            text1.delegate = self;
            text2.delegate = self;
        }else if ([text1 isKindOfClass:[UISegmentedControl class]]){
            
        }else if ([text1 isKindOfClass:[UISwitch class]]){
            
        }
        
        
        switch (indexPath.row) {
            case 1:
            {
                text1.text = [Tool getMeiTianCishu];
            }
                break;
            case 2:
            {
                text1.text = [Tool getdiyici];
                text2.text = [Tool getdiyiciChang];
            }
                break;
            case 3:
            {
                text1.text = [Tool getdierci];
                text2.text = [Tool getdierciChang];
            }
                break;
            case 4:
            {
                text1.text = [Tool getdisanci];
                text2.text = [Tool getdisanciChang];
            }
                break;
            case 5:
            {
                text1.text = [Tool getdisici];
                text2.text = [Tool getdisiciChang];
            }
                break;
            case 6:
            {
                text1.text = [Tool getdiwuci];
                text2.text = [Tool getdiwuciChang];
            }
                break;
            case 7:
            {
                text1.text = [Tool getdiliuci];
                text2.text = [Tool getdiliuciChang];
            }
                break;
            case 9:
            {
                text1.text = [Tool getxunhuan];
            }
                break;
            case 10:
            {
                text1.text = [Tool getjiange];
            }
                break;
            case 12:
            {
                UISegmentedControl *segn = (id )text1;
                if ([[Tool getbofangliebiaomoshi] intValue] == 1) {
                    [segn setSelectedSegmentIndex:0];
                }else{
                    [segn setSelectedSegmentIndex:1];
                }
                [segn addTarget:self action:@selector(segmentAction12:) forControlEvents:UIControlEventValueChanged];
            }
                break;
            case 13:
            {
                UISegmentedControl *segn = (id )text1;
                if ([[Tool getliebiaoneimoshi] intValue] == 1) {
                    [segn setSelectedSegmentIndex:0];
                }else{
                    [segn setSelectedSegmentIndex:1];
                }
                
                [segn addTarget:self action:@selector(segmentAction13:) forControlEvents:UIControlEventValueChanged];
            }
                break;
            case 15:
            {
                UISwitch *tetx = (UISwitch *)text1;
                
                [tetx setOn:[[Tool getyinxiao] boolValue]];
                
                [tetx addTarget:self action:@selector(yingliang:) forControlEvents:UIControlEventValueChanged];
            }
                break;
                
            default:
                break;
        }
        
        
        return cell;
        
    }
}
- (void)yingliang:(UISwitch *)objct{
    if (objct.isOn) {
        [Tool setyinxiao:@"1"];
    }else{
        [Tool setyinxiao:@"0"];
    }
}
- (void)segmentAction12:(UISegmentedControl *)objce{
    NSInteger Index = objce.selectedSegmentIndex;
    if (Index == 0) {
        [Tool setbofangliebiaomoshi:@"1"];
    }else{
        [Tool setbofangliebiaomoshi:@"2"];
    }
}
- (void)segmentAction13:(UISegmentedControl *)objce{
    NSInteger Index = objce.selectedSegmentIndex;
    if (Index == 0) {
        [Tool setliebiaoneimoshi:@"1"];
    }else{
        [Tool setliebiaoneimoshi:@"2"];
    }
}
//pickerView显示
- (void)insertRow:(NSIndexPath *)indexPath
{
    ShowPicker=YES;
    
    [typePicker update];
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    
    NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:0];
    ShowIndex=indexPathToInsert;
    
    [rowToInsert addObject:indexPathToInsert];
    
    cellNumber=17;
    [_setTablevewi beginUpdates];
    
    [_setTablevewi insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationLeft];
    [_setTablevewi endUpdates];
    
}

//pickerView消失；

- (void)deleteRow:(NSIndexPath *)RowtoDelete
{
    ShowPicker=NO;
    NSMutableArray* rowToDelete = [[NSMutableArray alloc] init];
    NSIndexPath* indexPathToDelete = [NSIndexPath indexPathForRow:ShowIndex.row inSection:ShowIndex.section];
    [rowToDelete addObject:indexPathToDelete];
    cellNumber=16;
    ShowIndex = nil;;
    [_setTablevewi beginUpdates];
    [_setTablevewi deleteRowsAtIndexPaths:rowToDelete withRowAnimation:UITableViewRowAnimationRight];
    [_setTablevewi endUpdates];
    
}

#pragma mark - ssss
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([Tool getAutoPlaying]) {
        
        ToastViewMessage(@"请先切换到手动模式");
        
        return NO;
    }
    
    NSInteger tag = textField.tag;
    
    selectTxt.select = textField;
    selectTxt.tag = tag;
    switch (tag) {
        case 101:
            sectionName=[[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
            break;
        case 102:
        case 103:
        case 104:
        case 105:
        case 106:
        case 107:
            sectionName=[[NSMutableArray alloc] initWithObjects:@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"00:00", nil];
            break;
        case 10200:
        case 10300:
        case 10400:
        case 10500:
        case 10600:
        case 10700:
            sectionName=[[NSMutableArray alloc] initWithObjects:@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",@"60", nil];
            break;
        case 109:
        case 110:
            sectionName=[[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
            break;
        default:
            break;
    }
    if (tag > 200) {
        tag = tag/100 - 100;
    }else{
        tag = tag - 100;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];

    
    if (!ShowPicker) {
        [self insertRow:indexPath];
    }
    else if(ShowPicker&&([[NSIndexPath indexPathForRow:(ShowIndex.row-1) inSection:0] isEqual:indexPath])){
        
        [self deleteRow:indexPath];
        
    }
    else if ([ShowIndex isEqual:indexPath]&&ShowPicker){
        NSLog(@"点击picker");
    }
    else if(ShowIndex&&![[NSIndexPath indexPathForRow:(ShowIndex.row-1) inSection:0] isEqual:indexPath]){
        
        [self deleteRow:indexPath];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}


#pragma mark MyPickerViewDelegate

- (void)pickerView:(MyPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSLog(@"title:%@",[sectionName objectAtIndex:row]);
    selectTxt.select.text = [sectionName objectAtIndex:row];
    NSString *str = [sectionName objectAtIndex:row];
    
    switch (selectTxt.tag) {
        case 101:
            [Tool setMeiTianCishu:str];
            break;
        case 102:
            [Tool setdiyici:str];
            break;
        case 10200:
            [Tool setdiyiciChang:str];
            break;
        case 103:
            [Tool setdierci:str];
            break;
        case 10300:
            [Tool setdierciChang:str];
            break;
        case 104:
            [Tool setdisanci:str];
            break;
        case 10400:
            [Tool setdisanciChang:str];
            break;
        case 105:
            [Tool setdisici:str];
            break;
        case 10500:
            [Tool setdisiciChang:str];
            break;
        case 106:
            [Tool setdiwuci:str];
            break;
        case 10600:
            [Tool setdiwuciChang:str];
            break;
        case 107:
            [Tool setdiliuci:str];
            break;
        case 10700:
            [Tool setdiliuciChang:str];
            break;
        case 109:
            [Tool setxunhuan:str];
            break;
        case 110:
            [Tool setjiange:str];
            break;
        default:
            break;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(MyPickerView *)pickerView
{
    
    return 1;
}

- (NSInteger) pickerView:(MyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [sectionName count];
    
}

- (NSString *)pickerView:(MyPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [sectionName objectAtIndex:row];
}

@end
