//
//  ResumeOrderRecordCell.m
//  jobClient
//
//  Created by 一览iOS on 15-3-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RRResumeOrderCell.h"

@implementation RRResumeOrderCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)giveDateWithModal:(OrderType_DataModal *)dataModal
{ 
    /*
     NSTimeInterval time = [[MyCommon getDate:modal.ordco_gwc_idatetime] timeIntervalSinceNow];
     time = -time;
     
     && time < (30*60)
     */
    if ([dataModal.ordco_gwc_status isEqualToString:@"0"])
    {
        self.timeLable.text = [NSString stringWithFormat:@"下单时间 %@",dataModal.ordco_gwc_idatetime];
        [self.payBtn setTitle:@"支付" forState:UIControlStateNormal];
        self.payBtn.backgroundColor = REDCOLOR;
        self.payBtn.enabled = YES;
    }
    else if([dataModal.ordco_gwc_status isEqualToString:@"100"])
    {
        self.timeLable.text = [NSString stringWithFormat:@"支付时间 %@",dataModal.ordco_gwc_paydate];
        [self.payBtn setTitle:@"已支付" forState:UIControlStateNormal];
        self.payBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    }
    else
    {
        self.timeLable.text = [NSString stringWithFormat:@"下单时间 %@",dataModal.ordco_gwc_idatetime];
        [self.payBtn setTitle:@"已过期" forState:UIControlStateNormal];
        self.payBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    }
    self.priceLable.text = [NSString stringWithFormat:@"￥%@",dataModal.ordco_gwc_price];
    self.workExpreience.text = dataModal.ordco_service_detail_name;
    self.ordertype.text = @"";
    
}

@end
