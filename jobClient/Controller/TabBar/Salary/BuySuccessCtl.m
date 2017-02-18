//
//  BuySuccessCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BuySuccessCtl.h"
#import "SalaryCompareOrderListCtl.h"
#import "SalaryCompeteCtl.h"

@interface BuySuccessCtl ()

@end

@implementation BuySuccessCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"购买成功";
    [self setNavTitle:@"购买成功"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark 查看订单
- (IBAction)showOrderBtnClick:(id)sender {
    NSInteger count = self.navigationController.childViewControllers.count;
    BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-3];
    if ([ctl isKindOfClass: [SalaryCompareOrderListCtl class]]) {
        [self.navigationController popToViewController:ctl animated:YES];
        [ctl beginLoad:nil exParam:nil];
        return;
    }
    SalaryCompareOrderListCtl *salaryCompareOrderListCtl = [[SalaryCompareOrderListCtl alloc]init];
    [self.navigationController pushViewController:salaryCompareOrderListCtl animated:YES];
    [salaryCompareOrderListCtl beginLoad:nil exParam:nil];
}

#pragma mark 马上去查看薪酬
- (IBAction)showSalaryBtnClick:(id)sender {
    SalaryCompeteCtl *competeCtl = [[SalaryCompeteCtl alloc]init];
    competeCtl.orderId = _orderId;
    [self.navigationController pushViewController:competeCtl animated:YES];
}

- (void)backBarBtnResponse:(id)sender
{
    NSInteger count = self.navigationController.childViewControllers.count;
    BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-3];
    [self.navigationController popToViewController:ctl animated:YES];
}

@end
