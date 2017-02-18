//
//  ELCreatChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/8/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELCreatChangeCtl.h"
#import "GroupPermission_DataModal.h"
#import "ChooseMemberCtl.h"
#import "ELLineView.h"

@interface ELCreatChangeCtl () <ChangeTypeDelegate,ChooseMemberOKDelegate>
{
    NSMutableArray *dataArr;  //存放列表数据的数组
    NSIndexPath *selectIndexPath; //点击cell的下标
    NSMutableArray *selectPeopleArr;
}
@end

@implementation ELCreatChangeCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        bHeaderEgo_ = NO;
        bFooterEgo_ = NO;
        rightNavBarStr_ = @"确定";
//        rightNavBarRightWidth = @"16";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatData];
    
    if (!_selectModel && dataArr.count > 0) {
        _selectModel = dataArr[0];
    }
    [tableView_ reloadData];
    
    //tableView顶部多出的15个高度
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,15)];
    view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    tableView_.tableHeaderView = view;
    
    //tableView_.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma 根据传入的类型来生成列表数据
-(void)creatData{
    dataArr = [[NSMutableArray alloc] init];
    switch (_dataType) {
        case AllType:
        {        
            NSArray *arr = @[kJoinTypeName,kPublishTypeName,kInviteTypeName,kCanSeeTypeName];
//            self.navigationItem.title = @"社群权限设置";
            [self setNavTitle:@"社群权限设置"];
            for (NSString *name in arr) {
                ELGroupChangeTypeModel *model = [[ELGroupChangeTypeModel alloc] init];
                model.status = name;
                [dataArr addObject:model];
            }
            __weak ELCreatChangeCtl *onwCtl = self;
            [ELRequest postbodyMsg:[NSString stringWithFormat:@"group_id=%@",_groupId] op:@"groups" func:@"busi_getGroupPermission" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
                NSDictionary *dic = result;
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    _groupPermissionModel = [[GroupPermission_DataModal alloc] initWithDictionary:dic];  
                    [onwCtl getStatusWithModel:_groupPermissionModel];
                }
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                
            }];
        }
            break;
        case JoinType:
        { 
            NSArray *arr = @[kJoinTypeAll,kJoinTypeApply,kJoinTypeInvite];
//            self.navigationItem.title = @"加群验证";
            [self setNavTitle:@"加群验证"];
            for (NSString *name in arr) {
                ELGroupChangeTypeModel *model = [[ELGroupChangeTypeModel alloc] init];
                model.status = name;
                if ([name isEqualToString:kJoinTypeAll]) {
                    model.detailStatus = @"100";
                }else if ([name isEqualToString:kJoinTypeApply]) {
                    model.detailStatus = @"1";
                }else if ([name isEqualToString:kJoinTypeInvite]) {
                    model.detailStatus = @"3";
                }
                [dataArr addObject:model];
            }
        }
            break;
        case PublishArticleType:
        {
            NSArray *arr = @[kPublishTypeOwn,kPublishTypeSpecific,kPublishTypeAll];
//            self.navigationItem.title = @"话题发表";
            [self setNavTitle:@"话题发表"];
            for (NSString *name in arr) {
                ELGroupChangeTypeModel *model = [[ELGroupChangeTypeModel alloc] init];
                model.status = name;
                if ([name isEqualToString:kPublishTypeAll]) {
                    model.detailStatus = @"100";
                }else if ([name isEqualToString:kPublishTypeOwn]) {
                    model.detailStatus = @"1";
                }else if ([name isEqualToString:kPublishTypeSpecific]) {
                    model.detailStatus = @"3";
                }
                [dataArr addObject:model];
            }
        }
            break;
        case InviteType:
        {
            NSArray *arr = @[kInviteTypeOwn,kInviteTypeSpecific,kInviteTypeAll];
//            self.navigationItem.title = @"成员邀请";
            [self setNavTitle:@"成员邀请"];
            for (NSString *name in arr) {
                ELGroupChangeTypeModel *model = [[ELGroupChangeTypeModel alloc] init];
                model.status = name;
                if ([name isEqualToString:kInviteTypeAll]) {
                    model.detailStatus = @"100";
                }else if ([name isEqualToString:kInviteTypeOwn]) {
                    model.detailStatus = @"1";
                }else if ([name isEqualToString:kInviteTypeSpecific]) {
                    model.detailStatus = @"3";
                }
                [dataArr addObject:model];
            }
        }
            break;
        case CanSeeType:
        {
            NSArray *arr = @[kCanSeeTypeAll,kCanSeeTypeLogin,kCanSeeTypeGroup];
//            self.navigationItem.title = @"谁可浏览";
            [self setNavTitle:@"谁可浏览"];
            for (NSString *name in arr) {
                ELGroupChangeTypeModel *model = [[ELGroupChangeTypeModel alloc] init];
                model.status = name;
                if ([name isEqualToString:kCanSeeTypeAll]) {
                    model.detailStatus = @"300";
                }else if ([name isEqualToString:kCanSeeTypeLogin]) {
                    model.detailStatus = @"200";
                }else if ([name isEqualToString:kCanSeeTypeGroup]) {
                    model.detailStatus = @"100";
                }
                [dataArr addObject:model];
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 通过接口返回的社群权限相关数据的值匹配对应的名字
-(void)getStatusWithModel:(GroupPermission_DataModal *)groupPermissionModel{
    for (ELGroupChangeTypeModel *model in dataArr){
        if ([model.status isEqualToString:kJoinTypeName]) {
            if ([groupPermissionModel.group_open_status isEqualToString:@"1"]) {
                model.detailStatus = kJoinTypeApply;
            }else if ([groupPermissionModel.group_open_status isEqualToString:@"3"]){
                model.detailStatus = kJoinTypeInvite;
            }else if ([groupPermissionModel.group_open_status isEqualToString:@"100"]){
                model.detailStatus = kJoinTypeAll;
            }
        }else if ([model.status isEqualToString:kPublishTypeName]) {
            if ([groupPermissionModel.gs_topic_publish isEqualToString:@"1"]) {
                model.detailStatus = kPublishTypeOwn;
            }else if ([groupPermissionModel.gs_topic_publish isEqualToString:@"3"]){
                model.detailStatus = kPublishTypeSpecific;
            }else if ([groupPermissionModel.gs_topic_publish isEqualToString:@"100"]){
                model.detailStatus = kPublishTypeAll;
            }
        }else if ([model.status isEqualToString:kInviteTypeName]) {
            if ([groupPermissionModel.gs_member_invite isEqualToString:@"1"]) {
                model.detailStatus = kInviteTypeOwn;
            }else if ([groupPermissionModel.gs_member_invite isEqualToString:@"3"]){
                model.detailStatus = kInviteTypeSpecific;
            }else if ([groupPermissionModel.gs_member_invite isEqualToString:@"100"]){
                model.detailStatus = kInviteTypeAll;
            }
        }else if ([model.status isEqualToString:kCanSeeTypeName]) {
            if ([groupPermissionModel.gs_view_content isEqualToString:@"100"]) {
                model.detailStatus = kCanSeeTypeGroup;
            }else if ([groupPermissionModel.gs_view_content isEqualToString:@"200"]){
                model.detailStatus = kCanSeeTypeLogin;
            }else if ([groupPermissionModel.gs_view_content isEqualToString:@"300"]){
                model.detailStatus = kCanSeeTypeAll;
            }
        }
    }
    [tableView_ reloadData];
}

#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cellOne";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageRight = [[UIImageView alloc] init];
        imageRight.tag = 1002;
        [cell.contentView addSubview:imageRight];
        if (_dataType == AllType) {
            imageRight.frame = CGRectMake(ScreenWidth-23,17,8,13);
            imageRight.image = [UIImage imageNamed:@"right_jiantou_image"];
            
            UILabel *lableOne = [[UILabel alloc] initWithFrame:CGRectMake(16,15,CGRectGetMidX(imageRight.frame)-26,18)];
            lableOne.font = [UIFont systemFontOfSize:14];
            lableOne.textAlignment = NSTextAlignmentRight;
            lableOne.textColor = UIColorFromRGB(0x757575);
            lableOne.tag = 500;
            [cell.contentView addSubview:lableOne];
        }else{
            imageRight.frame = CGRectMake(ScreenWidth-31,15,18,18);
            imageRight.image = [UIImage imageNamed:@"creat_group_select_image"];
        }
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(16,14,CGRectGetMidX(imageRight.frame)-26,20)];
        lable.font = [UIFont systemFontOfSize:16];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.textColor = UIColorFromRGB(0x212121);
        lable.tag = 400;
        [cell.contentView addSubview:lable];
        
        ELLineView *lineView = [[ELLineView alloc] initWithFrame:CGRectMake(16,47,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
        lineView.tag = 2000;
        [cell.contentView addSubview:lineView];
    }
    UILabel *lable = (UILabel *)[cell.contentView viewWithTag:400];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1002];
    UIView *lineView = [cell.contentView viewWithTag:2000];
    if (indexPath.row == dataArr.count-1) {
        lineView.hidden = YES;
    }else{
        lineView.hidden = NO;
    }
    
    ELGroupChangeTypeModel *dataModel = dataArr[indexPath.row];
    lable.text = dataModel.status;
    if (_dataType == AllType) {
        UILabel *detailLable = (UILabel *)[cell.contentView viewWithTag:500];
        detailLable.text = dataModel.detailStatus;
        imageView.hidden = NO;
    }else{
        if ([_selectModel.status isEqualToString:dataModel.status]) {
            imageView.hidden = NO;
        }else{
            imageView.hidden = YES;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectIndexPath = indexPath;
    ELGroupChangeTypeModel *dataModel = dataArr[indexPath.row];
    if (!_isFromGroup) {
        if ([_typeDeleagte respondsToSelector:@selector(selectTypeWithName:)]){
            [_typeDeleagte selectTypeWithName:dataModel];
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    switch (_dataType) {
        case AllType:
        {
            if (!_groupPermissionModel) {
                return;
            }
            ELCreatChangeCtl *changeCtl = [[ELCreatChangeCtl alloc] init];
            changeCtl.selectModel = [[ELGroupChangeTypeModel alloc] init];
            changeCtl.selectModel.status = dataModel.detailStatus;
            changeCtl.typeDeleagte = self;
            changeCtl.isFromGroup = YES;
            changeCtl.groupPermissionModel = _groupPermissionModel;
            changeCtl.groupId = _groupId;
            if ([dataModel.status isEqualToString:kJoinTypeName]) {
                changeCtl.dataType = JoinType;
                changeCtl.selectModel.detailStatus = _groupPermissionModel.group_open_status;
            }else if ([dataModel.status isEqualToString:kPublishTypeName]){
                changeCtl.dataType = PublishArticleType;
                changeCtl.selectModel.detailStatus = _groupPermissionModel.gs_topic_publish;
            }else if ([dataModel.status isEqualToString:kInviteTypeName]){
                changeCtl.dataType = InviteType;
                changeCtl.selectModel.detailStatus = _groupPermissionModel.gs_member_invite;
            }else if ([dataModel.status isEqualToString:kCanSeeTypeName]){
                changeCtl.dataType = CanSeeType;
                changeCtl.selectModel.detailStatus = _groupPermissionModel.gs_view_content;
            }
            [self.navigationController pushViewController:changeCtl animated:YES];
        }
            break;
        case JoinType:
        {
            _selectModel = dataModel;
            [tableView_ reloadData];
        }
            break;
        case PublishArticleType:
        {
            if ([dataModel.status isEqualToString:kPublishTypeSpecific]){
                ChooseMemberCtl *chooseMemberCtl = [[ChooseMemberCtl alloc] init];
                chooseMemberCtl.type_ = Publish_Type;
                chooseMemberCtl.groupPermissionModel = _groupPermissionModel;
                chooseMemberCtl.delegate_ = self;
                [self.navigationController pushViewController:chooseMemberCtl animated:YES];
                NSMutableArray *arr = _groupPermissionModel._topic_publish_list;
                if (selectPeopleArr) {
                    arr = selectPeopleArr;
                }
                [chooseMemberCtl beginLoad:_groupId exParam:arr];
            }else{
                _selectModel = dataModel;
                [tableView_ reloadData];
            }
        }
            break;
        case InviteType:
        {
            if ([dataModel.status isEqualToString:kInviteTypeSpecific]){
                ChooseMemberCtl *chooseMemberCtl = [[ChooseMemberCtl alloc] init];
                chooseMemberCtl.type_ = Invite_Type;
                chooseMemberCtl.groupPermissionModel = _groupPermissionModel;
                chooseMemberCtl.delegate_ = self;
                [self.navigationController pushViewController:chooseMemberCtl animated:YES];
                NSMutableArray *arr = _groupPermissionModel._member_invite_list;
                if (selectPeopleArr) {
                    arr = selectPeopleArr;
                }
                [chooseMemberCtl beginLoad:_groupId exParam:arr];
            }else{
                _selectModel = dataModel;
                [tableView_ reloadData];
            }
        }
            break;
        case CanSeeType:
        {
            _selectModel = dataModel;
            [tableView_ reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 调用接口修改社群相关权限
/*
    接口相关字段介绍：
    group_open_status（加群验证）
    传值：@"1"(申请加入),@"3"(受邀加入),@"100"(允许所有人加入)
    gs_topic_publish（话题发表）
    传值：@"1"(仅自己),@"3"(特定成员),@"100"(所有人)
    gs_member_invite（成员邀请）
    传值：@"1"(仅自己),@"3"(特定成员),@"100"(所有人)
    gs_view_content（谁可浏览）
    传值：@"100"(社群成员),@"200"(登录后),@"300"(所有人)
 */
-(void)saveDataWithModel:(ELGroupChangeTypeModel *)dataModel{
    
    NSMutableDictionary * setDic = [[NSMutableDictionary alloc] init];
    if (!dataModel.detailStatus || [dataModel.detailStatus isEqualToString:@""]) {
        return;
    }
    switch (_dataType) {
        case JoinType:
        {
            [setDic setNewValue:dataModel.detailStatus forKey:@"group_open_status"];
            [setDic setNewValue:_groupPermissionModel.gs_topic_publish forKey:@"gs_topic_publish"];
            [setDic setNewValue:_groupPermissionModel.gs_member_invite forKey:@"gs_member_invite"];
            [setDic setNewValue:_groupPermissionModel.gs_view_content forKey:@"gs_view_content"];
        }
            break;
        case PublishArticleType:
        {
            [setDic setNewValue:dataModel.detailStatus forKey:@"gs_topic_publish"];
            [setDic setNewValue:_groupPermissionModel.group_open_status forKey:@"group_open_status"];
            [setDic setNewValue:_groupPermissionModel.gs_member_invite forKey:@"gs_member_invite"];
            [setDic setNewValue:_groupPermissionModel.gs_view_content forKey:@"gs_view_content"];
            if ([dataModel.detailStatus isEqualToString:@"3"]) {
                if (dataModel.publishArr) {
                    [setDic setNewValue:dataModel.publishArr forKey:@"topic_publish"];
                }
            }
        }
            break;
        case InviteType:
        {
            [setDic setNewValue:dataModel.detailStatus forKey:@"gs_member_invite"];
            [setDic setNewValue:_groupPermissionModel.group_open_status forKey:@"group_open_status"];
            [setDic setNewValue:_groupPermissionModel.gs_topic_publish forKey:@"gs_topic_publish"];
            [setDic setNewValue:_groupPermissionModel.gs_view_content forKey:@"gs_view_content"];
            if ([dataModel.detailStatus isEqualToString:@"3"]) {
                if (dataModel.inviteArr) {
                    [setDic setNewValue:dataModel.inviteArr forKey:@"member_invite"];
                }
            }
        }
            break;
        case CanSeeType:
        {
            [setDic setNewValue:dataModel.detailStatus forKey:@"gs_view_content"];
            [setDic setNewValue:_groupPermissionModel.group_open_status forKey:@"group_open_status"];
            [setDic setNewValue:_groupPermissionModel.gs_topic_publish forKey:@"gs_topic_publish"];
            [setDic setNewValue:_groupPermissionModel.gs_member_invite forKey:@"gs_member_invite"];
        }
            break;
        default:
            break;
    }

    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:setDic];
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&person_id=%@&settingArr=%@",_groupId,[Manager getUserInfo].userId_,conditionStr];
    NSString * function = @"busi_settingGroupStatusAndPermission";
    NSString * op = @"groups";
    [BaseUIViewController showLoadView:YES content:@"正在修改" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result){
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]){
            NSString *status = [dic objectForKey:@"status"];
            NSString *desc = [dic objectForKey:@"status_desc"];
            if ([status isEqualToString:@"OK"]) {
                if (!desc || [desc isEqualToString:@""]) {
                    desc = @"修改成功";
                }
                if ([_typeDeleagte respondsToSelector:@selector(selectTypeWithName:)]){
                    [_typeDeleagte selectTypeWithName:dataModel];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                if (!desc || [desc isEqualToString:@""]) {
                    desc = @"出错了，请稍后再试";
                }
            }
            [BaseUIViewController showAlertViewContent:desc toView:self.view second:1.0 animated:YES];
        }else{
            [BaseUIViewController showAlertViewContent:@"出错了，请稍后再试" toView:self.view second:1.0 animated:YES];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        [BaseUIViewController showAlertViewContent:@"出错了，请稍后再试" toView:self.view second:1.0 animated:YES];
    }];
}

#pragma mark - ChangeTypeDelegate修改社群权限成功的代理方法
-(void)selectTypeWithName:(ELGroupChangeTypeModel *)dataModel{
    switch (_dataType) {
        case AllType:
        {
            ELGroupChangeTypeModel *model = dataArr[selectIndexPath.row];
            model.detailStatus = dataModel.status;
            if ([dataModel.status isEqualToString:kPublishTypeAll] || [dataModel.status isEqualToString:kPublishTypeOwn] || [dataModel.status isEqualToString:kPublishTypeSpecific]) {
                if ([dataModel.status isEqualToString:kPublishTypeSpecific]) {
                    _groupPermissionModel._topic_publish_list = [[NSMutableArray alloc] initWithArray:dataModel.publishArr];
                }else{
                    _groupPermissionModel._topic_publish_list = nil;
                }
                _groupPermissionModel.gs_topic_publish = dataModel.detailStatus;
            }else if ([dataModel.status isEqualToString:kJoinTypeAll] || [dataModel.status isEqualToString:kJoinTypeApply] || [dataModel.status isEqualToString:kJoinTypeInvite]) {
                _groupPermissionModel.group_open_status = dataModel.detailStatus;
            }else if ([dataModel.status isEqualToString:kInviteTypeAll] || [dataModel.status isEqualToString:kInviteTypeOwn] || [dataModel.status isEqualToString:kInviteTypeSpecific]) {
                if ([dataModel.status isEqualToString:kInviteTypeSpecific]){
                    _groupPermissionModel._member_invite_list = [[NSMutableArray alloc] initWithArray:dataModel.inviteArr];
                }else{
                    _groupPermissionModel._member_invite_list = nil;
                }
                _groupPermissionModel.gs_member_invite = dataModel.detailStatus;
            }else if ([dataModel.status isEqualToString:kCanSeeTypeAll] || [dataModel.status isEqualToString:kCanSeeTypeGroup] || [dataModel.status isEqualToString:kCanSeeTypeLogin]) {
                _groupPermissionModel.gs_view_content = dataModel.detailStatus;
            }
            [tableView_ reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ChooseMemberOKDelegate 选择特定成员成功的代理
-(void)chooseMember:(ChooseMemberCtl *)ctl memberArray:(NSMutableArray *)array type:(ChooseType)type{
    if (!array) {
        return;
    }
    if (array.count <= 0) {
        return;
    }
    ELGroupChangeTypeModel *model = dataArr[selectIndexPath.row];
    if (type == Invite_Type){
        model.inviteArr = [[NSMutableArray alloc] initWithArray:array];
    }else if (type == Publish_Type){
        model.publishArr = [[NSMutableArray alloc] initWithArray:array];
    }
    _selectModel = model;
    selectPeopleArr = [[NSMutableArray alloc] initWithArray:array];
    [tableView_ reloadData];
}

-(void)setRightBarBtnAtt{
    if (_dataType == AllType || !_isFromGroup){
        rightBarBtn_.hidden = YES;
    }else{
        rightBarBtn_.hidden = NO;
        [rightBarBtn_ setTitle:@"确定" forState:UIControlStateNormal];
        [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 31)];
        rightBarBtn_.titleLabel.font = [UIFont systemFontOfSize:15];
    }
}

-(void)rightBarBtnResponse:(id)sender{
    /*
        判断是否为修改社群权限，若是调用请求，否则调用代理返回
     */
    if(_isFromGroup){
        [self saveDataWithModel:_selectModel];
    }else{
        if ([_typeDeleagte respondsToSelector:@selector(selectTypeWithName:)]){
            [_typeDeleagte selectTypeWithName:_selectModel];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
