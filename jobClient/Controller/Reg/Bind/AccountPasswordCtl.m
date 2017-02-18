//
//  SysTemSetCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "AccountPasswordCtl.h"
#import "AccountPasswordCtl_Cell.h"
#import "SafeVarifyCtl.h"
#import "ResetPwdCtl.h"


@interface AccountPasswordCtl ()
{
    NSArray *_dataArr;
}
@end

@implementation AccountPasswordCtl


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        bHeaderEgo_ = NO;
        bFooterEgo_ = NO;
        NSArray *section1 = @[
            [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"phone", @"title":@"手机号", @"value":@"136*****0747" , @"show":@""}],
            [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"email", @"title":@"邮箱", @"value":@"mis****@163.com",  @"show":@""}],
            ];
        NSArray *section = @[
                             [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"password", @"title":@"帐号密码", @"value":@"绑定邮箱或手机号后方可设置" , @"show":@""}]
                             ];
   
        NSArray *section2 = @[
        [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"wechat", @"title":@"微信", @"value":@"0" }],
        [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"qq", @"title":@"腾讯QQ", @"value":@"0"}],
        [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"weibo", @"title":@"新浪微博", @"value":@"0"}]
        ];
        NSArray *data = @[section1, section, section2];
        _dataArr = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"帐号和密码";
    [self setNavTitle:@"帐号和密码"];
    tableView_.sectionFooterHeight = 1.0;
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"帐号和密码";
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
    if (![Manager shareMgr].haveLogin) {//未登录，不请求
        return;
    }
    //查询绑定状态
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&", [Manager getUserInfo].userId_ ? [Manager getUserInfo].userId_:@""];
    [ELRequest postbodyMsg:bodyMsg op:@"job1001user_person_bind_busi" func:@"getBindInfo" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSString *emailStatus = result[@"email"][@"status"];
        NSString *emailValue = @"未绑定";
        if ([emailStatus isEqualToString:@"OK"]) {
            emailValue = result[@"email"][@"status_info"][@"email"];
            
        }
        NSString *phoneStatus = result[@"mobile"][@"status"]; 
        NSString *phoneValue = @"未绑定";
        if ([phoneStatus isEqualToString:@"OK"]) {
            phoneValue = result[@"mobile"][@"status_info"][@"shouji"];
        }

        NSString *qqStatus = result[@"qq"][@"status"];
        NSString *qqValue = @"未绑定";
        if ([qqStatus isEqualToString:@"OK"]) {
            qqValue = result[@"qq"][@"status_info"][@"qq"];
        }
        
        NSString *wechatStatus = result[@"wechat"][@"status"];
        NSString *wechatValue = @"未绑定";
        if ([wechatStatus isEqualToString:@"OK"]) {
            wechatValue = result[@"wechat"][@"status_info"][@"wechat"];
        }
        
        NSString *weiboStatus = result[@"sina_weibo"][@"status"];
        NSString *weiboValue = @"未绑定";
        if ([weiboStatus isEqualToString:@"OK"]) {
            weiboValue = result[@"sina_weibo"][@"status_info"][@"sina_weibo"];
        }
       
        for (NSArray *arr in _dataArr)
        {
            for (NSMutableDictionary *dic in arr)
            {
                NSString *type = dic[@"type"];
                if ([type isEqualToString:@"email"])
                {
                    dic[@"value"] = emailValue;
                    if ([emailValue isEqualToString:@"未绑定"]) {
                        dic[@"show"] = emailValue;
                        
                    }else{
                        NSRange range = [emailValue rangeOfString:@"@"];
                        dic[@"show"] = [NSString stringWithFormat:@"%@****%@", [emailValue substringToIndex:3], [emailValue substringFromIndex:range.location]];
                    }
                }
                else if ([type isEqualToString:@"phone"]) {
                    dic[@"value"] = phoneValue;
                    if ([phoneValue isEqualToString:@"未绑定"]) {
                        dic[@"show"] = phoneValue;
                    }else{
                        dic[@"show"] = [NSString stringWithFormat:@"%@****%@", [phoneValue substringToIndex:3], [phoneValue substringFromIndex:7]];
                    }
                    
                }else if ([type isEqualToString:@"wechat"]) {
                    dic[@"value"] = wechatValue;
                    dic[@"show"] = wechatValue;
                }else if ([type isEqualToString:@"qq"]) {
                    dic[@"value"] = qqValue;
                    dic[@"show"] = qqValue;
                }else if ([type isEqualToString:@"weibo"]) {
                    dic[@"value"] = weiboValue;
                    dic[@"show"] = weiboValue;
                }
                else if ([type isEqualToString:@"password"]) {
//                    if ([phoneValue isEqualToString:@"未绑定"]) {
//                        dic[@"value"] = @"";
//                        dic[@"show"] = @"绑定手机或邮箱后方可设置";
//                    }else
                    if(![phoneValue isEqualToString:@"未绑定"]){
                        dic[@"value"] = phoneValue;
                        dic[@"show"] = @"";
                    }else if (![emailValue isEqualToString:@"未绑定"]){
                        dic[@"value"] = emailValue;
                        dic[@"show"] = @"";
                    }
                }
            }
        }
        [tableView_ reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)btnResponse:(id)sender
{
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = _dataArr[section];
    if ([array count] != 0) {
        return [array count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [sectionView setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AccountPasswordCtl_Cell";
    AccountPasswordCtl_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountPasswordCtl_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.valueSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
        [cell.valueSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    cell.valueSwitch.tag = indexPath.row;
    NSArray *sectionArr = _dataArr[indexPath.section];
    NSDictionary *dataDic = sectionArr[indexPath.row];
    cell.titleLb.text = dataDic[@"title"];
    cell.valueLb.text = dataDic[@"show"];
    
    if (indexPath.row == sectionArr.count - 1) {
        cell.lineView.hidden = YES;
    }
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        cell.valueSwitch.hidden = YES;
    }
    else if (indexPath.section == 2)
    {
        cell.valueLb.hidden = YES;
        cell.arrowImgv.hidden = YES;
        cell.valueSwitch.hidden = NO;
        if ([dataDic[@"value"] isEqualToString:@"未绑定"]) {
            [cell.valueSwitch setOn:NO];
        }else{
            [cell.valueSwitch setOn:YES];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0: //
        {
            if (![Manager shareMgr].haveLogin) {
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            }
            else
            {
                NSArray *sectionArr = _dataArr[indexPath.section];
                NSDictionary *dic = sectionArr[indexPath.row];
                
                if ([dic[@"type"] isEqualToString:@"email"])
                {//邮箱
                    NSArray *section1 = _dataArr[0];
                    NSDictionary *emailDic = section1[1];
                    NSString *emailValue = emailDic[@"value"];
                    
                    if ([emailValue isEqualToString:@"未绑定"])
                    {
                        BindCtl *bindCtl = [[BindCtl alloc]init];
                        bindCtl.varifyType = VarifyTypeBindEmail;
                        [self.navigationController pushViewController:bindCtl animated:YES];
                    }
                    else{
                        SafeVarifyCtl *safeVarifyCtl = [[SafeVarifyCtl alloc] initWithNibName:@"SafeVarifyEmailCtl" bundle:[NSBundle mainBundle]];
                        safeVarifyCtl.varifyType = VarifyTypeUpdateEmail;//修改绑定的邮箱
                        safeVarifyCtl.title = @"安全验证";
                        safeVarifyCtl.email = emailValue;
                        [self.navigationController pushViewController:safeVarifyCtl animated:YES];
                    }
                }
                else if ([dic[@"type"] isEqualToString:@"phone"])
                {//手机
                    NSArray *section1 = _dataArr[0];
                    NSDictionary *phoneDic = section1[0];
                    NSString *phoneValue = phoneDic[@"value"];
                    
                    if ([phoneValue isEqualToString:@"未绑定"]) {
                        BindCtl *bindCtl = [[BindCtl alloc]init];
                        bindCtl.varifyType = VarifyTypeBindPhone;
                        [self.navigationController pushViewController:bindCtl animated:YES];
                    }
                    else{
                        SafeVarifyCtl *safeVarifyCtl = [[SafeVarifyCtl alloc] initWithNibName:@"SafeVarifyPhoneCtl" bundle:[NSBundle mainBundle]];
                        safeVarifyCtl.varifyType = VarifyTypeUpdatePhone;//修改绑定的手机号
                        safeVarifyCtl.title = @"安全验证";
                        safeVarifyCtl.phone = phoneValue;
                        [self.navigationController pushViewController:safeVarifyCtl animated:YES];
                    }
                    
                }
            }
        }
            break;
        case 1:
        {
            NSArray *sectionArr = _dataArr[indexPath.section];
            NSDictionary *dic = sectionArr[indexPath.row];
            
            if ([dic[@"type"] isEqualToString:@"password"])
            {//账号密码
                @try {
                    NSArray *section1 = _dataArr[1];
                    NSDictionary *phoneDic = section1[0];
                    NSString *phoneValue = phoneDic[@"value"];
                    
                    if ([Manager shareMgr].isThridLogin_) {//第三方登录
                        
                        if ([phoneValue isEqualToString:@""])
                        {
                            [BaseUIViewController showAutoDismissFailView:nil msg:@"绑定手机或邮箱方可设置"];
                            return;
                        }
                        else{//手机已绑定验证
                            SafeVarifyCtl *safeCtl = [[SafeVarifyCtl alloc] initWithNibName:@"SafeVarifyUpdatePwd" bundle:[NSBundle mainBundle]];
                            
                            safeCtl.varifyType = VarifyTypeUpdatePwdVarifyPhone;
                            safeCtl.phone = phoneValue;
                            [self.navigationController pushViewController:safeCtl animated:YES];
                        }
                    }
                    else
                    {
                        //修改密码
                        ResetPwdCtl *resetPwdCtl_ = [[ResetPwdCtl alloc] init];
                        [self.navigationController pushViewController:resetPwdCtl_ animated:YES];
                    }
                    
                    return;
                }
                @catch (NSException *exception) {
                    
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -
- (void)switchAction:(UISwitch *)sender
{
    BOOL isOn = sender.isOn;
    NSInteger tag = sender.tag;
    NSArray *sectionArr = _dataArr[2];
    NSDictionary *dic = sectionArr[tag];
    if ([dic[@"type"] isEqualToString:@"wechat"]) {
        if (isOn) {
            
        }else{
            
        }
    }else if ([dic[@"type"] isEqualToString:@"qq"]) {
        if (isOn) {
            
        }else{
            
        }
    }else if ([dic[@"type"] isEqualToString:@"weibo"]) {
        if (isOn) {
            
        }else{
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
