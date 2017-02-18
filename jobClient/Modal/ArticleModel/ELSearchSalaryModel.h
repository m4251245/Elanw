//
//  ELSalaryModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELArticleVoteModel.h"
//搜索薪水文章
@interface ELSearchSalaryModel : PageInfo

@property (nonatomic, copy) NSString *article_id;//文章id
@property (nonatomic, copy) NSString *own_id;//个人id
@property (nonatomic, copy) NSString *c_cnt;//评论数
@property (nonatomic, copy) NSString *like_cnt;//点赞数
@property (nonatomic, copy) NSString *content;//内容
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, assign) BOOL is_recommend;//是否推荐
@property (nonatomic, copy) NSString *is_system;
@property (nonatomic, copy) NSString *is_jing;//精华帖
@property (nonatomic, copy) NSString *source;//职业id
@property (nonatomic, strong) NSDictionary *_vote_info;//投票信息
@end
