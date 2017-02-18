//
//  MyTradeRecordModal.m
//  jobClient
//
//  Created by YL1001 on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "MyTradeRecordModal.h"

@implementation MyTradeRecordModal

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"record_info"]) {
        NSDictionary *dict = value;
        self.service_detail_id = dict[@"service_detail_id"];
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

@end
