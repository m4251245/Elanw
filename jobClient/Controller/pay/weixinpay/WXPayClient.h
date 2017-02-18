//
//  WXPayClient.h
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@class Order;

@interface WXPayClient : NSObject

+ (instancetype)shareInstance;

- (void)payProduct;

- (NSString *)genNonceStr;

- (NSString *)genTimeStamp;

- (NSString *)genSign:(NSDictionary *)signParams;

@property (nonatomic, strong) Order *order;

@end
