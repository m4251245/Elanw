//
//  ELSalaryModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//


#import "PageInfo.h"
//#import "User_DataModal.h"

@interface ELSalaryModel : PageInfo
//搜索薪水入口文章
@property(nonatomic, assign) NSInteger articleType_;
@property(nonatomic, copy) NSString *_show_type;//展示类型
@property(nonatomic, assign) NSInteger like_cnt;//点赞数
@property(nonatomic, copy) NSString *article_id;//文章id
@property(nonatomic, copy) NSString *content;//内容
@property(nonatomic, assign) NSInteger c_cnt;//评论数
@property(nonatomic, copy) NSString *is_recommend;//推荐
@property(nonatomic, copy) NSString *own_id;//个人id
@property(nonatomic, copy) NSDictionary *_vote_info;//投票信息
//投票包含字段
@property(nonatomic, copy) NSString *isVote;
@property(nonatomic, copy) NSString *canVote;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *allVote;
@property(nonatomic, strong) NSMutableArray *option_info;
//
@property(nonatomic, copy) NSString *thumb;//图片
@property(nonatomic, copy) NSString *is_system;
@property(nonatomic, copy) NSString *is_jing;//是否是精华帖
@property(nonatomic, copy) NSString *source;//职业id
//
@property(nonatomic, strong) NSMutableArray *resultDataArr;
@property(nonatomic, assign) BOOL isRefresh;
@property(nonatomic, strong) NSIndexPath *indexpath;
@property(nonatomic, assign) BOOL isLike_;//是否点赞
@property(nonatomic, assign) BOOL isSalaryDetail;
@property(nonatomic, strong) id cellFrame;
@property(nonatomic, copy) NSString *title_;//

@property(nonatomic, strong) UIColor *bgColor_;//背景颜色


@property(nonatomic, assign) NSInteger v_cnt;
@property(nonatomic, copy) NSString *summary;
@property(nonatomic, copy) NSString *person_iname;
@property(nonatomic, copy) NSString *person_nickname;
@property(nonatomic, copy) NSString *person_pic;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
