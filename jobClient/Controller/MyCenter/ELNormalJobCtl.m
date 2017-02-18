//
//  ELNormalJobCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/1/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNormalJobCtl.h"
#import "InbiddingJobCell.h"
#import "CompanyResumeCtl.h"
#import "ELToolTipJobCtl.h"
#import "FBPositionCtl.h"
#import "New_ELSelectionViewController.h"

@interface ELNormalJobCtl ()<UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSString *inCompanyId;
    ELToolTipJobCtl *toolTipCtl;
    
    NSInteger selectIndex;
}
@end

@implementation ELNormalJobCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerRefreshFlag = YES;
    self.footerRefreshFlag = YES;
    // Do any additional setup after loading the view from its nib.
    
    toolTipCtl = [[ELToolTipJobCtl alloc] init];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (dataModal)
    {
        inCompanyId = dataModal;
    }
    
    self.noDataString = @"无在招职位";
    NSMutableDictionary *conditionDic = [NSMutableDictionary dictionary];
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    
    NSString * conditionStr;
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_id"];
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        conditionStr = [jsonWriter stringWithObject:conditionDic];
    }
    
    NSString *bodyMsg;
    if (conditionStr && conditionStr.length > 0) {
        bodyMsg = [NSString stringWithFormat:@"company_id=%@&page_size=%@&pageIndex=%@&conditionArr=%@",inCompanyId,pageParams,[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_],conditionStr];
    }else{
        bodyMsg = [NSString stringWithFormat:@"company_id=%@&page_size=%@&pageIndex=%@",inCompanyId,pageParams,[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_]];
    }
    
    NSString *op = @"zp_busi";
    NSString *function = @"getZplist";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *subDic = result;
         [self parserPageInfo:subDic];
         if([subDic isKindOfClass:[NSDictionary class]])
         {
             if ([subDic[@"data"] isKindOfClass:[NSArray class]])
             {
                 for (NSDictionary *dic in subDic[@"data"])
                 {
                     ZWDetail_DataModal *model = [[ZWDetail_DataModal alloc] init];
                     model.zwName_ = dic[@"jtzw"];
                     model.count_ = dic[@"ypNumber"];   //应聘人数
                     model.salary_ = dic[@"salary"];
                     model.regionName_ = dic[@"regionid"];
                     model.companyID_ = dic[@"uid"];
                     model.zwID_ = dic[@"id"];
                     model.updateTime_ = dic[@"updatetime"];
                     model.zprenshu = dic[@"zprenshu"];
                     model.companyName_ = dic[@"cname"];
                     model.tjNumber = dic[@"tjNumber"];
                     [_dataArray addObject:model];
                 }
             }
             [self.tableView reloadData];
         }
         
         [self finishReloadingData];
         [self refreshEGORefreshView];
     }
     failure:^(NSURLSessionDataTask *operation, NSError *error){
         [self finishReloadingData];
     }];
}

#pragma mark - buttonClick
-(void)refreshBtnRespone:(UIButton *)sender
{
    NSString *m_isDown = [CommonConfig getDBValueByKey:@"m_isAddZp"];
    if (m_isDown && [m_isDown isEqualToString:@"0"]) {
        [BaseUIViewController showAlertView:@"" msg:@"该账号没有此权限哟" btnTitle:@"关闭"];
        return;
    }
    ZWDetail_DataModal *model = _dataArray[sender.tag - 1000];
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&job_id=%@",inCompanyId,model.zwID_];
    NSString *op = @"zp_busi";
    NSString *function = @"refreshZpupdatetime";
    [BaseUIViewController showLoadView:YES content:@"正在刷新" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
         NSDictionary *subDic = result;
         NSString *status = subDic[@"status"];
         NSString *status_desc = subDic[@"status_desc"];
         if ([status isEqualToString:@"OK"])
         {
             [BaseUIViewController showAutoDismissSucessView:nil msg:status_desc seconds:1.0];
             [self refreshLoad];
         }
         else {
             [BaseUIViewController showAutoDismissFailView:nil msg:status_desc seconds:1.0];
         }
     }
     failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
     }];
}

-(void)editorBtnRespone:(UIButton *)sender
{
    NSString *m_isDown = [CommonConfig getDBValueByKey:@"m_isAddZp"];
    if (m_isDown && [m_isDown isEqualToString:@"0"]) {
        [BaseUIViewController showAlertView:@"" msg:@"该账号没有此权限哟" btnTitle:@"关闭"];
        return;
    }
    
    FBPositionCtl *ctl = [[FBPositionCtl alloc] init];
    ZWDetail_DataModal *model = _dataArray[sender.tag - 2000];
    ctl.isEditorStatus = YES;
    ctl.block = ^(){
        [self refreshLoad];
    };
    [ctl beginLoad:inCompanyId exParam:model.zwID_];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)moreBtnRespone:(UIButton *)sender
{
    NSString *m_isDown = [CommonConfig getDBValueByKey:@"m_isAddZp"];
    if (m_isDown && [m_isDown isEqualToString:@"0"]) {
        [BaseUIViewController showAlertView:@"" msg:@"该账号没有此权限哟" btnTitle:@"关闭"];
        return;
    }
    
    selectIndex = sender.tag - 3000;
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"停止职位", @"删除职位", nil];
    [sheetView showInView:self.view];
}

