//
//  RegSendSmsCodeCtl.m
//  jobClient
//
//  Created by 一览ios on 14/12/25.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RegSendSmsCodeCtl.h"
#import "ServiceCode_DataModal.h"
#import "RegPhoneNoCodeCtl.h"

@interface RegSendSmsCodeCtl ()
{
    ServiceCode_DataModal *_serviceCode;
}
@end

@implementation RegSendSmsCodeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"主动验证" withColor:[UIColor blackColor]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _phoneLb.text = [NSString stringWithFormat:@"请使用手机%@",_phone];
    CALayer *btnLayer = _editSmsBtn.layer;
    btnLayer.masksToBounds = YES;
    btnLayer.cornerRadius = 3.0;
    btnLayer = _sendedSmsBtn.layer;
    btnLayer.masksToBounds = YES;
    btnLayer.cornerRadius = 3.0;
    btnLayer.borderColor = UIColorFromRGB(0xf85656).CGColor;
    btnLayer.borderWidth = 1.0;
}

-(void)setBackBarBtnAtt{
    [super setBackBarBtnAtt];
    [backBarBtn_ setImage:[UIImage imageNamed:@"back_grey_new_back"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//-----------数据请求与刷新－－－－－－－－－－

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (requestCon_ == nil) {
        requestCon_ = [self getNewRequestCon:NO];
    }
    [requestCon_ getServiceNumberWithPhone:_phone];
}


-(void)getDataFunction:(RequestCon *)con
{
    [super getDataFunction:con];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetServiceNumber:{
            id result = dataArr[0];
            if ([result isKindOfClass:[ServiceCode_DataModal class]]) {
                ServiceCode_DataModal *serviceCode = (ServiceCode_DataModal *)result;
                _serviceCode = serviceCode;
                _msgContentLb.text = serviceCode.code;
                _msgToLb.text = serviceCode.number;
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark 发送短信验证码
- (IBAction)editMsg:(id)sender {
    [self showMessageViewWithContent:_msgContentLb.text receiver:_msgToLb.text];
}

#pragma mark 已经发送短信码，开始注册
- (IBAction)goRegist:(id)sender {
    RegPhoneNoCodeCtl *regCtl = [[RegPhoneNoCodeCtl alloc]init];
    regCtl.serviceCode = _serviceCode;
    regCtl.phone = _phone;
    [self.navigationController pushViewController:regCtl animated:YES];
}

- (void)showMessageViewWithContent:(NSString *)content receiver:(NSString *)receiver
{
    
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //
        controller.recipients = [NSArray arrayWithObject:receiver];
        controller.body = content;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{}];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送短信"];//修改短信界面标题
    }else{
        
        [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
    }
}

- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];  
    
}

//MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:NO completion:^{}];
    switch ( result ) {
        case MessageComposeResultCancelled:
//            [self alertWithTitle:@"提示信息" msg:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self alertWithTitle:@"提示信息" msg:@"发送失败"];
            break;
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg:@"发送成功"];
            break;
        default:
            break;
    }
}

@end
