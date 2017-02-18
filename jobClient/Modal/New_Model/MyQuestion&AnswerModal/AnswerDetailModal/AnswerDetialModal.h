//
//  AnswerDetialModal.h
//  jobClient
//
//  Created by YL1001 on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "AnswerListModal.h"

@interface AnswerDetialModal : PageInfo

/*
 问答详情
 */

//questionInfo
@property (nonatomic, copy) NSString *question_title;
@property (nonatomic, copy) NSString *question_replys_count;
@property (nonatomic, copy) NSString *question_idate;
@property (nonatomic, copy) NSString *is_recommend;
@property (nonatomic, copy) NSString *question_id;
@property (nonatomic, copy) NSString *question_content;
@property (nonatomic, copy) NSString *old_question_content;
@property (nonatomic, copy) NSString *question_view_count;
@property (nonatomic, copy) NSString *totalid;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *question_status;
@property (nonatomic, strong) NSArray *tag_info;

@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, strong) NSArray *relative_question_list;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
