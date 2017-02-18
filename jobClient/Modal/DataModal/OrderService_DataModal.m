//
//  OrderService.m
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OrderService_DataModal.h"

@implementation OrderService_DataModal

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self == [super init]) {
        self.resumeId = dict[@"ordco_p_resume_id"];
        self.serviceCode = dict[@"ordco_service_code"];
        self.serviceName = dict[@"ordco_service_name"];
        self.levelName = dict[@"ordco_level_name"];
        self.versionTypeName = dict[@"ordco_time"];
        self.versionType = dict[@"ordco_type"];
        self.originPrice = dict[@"service_price_ori"];
        self.price = dict[@"service_price"];
        self.isShow = dict[@"ordco_is_show"];
        self.orders = dict[@"orders"];
        self.iDateTime = dict[@"ordco_idatetime"];
    }
    return self;
}

- (instancetype)initWithResumeApplyDictionary:(NSDictionary *)dict
{
    if (self == [super init]) {
        self.resumeId = dict[@"zhitui_service_id"];
        self.levelName = dict[@"service_detail_name"];
        self.originPrice = dict[@"service_price_ori"];
        self.price = dict[@"service_price"];
        self.orders = dict[@"orders"];
    }
    return self;
}

@end
