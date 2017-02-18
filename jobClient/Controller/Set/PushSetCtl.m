
//  PushSetCtl.m
//  Association
//
//  Created by 一览iOS on 14-5-10.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "PushSetCtl.h"
#import "MyDataBase.h"
#import "PushSetDateModel.h"
#import "DBTools.h"
#import "Status_DataModal.h"


@implementation PushSetCtl
{
    NSArray *_titleArr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        setCount_ = 0;
        totalFlag_ = NO;
    }
    return self;
}

//200  202  201  251  //社群消息
//190 250  //新的发表
//180      //新的回答
//181      //新的提问

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"消息提醒";
    [self setNavTitle:@"消息提醒"];
    pushSwitch_.on = YES;
    pushTableView_.dataSource = self;
    pushTableView_.delegate = self;
    pushTableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if(version >= 7.0){
        [topView_ setFrame:CGRectMake(0, 20, 320, 52)];
    }
    
    _titleArr = [[NSArray alloc] initWithObjects:@"社群消息", @"新的发表", @"新的问题", @"新的回答", nil];
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (!db_) {
        db_ = [[DBTools alloc]init];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pushDefault = [defaults objectForKey:@"PUSHSQLSET"];
    if (![pushDefault isEqualToString:@"firstLogin"]) {
       [defaults setObject:@"firstLogin" forKey:@"PUSHSQLSET"];
        [db_ deleteTable];
    }else{
        [db_ createTable];
    }
    dateArr_ = [db_ inquire:[Manager getUserInfo].userId_];
    
    if ([dateArr_ count] != 0) {
        PushSetDateModel *model = [dateArr_ lastObject];
        if([model.stutas_ isEqualToString:@"1"]){
            [pushSwitch_ setOn:YES];
            [pushTableView_ setHidden:NO];
        }else{
            [pushSwitch_ setOn:NO];
            [pushTableView_ setHidden:YES];
        }
    }
}

