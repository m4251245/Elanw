//
//  OrderCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RROrderCtl.h"
#import "PayCtl.h"
#import "OrderService_DataModal.h"
#import "RRServiceSelectCtl.h"
#import "Order.h"

@interface RROrderCtl ()<ServiceSelectDelegate>
{
    RequestCon *_orderRequestCon;
}
@end

@implementation RROrderCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    _tips2Lb.hidden = YES;
//    self.navigationItem.title = @"选择套餐";
    [self setNavTitle:@"选择套餐"];
    if (_applyStatus == ResumeRecommendPay) {//购买状态
        [self showPayStatusView];
    }
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
    [requestCon_ getResumeApplyServiceInfo:[Manager  getUserInfo].userId_];//简历直推信息
}



- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetResumeApplyServiceInfo://服务信息
            if ([[requestCon_.dataArr_ lastObject] isKindOfClass:[NSString class]]) {
                _phoneTF.text = [requestCon_.dataArr_ lastObject];
                [requestCon_.dataArr_ removeLastObject];
            }
            if (_applyStatus == ResumeRecommendPay) {
                if (_serviceDetailId) {
                    for (OrderService_DataModal *service in requestCon_.dataArr_) {
                        if ([service.resumeId isEqualToString:_serviceDetailId ]) {
                            [self refreshService:service];
                            break;
                        }
                    }
                    break;
                }
            }
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
        case Request_ApplyResumeRecommend://简历直推申请
        {
            Status_DataModal *statusModel = dataArr[0];
            if ([statusModel.code_ isEqualToString: @"200"]) {
                if ([statusModel.status_ isEqualToString:Success_Status]) {
                    [BaseUIViewController showAutoDismissSucessView:nil msg:statusModel.des_];
                    [_nextBtn setTitle:statusModel.des_ forState:UIControlStateNormal];
                    [_personTypeBtn setImage:[[UIImage alloc]init] forState:UIControlStateNormal];
                    _nextBtn.userInteractionEnabled = NO;
                    //跳转到详情页面
                    [self showDetailView];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 详情页面
- (void)showDetailView
{
    _personTypeBtn.userInteractionEnabled = NO;
    _tips1Lb.hidden = YES;
    _tips2Lb.hidden = NO;
    _phoneView.hidden = YES;
    [_personTypeBtn setImage:nil forState:UIControlStateNormal];
    CGRect frame = _nextBtn.frame;
    CGFloat nextBtnY = CGRectGetMaxY(_contentView.frame);
    frame.origin.y = nextBtnY + 28;
    _nextBtn.frame = frame;
    frame = _tips2Lb.frame;
    CGFloat tips2LbY = CGRectGetMaxY(_nextBtn.frame);
    frame.origin.y = tips2LbY + 8;
    _tips2Lb.frame = frame;
}

#pragma mark 支付页面
- (void)showPayStatusView
{
    _personTypeBtn.userInteractionEnabled = NO;
    _tips1Lb.hidden = YES;
    _tips2Lb.hidden = YES;
    _phoneView.hidden = YES;
    [_personTypeBtn setImage:nil forState:UIControlStateNormal];
    CGRect frame = _nextBtn.frame;
    CGFloat nextBtnY = CGRectGetMaxY(_contentView.frame);
    frame.origin.y = nextBtnY + 28;
    _nextBtn.frame = frame;
    [_nextBtn setTitle:@"立即支付" forState:UIControlStateNormal];
}

- (void)refreshService:(OrderService_DataModal*)service
{
    _selectedService = service;
    [_personTypeBtn setTitle:service.levelName forState:UIControlStateNormal];
    _priceLb.text = [NSString stringWithFormat:@"¥ %@元", service.price];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)btnResponse:(UIButton *)sender
{
    if (sender == _nextBtn) {//下一步如果状态为申请状态，则申请简历推荐，如果可以支付，则到支付页面
        
        if (!_orderRequestCon) {
            _orderRequestCon = [self getNewRequestCon:NO];
        }
        
        NSString *userId = [Manager getUserInfo].userId_;
        if (!userId) {
            [BaseUIViewController showAlertView:nil msg:@"请登录" btnTitle:@"确定"];
            return;
        }
        //如果状态为申请的状态
        if (_applyStatus == ResumeRecommendApply) {//申请
            [_orderRequestCon applyResumeRecommend:userId serviceDetailId:_selectedService.resumeId];
            
        }else if(_applyStatus == ResumeRecommendPay){//去购买
            [Manager shareMgr].payType = PayTypeResumeRecommed;//简历直推
            [_orderRequestCon genShoppingCartWithServiceCode:@"P_ZHITUI" serviceId:_selectedService.resumeId userId:userId expertId:@""];
        }
        return;
        
    }
}

- (IBAction)personTypeBtnClick:(UIButton *)sender {
    RRServiceSelectCtl *ctl = [[RRServiceSelectCtl alloc]init];
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
    if (textField == _phoneTF) {
        [_phoneTF resignFirstResponder];
    }
    return YES;
}

@end
