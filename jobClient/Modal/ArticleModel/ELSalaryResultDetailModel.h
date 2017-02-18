//
//  ELSalaryResultDetailModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELUserModel.h"
#import "UserJob_DataModal.h"

@interface ELSalaryResultDetailModel : PageInfo

@property(nonatomic, copy) NSString *share_url;
@property(nonatomic, strong) NSArray *reco_position;
//@property(nonatomic, strong) NSArray *percent_info;
@property(nonatomic, copy) NSString *percent;
//@property(nonatomic, strong) NSArray *gxs_list;
//@property(nonatomic, strong) NSArray *reco_adv;
//@property(nonatomic, strong) NSArray *work_list;

//percent_info 包含字段
@property(nonatomic, copy) NSString *sum_cnt;
@property(nonatomic, copy) NSString *desc;


@property(nonatomic, strong) NSMutableArray *jobArr;

@property(nonatomic, strong) NSMutableArray *gxsArticleArr;

@property(nonatomic, strong) NSMutableArray *recommendJobArr;

@property(nonatomic, strong) ELUserModel *userInfo;

//reco_adv 包含字段
@property(nonatomic, copy) NSString *ya_path;
@property(nonatomic, copy) NSString *ya_url;


- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