/*
-(void)closeTotalSwitch:(NSInteger)setCont
{
    if (setCount_ < 1) {
        [pushTableView_ setHidden:YES];
        [db_ updateTable:[Manager getUserInfo].userId_ type:@"totalset" stutas:@"0"];
        [pushSwitch_ setOn:NO];
    }
}
*/
-(void)getDataFunction:(RequestCon *)con
{

    RequestCon  *con_ = [self getNewRequestCon:NO];
    if (pushSwitch_.isOn == NO) {
        return;
    }
    [con_ getPushSetMessage:[Manager getUserInfo].userId_];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
   
    
    Status_DataModal *model;
    
    switch (type) {
        case Request_GetPushSetMessage:
            //插入本地数据库
            NSLog(@"======获取服务器推送配置=========1");
            if ([dateArr_ count] == 0) {
                for (int i=0;i<6;i++) {
                    NSLog(@"======初始化本地数据库========2");
                    switch (i) {
                        case 0:
                            [db_ insertTable:@"200" stutas:@"1" userId:[Manager getUserInfo].userId_]; //社群推送
                            break;
                        case 1:
                            [db_ insertTable:@"190" stutas:@"1" userId:[Manager getUserInfo].userId_];//新的发表
                            break;
                        case 2:
                            [db_ insertTable:@"181" stutas:@"1" userId:[Manager getUserInfo].userId_]; //新的问题
                            break;
                        case 3:
                            [db_ insertTable:@"180" stutas:@"1" userId:[Manager getUserInfo].userId_];  //新的回答
                            break;
                        case 4:
                            [db_ insertTable:@"515" stutas:@"1" userId:[Manager getUserInfo].userId_]; //薪闻推送
                            break;
                        case 5:
                            [db_ insertTable:@"totalset" stutas:@"1" userId:[Manager getUserInfo].userId_];
                            break;
                        default:
                            break;
                    }
                    
                }
                
                for (PushSetDateModel *model in dataArr) {
                    if ([model.type_ isEqualToString:@"190"]) {
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"190" stutas:model.stutas_];//新的发表
                    }else if([model.type_ isEqualToString:@"180"]){
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"180" stutas:model.stutas_];  //新的回答
                    }
                    else if([model.type_ isEqualToString:@"181"]){
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"181" stutas:model.stutas_]; //新的问题
                    }
                    else if([model.type_ isEqualToString:@"200"]){
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"200" stutas:model.stutas_]; //社群推送
                    }else if([model.type_ isEqualToString:@"515"]){
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"515" stutas:model.stutas_]; //薪闻推送
                    }
                }
                
                dateArr_ = [db_ inquire:[Manager getUserInfo].userId_];
                
                setCount_ = 0;
                for (PushSetDateModel *model in dateArr_) {
                    if ([model.stutas_ isEqualToString:@"1"] && ![model.type_ isEqualToString:@"totalset"]) {
                        setCount_ ++;
                        NSLog(@"setCount_ = %ld",(long)setCount_);
                    }
                }
                
                if (setCount_ == 0) {
                    [db_ updateTable:[Manager getUserInfo].userId_ type:@"totalset" stutas:@"0"];
                }else{
                    [db_ updateTable:[Manager getUserInfo].userId_ type:@"totalset" stutas:@"1"];
                    
                }
            }
            else{//更新本地数据库
                NSLog(@"======更新推送配置到本地数据库=========2");
                if (pushSwitch_.isOn == NO) {
                    dateArr_ = [db_ inquire:[Manager getUserInfo].userId_];
                    setCount_ = 0;
                    for (PushSetDateModel *model in dateArr_) {
                        if ([model.stutas_ isEqualToString:@"1"] && ![model.type_ isEqualToString:@"totalset"]) {
                            setCount_ ++;
                            NSLog(@"setCount_ = %ld",(long)setCount_);
                        }
                    }
                }
                else{
                    for (PushSetDateModel *model in dataArr) {
                        if ([model.type_ isEqualToString:@"190"]) {
                            [db_ updateTable:[Manager getUserInfo].userId_ type:@"190" stutas:model.stutas_];//新的发表
                        }else if([model.type_ isEqualToString:@"180"]){
                            [db_ updateTable:[Manager getUserInfo].userId_ type:@"180" stutas:model.stutas_];  //新的回答
                        }
                        else if([model.type_ isEqualToString:@"181"]){
                            [db_ updateTable:[Manager getUserInfo].userId_ type:@"181" stutas:model.stutas_]; //新的问题
                        }
                        else if([model.type_ isEqualToString:@"200"]){
                            [db_ updateTable:[Manager getUserInfo].userId_ type:@"200" stutas:model.stutas_]; //社群推送
                        }else if([model.type_ isEqualToString:@"515"]){
                            [db_ updateTable:[Manager getUserInfo].userId_ type:@"515" stutas:model.stutas_]; //薪闻推送
                        }
                    }
                    
                    dateArr_ = [db_ inquire:[Manager getUserInfo].userId_];
                    
                    setCount_ = 0;
                    for (PushSetDateModel *model in dateArr_) {
                        if ([model.stutas_ isEqualToString:@"1"] && ![model.type_ isEqualToString:@"totalset"]) {
                            setCount_ ++;
                            NSLog(@"setCount_ = %ld",(long)setCount_);
                        }
                    }
                    
                    if (setCount_ == 0) {
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"totalset" stutas:@"0"];
                    }else{
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"totalset" stutas:@"1"];
                        
                    }
                }
            }
            [pushTableView_ reloadData];
            break;
    case Request_UpdatePushSettings:
        //批量推送设置结果;
            model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
//                NSLog(@"======批量设置推送配置成功=========1");
//                if ([@"200,201,251,202" rangeOfString:model.des_].location != NSNotFound) {
//                    [db_ updateTable:[Manager getUserInfo].userId_ type:@"200" stutas:model.code_];
//                    NSLog(@"批量设置推送更新本地数据成功");
//                }
//                if ([model.des_ isEqualToString:@"190"]) {
//                    [db_ updateTable:[Manager getUserInfo].userId_ type:@"190" stutas:model.code_];
//                    NSLog(@"批量设置推送更新本地数据成功");
//                }
//                if (!totalFlag_) {
                    [BaseUIViewController showAutoDismissSucessView:@"设置成功" msg:nil seconds:0.25];
