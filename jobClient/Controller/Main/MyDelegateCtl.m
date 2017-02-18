//
//  MyDelegateCtl.m
//  jobClient
//
//  Created by 一览ios on 15/11/18.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "MyDelegateCtl.h"
#import "Expert_DataModal.h"
#import "SameTradeCell.h"
#import "ResumePreviewController.h"
#import "ELSameTradePeopleFrameModel.h"
#import "MyDelegateModal.h"
#import "YLExpertListCtl.h"
#import "MyJobGuideCtl.h"

@interface MyDelegateCtl ()<UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    BOOL _shouldRefresh;
    NSIndexPath *_indexPath;
}
@end

@implementation MyDelegateCtl

- (void)viewDidLoad {
    self.showNoDataViewFlag = NO;
    [super viewDidLoad];
//    self.navigationItem.title = @"我的委托";
    [self setNavTitle:@"我的委托"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController setNavigationBarHidden:NO];
    
    _actionBtn.layer.cornerRadius = 4.0f;
    _actionBtn.layer.masksToBounds = YES;
    
    self.tableView.tableHeaderView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_shouldRefresh) {
        [self refreshLoad];
        _shouldRefresh = NO;
    }
//    self.navigationItem.title  = @"我的委托";
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
    if (_userType > 0) {
        if (_userType == UserTypeAgent) {//职业经纪人
            [self getMyDelegateList:YES];
        }else{
            [self getMyDelegateList:NO];
        }
        return;
    }
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&", [Manager getUserInfo].userId_];
    
    [ELRequest postbodyMsg:bodyMsg op:@"yl_es_person_busi" func:@"getPersonIdentity" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
    
        if ([result[@"is_broker"] isEqualToString:@"1"]) {//职业经纪人
            _userType = UserTypeAgent;
            [self getMyDelegateList:YES];
            self.tableView.tableHeaderView = nil;
        }else{
            _userType = UserTypeCommon;
            [self getMyDelegateList:NO];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        self.showNoDataViewFlag = YES;
        [self finishReloadingData];
        [self refreshEGORefreshView];
    }];
}


