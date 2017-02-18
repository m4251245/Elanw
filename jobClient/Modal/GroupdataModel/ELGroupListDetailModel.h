//
//  ELGroupListDetailModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupListDetailModel : PageInfo

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *status_desc;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *group_person_id;
@property (nonatomic, copy) NSString *group_pic;
@property (nonatomic, copy) NSString *group_person_cnt;
@property (nonatomic, copy) NSString *group_article_cnt;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *group_open_status;
@property (nonatomic, copy) NSString *_dynamic_cnt;
@property (nonatomic, copy) NSString *updatetime_act_last;
@property (nonatomic, strong) NSMutableArray *_article;
@property(nonatomic,copy) NSString *articleListContent;
@property(nonatomic,strong) NSMutableAttributedString *attStringTitle;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
