//
//  ResumeOrderRecord.m
//  jobClient
//
//  Created by 一览iOS on 15-3-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ResumeOrderRecord.h"
#import "ResumeOrderRecordCell.h"
#import "OrderType_DataModal.h"
#import "Order.h"
#import "PayCtl.h"
#import "ServiceInfo.h"

@interface ResumeOrderRecord ()
{
    RequestCon *_shouldPayCon;
    Order *_selectedOrder;
}
@end

@implementation ResumeOrderRecord

-(id)init
{
    self = [super init];
    
    bFooterEgo_ = YES;
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"订单记录";
    [self setNavTitle:@"订单记录"];
    // Do any additional setup after loading the view from its nib.
    [tableView_ setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getOrderRecord:[Manager getUserInfo].userId_ pageSize:15 serviceCode:@"P_RESUME" gwcFor:@"20" pageIndex:requestCon_.pageInfo_.currentPage_];
}
-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_GetOrderReocrd:
        
            break;
        case Request_GetServiceStatus://服务状态
        {
            NSDictionary *dict = dataArr[0];
            NSString * result = dict[@"result"];
            if ([result isEqualToString:@"0"] || [result isEqualToString:@"null"] || [result isEqualToString:@""]) {
                [Manager shareMgr].payType = PayTypeResumeBuy;
                NSInteger count = self.navigationController.childViewControllers.count;
                PayCtl *ctl  =self.navigationController.childViewControllers[count-2];
                if ([ctl isKindOfClass: [PayCtl class]]) {
                    ctl.order = _selectedOrder;
                    [self.navigationController popToViewController:ctl animated:YES];
                    return;
                }
                PayCtl *payCtl = [[PayCtl alloc]init];
                payCtl.order = _selectedOrder;
                [self.navigationController pushViewController:payCtl animated:YES ];
            }else{
                [BaseUIViewController showAlertView:nil msg:@"您已经购买了该类服务" btnTitle:@"确定"];
            }
        }
            break;
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResumeOrderRecordCell";
    
    ResumeOrderRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ResumeOrderRecordCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.payBtn.enabled = NO;
    
    OrderType_DataModal *modal = requestCon_.dataArr_[indexPath.row];
    [cell giveDateWithModal:modal];
    
    cell.payBtn.tag = indexPath.row;
    [cell.payBtn addTarget:self action:@selector(btnPayCtl:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)btnPayCtl:(UIButton *)sender
{
    OrderType_DataModal *modal = requestCon_.dataArr_[sender.tag];
    Order *order = [[Order alloc]init];
    order.tradeNO = modal.ordco_gwc_id;
    order.productName = modal.ordco_service_name;
    order.productDescription = modal.ordco_service_detail_name;
    order.amount = modal.ordco_gwc_price;
    _selectedOrder = order;
    [self shouldPay];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBarBtnResponse:(id)sender
{
    UIViewController *tmpCtl = nil;
    for ( UIViewController *ctl in self.navigationController.viewControllers ) {
        if( [ctl isKindOfClass:[ServiceInfo class]] ){
            tmpCtl = ctl;
            break;
        }
    }
    
    [self.navigationController popToViewController:tmpCtl animated:YES];
}

- (void)shouldPay
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        [BaseUIViewController showAlertView:nil msg:@"请登录后再操作" btnTitle:@"确定"];
        return;
    } 
    //20 个人用户，企业用户不需要
    if (!_shouldPayCon) {
        _shouldPayCon = [self getNewRequestCon:NO];
    }
    [_shouldPayCon getServiceStatus:@"20" userId:userId serviceCode:@"P_RESUME"];
}

@end