//                }
                /*
                if ([model.code_ isEqualToString:@"1"]) {
                    if ([model.des_ isEqualToString:@"190"]) {				//新的发表
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"190" stutas:model.code_];
                    }else if ([model.des_ isEqualToString:@"201"]) {		//社群消息
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"200" stutas:model.code_];
                    }else if ([model.des_ isEqualToString:@"181"]) {
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"181" stutas:model.code_];
                    }else if ([model.des_ isEqualToString:@"180"]) {
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"180" stutas:model.code_];
                    }else if([model.des_ isEqualToString:@"515"]){
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"515" stutas:model.code_]; //薪闻推送
                    }
                }
                else {
                    if ([model.des_ isEqualToString:@"190"]) {				//新的发表
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"190" stutas:model.code_];
                    }else if ([model.des_ isEqualToString:@"201"]) {		//社群消息
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"200" stutas:model.code_];
                    }else if ([model.des_ isEqualToString:@"181"]) {
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"181" stutas:model.code_];
                    }else if ([model.des_ isEqualToString:@"180"]) {
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"180" stutas:model.code_];
                    }else if([model.des_ isEqualToString:@"515"]){
                        [db_ updateTable:[Manager getUserInfo].userId_ type:@"515" stutas:model.code_]; //薪闻推送
                    }
                }
                 */
            }else{
                NSLog(@"======批量设置推送配置失败=========1");
                if (!totalFlag_) {
                    [BaseUIViewController showAutoDismissFailView:@"设置失败，请重新设置" msg:nil seconds:0.25];
                }
                UISwitch *cellSwitch = (UISwitch *)[self.view viewWithTag:cellSwitchTag_];
                if (cellSwitch.isOn == YES) {
                    [cellSwitch setOn:NO];
                }else{
                    [cellSwitch setOn:YES];
                }
            }
            dateArr_ = [db_ inquire:[Manager getUserInfo].userId_];
            [pushTableView_ reloadData];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark- UITableViewDelegate UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }else{
        return 4;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [sectionView setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    return sectionView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000000001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    

    PushCustomCell *cell = (PushCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PushCustomCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.pushCellSwitch_ addTarget:self action:@selector(cellSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    NSString * str;
    if (indexPath.section == 0) {
        str = [_titleArr objectAtIndex:indexPath.row];
        
        if (indexPath.row == _titleArr.count - 1) {
            [cell.lineView_ setHidden:YES];
        }
    }
    
    if (indexPath.section == 1) {
        str = @"每日精选";
    }
    
    cell.pushName_.text = str;
    
    if ([dateArr_ count] !=0) {
       
        if (indexPath.section == 0) {
            PushSetDateModel *model = [dateArr_ objectAtIndex:indexPath.row];
            NSString *type = model.type_;
            cell.pushCellSwitch_.tag = [model.type_ intValue];
            
            if ([type isEqualToString:@"200"]) {//社群消息
                if ([model.stutas_ isEqualToString:@"1"]) {
                    [cell.pushCellSwitch_ setOn:YES];
                }else{
                    [cell.pushCellSwitch_ setOn:NO];
                }
            }
            else if ([type isEqualToString:@"190"]){//新的发表
                if ([model.stutas_ isEqualToString:@"1"]) {
                    [cell.pushCellSwitch_ setOn:YES];
                }else{
                    [cell.pushCellSwitch_ setOn:NO];
                }
            }
            else if ([type isEqualToString:@"181"]) {
                if ([model.stutas_ isEqualToString:@"1"]) {
                    [cell.pushCellSwitch_ setOn:YES];
                }else{
                    [cell.pushCellSwitch_ setOn:NO];
                }
            }
            else if ([type isEqualToString:@"180"]){
                if ([model.stutas_ isEqualToString:@"1"]) {
                    [cell.pushCellSwitch_ setOn:YES];
                }else{
                    [cell.pushCellSwitch_ setOn:NO];
                }
            }
        }
        else if (indexPath.section == 1)
        {
            PushSetDateModel *model = [dateArr_ objectAtIndex:indexPath.row+4];
            cell.pushCellSwitch_.tag = [model.type_ intValue];
            NSString *type = model.type_;
            if ([type isEqualToString:@"515"]) {
                if ([model.stutas_ isEqualToString:@"1"]) {
                    [cell.pushCellSwitch_ setOn:YES];
                }else{
                    [cell.pushCellSwitch_ setOn:NO];
                }
            }
        }
    }
    return cell;
}

-(void)cellSwitchClick:(UISwitch *)cellSwitch
{
    cellSwitchTag_ = cellSwitch.tag;
    RequestCon *updataCon = [self getNewRequestCon:NO];
    totalFlag_ = NO;
    switch (cellSwitch.tag) {
        case 190://新的发表
            if (cellSwitch.isOn == NO) {
                setCount_ --;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:@"0" forKey:@"250"];
                [dic setObject:@"0" forKey:@"190"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"190" stutas:@"0"];
            }else{
                setCount_ ++;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:@"1" forKey:@"250"];
                [dic setObject:@"1" forKey:@"190"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"190" stutas:@"1"];
            }
            break;
        case 180://新的回答
            if (cellSwitch.isOn == NO) {
                setCount_ --;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:@"0" forKey:@"180"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"180" stutas:@"0"];
            }else{
                setCount_ ++;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:@"1" forKey:@"180"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"180" stutas:@"1"];
            }
            break;
        case 181://新的提问
            if (cellSwitch.isOn == NO) {
                setCount_ --;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:@"0" forKey:@"181"];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"181" stutas:@"0"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
            }else{
                setCount_ ++;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:@"1" forKey:@"181"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"181" stutas:@"1"];
            }
            break;
        case 200://社群消息
            if (cellSwitch.isOn == NO) {
                //200  202  201  251
                setCount_ --;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                
                [dic setObject:@"0" forKey:@"201"];
                [dic setObject:@"0" forKey:@"200"];
                [dic setObject:@"0" forKey:@"202"];
                [dic setObject:@"0" forKey:@"251"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"200" stutas:@"0"];
            }else{
                setCount_ ++;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                
                [dic setObject:@"1" forKey:@"201"];
                [dic setObject:@"1" forKey:@"200"];
                [dic setObject:@"1" forKey:@"202"];
                [dic setObject:@"1" forKey:@"251"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"200" stutas:@"1"];
            }
            break;
        case 515://每日精选
            if (cellSwitch.isOn == NO) {
                setCount_ --;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:@"0" forKey:@"515"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"515" stutas:@"0"];
            }else{
                setCount_ ++;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:@"1" forKey:@"515"];
                [updataCon updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
                [db_ updateTable:[Manager getUserInfo].userId_ type:@"515" stutas:@"1"];
            }
            break;
        default:
            break;
    }
     NSLog(@"self setCount_ = %ld",(long)setCount_);
