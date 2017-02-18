//
//  PayCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PayCtl.h"
#import "Constant.h"
#import "WXPayClient.h"
#import "CommonUtil.h"
#import "BuySuccessCtl.h"
#import "SalaryCompareOrderListCtl.h"
#import "AspectantDiscussSuccessCtl.h"
#import "ELMyAspectantDiscussCtl.h"
#import "ELPersonCenterCtl.h"


@interface PayCtl ()
{
    RequestCon *_getPrepayIdCon;
    RequestCon *_myAccountCon;//我的账户
    RequestCon *yuerCon;
    NSInteger   balanceValue;
    
    IBOutlet UIImageView *_selectAliImg;
    IBOutlet UIImageView *_selectWeixImg;
    IBOutlet UIImageView *_selectYuerImg;
 
//    NSNotification *rewardNotification;
}
@end

@implementation PayCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setFd_interactivePopDisabled:YES];
//    self.navigationItem.title = @"请选择支付方式";
    [self setNavTitle:@"请选择支付方式"];
    _priceLb.text = _order.amount;
    _orderNUm.text = _order.tradeNO;
    _productName.text = [NSString stringWithFormat:@"%@(%@)", _order.productDescription, _order.productName];
    
    
    [_selectAliImg setImage:[UIImage imageNamed:@"ok_06.png"]];
    _alipayBtn.selected = YES;
    _weixinPayBtn.selected = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"WX_PAY_SUCCESS" object:nil];
    

    _scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(_payBtn.frame) + 50);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _payBtn.enabled = YES;
//    self.navigationItem.title = @"请选择支付方式";
    
    [self setFd_prefersNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getDataFunction:(RequestCon *)con
{
    if (!_myAccountCon) {
        _myAccountCon = [self getNewRequestCon:NO];
    }
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        return;
    }
    [_myAccountCon getMyAccount:userId];
}


- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case request_PayWithyuer:
        {
            NSDictionary *resultDic = dataArr[0];
            if ([resultDic[@"status"] isEqualToString:@"OK"]) {
                
                if ([Manager shareMgr].payType == PayTypeDiscuss) {
                
                    AspectantDiscussSuccessCtl *successCtl = [[AspectantDiscussSuccessCtl alloc]init];
                    [_delegate interviewPaySuccess];
                    [self.navigationController pushViewController:successCtl animated:YES];
                    return ;
                }
                else if ([Manager shareMgr].payType == PayTypeReward)
                {
                    if ([Manager shareMgr].dashangBackCtlIndex <self.navigationController.viewControllers.count) {
                        id ctl = self.navigationController.viewControllers[[Manager shareMgr].dashangBackCtlIndex];
                        [self.navigationController popToViewController:ctl animated:YES];
                        [Manager shareMgr].isShowRewardAnimat = YES;
                        if ([ctl isKindOfClass:[ELPersonCenterCtl class]]) {
                            [ctl loadPersonInformation];
                        }
                    }
                    return;
                }
                else if ([Manager shareMgr].payType == PayTypeQuerySalary)
                {
                    BuySuccessCtl *successCtl = [[BuySuccessCtl alloc]init];
                    [self.navigationController pushViewController:successCtl animated:YES];
                }
            }
            else{
                [BaseUIViewController showAutoDismissFailView:resultDic[@"stat_desc"] msg:nil seconds:0.5];
            }
        }
            break;
        case Request_GetWXPrepayId:
        {
            NSDictionary *result = [dataArr objectAtIndex:0];
            NSString *status = result[@"status"];
            if ([status isEqualToString:@"OK"]) {
                NSString *payid = result[@"payid"];
                if (payid) {
                    [self requestWXClient:payid];
                }
            }else{
#pragma mark 
                [BaseUIViewController showAlertView:nil msg:@"订单异常" btnTitle:@"确定"];
            }
        }
            break;
        case Request_GetMyAccount:
        {
            NSDictionary *result = dataArr[0];
            NSString *balance = result[@"person_balance"];
            if (balance.length <= 0) {
                balance = @"0";
            }
            _balancePayAmtLb.text = [NSString stringWithFormat:@"(%@元)", balance];
            balanceValue = [balance integerValue];
        }
        default:
            break;
    }
}

//取消支付，返回约谈
- (void)backToAspDisCtl
{
    [self.navigationController popToViewController:[Manager shareMgr].yuetanBackCtl animated:YES];
}