-(void)jianliBtnRespone:(UIButton *)sender
{
    ZWDetail_DataModal *model = _dataArray[sender.tag - 4000];
    CompanyResumeCtl *companyResumeCtl = [[CompanyResumeCtl alloc] init];
    companyResumeCtl.isZwgl = YES;
    companyResumeCtl.type_ = 0;
    companyResumeCtl.jobId_ = model.zwID_;
    companyResumeCtl.jobName = model.zwName_;
    companyResumeCtl.entrance = POSITION;
    companyResumeCtl.resumeType = ResumeTypePersonDelivery;
    companyResumeCtl.title = @"投递应聘";
    [self.navigationController pushViewController:companyResumeCtl animated:YES];
    [companyResumeCtl beginLoad:inCompanyId exParam:nil];
}

- (void)recommendBtnRespone:(UIButton *)sender
{
    ZWDetail_DataModal *model = _dataArray[sender.tag - 5000];
    New_ELSelectionViewController *selecCtl = [[New_ELSelectionViewController alloc] init];
    selecCtl.type = 2;
    selecCtl.jobId_ = model.zwID_;
    selecCtl.entrance = POSITION;
    selecCtl.positionName = model.zwName_;
    [self.navigationController pushViewController:selecCtl animated:YES];
    [selecCtl beginLoad:model.companyID_ exParam:nil];
}

#pragma mark - delegate
//UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要停用选中的职位吗？" message:@"停止的将归类至“停止职位”" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 100;
            [alertView show];
        }
            break;
        case 1:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除选中的职位吗？" message:@"职位删除后可登录PC端查找" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 101;
            [alertView show];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ZWDetail_DataModal *model = _dataArray[selectIndex];
    switch (alertView.tag) {
        case 100:
        {
            if (buttonIndex == 1) {
                NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&zp_id=%@",inCompanyId,model.zwID_];
                NSString *op = @"zp_busi";
                NSString *function = @"stopZp";
                [BaseUIViewController showLoadView:YES content:@"正在停止" view:nil];

                [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                    [BaseUIViewController showLoadView:NO content:nil view:nil];
                    NSDictionary *subDic = result;
                    NSString *status = subDic[@"status"];
                    NSString *status_desc = subDic[@"status_desc"];
                    if ([status isEqualToString:@"OK"])
                    {
                        [_dataArray removeObjectAtIndex:selectIndex];
                        [self.tableView reloadData];
                        _startBlock();
                        [self refreshEGORefreshView];
                        [BaseUIViewController showAutoDismissSucessView:nil msg:status_desc seconds:1.0];
                    }
                    else {
                        [BaseUIViewController showAutoDismissFailView:nil msg:status_desc seconds:1.0];
                    }
                    
                } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    [BaseUIViewController showLoadView:NO content:nil view:nil];
                }];
            }
        }
            break;
        case 101:
        {
            if (buttonIndex == 1) {
                NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&job_id=%@",inCompanyId,model.zwID_];
                NSString *op = @"zp_busi";
                NSString *function = @"deleteZp";
                [BaseUIViewController showLoadView:YES content:@"正在删除" view:nil];
                [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                    [BaseUIViewController showLoadView:NO content:nil view:nil];
                    NSDictionary *subDic = result;
                    NSString *status = subDic[@"status"];
                    NSString *status_desc = subDic[@"status_desc"];
                    if ([status isEqualToString:@"OK"])
                    {
                        [BaseUIViewController showAutoDismissSucessView:nil msg:status_desc seconds:1.0];
                        [_dataArray removeObjectAtIndex:selectIndex];
                        [self.tableView reloadData];
                        [self refreshEGORefreshView];
                    }
                    else {
                        [BaseUIViewController showAutoDismissFailView:nil msg:status_desc seconds:1.0];
                    }
                    
                } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    [BaseUIViewController showLoadView:NO content:nil view:nil];
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    InbiddingJobCell *jobCell = (InbiddingJobCell *)cell;
    ZWDetail_DataModal *model = _dataArray[indexPath.row];
    [jobCell.positionLb setText:model.zwName_];
    [jobCell.salaryLb setText:model.salary_];
    [jobCell.regionLb setText:model.regionName_];
    [jobCell.companyLb setText:[NSString stringWithFormat:@"发布时间:%@",[model.updateTime_ substringToIndex:10]]];
    
    [jobCell.jianliBtn setTitle:[NSString stringWithFormat:@"投递 %@ 份",[NSString changeNullOrNil:model.count_]] forState:UIControlStateNormal];
    [jobCell.perfectSelectBtn setTitle:[NSString stringWithFormat:@"精选 %@ 份",[NSString changeNullOrNil:model.tjNumber]] forState:UIControlStateNormal];
    [jobCell giveDataNormalJobModal:model];
    
    jobCell.leftBtn.tag = 1000 + indexPath.row;
    jobCell.centerBtn.tag = 2000 + indexPath.row;
    jobCell.rightBtn.tag = 3000 + indexPath.row;
    jobCell.jianliBtn.tag = 4000 + indexPath.row;
    jobCell.perfectSelectBtn.tag = 5000+indexPath.row;
    [jobCell.leftBtn addTarget:self action:@selector(refreshBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [jobCell.centerBtn addTarget:self action:@selector(editorBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [jobCell.rightBtn addTarget:self action:@selector(moreBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [jobCell.jianliBtn addTarget:self action:@selector(jianliBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [jobCell.perfectSelectBtn addTarget:self action:@selector(recommendBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"InbiddingJobCell";
    InbiddingJobCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"InbiddingJobCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWDetail_DataModal *model = _dataArray[indexPath.row];
    PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
    detailCtl.jobManager = YES;
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:model exParam:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
