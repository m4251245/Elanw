//
//  JobGuideQuizModal.h
//  jobClient
//
//  Created by YL1001 on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface JobGuideQuizModal : PageInfo

/*
 职导问答
 */
@property (nonatomic, copy) NSString *question_replys_count;
@property (nonatomic, copy) NSString *question_id;
@property (nonatomic, copy) NSString *question_title;
@property (nonatomic, copy) NSString *question_view_count;
@property (nonatomic, copy) NSString *question_content;
@property (nonatomic, copy) NSString *answer_comment_count;
@property (nonatomic, copy) NSString *hot_count;
@property (nonatomic, copy) NSString *is_recommend;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *totalid;
@property (nonatomic, strong) ELSameTradePeopleModel *person_detail;
@property (nonatomic, strong) NSMutableArray *answer_detail;

@property (nonatomic, strong) NSArray *tag_info;
@property (nonatomic, strong) NSArray *targ;
@property (nonatomic, strong) NSMutableArray *lableArr;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect commentViewFrame;
@property (nonatomic,strong) NSMutableAttributedString *contentAttString;
@property (nonatomic,strong) NSMutableAttributedString *personNameAttString;
@property (nonatomic,strong) NSMutableAttributedString *answerDetailAtt;
@property (nonatomic,strong) NSMutableAttributedString *commentOneAtt;
@property (nonatomic,strong) NSMutableAttributedString *commentTwoAtt;
@property (nonatomic,strong) NSMutableArray *commentOneArr;
@property (nonatomic,strong) NSMutableArray *commentTwoArr;
@property (nonatomic, assign) CGRect commentOneFrame;
@property (nonatomic, assign) CGRect commentTwoFrame;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
