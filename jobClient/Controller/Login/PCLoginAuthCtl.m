//
//  PCLoginAuthCtl.m
//  jobClient
//
//  Created by 一览ios on 14/12/18.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//扫描登录

#import "PCLoginAuthCtl.h"

@interface PCLoginAuthCtl ()

@end

@implementation PCLoginAuthCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"扫描登录";
    [self setNavTitle:@"扫描登录"];
    _summaryLb.text = [NSString stringWithFormat:@"您将使用：%@", _companyName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------数据请求与刷新－－－－－－－－－－
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}


-(void)getDataFunction:(RequestCon *)con
{
    if(con == requestCon_){
        NSString *userId = [Manager getUserInfo].userId_;
        [con authorizedLoginWithCompanyId:_companyId userId:userId url:_url];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (requestCon == requestCon_){
        Status_DataModal *dataModal = [dataArr objectAtIndex:0];
//        NSString *code = dataModal.code_;
        if( [dataModal.status_ isEqualToString:Success_Status] ){
            //登录成功
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"登录成功"];
            [self performSelector:@selector(back) withObject:self afterDelay:1.5];
        }else{
            //登录失败
            NSString *desc = dataModal.des_;
            [BaseUIViewController showAutoDismissFailView:nil msg:desc];
        }
    }
}

- (void)back
{
    NSInteger count = self.navigationController.childViewControllers.count;
    UIViewController *ctl  =self.navigationController.childViewControllers[count-3];
    [self.navigationController popToViewController:ctl animated:YES];
}

-(void)updateCom:(RequestCon *)con
{
    if (con == requestCon_) {
        
    }
    
}

- (IBAction)loginBtnClick:(id)sender {
    [self beginLoad:nil exParam:nil];
}

- (IBAction)cancelLoginBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}



@end
