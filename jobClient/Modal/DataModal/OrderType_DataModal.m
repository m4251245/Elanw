//
//  OrderType_DataModal.m
//  jobClient
//
//  Created by 一览iOS on 15-3-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OrderType_DataModal.h"

@implementation OrderType_DataModal

-(OrderType_DataModal *)initWithDictionary:(NSDictionary *)subDic
{
    self = [super init];
    if (self) {
        self.ordco_id = [subDic objectForKey:@"ordco_id"];
        self.ordco_gwc_id = [subDic objectForKey:@"ordco_gwc_id"];
        self.ordco_gwc_idate = [subDic objectForKey:@"ordco_gwc_idate"];
        self.ordco_gwc_for = [subDic objectForKey:@"ordco_gwc_for"];
        self.ordco_gwc_owner_id = [subDic objectForKey:@"ordco_gwc_owner_id"];
        self.ordco_gwc_owner_name = [subDic objectForKey:@"ordco_gwc_owner_name"];
        self.ordco_gwc_owner_belong_uname = [subDic objectForKey:@"ordco_gwc_owner_belong_uname"];
        self.tradeid = [subDic objectForKey:@"tradeid"];
        self.totalid = [subDic objectForKey:@"totalid"];
        self.ordco_service_code = [subDic objectForKey:@"ordco_service_code"];
        self.ordco_service_name = [subDic objectForKey:@"ordco_service_name"];
        self.ordco_service_detail_name = [subDic objectForKey:@"ordco_service_detail_name"];
        self.ordco_service_detail_id = [subDic objectForKey:@"ordco_service_detail_id"];
        self.ordco_gwc_price_original = [subDic objectForKey:@"ordco_gwc_price_original"];
        self.ordco_gwc_price = [subDic objectForKey:@"ordco_gwc_price"];
        self.ordco_gwc_paydate = [subDic objectForKey:@"ordco_gwc_paydate"];
        self.ordco_gwc_idatetime = [subDic objectForKey:@"ordco_gwc_idatetime"];
        self.ordco_gwc_status = [subDic objectForKey:@"ordco_gwc_status"];
        self.ordco_gwc_source = [subDic objectForKey:@"ordco_gwc_source"];
        self.ordco_gwc_buynums = [subDic objectForKey:@"ordco_gwc_buynums"];
    }
    return self;
}

@end
