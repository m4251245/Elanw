//
//  FBPositionCtl.m
//  jobClient
//
//  Created by 一览ios on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "FBPositionCtl.h"
#import "PositonType.h"
#import "ZWModel.h"
#import "FBWebsiteListCtl.h"
#import "FBCondictionCtl.h"
#import "FBRegionCtl.h"
#import "FBPositionDescCtl.h"
#import "ExRequetCon.h"
#import "ELToolTipJobCtl.h"
#import "ELPositionAddEmailCtl.h"

@interface FBPositionCtl ()
{
    ZWModel *zwmodel;
    NSString    *incompany;
    RequestCon  *fabuCon;
    NSString    *job_id;
    NSString *oldJobName;
    ELToolTipJobCtl *toolTipCtl;
}
@end

@implementation FBPositionCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"发布职位"];
    
    zwmodel = [[ZWModel alloc] init];
    _fbBtn.layer.cornerRadius = 4.0;
    _fbBtn.layer.borderColor = [UIColor clearColor].CGColor;
    _fbBtn.layer.masksToBounds = YES;
    
    _positionTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xbdbdbd)}];
    _zprenshuTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xbdbdbd)}];
//    _emailTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xbdbdbd)}];
    
    NSString *str = @"";
    if (_companyDetailModal.regionName.length > 0 ) {
        str = _companyDetailModal.regionName;
    }
    else
    {
        str = [Manager shareMgr].regionName_;
    }
    
    if (str.length > 0 && ![str isEqualToString:@"全国"]) 
    {
        [_workAddBtn setTitle:str forState:UIControlStateNormal];
        zwmodel.regionid = [CondictionListCtl getRegionId:str];
        zwmodel.region = str;
    }

    if (_isEditorStatus)
    {
        [_fbBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        toolTipCtl = [[ELToolTipJobCtl alloc] init];
        [self refreshLoadData];
    }
    else
    {
        [_fbBtn setTitle:@"发布新职位" forState:UIControlStateNormal];
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    incompany = dataModal;
    job_id = exParam;
}

-(void)refreshLoadData
{
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&job_id=%@",incompany,job_id];
    NSString *op = @"zp_busi";
    NSString *function = @"getZpDetail";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *subDic = result;
         if([subDic isKindOfClass:[NSDictionary class]])
         {
             zwmodel = [[ZWModel alloc] initWithDictionary:subDic];
             _positionTf.text = zwmodel.jtzw;
             [_fabuwangzBtn setTitle:zwmodel.zp_urlName forState:UIControlStateNormal];
             [_bumenBtn setTitle:zwmodel.deptName forState:UIControlStateNormal];
             [_zwleixingBtn setTitle:zwmodel.job_child forState:UIControlStateNormal];
             [_workageBtn setTitle:zwmodel.gznum forState:UIControlStateNormal];
             [_salaryBtn setTitle:zwmodel.salary forState:UIControlStateNormal];
             _zprenshuTf.text = zwmodel.zpnum;
//             _emailTf.text = zwmodel.email;
             [_emailBtn setTitle:zwmodel.email forState:UIControlStateNormal];
             [_workAddBtn setTitle:zwmodel.region forState:UIControlStateNormal];
             [_xueliBtn setTitle:zwmodel.edu.length > 0 ? zwmodel.edu:@"不限" forState:UIControlStateNormal];
             [_zwmiaoshuBtn setTitle:zwmodel.zptext forState:UIControlStateNormal];
             oldJobName = zwmodel.jtzw;
         }
     }
     failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         
     }];

}

