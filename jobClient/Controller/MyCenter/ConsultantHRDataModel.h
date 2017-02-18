//
//  ConsultantHRDataModel.h
//  jobClient
//
//  Created by 一览ios on 15/6/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "Expert_DataModal.h"

@interface ConsultantHRDataModel : Expert_DataModal

@property(nonatomic,strong) NSString *salerId;//顾问人员编号
@property(nonatomic,strong) NSString *candownCount;  //可以下载的简历总数
@property(nonatomic,strong) NSString *totalDownCount;//已下载人才数
@property(nonatomic,strong) NSString *downCount;     //已经下载简历数
@property(nonatomic,strong) NSString *canContact;    //月可下载联系方式数量
@property(nonatomic,strong) NSString *recomdCount;   //已推荐简历数
@property(nonatomic,strong) NSString *userType;      //0 内部用户  2 非内部用户
@property(nonatomic,strong) NSString *userName;      //用户名
@property(nonatomic,strong) NSString *visitcnt;      //联系记录的数量
@property(nonatomic,strong) NSString *jobfaircnt;    //offerpai 数量
@property(nonatomic,copy) NSString *all_resume_cnt; //我的人才库数量

@end
