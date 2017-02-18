//
//  OrderType_DataModal.h
//  jobClient
//
//  Created by 一览iOS on 15-3-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface OrderType_DataModal : PageInfo

@property (nonatomic,copy) NSString *ordco_id;
@property (nonatomic,copy) NSString *ordco_gwc_id;
@property (nonatomic,copy) NSString *ordco_gwc_idate;
@property (nonatomic,copy) NSString *ordco_gwc_for;
@property (nonatomic,copy) NSString *ordco_gwc_owner_id;
@property (nonatomic,copy) NSString *ordco_gwc_owner_name;
@property (nonatomic,copy) NSString *ordco_gwc_owner_belong_uname;
@property (nonatomic,copy) NSString *tradeid;
@property (nonatomic,copy) NSString *totalid;
@property (nonatomic,copy) NSString *ordco_service_code;
@property (nonatomic,copy) NSString *ordco_service_name;
@property (nonatomic,copy) NSString *ordco_service_detail_name;
@property (nonatomic,copy) NSString *ordco_service_detail_id;
@property (nonatomic,copy) NSString *ordco_gwc_price_original;
@property (nonatomic,copy) NSString *ordco_gwc_price;
@property (nonatomic,copy) NSString *ordco_gwc_paydate;
@property (nonatomic,copy) NSString *ordco_gwc_idatetime;
@property (nonatomic,copy) NSString *ordco_gwc_status;//支付状态，订单状态
@property (nonatomic,copy) NSString *ordco_gwc_source;
@property (nonatomic,copy) NSString *ordco_gwc_buynums;
@property (nonatomic,copy) NSString *ordco_gwc_isIncome; //退款中
@property (nonatomic,copy) NSString *ordco_gwc_type; //打赏 约谈 提现
@property (nonatomic,copy) NSString *rewardImgId;  //打赏图片类型

@property (nonatomic,copy) NSDictionary *order_use_status;//订单使用状态，已用完，未用完


-(OrderType_DataModal *)initWithDictionary:(NSDictionary *)subDic;

@end
