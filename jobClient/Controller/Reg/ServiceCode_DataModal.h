//
//  ServiceCode_DataModal.h
//  jobClient
//
//  Created by 一览ios on 14/12/24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//无法返回验证码 注册第一步返回的服务码

#import <Foundation/Foundation.h>

@interface ServiceCode_DataModal : NSObject

@property(nonatomic, copy) NSString *number;
@property(nonatomic, copy) NSString *code;

@end
