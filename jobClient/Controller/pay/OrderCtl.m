//
//  OrderCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OrderCtl.h"
#import "PayCtl.h"
#import "OrderService_DataModal.h"
#import "ServiceSelectCtl.h"
#import "Order.h"

@interface OrderCtl ()<ServiceSelectDelegate>
{
    OrderService_DataModal *_selectedService;
    RequestCon *_orderRequestCon;
}
@end

@implementation OrderCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"支付";
    [self setNavTitle:@"支付"];
    [self beginLoad:nil exParam:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (requestCon_ == nil) {
        requestCon_ = [self getNewRequestCon:NO];
        requestCon_.storeType_ = TempStoreType;
    }
    [requestCon_ getOrderServiceInfo:@"P_RESUME"];
}



- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetOrderServiceInfo://服务信息
            _serviceNameLb.text = requestCon_.dataArr_[0][@"ordco_service_name"];
            [requestCon_.dataArr_ removeObjectAtIndex:0];
            [self refreshService:requestCon_.dataArr_[0]];
            break;
        case Request_GenShoppingCart://生成订单
        {
            NSDictionary *orderDict = dataArr[0];
            if ([orderDict[@"status"] isEqualToString:@"SUCCESS"]) {
                NSString *orderId = orderDict[@"gwc_id"];
                Order *order = [[Order alloc]init];
                order.tradeNO = orderId;
                order.productName = orderDict[@"subject"];
                order.productDescription = orderDict[@"body"];
                order.amount = orderDict[@"payfree"];
                PayCtl *payCtl = [[PayCtl alloc]init];
                payCtl.order = order;
                [payCtl beginLoad:nil exParam:nil];
                [self.navigationController pushViewController:payCtl animated:YES ];
            }
        }
            break;
        default:
            break;
    }
}

- (void)refreshService:(OrderService_DataModal*)service
{
    _selectedService = service;
    [_personTypeBtn setTitle:service.levelName forState:UIControlStateNormal];
    [_versionTypeBtn setTitle:service.versionTypeName forState:UIControlStateNormal];
    _priceLb.text = [NSString stringWithFormat:@"¥ %@元", service.price];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)btnResponse:(UIButton *)sender
{
    if (sender == _nextBtn) {//下一步生成购物车，即未支付订单
//        sender.enabled = NO;
        if (!_orderRequestCon) {
            _orderRequestCon = [self getNewRequestCon:NO];
        }
        NSString *userId = [Manager getUserInfo].userId_;
        if (!userId) {
            [BaseUIViewController showAlertView:nil msg:@"请登录" btnTitle:@"确定"];
            return;
        }
        [Manager shareMgr].payType = PayTypeResumeBuy;
        [_orderRequestCon genShoppingCartWithServiceCode:_selectedService.serviceCode serviceId:_selectedService.resumeId userId:userId expertId:@""];
    }
}

- (IBAction)personTypeBtnClick:(UIButton *)sender {
    ServiceSelectCtl *ctl = [[ServiceSelectCtl alloc]init];
    ctl.serviceArr = requestCon_.dataArr_;
    ctl.delegate = self;
    [self.navigationController pushViewController:ctl animated:YES ];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    CGPoint point = self.scrollView_.contentOffset;
    if( point.y < 0 ){
        [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if( self.scrollView_.frame.size.height + point.y > self.scrollView_.contentSize.height ){
        if( self.scrollView_.frame.size.height > self.scrollView_.contentSize.height ){
            [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
        }else
            [self.scrollView_ setContentOffset:CGPointMake(0, self.scrollView_.contentSize.height - self.scrollView_.frame.size.height) animated:YES];
    }
    CGRect frame = self.toolbarHolder.frame;
    frame.origin.y = self.view.frame.size.height;
    self.toolbarHolder.frame = frame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTF) {
        [_userNameTF resignFirstResponder];
        [_phoneTF becomeFirstResponder];
        
    }else if (textField == _phoneTF) {
        [_phoneTF resignFirstResponder];
        [_emailTF becomeFirstResponder];
        
    }else if (textField == _emailTF) {
        [_emailTF resignFirstResponder];
        
    }
    return YES;
}

@end
