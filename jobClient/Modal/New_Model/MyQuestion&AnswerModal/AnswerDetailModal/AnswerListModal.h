//
//  AnswerListModal.h
//  jobClient
//
//  Created by YL1001 on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ReplyCommentModal.h"
#import "ELSameTradePeopleModel.h"
#import "ELButtonView.h"

@interface AnswerListModal : PageInfo

/*
 问答详情回答列表
 */

@property (nonatomic, copy) NSString *dashang_total;
@property (nonatomic, copy) NSString *answer_comment_count;
@property (nonatomic, copy) NSString *answer_idate;
@property (nonatomic, copy) NSString *answer_id;
@property (nonatomic, copy) NSString *answer_content;
@property (nonatomic, copy) NSString *is_support;
@property (nonatomic, copy) NSString *answer_support_count;
@property (nonatomic, copy) NSString *manage_status;

@property (nonatomic,strong) ELSameTradePeopleModel *answer_person_detail; 
//@property (nonatomic, assign) BOOL is_expert;
//@property (nonatomic, copy) NSString *person_pic;
//@property (nonatomic, copy) NSString *person_id;
//@property (nonatomic, copy) NSString *person_iname;
//@property (nonatomic, copy) NSString *person_job_now;

@property (nonatomic, copy) NSString *article_id;

//commentInfo
@property (nonatomic, strong) NSMutableArray *comment_list;
@property (nonatomic, strong) NSMutableAttributedString *personNameAttString;
@property (nonatomic, strong) NSMutableAttributedString *answerContentAttString;
@property (nonatomic, assign) CGRect answerFrame;
@property (nonatomic,assign) CGFloat cellHeight;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
-(void)creatAttString;
-(void)changeAnswerContent:(ELButtonView *)view;
-(void)changeReplyContent:(ELButtonView *)view;


@end
