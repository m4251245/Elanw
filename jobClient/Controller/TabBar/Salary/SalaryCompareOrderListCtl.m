//
//  SalaryCompareOrderListCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
// 比薪水订单列表

#import "SalaryCompareOrderListCtl.h"
#import "SalaryCompareOrder_Cell.h"
#import "OrderType_DataModal.h"
#import "Order.h"
#import "PayCtl.h"
#import "SalaryCompeteCtl.h"
#import "SalaryCompareQueryListCtl.h"
#import "BuySuccessCtl.h"

@interface SalaryCompareOrderListCtl ()

@end

@implementation SalaryCompareOrderListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"我的订单";
    [self setNavTitle:@"我的订单"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    bFooterEgo_ = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        [BaseUIViewController showAlertView:nil msg:@"请登录后再查看" btnTitle:@"确定"];
        return;
    }
    [con getSalaryOrderRecord:userId pageSize:requestCon_.pageInfo_.pageSize_ pageIndex:requestCon_.pageInfo_.currentPage_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SalaryCompareOrder_Cell";
    SalaryCompareOrder_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SalaryCompareOrder_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.payBtn addTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goUseBtn addTarget:self action:@selector(goQuerySalary:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.payBtn.tag = indexPath.row + 1001;
    cell.goUseBtn.tag = indexPath.row + 1001;
    OrderType_DataModal *order = requestCon_.dataArr_[indexPath.row];
    [cell setOrder:order];
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];

//    OrderType_DataModal *modal = selectData;
//    Order *order = [[Order alloc] init];
//    order.tradeNO = modal.ordco_gwc_id;
//    order.productName = modal.ordco_service_name;
//    order.productDescription = modal.ordco_service_detail_name;
//    order.amount = modal.ordco_gwc_price;
//    PayCtl *payCtl = [[PayCtl alloc]init];
//    payCtl.order = order;
//    [self.navigationController pushViewController:payCtl animated:YES ];
//    [payCtl beginLoad:nil exParam:nil];
}

#pragma mark 支付订单
- (void)goPay:(UIButton *)sender
{
    
    [Manager shareMgr].payType = PayTypeQuerySalary;
    NSInteger index = sender.tag -1001;
    
    OrderType_DataModal *modal = requestCon_.dataArr_[index];
    Order *order = [[Order alloc]init];
    order.tradeNO = modal.ordco_gwc_id;
    order.productName = modal.ordco_service_name;
    order.productDescription = modal.ordco_service_detail_name;
    order.amount = modal.ordco_gwc_price;
    PayCtl *payCtl = [[PayCtl alloc]init];
    payCtl.order = order;
    [self.navigationController pushViewController:payCtl animated:YES ];
    [payCtl beginLoad:nil exParam:nil];
}

#pragma mark 查询薪指
- (void)goQuerySalary:(UIButton *)sender
{
    NSInteger index = sender.tag -1001;
    OrderType_DataModal *order = requestCon_.dataArr_[index];
    NSInteger count = self.navigationController.childViewControllers.count;
    SalaryCompeteCtl *ctl  =self.navigationController.childViewControllers[count-2];
    if ([ctl isKindOfClass: [SalaryCompeteCtl class]]) {
        ctl.orderId = order.ordco_gwc_id;
        [self.navigationController popToViewController:ctl animated:YES];
        return;
    }
    
    SalaryCompeteCtl *competeCtl = [[SalaryCompeteCtl alloc]init];
    competeCtl.orderId = order.ordco_gwc_id;
    [self.navigationController pushViewController:competeCtl animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height ;
    OrderType_DataModal *order = requestCon_.dataArr_[indexPath.row];
    if ([order.order_use_status isKindOfClass:[NSDictionary class]]) {//已经购买
        height = 130.f + 4;
    }else{//没有购买
        height = 106.f + 4;
    }

    return height + CELL_MARGIN_TOP;
}

- (void)btnResponse:(id)sender
{
    if (sender == myRightBarBtnItem_) {
        [self rightBarBtnResponse:sender ];
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    SalaryCompareQueryListCtl *queryCtl = [[SalaryCompareQueryListCtl alloc]init];
    [self.navigationController pushViewController:queryCtl animated:YES];
    [queryCtl beginLoad:nil exParam:nil];
}


@end
