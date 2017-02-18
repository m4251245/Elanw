//
//  ELGroupExpertModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupExpertModel : PageInfo

@property (nonatomic, copy) NSString *first_a_time;
@property (nonatomic, copy) NSString *expert_id;
@property (nonatomic, copy) NSString *orders;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *recommend_active;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *good_at;
@property (nonatomic, copy) NSString *uname;
@property (nonatomic, copy) NSString *recommend_tradeid;
@property (nonatomic, copy) NSString *all_topic;
@property (nonatomic, copy) NSString *personid;
@property (nonatomic, copy) NSString *c_time;
@property (nonatomic, copy) NSString *complex;
@property (nonatomic, copy) NSString *totalid;
@property (nonatomic, copy) NSString *is_expert;
@property (nonatomic, copy) NSString *recommend_totalid;
@property (nonatomic, copy) NSString *id_;
@property (nonatomic, copy) NSString *iname;
@property (nonatomic, copy) NSString *belongs;
@property (nonatomic, copy) NSString *recommend_admin;
@property (nonatomic, copy) NSString *topic_id;
@property (nonatomic, copy) NSString *recommend_yjs;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *orders_active;
@property (nonatomic, copy) NSString *modeflag;
@property (nonatomic, copy) NSString *recommend_yl;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *modetype;
@property (nonatomic, copy) NSString *orders_yl;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
