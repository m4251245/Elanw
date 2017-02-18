//
//  OrderService.h
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderService_DataModal : NSObject

@property(nonatomic, copy) NSString *resumeId;

@property(nonatomic, copy) NSString *serviceCode;

@property(nonatomic, copy) NSString *serviceName;

@property(nonatomic, copy) NSString *levelName;

@property(nonatomic, copy) NSString *versionTypeName;

@property(nonatomic, copy) NSString *versionType;

@property(nonatomic, copy) NSString *originPrice;

@property(nonatomic, copy) NSString *price;

@property(nonatomic, copy) NSString *isShow;

@property(nonatomic, copy) NSString *orders;

@property(nonatomic, copy) NSString *iDateTime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithResumeApplyDictionary:(NSDictionary *)dict;

@end
