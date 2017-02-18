//
//  MyQuestionAndAnswerModal.h
//  jobClient
//
//  Created by YL1001 on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface MyQuestionAndAnswerModal : PageInfo


/*
 我的问答
 */
@property (nonatomic, copy) NSString *is_new;
@property (nonatomic, copy) NSString *question_title;
@property (nonatomic, copy) NSString *question_idate;
@property (nonatomic, copy) NSString *question_replys_count;
@property (nonatomic, copy) NSString *question_id;
@property (nonatomic, copy) NSString *question_content;

@property (nonatomic, strong) NSDictionary *person_info;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *person_id;

@property (nonatomic, strong) NSDictionary *question_person_info;
@property (nonatomic, copy) NSString *question_person_pic;
@property (nonatomic, copy) NSString *question_person_iname;
@property (nonatomic, copy) NSString *question_person_id;

@property (nonatomic, strong) NSDictionary *answer_info;
@property (nonatomic, copy) NSString *answer_content;
@property (nonatomic, copy) NSString *answer_idate;
@property (nonatomic, copy) NSString *answer_id;
@property (nonatomic, copy) NSString *manage_status;
@property (nonatomic, copy) NSString *question_status;

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect titleFrame;
@property (nonatomic,assign) CGRect contentFrame;
@property (nonatomic,strong) NSMutableAttributedString *titleAttString;
@property (nonatomic,strong) NSMutableAttributedString *contentAttString;

- (instancetype)initWithdict:(NSDictionary *)dict;

@end
