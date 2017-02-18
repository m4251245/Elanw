//
//  ELInterviewRefundCtl.m
//  jobClient
//
//  Created by YL1001 on 15/11/18.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELInterviewRefundCtl.h"
#import "ELAspectantDiscuss_Modal.h"
#import "ELRequest.h"
#import "Manager.h"
#import "SBJson.h"

@interface ELInterviewRefundCtl ()
{
    ELAspectantDiscuss_Modal *aspDataModal;
    
    IBOutlet UIView *BtnBgView;
    __weak IBOutlet UIView *reasonBgView;
    
}
@end

@implementation ELInterviewRefundCtl

- (instancetype)init
{
    self = [super init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请退款";
    BtnBgView.layer.cornerRadius = 6.0f;
    BtnBgView.layer.masksToBounds = YES;
    
    reasonBgView.layer.cornerRadius = 6.0f;
    reasonBgView.layer.masksToBounds = YES;
    
    finishedBtn.layer.cornerRadius = 3.0f;
    finishedBtn.layer.masksToBounds = YES;
    finishedBtn.layer.borderWidth = 1.0f;
    finishedBtn.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
    
    unfinishedBtn.layer.cornerRadius = 3.0f;
    unfinishedBtn.layer.masksToBounds = YES;
    unfinishedBtn.layer.borderWidth = 1.0f;
    unfinishedBtn.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
    
    confirmBtn.layer.cornerRadius = 3.0f;
    confirmBtn.layer.masksToBounds = YES;
    
    reasonTV.layer.borderWidth = 1.0f;
    reasonTV.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
    aspDataModal = dataModal;
}

- (void)btnResponse:(id)sender
{
    if (sender == finishedBtn) {
        [unfinishedBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        unfinishedBtn.backgroundColor = [UIColor whiteColor];
        
        [finishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finishedBtn.backgroundColor = UIColorFromRGB(0xE4403A);
        
    }
    else if (sender == unfinishedBtn)
    {
        [finishedBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        finishedBtn.backgroundColor = [UIColor whiteColor];
        
        [unfinishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        unfinishedBtn.backgroundColor = UIColorFromRGB(0xE4403A);
    }
    else if (sender == confirmBtn)
    {
        if ([reasonTV.text isEqualToString:@""]) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请填写退款原因"];
        }
        else
        {
            [self confirmRefundApply];
        }
    }
}

/**
 * 添加退款申请
 * @param   $person_id                  integer         用户编号
 * @param   $record_id                  integer         约谈编号
 * @param   $applyInfo                  array
 *          $applyInfo[refund_reason]   string          申请理由
 * 返回值：array('status'=> 'OK','code'=> 200,'status_desc'=> '申请成功！',);
 **/
- (void)confirmRefundApply
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        return;
    }
    
    NSString *op = @"yuetan_refund_busi";
    NSString *func = @"addRefundApply";
    
    NSMutableDictionary *applyDic = [[NSMutableDictionary alloc] init];
    [applyDic setValue:reasonTV.text forKey:@"refund_reason"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *applyStr = [jsonWrite stringWithObject:applyDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&applyInfo=%@&",userId,aspDataModal.recordId,applyStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        Status_DataModal *statusModal = [[Status_DataModal alloc] init];
        statusModal.status_ = result[@"status"];
        statusModal.code_ = result[@"code"];
        statusModal.status_desc = result[@"status_desc"];
        if ([statusModal.code_ isEqualToString:@"200"]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:statusModal.status_desc];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:nil msg:statusModal.status_desc];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