- (void)getMyDelegateList:(BOOL)isJobAgent
{
    NSString *userId = [Manager getUserInfo].userId_;
    NSString *func = nil;
    NSString *bodyMsg = nil;
    
    if (isJobAgent) {//受委托的普通用户
        func = @"getMyClientsList";
        bodyMsg = [NSString stringWithFormat:@"broker_id=%@&conditionArr=%@&", userId, [self getPageQueryStr:10]];
    }else {//委托的职业经纪人
        func = @"getMyBrokersList";
        bodyMsg = [NSString stringWithFormat:@"client_id=%@&conditionArr=%@&", userId, [self getPageQueryStr:10]];
    }
    
    [ELRequest postbodyMsg:bodyMsg op:@"broker_entrust_busi" func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {

        [self parserPageInfo:result];
        
        NSArray *arr = result[@"data"];
        @try {
            if (![arr isKindOfClass:[NSNull class]] && arr != nil) {
                if (_noDataView.superview) {
                    [_noDataView removeFromSuperview];
                }
                
                for ( NSDictionary *subDic in arr ) {
                    ELSameTradePeopleFrameModel *dataModel = [[ELSameTradePeopleFrameModel alloc] init];
                    ELSameTradePeopleModel *model = [[ELSameTradePeopleModel alloc] initWithDictionary:subDic];
                    dataModel.peopleModel = model;
                    [_dataArray addObject:dataModel];
                }
                
            }else{
                [self updateCom:nil];
            }
            
            [self.tableView reloadData];
            [self finishReloadingData];
            [self refreshEGORefreshView];
            
            self.tableView.tableHeaderView.hidden = NO;
            
        }@catch (NSException *exception) {
            
        }@finally {
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}

- (void)updateCom:(RequestCon *)con
{
    if (!_dataArray.count) {
        
        self.tableView.tableHeaderView = nil;
        //没有数据
        if (_noDataView.superview) {
            [_noDataView removeFromSuperview];
        }
        _noDataView.frame = CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height);
        [self.view addSubview:_noDataView];
        if (_userType == UserTypeAgent) {//职业经纪人
            _line1Lb.text = @"最近有点闲！";
            _line2Lb.text = @"暂时还没有需要委托的人才";
            [_actionBtn setTitle:@"去帮助他人，建立更多人脉" forState:UIControlStateNormal];
        }else if (_userType == UserTypeCommon){//普通用户
            _line1Lb.text = @"还没有委托的职业经纪人！";
            _line2Lb.text = @"你与梦想只有一位经纪人的距离";
            [_actionBtn setTitle:@"去选择我的专属职业经纪人" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELSameTradePeopleFrameModel *model = _dataArray[indexPath.row];
    static NSString *identifier = @"cell";
    SameTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SameTradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.showMessageButton = YES;
    cell.peopleModel = model;
    if(_userType == UserTypeAgent){
        cell.phototImgv_.userInteractionEnabled = YES;
    }else{
        cell.phototImgv_.userInteractionEnabled = NO;
    }
    cell.dynamicLb_.text = [MyCommon getWhoLikeMeListCurrentTime:[MyCommon getDate:model.peopleModel.idatetime] currentTimeString:model.peopleModel.idatetime];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELSameTradePeopleFrameModel *model = [_dataArray objectAtIndex:indexPath.row];
    if(_userType == UserTypeAgent){
        //简历列表
        ShareMessageModal * dataModal = [[ShareMessageModal alloc]init];
        dataModal.personId = model.peopleModel.personId;
        dataModal.personName = model.peopleModel.person_iname;
        dataModal.person_pic = model.peopleModel.person_pic;
        dataModal.person_zw = model.peopleModel.person_job_now;
        dataModal.person_gznum = model.peopleModel.person_gznum;
        
        ResumePreviewController *resumeCtl = [[ResumePreviewController alloc] init];
        resumeCtl.showTranspontResumeBtn = YES;
        [self.navigationController pushViewController:resumeCtl animated:YES];
        [resumeCtl beginLoad:dataModal exParam:nil];
        
        return;
    }
    //个人中心
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    [self.navigationController pushViewController:personCenterCtl animated:NO];
    [personCenterCtl beginLoad:model.peopleModel.personId exParam:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_userType == UserTypeAgent) {
        return NO;
    }
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _indexPath = indexPath;
        [self showCancelDelegateWithTag:51];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"取消委托";
}

//显示取消委托原因
- (void)showCancelDelegateWithTag:(NSInteger)tag
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"我想委托其他职业经纪人", @"已找到工作", @"服务不满意", @"其他原因", nil];
    actionSheet.tag = tag;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 51) {//取消委托
        NSString *reason = @"";
        
        if (buttonIndex == 0) {
            reason = @"1";
        }else if (buttonIndex == 1) {
            reason = @"2";
        }else if (buttonIndex == 2) {
            reason = @"3";
        }else if (buttonIndex == 3) {
            reason = @"100";
        }else{
            [self.tableView setEditing:NO];
            return;
        }
        [BaseUIViewController showLoadView:YES content:nil view:nil];
        ELSameTradePeopleFrameModel *model = _dataArray[_indexPath.row];
        
        NSString *bodyMsg = [NSString stringWithFormat:@"client_user_id=%@&broker_user_id=%@&conditionArr={\"logs_remark\":\"%@\"}&", [Manager getUserInfo].userId_, model.peopleModel.personId, reason];
        [ELRequest postbodyMsg:bodyMsg op:@"broker_entrust_busi" func:@"cancelEntrust" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
            if ([result[@"code"] isEqualToString:@"200"]) {
                [BaseUIViewController showAutoDismissSucessView:nil msg:result[@"status_desc"] seconds:2.f];
                
                [_dataArray removeObject:model];
                [self.tableView reloadData];
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"] seconds:2.f];
            }
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
        }];
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == _actionBtn) {
        if (_userType == UserTypeCommon) {//普通用户
            _shouldRefresh = YES;
            YLExpertListCtl *expertList = [[YLExpertListCtl alloc] init];
            expertList.selectedTab = @"职业经纪人";
            [self.navigationController pushViewController:expertList animated:YES];
        }
        else if (_userType == UserTypeAgent){//职业经纪人
            _shouldRefresh = YES;
            MyJobGuideCtl *myJobGuideCtl_ = [[MyJobGuideCtl alloc] init];
            myJobGuideCtl_.noSegment = YES;
            [self.navigationController pushViewController:myJobGuideCtl_ animated:YES];
        }
    }
}


@end
