//
//  ELJobSearchModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELJobSearchModel : PageInfo
@property(nonatomic, copy) NSString *zwId;
@property(nonatomic, copy) NSString *jtzw;
@property(nonatomic, copy) NSString *uid;//公司id
@property(nonatomic, copy) NSString *cname;//公司名字
@property(nonatomic, copy) NSString *cname_all;
@property(nonatomic, copy) NSString *regionname;//地区
@property(nonatomic, copy) NSString *updatetime;
@property(nonatomic, copy) NSString *xzdy;//薪水
@property(nonatomic, strong) NSArray *fldy;
@property(nonatomic, copy) NSString *logo;//公司logo

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