//    [self closeTotalSwitch:setCount_];

}

-(void)btnResponse:(id)sender
{
    if (sender == pushSwitch_) {
        //消息总开关 关闭
        if (pushSwitch_.isOn == NO) {
            totalFlag_ = NO;
            [db_ updateTable:[Manager getUserInfo].userId_ type:@"totalset" stutas:@"0"];
            //关闭消息
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:@"0" forKey:@"200"];
            [dic setObject:@"0" forKey:@"201"];    //邀请
            [dic setObject:@"0" forKey:@"202"];    //申请
            [dic setObject:@"0" forKey:@"251"];
            [dic setObject:@"0" forKey:@"190"];
            [dic setObject:@"0" forKey:@"181"];
            [dic setObject:@"0" forKey:@"180"];
            [dic setObject:@"0" forKey:@"250"];
            [dic setObject:@"0" forKey:@"515"];
            RequestCon *updCon_= [self getNewRequestCon:NO];
            [updCon_ updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
            [pushTableView_ setHidden:YES];
        
        }
        else if (pushSwitch_.isOn == YES)
        {//消息总开关 打开
            totalFlag_ = YES;
            [db_ updateTable:[Manager getUserInfo].userId_ type:@"totalset" stutas:@"1"];
                        
            //关闭消息
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:@"1" forKey:@"200"];
            [dic setObject:@"1" forKey:@"201"];    //邀请
            [dic setObject:@"1" forKey:@"202"];    //申请
            [dic setObject:@"1" forKey:@"251"];
            [dic setObject:@"1" forKey:@"190"];
            [dic setObject:@"1" forKey:@"181"];
            [dic setObject:@"1" forKey:@"180"];
            [dic setObject:@"1" forKey:@"250"];
            [dic setObject:@"1" forKey:@"515"];
            RequestCon *updCon_= [self getNewRequestCon:NO];
            [updCon_ updatePushSettings:[Manager getUserInfo].userId_ settingArr:dic];
            [pushTableView_ setHidden:NO];
        }
    }
    
}

@end
