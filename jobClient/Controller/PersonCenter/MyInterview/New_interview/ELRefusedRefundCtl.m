//
//  ELRefusedRefundCtl.m
//  jobClient
//
//  Created by YL1001 on 15/11/19.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELRefusedRefundCtl.h"
#import "ELAspectantDiscuss_Modal.h"

@interface ELRefusedRefundCtl ()
{
    __weak IBOutlet UIView *bgView;
    ELAspectantDiscuss_Modal *aspDataModal;
}
@end

@implementation ELRefusedRefundCtl

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    
    bgView.layer.cornerRadius = 6.0f;
    bgView.layer.masksToBounds = YES;
    
    reasonTV.layer.borderWidth = 1.0f;
    reasonTV.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    aspDataModal = dataModal;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger length = textView.text.length;
    NSString *lang = [textView.textInputMode primaryLanguage];
    
    if (reasonTV.text.length <= 0)
    {
        numberLb.text = @"500字";
    }
    else
    {
        length = 500 - length;
        numberLb.text = [NSString stringWithFormat:@"%ld字",(long)length];
        if (length <= 0) {
            numberLb.text = @"0字";
        }
        
        if ([lang isEqualToString:@"zh-Hans"]) {//如果输入的时中文
            UITextRange *selectedRange = [reasonTV markedTextRange];
            UITextPosition *position = [reasonTV positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                if (reasonTV.text.length > 500) {
                    reasonTV.text = [reasonTV.text substringToIndex:500];
                }
            }
        }else{
            if (reasonTV.text.length > 500) {
                reasonTV.text = [reasonTV.text substringToIndex:500];
            }
        }
    }
}

- (void)btnResponse:(id)sender
{
    if ([reasonTV.text isEqualToString:@""]) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"请填写拒绝的原因"];
    }
    else
    {
        [self refuseRefundApply];
    }
}

/**
 * 拒绝退款申请
 * @param   $person_id                  integer         用户编号
 * @param   $record_id                  integer         约谈编号
 * @param   $applyInfo                  array
 *          $applyInfo[refuse_reason]   string          拒绝理由
 *返回值：array('status'=> 'OK','code'=> 200,'status_desc'=> '操作成功！',);
 **/
- (void)refuseRefundApply
{
    NSString *op = @"yuetan_refund_busi";
    NSString *func = @"refuseRefundApply";
    
    NSMutableDictionary *refuseDic = [[NSMutableDictionary alloc] init];
    [refuseDic setValue:reasonTV.text forKey:@"refuse_reason"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *refuseStr = [jsonWrite stringWithObject:refuseDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&applyInfo=%@&",[Manager getUserInfo].userId_,aspDataModal.recordId,refuseStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        Status_DataModal *statusModal = [[Status_DataModal alloc] init];
        statusModal.status_ = result[@"status"];
        statusModal.code_ = result[@"code"];
        statusModal.status_desc = result[@"status_desc"];
        if ([statusModal.code_ isEqualToString:@"200"]) {
//            [BaseUIViewController showAutoDismissSucessView:nil msg:statusModal.status_desc];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDetail" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"操作失败"];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
