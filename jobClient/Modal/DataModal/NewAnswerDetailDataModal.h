//
//  NewAnswerDetailDataModal.h
//  jobClient
//
//  Created by 一览iOS on 15-3-20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface NewAnswerDetailDataModal : PageInfo

@property (nonatomic,copy) NSString *question_id;
@property (nonatomic,copy) NSString *question_title;
@property (nonatomic,copy) NSString *question_replys_count;
@property (nonatomic,copy) NSString *question_view_count;
@property (nonatomic,copy) NSString *question_idate;
@property (nonatomic,copy) NSString *question_content;
@property (nonatomic,copy) NSString *person_id;
@property (nonatomic,copy) NSString *person_iname;
@property (nonatomic,copy) NSString *person_pic;
@property (nonatomic,strong) NSMutableArray *tagArray;
@property(nonatomic,strong) NSString *isRecommend;         // 是否为悬赏问答，1是 0或空不是

-(NewAnswerDetailDataModal *)initWithDictionary:(NSDictionary *)dic;

@end
