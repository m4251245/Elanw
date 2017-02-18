//
//  ELActivityModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELActivityModel : PageInfo

@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *gaa_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cnt;
@property (nonatomic, copy) NSString *idatetime;
@property (nonatomic, copy) NSString *own_id;
@property (nonatomic, copy) NSString *need_info;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *need_join;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *last_join_time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *id_;
@property (nonatomic, copy) NSString *regionid;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *qi_id;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *joinTime;
@property (nonatomic, copy) NSString *join_cnt;
@property (nonatomic, copy) NSString *is_create_group;
@property (nonatomic, copy) NSString *group_id;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