- (void)btnResponse:(id)sender
{
    if (sender == _zwleixingBtn) {
        if (zwmodel.zp_urlId == nil) {
            [BaseUIViewController showAlertView:@"" msg:@"请选择发布网站" btnTitle:@"知道了"];
            return;
        }
        PositonType *ctl = [[PositonType alloc]init];
        ctl.inzwmodel = zwmodel;
        ctl.block = ^(ZWModel *model)
        {
            if(zwmodel.job_child.length > 0)
            {
                [_zwleixingBtn setTitle:zwmodel.job_child forState:UIControlStateNormal]; 
            }
            else
            {
                [_zwleixingBtn setTitle:zwmodel.job forState:UIControlStateNormal]; 
            }

        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _fabuwangzBtn){
        FBWebsiteListCtl *ctl = [[FBWebsiteListCtl alloc] init];
        ctl.inzwmodel = zwmodel;
        ctl.block = ^(){
            [_fabuwangzBtn setTitle:zwmodel.zp_urlName forState:UIControlStateNormal];
        };
        [ctl beginLoad:incompany exParam:nil];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _bumenBtn){
        FBWebsiteListCtl *ctl = [[FBWebsiteListCtl alloc] init];
        ctl.inzwmodel = zwmodel;
        ctl.type = @"1";
        ctl.block = ^(){
            [_bumenBtn setTitle:zwmodel.deptName forState:UIControlStateNormal];
        };
        [ctl beginLoad:incompany exParam:nil];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _workageBtn){
        FBCondictionCtl *ctl = [[FBCondictionCtl alloc] init];
        ctl.inzwmodel = zwmodel;
        ctl.block = ^(){
            [_workageBtn setTitle:zwmodel.gznum forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _xueliBtn){
        FBCondictionCtl *ctl = [[FBCondictionCtl alloc] init];
        ctl.type = @"1";
        ctl.inzwmodel = zwmodel;
        ctl.block = ^(){
            [_xueliBtn setTitle:zwmodel.edu forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _workAddBtn){
        FBRegionCtl *ctl = [[FBRegionCtl alloc] init];
        ctl.inzwmodel = zwmodel;
        ctl.block = ^(NSString *regionName,NSString *regionId,BOOL selectHotCity){
            [_workAddBtn setTitle:zwmodel.region forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _salaryBtn){
        FBCondictionCtl *ctl = [[FBCondictionCtl alloc] init];
        ctl.type = @"2";
        ctl.inzwmodel = zwmodel;
        ctl.block = ^(){
            [_salaryBtn setTitle:zwmodel.salary forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _zwmiaoshuBtn){
        FBPositionDescCtl *ctl = [[FBPositionDescCtl alloc] init];
        ctl.inzwmodel = zwmodel;
        ctl.block = ^(){
            [_zwmiaoshuBtn setTitle:zwmodel.zptext forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _emailBtn)
    {
        ELPositionAddEmailCtl *ctl = [[ELPositionAddEmailCtl alloc] init];
//        ctl.inzwmodel = zwmodel;
        ctl.block = ^(){
            [_emailBtn setTitle:zwmodel.email forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:zwmodel exParam:nil];
    }
    else if (sender == _fbBtn) {
        if(_isEditorStatus)
        {
            if ([self validate]) {
                zwmodel.jtzw = [MyCommon removeAllSpace:_positionTf.text];
                zwmodel.zpnum = [MyCommon removeAllSpace:_zprenshuTf.text];
//                zwmodel.email = [MyCommon removeAllSpace:_emailTf.text];
                
                if (![zwmodel.jtzw isEqualToString:oldJobName]) 
                {
                    NSMutableAttributedString *stringOne = [[NSMutableAttributedString alloc] initWithString:@"确定要修改职位名称吗？"];
                    [stringOne addAttribute:NSForegroundColorAttributeName value:FONEREDCOLOR range:NSMakeRange(3,6)];
                    
                    NSMutableAttributedString *stringTwo = [[NSMutableAttributedString alloc] initWithString:@"修改职位名称将扣除1个职位数”"];
                    [stringTwo addAttribute:NSForegroundColorAttributeName value:FONEREDCOLOR range:NSMakeRange(9,1)];
                    [toolTipCtl showViewCtlWithAttStringOne:stringOne attStringTwo:stringTwo btnRespone:^(NSInteger type)
                     {
                         if (type == 1)//取消
                         {
                             
                         }
                         else if(type == 2)//确认
                         {
                             [self changeJobMessageRequest];
                         }
                         [toolTipCtl hideViewCtl];
                     }];
                    return;
                }
                [self changeJobMessageRequest];
            }            
        }
        else
        {
            if ([self validate]) {
                zwmodel.jtzw = [MyCommon removeAllSpace:_positionTf.text];
                zwmodel.zpnum = [MyCommon removeAllSpace:_zprenshuTf.text];
//                zwmodel.email = [MyCommon removeAllSpace:_emailTf.text];
                
                if (!fabuCon) {
                    fabuCon = [self getNewRequestCon:NO];
                }
                [fabuCon addPositionWithCompanyId:incompany dataModel:zwmodel];
            }
        }
    }
}


-(void)changeJobMessageRequest
{
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:zwmodel.regionid forKey:@"region"];
    [conditionDic setObject:zwmodel.gznumId forKey:@"gznum1"];
    [conditionDic setObject:zwmodel.gznumId1 forKey:@"gznum2"];
    [conditionDic setObject:zwmodel.jtzw forKey:@"jtzw"];
    [conditionDic setObject:zwmodel.job forKey:@"job"];
    [conditionDic setObject:zwmodel.job_child forKey:@"job_child"];
    if (zwmodel.deptId != nil) {
        [conditionDic setObject:zwmodel.deptId forKey:@"deptId"];
    }
    [conditionDic setObject:zwmodel.zpnum forKey:@"zpnum"];
    [conditionDic setObject:[zwmodel.salary isEqualToString:@"50000以上"]?@"50000-0":zwmodel.salary forKey:@"salary"];
    [conditionDic setObject:zwmodel.zptext forKey:@"zptext"];
    [conditionDic setObject:zwmodel.email forKey:@"email"];
    [conditionDic setObject:zwmodel.zp_urlId forKey:@"zp_urlId"];
    if (zwmodel.eduId != nil) {
        [conditionDic setObject:zwmodel.eduId forKey:@"eduId"];
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&job_id=%@&zparr=%@",incompany,job_id,conditionDicStr];
    NSString *function = @"updateZP";
    NSString * op = @"zp_busi";
    [BaseUIViewController showLoadView:YES content:@"正在修改" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
         NSDictionary *subDic = result;
         NSString *status = subDic[@"status"];
         NSString *status_desc = subDic[@"status_desc"];
         if ([status isEqualToString:@"OK"])
         {
             [self.navigationController popViewControllerAnimated:YES];
             _block();
             [BaseUIViewController showAutoDismissSucessView:nil msg:status_desc seconds:1.0];
         }
         else
         {
             [BaseUIViewController showAutoDismissFailView:nil msg:status_desc seconds:1.0];
         }
     }
     failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
     }];

}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ADDJob:
        {
            NSDictionary *dic = [dataArr firstObject];
            if ([dic[@"status"] isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"" msg:@"发布成功" seconds:1.0];
                if (_block) {
                    _block();
                }
                ZWDetail_DataModal *model = [[ZWDetail_DataModal alloc] init];
                model.zwID_ = dic[@"zp_id"];
                model.companyName_ = dic[@"cname"];
                PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
                detailCtl.showJobSuccessView = YES;
                //解决先pop再push不起作用
                NSMutableArray *viewCtls = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                NSInteger idx = [viewCtls indexOfObject:self];
                [viewCtls removeObjectAtIndex:idx];
                [viewCtls addObject:detailCtl];
                [self.navigationController setViewControllers:viewCtls animated:YES];
                [detailCtl beginLoad:model exParam:nil];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"" msg:dic[@"desc"] seconds:1.0];
            }
        }
            break;
        default:
            break;
    }
}



- (BOOL)validate
{
    if ([MyCommon removeAllSpace:_positionTf.text].length == 0) {
        [BaseUIViewController showAlertView:@"" msg:@"请填写职位名称" btnTitle:@"知道了"];
        return NO;
    }else if (_fabuwangzBtn.titleLabel.text.length == 0){
        [BaseUIViewController showAlertView:@"" msg:@"请选择发布网站" btnTitle:@"知道了"];
        return NO;
    }else if (_zwleixingBtn.titleLabel.text.length == 0){
        [BaseUIViewController showAlertView:@"" msg:@"请选择职位类型" btnTitle:@"知道了"];
                        return NO;
    }else if (_workageBtn.titleLabel.text.length == 0){
        [BaseUIViewController showAlertView:@"" msg:@"请选择工作经验" btnTitle:@"知道了"];
        return NO;
    }else if (_salaryBtn.titleLabel.text.length == 0){
        [BaseUIViewController showAlertView:@"" msg:@"请选择薪酬" btnTitle:@"知道了"];
                        return NO;
    }else if ([MyCommon removeAllSpace:_zprenshuTf.text].length == 0){
        [BaseUIViewController showAlertView:@"" msg:@"请填写招聘人数" btnTitle:@"知道了"];
        return NO;
    }
//    else if ([MyCommon removeAllSpace:_emailTf.text].length == 0){
//        [BaseUIViewController showAlertView:@"" msg:@"请填写接收邮箱" btnTitle:@"知道了"];
//        return NO;
//    }
    else if (_workAddBtn.titleLabel.text.length == 0){
        [BaseUIViewController showAlertView:@"" msg:@"请选择工作地点" btnTitle:@"知道了"];
        return NO;
    }else if (_zwmiaoshuBtn.titleLabel.text.length == 0){
        [BaseUIViewController showAlertView:@"" msg:@"请填写职位描述" btnTitle:@"知道了"];
        return NO;
    }else{
        return YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    
    CGPoint point = self.scrollView_.contentOffset;
    if( point.y < 0 ){
        [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if(self.scrollView_.frame.size.height + point.y > self.scrollView_.contentSize.height ){
        if(self.scrollView_.frame.size.height > self.scrollView_.contentSize.height ){
            [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
        }else
            [self.scrollView_ setContentOffset:CGPointMake(0, self.scrollView_.contentSize.height - self.scrollView_.frame.size.height) animated:YES];
    }
    
    CGRect frame = self.toolbarHolder.frame;
    frame.origin.y = self.view.frame.size.height;
    self.toolbarHolder.frame = frame;
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