#pragma mark 支付成功挑转到订单列表页面
- (void)paySuccess:(NSNotification *)notification
{
    _payBtn.enabled = YES;
    if (notification && [Manager shareMgr].payType == PayTypeQuerySalary) {//微信支付付费查薪
        NSDictionary *userInfo = notification.userInfo;
        NSInteger errCode = [userInfo[@"errCode"] integerValue];
        if (errCode == 0) {//跳转到成功页面
            BuySuccessCtl *successCtl = [[BuySuccessCtl alloc]init];
            [self.navigationController pushViewController:successCtl animated:YES];
        }else{//跳转到订单页面
            [self paySalarySuccess];
        }
        return;
    }else if ([Manager shareMgr].payType == PayTypeResumeRecommed) {//简历直推购买 跳转到订单页面
        //简历直推购买
        NSInteger count = self.navigationController.childViewControllers.count;
        BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-2];
        if ([ctl isKindOfClass: [RRResumeOrderRecord class]]) {
            [self.navigationController popToViewController:ctl animated:YES];
            [ctl beginLoad:nil exParam:nil];
            return;
        }
        RRResumeOrderRecord *resumeOrderRecord = [[RRResumeOrderRecord alloc]init];
        [resumeOrderRecord beginLoad:nil exParam:nil];
        [self.navigationController pushViewController:resumeOrderRecord animated:YES];
        return;
    }else if (notification && [Manager shareMgr].payType == PayTypeDiscuss){//行家约谈服务
        NSDictionary *userInfo = notification.userInfo;
        NSInteger errCode = [userInfo[@"errCode"] integerValue];
        if (errCode == 0) {
            AspectantDiscussSuccessCtl *successCtl = [[AspectantDiscussSuccessCtl alloc]init];
            [_delegate interviewPaySuccess];
            [self.navigationController pushViewController:successCtl animated:YES];
            return ;
        }
        else
        {
            [self backToAspDisCtl];
            return;
        }
    }else if ([Manager shareMgr].payType == PayTypeReward){
        NSDictionary *userInfo = notification.userInfo;
        NSInteger errCode = [userInfo[@"errCode"] integerValue];
        if (errCode == 0) {
            if ([Manager shareMgr].dashangBackCtlIndex <self.navigationController.viewControllers.count) {
                id ctl = self.navigationController.viewControllers[[Manager shareMgr].dashangBackCtlIndex];
                [self.navigationController popToViewController:ctl animated:YES];
                [Manager shareMgr].isShowRewardAnimat = YES;
                
                if ([ctl isKindOfClass:[ELPersonCenterCtl class]]) {
                    [ctl loadPersonInformation];
                }
            }
            return;
        }else{
            return;
        }
    }
    //简历购买 跳转到订单页面
    NSInteger count = self.navigationController.childViewControllers.count;
    BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-2];
    if ([ctl isKindOfClass: [ResumeOrderRecord class]]) {
        [self.navigationController popToViewController:ctl animated:YES];
        [ctl beginLoad:nil exParam:nil];
        return;
    }
    ResumeOrderRecord *resumeOrderRecord = [[ResumeOrderRecord alloc]init];
    [resumeOrderRecord beginLoad:nil exParam:nil];
    [self.navigationController pushViewController:resumeOrderRecord animated:YES];
    return;
}

#pragma mark 支付薪指成功挑转到订单列表页面
- (void)paySalarySuccess
{
    NSInteger count = self.navigationController.childViewControllers.count;
    BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-2];
    if ([ctl isKindOfClass: [SalaryCompareOrderListCtl class]]) {
        [self.navigationController popToViewController:ctl animated:YES];
        [ctl beginLoad:nil exParam:nil];
        return;
    }
    SalaryCompareOrderListCtl *salaryOrderRecord = [[SalaryCompareOrderListCtl alloc]init];
    [salaryOrderRecord beginLoad:nil exParam:nil];
    [self.navigationController pushViewController:salaryOrderRecord animated:YES];
}

