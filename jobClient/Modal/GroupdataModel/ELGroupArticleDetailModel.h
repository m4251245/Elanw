//
//  ELGroupArticleDetailModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupArticleDetailModel : PageInfo

@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *group_code;
@property (nonatomic, copy) NSString *person_zw;
@property (nonatomic, copy) NSString *person_nickname;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic,copy)  NSString *is_expert;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *like_cnt;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *info_type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *qi_id;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *fujian_flag;
@property (nonatomic, copy) NSString *c_cnt;
@property (nonatomic,strong) NSArray *_pic_list;
@property (nonatomic,strong) NSMutableArray *_comment_list;
@property (nonatomic,strong) NSMutableArray *_agree_list;

-(id)initWithDictionary:(NSDictionary *)dic;
-(id)initWithGroupDictionary:(NSDictionary *)dic;

@end
