//
//  SalaryResult_DataModal.h
//  jobClient
//
//  Created by YL1001 on 14-9-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User_DataModal.h"

@interface SalaryResult_DataModal : PageInfo

@property(nonatomic,strong) NSString        * percent_;
@property(nonatomic,strong) User_DataModal  * userInfo_;
@property(nonatomic,strong) NSMutableArray  * gxsArticleArr_;
@property(nonatomic,strong) NSMutableArray  * recommendJobArr_;
@property(nonatomic,strong) NSMutableArray  * recommendCourseArr_;
@property(nonatomic,strong) NSMutableArray  * recommendUserArr;
@property(nonatomic,strong) NSString        * ADImgPath_;
@property(nonatomic,strong) NSString        * ADUrl_;
@property(nonatomic,strong) NSDictionary    * percentDic_;
@property(nonatomic,assign) NSInteger               sumCnt_;
@property(nonatomic,strong) NSString        * des_;
@property(nonatomic,strong) NSString        * shareUrl_;


@property(nonatomic, copy) NSString *iname;//用户名
@property(nonatomic, copy) NSString *sex;//性别
@property(nonatomic, copy) NSString *sendtime_desc;
@property(nonatomic, strong) NSDictionary *personInfo;//个人信息

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