- (void)btnResponse:(UIButton *)sender
{
    if (sender == _payBtn) {//支付
//        sender.enabled = NO;
        if(_alipayBtn.selected){
            [self alipay];
        }
        else if(_weixinPayBtn.selected){//微信支付
            if( ![WXApi isWXAppInstalled ]){
                [BaseUIViewController showAlertView:nil msg:@"微信支付需要安装微信客户端" btnTitle:@"确定"];
                return;
            }
            if( ![WXApi isWXAppSupportApi ]){
                [BaseUIViewController showAlertView:nil msg:@"当前微信客户端不支持微信支付功能，请下载最新的版本" btnTitle:@"确定"];
                return;
            }
            [self weixinPay2];
        }
        else if(_balancePayBtn.selected){
            if (balanceValue >= [_order.amount integerValue]) {
                if (!yuerCon) {
                    yuerCon = [self getNewRequestCon:NO];
                }
                [yuerCon payWithyuer:_order.tradeNO];
            }else{
                [BaseUIViewController showAlertView:@"账户余额不足" msg:nil btnTitle:@"确定"];
                _balancePayBtn.enabled = YES;
            }
        }
    }else if (sender == _alipayBtn){//选择支付宝
        if (!_alipayBtn.selected) {
            
            [_selectAliImg setImage:[UIImage imageNamed:@"ok_06.png"]];
            [_selectWeixImg setImage:[UIImage imageNamed:@"no_11.png"]];
            [_selectYuerImg setImage:[UIImage imageNamed:@"no_11.png"]];
            
            _weixinPayBtn.selected = NO;
            _balancePayBtn.selected = NO;
            _alipayBtn.selected = YES;
        }
    }else if (sender == _weixinPayBtn){//选择微信支付
        if (!_weixinPayBtn.selected) {
            [_selectAliImg setImage:[UIImage imageNamed:@"no_11.png"]];
            [_selectWeixImg setImage:[UIImage imageNamed:@"ok_06.png"]];
            [_selectYuerImg setImage:[UIImage imageNamed:@"no_11.png"]];
            
            _alipayBtn.selected = NO;
            _balancePayBtn.selected = NO;
            _weixinPayBtn.selected = YES;
        }
    }else if (sender == _balancePayBtn){//选择余额支付
        if (!_balancePayBtn.selected) {
            [_selectAliImg setImage:[UIImage imageNamed:@"no_11.png"]];
            [_selectWeixImg setImage:[UIImage imageNamed:@"no_11.png"]];
            [_selectYuerImg setImage:[UIImage imageNamed:@"ok_06.png"]];
            
            _balancePayBtn.selected = YES;
            _alipayBtn.selected = NO;
            _weixinPayBtn.selected = NO;
        }
    }
}

#pragma mark 微信支付向服务端获取prepayID
- (void)weixinPay2
{
    if (!_getPrepayIdCon) {
        _getPrepayIdCon = [self getNewRequestCon:NO];
    }
    [_getPrepayIdCon getWXPrepayId:_order.tradeNO];
}

#pragma mark 请求微信客户端支付
- (void)requestWXClient:(NSString *)prePayId
{
    // 调起微信支付
    PayReq *request   = [[PayReq alloc] init];
    
    request.partnerId = WXPartnerId;
    request.prepayId  = prePayId;
    request.package   = @"Sign=WXPay";
    request.nonceStr  = [[WXPayClient shareInstance] genNonceStr];
    NSString *timeStampStr = [[WXPayClient shareInstance] genTimeStamp];
    request.timeStamp = (UInt32)[timeStampStr longLongValue];
    
    // 构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:WXAppId forKey:@"appid"];
    [params setObject:request.partnerId forKey:@"partnerid"];
    [params setObject:request.prepayId forKey:@"prepayid"];
    [params setObject:request.package forKey:@"package"];
    [params setObject:request.nonceStr forKey:@"noncestr"];
    [params setObject:timeStampStr forKey:@"timestamp"];
    
    request.sign = [[WXPayClient shareInstance] genSign:params];
    
    // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
    [WXApi sendReq:request];
}

#pragma mark 微信支付 微信服务器请求

- (void)weixinPay
{
    WXPayClient *wxPayClient = [WXPayClient shareInstance];
    wxPayClient.order = _order;
    [wxPayClient payProduct];
}

