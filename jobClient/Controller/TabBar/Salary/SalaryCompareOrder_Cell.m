//
//  SalaryCompareOrder_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/3/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryCompareOrder_Cell.h"
#import "OrderType_DataModal.h"

@implementation SalaryCompareOrder_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *layer = self.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += CELL_MARGIN_TOP;
    frame.size.height -= CELL_MARGIN_TOP;
    [super setFrame:frame];
}

- (void)setOrder:(OrderType_DataModal *)order
{
    _orderNumLb.text = order.ordco_gwc_id;
    _amountLb.text = [NSString stringWithFormat:@"￥%@", order.ordco_gwc_price];
    _serviceContentLb.text = order.ordco_service_detail_name;
    _orderTime.text = order.ordco_gwc_idatetime;

    if ([order.order_use_status isKindOfClass:[NSDictionary class]]) {//已经购买
        _payBtn.hidden = YES;
        _amountLb.textColor = [UIColor lightGrayColor];
        NSDictionary *orderUseStatus = order.order_use_status;
        if ([orderUseStatus[@"all_select_nums"] isEqualToString:orderUseStatus[@"use_select_nums"]]) {//已用完
            _tipsView1.hidden = NO;
            _tipsView2.hidden = YES;
            _countUsedImgv.hidden = NO;
        }else{//未用完
            _tipsView1.hidden = YES;
            _tipsView2.hidden = NO;
//            _tipsView2.frame = _tipsView1.frame;
            [self.contentView bringSubviewToFront:_tipsView2];
            _countUsedImgv.hidden = YES;
            _countLb.text = [NSString stringWithFormat:@"%d", [orderUseStatus[@"all_select_nums"] intValue] - [orderUseStatus[@"use_select_nums"] intValue]];
        }
    }else{//没有购买
        _payBtn.hidden = NO;
        _countUsedImgv.hidden = YES;
        
        _amountLb.textColor = [UIColor colorWithRed:225.f/255 green:15.f/255 blue:25.f/255 alpha:1.f];
        NSString *orderStatus = order.ordco_gwc_status;
        if ([orderStatus isEqualToString:@"0"]) {
            [_payBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [_payBtn setBackgroundColor:[UIColor colorWithRed:227.f/225 green:15.f/225 blue:25.f/225 alpha:1.f]];
        }else if ([orderStatus isEqualToString:@"100"]){
            [_payBtn setTitle:@"已支付" forState:UIControlStateNormal];
            [_payBtn setBackgroundColor:[UIColor grayColor]];
        }else{
            [_payBtn setTitle:@"已过期" forState:UIControlStateNormal];
            [_payBtn setBackgroundColor:[UIColor grayColor]];
        }
    }
}

@end
