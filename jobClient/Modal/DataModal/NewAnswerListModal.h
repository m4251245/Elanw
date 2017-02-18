//
//  NewAnswerListModal.h
//  jobClient
//
//  Created by 一览iOS on 15-3-20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "Comment_DataModal.h"
#import "NewAnswerDetailDataModal.h"

@interface NewAnswerListModal : PageInfo


@property (nonatomic,copy) NSString *answer_id;
@property (nonatomic,copy) NSString *answer_content;
@property (nonatomic,copy) NSString *answer_support_count;
@property (nonatomic,copy) NSString *answer_comment_count;
@property (nonatomic,copy) NSString *answer_idate;
@property (nonatomic,copy) NSString *person_id;
@property (nonatomic,copy) NSString *person_iname;
@property (nonatomic,copy) NSString *person_pic;
@property (nonatomic,copy) NSString *dashangTotal;
@property (nonatomic,strong) NSMutableArray *commentList;
@property (nonatomic,strong) NewAnswerDetailDataModal *answerModal;

@property (nonatomic,assign) BOOL isExpert;
@property (nonatomic,copy) NSString *is_support;

-(NewAnswerListModal *)initWithDictionary:(NSDictionary *)dic;

@end