#pragma mark   ==============支付宝无线账户授权==============
+ (void)authLogin {
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = ALIPAY_PARTNER;
    NSString *appID = @"2015120800940532";
    NSString *privateKey = ALIPAY_PRIVATE_KEY;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者appID或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    APAuthV2Info *info = [APAuthV2Info new];
    info.pid = partner;
    info.appID = appID;
    info.authType = @"LOGIN";//默认是AUTHACCOUNT
    
    info.signDate = [[NSDate date] stringWithFormatDefault];
    
    NSString *authStr = [info description];
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signStr = [signer signString:authStr];
    
    signStr = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
               authStr, signStr, @"RSA"];
    
    [[AlipaySDK defaultService] auth_V2WithInfo:signStr
                                     fromScheme:@"yl1001"
                                       callback:^(NSDictionary *resultDic) {
                                           NSLog(@"result = %@",resultDic);
                                           NSString *resultStr = resultDic[@"result"];
                                           
                                           if (resultStr&&resultStr.length>0) {
                                               NSArray *resultArr = [resultStr componentsSeparatedByString:@"&"];
                                               
                                               for (NSString *subResult in resultArr) {
                                                   NSArray *subResultArr = [subResult componentsSeparatedByString:@"="];
                                                   if ([subResultArr[0] isEqualToString:@"auth_code"]) {
                                                       NSLog(@"authCode = %@",subResultArr[1]);
                                                       [ELRequest postbodyMsg:@"" op:@"" func:@"" requestVersion:YES
                                                                 progressFlag:NO progressMsg:nil success:^(NSURLSessionDataTask *operation, id result) {
                                                                     
                                                                 } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                                                     
                                                                 }];
                                                   }
                                               }
                                           }
                                       }];
}


#pragma mark 支付宝支付
- (void)alipay
{
    //支付宝支付
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    /*=======================需要填写商户app申请的===================================*/
    NSString *partner = ALIPAY_PARTNER;
    NSString *seller = ALIPAY_SELLER;
    NSString *privateKey = ALIPAY_PRIVATE_KEY;
    
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = self.order;
    order.partner = partner;
    order.seller = seller;
    //            order.tradeNO = [self generateTradeNO]; //订单ID（自行制定）
    //            order.productName = product.subject; //商品标题
    //            order.productDescription = product.body; //商品描述
    //            order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.job1001.com/inc/pay/alipay/app/notify_url.php"; //回调URL
     
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"http://m.job1001.com/";
    
    //应用注册scheme,在jobClient-Info.plist定义URL types
    NSString *appScheme = @"yl1001";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSDictionary *result =[PayCtl parseQueryString:resultDic[@"result"]];
            
            _payBtn.enabled = YES;
            
            if ([Manager shareMgr].payType == PayTypeDiscuss) {
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
                    AspectantDiscussSuccessCtl *successCtl = [[AspectantDiscussSuccessCtl alloc]init];
                    [_delegate interviewPaySuccess];
                    [self.navigationController pushViewController:successCtl animated:YES];
                    return ;
                }else{
                    [self backToAspDisCtl];
                    return;
                }
            }
            
            if ([Manager shareMgr].payType == PayTypeReward){
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
                    if ([Manager shareMgr].dashangBackCtlIndex <self.navigationController.viewControllers.count) {
                        id ctl = self.navigationController.viewControllers[[Manager shareMgr].dashangBackCtlIndex];
                        [self.navigationController popToViewController:ctl animated:YES];
                        [Manager shareMgr].isShowRewardAnimat = YES;
                    }
                    return;
                }
            }
            
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {//检查 resultStatus 以及 success="true"来判定支付结果
                
                if ([result[@"success"] isEqualToString:@"\"true\""]) {
                    [BaseUIViewController showAlertView:nil msg:@"支付成功" btnTitle:@"确定"];
                }
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]){
                [BaseUIViewController showAlertView:nil msg:@"订单正在处理中，请查看订单记录" btnTitle:@"确定"];
                return;
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]){
                [BaseUIViewController showAlertView:nil msg:@"订单支付失败" btnTitle:@"确定"];
                return;
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
                [BaseUIViewController showAlertView:nil msg:@"支付中途被取消" btnTitle:@"确定"];
                return;
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]){
                [BaseUIViewController showAlertView:nil msg:@"网络连接出错" btnTitle:@"确定"];
                return;
            }
            if ([Manager shareMgr].payType == PayTypeQuerySalary) {//薪指购买处理
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
                    BuySuccessCtl *successCtl = [[BuySuccessCtl alloc]init];
                    successCtl.orderId = resultDic[@"out_trade_no"];
                    [self.navigationController pushViewController:successCtl animated:YES];
                    return ;
                }else{
                    [self paySalarySuccess];
                    return;
                }
            }        //简历购买处理 简历直推
            [self paySuccess:nil];
        }];
        
    }
}

- (void)backBarBtnResponse:(id)sender
{
     [self showChooseAlertView:10 title:@"提示信息" msg:@"您还未支付，是否要离开" okBtnTitle:@"狠心离开" cancelBtnTitle:@"继续支付"];
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 10:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            continue;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (!key || !val) {
            continue;
        }
        [dict setObject:val forKey:key];
    }
    return dict;
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WX_PAY_SUCCESS" object:nil];
}

@end
