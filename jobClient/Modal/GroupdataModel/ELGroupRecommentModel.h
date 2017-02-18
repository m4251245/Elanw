//
//  ELGroupRecommentModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupRecommentModel : PageInfo

@property(nonatomic,copy) NSString *group_id;
@property(nonatomic,copy) NSString *group_code;
@property(nonatomic,copy) NSString *group_pic;
@property(nonatomic,copy) NSString *group_person_cnt;
@property(nonatomic,copy) NSString *group_name;
@property(nonatomic,copy) NSString *group_article_cnt;
@property(nonatomic,copy) NSString *article_id;
@property(nonatomic,copy) NSString *own_id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *own_name;
@property(nonatomic,copy) NSString *updatetime_act_last;
@property(nonatomic,strong) NSMutableArray *_comment;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
