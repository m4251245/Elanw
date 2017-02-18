//
//  MyTradeRecordModal.h
//  jobClient
//
//  Created by YL1001 on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface MyTradeRecordModal : PageInfo

@property (nonatomic, copy) NSString *bill_type;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *target_person_id;
@property (nonatomic, copy) NSString *bill_desc;
@property (nonatomic, copy) NSString *idatetime;
@property (nonatomic, copy) NSString *bill_status;
@property (nonatomic, copy) NSString *is_income;
@property (nonatomic, copy) NSString *bill_type_name;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *service_detail_id;

@end
