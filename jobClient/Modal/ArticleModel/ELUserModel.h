//
//  ELUserModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELUserModel : PageInfo
@property(nonatomic, copy) NSString *person_id;
@property(nonatomic, copy) NSString *iname;//昵称
@property(nonatomic, copy) NSString *yuex;//月薪
@property(nonatomic, copy) NSString *eduId;//教育id
@property(nonatomic, copy) NSString *school;//学校
@property(nonatomic, copy) NSString *job;//工作
@property(nonatomic, copy) NSString *bday;//出生日期？
@property(nonatomic, copy) NSString *gznum;//工作年龄
@property(nonatomic, copy) NSString *regionid;//地区id
@property(nonatomic, copy) NSString *sex;//性别
@property(nonatomic, copy) NSString *region_name;//地区
@property(nonatomic, copy) NSString *age;//年龄
@property(nonatomic, copy) NSString *edu;

@property(nonatomic, copy) NSString *person_pic;



- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
