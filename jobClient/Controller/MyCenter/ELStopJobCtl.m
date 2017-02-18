//
//  ELStopJobCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/1/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELStopJobCtl.h"
#import "InbiddingJobCell.h"
#import "CompanyResumeCtl.h"
#import "ELToolTipJobCtl.h"
#import "New_ELSelectionViewController.h"

@interface ELStopJobCtl ()<UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSString *inCompanyId;
    ELToolTipJobCtl *toolTipCtl;
    NSInteger _selectIndex;
}
@end

@implementation ELStopJobCtl

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
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"0" forKey:@"type"];
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_id"];
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&page_size=%@&pageIndex=%@&conditionArr=%@",inCompanyId,pageParams,[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_],conditionDicStr];
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
     failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [self finishReloadingData];
     }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    InbiddingJobCell *jobCell = (InbiddingJobCell *)cell;
    ZWDetail_DataModal *model = _dataArray[indexPath.row];
    [jobCell.positionLb setText:model.zwName_];
    [jobCell.salaryLb setText:model.salary_];
    [jobCell.regionLb setText:model.regionName_];
    [jobCell.companyLb setText:[NSString stringWithFormat:@"停止时间:%@",[model.updateTime_ substringToIndex:10]]];
    [jobCell.jianliBtn setTitle:[NSString stringWithFormat:@"投递 %@ 份",[NSString changeNullOrNil:model.count_]] forState:UIControlStateNormal];
    [jobCell.perfectSelectBtn setTitle:[NSString stringWithFormat:@"精选 %@ 份",[NSString changeNullOrNil:model.tjNumber]] forState:UIControlStateNormal];
    [jobCell giveDataStopJobModal:model];
    
    jobCell.leftBtn.tag = 1000 + indexPath.row;
    jobCell.centerBtn.tag = 2000 + indexPath.row;
    jobCell.jianliBtn.tag = 10000 + indexPath.row;
    jobCell.perfectSelectBtn.tag = 20000 + indexPath.row;
    [jobCell.leftBtn addTarget:self action:@selector(startBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [jobCell.centerBtn addTarget:self action:@selector(deleteBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWDetail_DataModal *model = _dataArray[indexPath.row];
//    CompanyResumeCtl *companyResumeCtl = [[CompanyResumeCtl alloc] init];
//    companyResumeCtl.isZwgl = YES;
//    companyResumeCtl.type_ = 0;
//    companyResumeCtl.jobId_ = model.zwID_;
//    companyResumeCtl.resumeType = ResumeTypePersonDelivery;
//    companyResumeCtl.title = @"人才投递";
//    [self.navigationController pushViewController:companyResumeCtl animated:YES];
//    [companyResumeCtl beginLoad:inCompanyId exParam:nil];
    
     PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
     [self.navigationController pushViewController:detailCtl animated:YES];
     [detailCtl beginLoad:model exParam:nil];
     
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128.0f;
}

#pragma mark - ButtonClick
-(void)jianliBtnRespone:(UIButton *)sender
{
    ZWDetail_DataModal *model = _dataArray[sender.tag - 10000];
    CompanyResumeCtl *companyResumeCtl = [[CompanyResumeCtl alloc] init];
    companyResumeCtl.isZwgl = YES;
    companyResumeCtl.type_ = 0;
    companyResumeCtl.jobId_ = model.zwID_;
    companyResumeCtl.jobName = model.zwName_;
    companyResumeCtl.entrance = POSITION;
    companyResumeCtl.resumeType = ResumeTypePersonDelivery;
    companyResumeCtl.title = @"人才投递";
    [self.navigationController pushViewController:companyResumeCtl animated:YES];
    [companyResumeCtl beginLoad:inCompanyId exParam:nil];
}

- (void)recommendBtnRespone:(UIButton *)sender
{
    ZWDetail_DataModal *model = _dataArray[sender.tag - 20000];
    New_ELSelectionViewController *selecCtl = [[New_ELSelectionViewController alloc] init];
    selecCtl.type = 2;
    selecCtl.jobId_ = model.zwID_;
    selecCtl.entrance = POSITION;
    selecCtl.positionName = model.zwName_;
    [self.navigationController pushViewController:selecCtl animated:YES];
    [selecCtl beginLoad:model.companyID_ exParam:nil];
}

-(void)startBtnRespone:(UIButton *)sender
{
    NSString *m_isDown = [CommonConfig getDBValueByKey:@"m_isAddZp"];
    if (m_isDown && [m_isDown isEqualToString:@"0"]) {
        [BaseUIViewController showAlertView:@"" msg:@"该账号没有此权限哟" btnTitle:@"关闭"];
        return;
    }
    
    _selectIndex = sender.tag - 1000;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要启用选中的职位吗？" message:@"启用的将归类至“在招职位”" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

-(void)deleteBtnRespone:(UIButton *)sender
{
    NSString *m_isDown = [CommonConfig getDBValueByKey:@"m_isAddZp"];
    if (m_isDown && [m_isDown isEqualToString:@"0"]) {
        [BaseUIViewController showAlertView:@"" msg:@"该账号没有此权限哟" btnTitle:@"关闭"];
        return;
    }
    _selectIndex = sender.tag - 2000;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除选中的职位吗？" message:@"职位删除后可登录PC端查找" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 101;
    [alertView show];
}

#pragma mark - delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ZWDetail_DataModal *model = _dataArray[_selectIndex];
    
    switch (alertView.tag) {
        case 100:
        {
            if (buttonIndex == 1) {
                NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&job_id=%@",model.companyID_,model.zwID_];
                NSString *op = @"zp_busi";
                NSString *function = @"startZp";
                [BaseUIViewController showLoadView:YES content:@"正在启用" view:nil];
                
                [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                    [BaseUIViewController showLoadView:NO content:nil view:nil];
                    NSDictionary *subDic = result;
                    NSString *status = subDic[@"status"];
                    NSString *status_desc = subDic[@"status_desc"];
                    if ([status isEqualToString:@"OK"])
                    {
                        [BaseUIViewController showAutoDismissSucessView:nil msg:status_desc seconds:1.0];
                        [_dataArray removeObjectAtIndex:_selectIndex];
                        [self.tableView reloadData];
                        _stopBlock();
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
        case 101:
        {
            if (buttonIndex == 1) {
                NSString *jobId;
                if (model.zwID_.length > 0) {
                    jobId = model.zwID_;
                }
                else{
                    jobId = @"";
                }
                NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&job_id=%@",model.companyID_,jobId];
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
                        [_dataArray removeObjectAtIndex:_selectIndex];
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
