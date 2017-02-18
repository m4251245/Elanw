//
//  SameTradeSection_DataModal.h
//  jobClient
//
//  Created by 一览ios on 15/3/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface SameTradeSection_DataModal : PageInfo

@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) NSArray *dataArray;

@property(nonatomic, copy) NSString *type;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
