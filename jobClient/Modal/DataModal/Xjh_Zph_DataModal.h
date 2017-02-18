//
//  Xjh_Zph_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-3-13.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"



@interface Xjh_Zph_DataModal : PageInfo

@property(nonatomic,strong) NSString * id_;
@property(nonatomic,strong) NSString * title_;
@property(nonatomic,strong) NSString * companyid_;
@property(nonatomic,strong) NSString * companyName_;
@property(nonatomic,strong) NSString * schoolId_;
@property(nonatomic,strong) NSString * schoolName_;
@property(nonatomic,strong) NSString * regionId_;
@property(nonatomic,strong) NSString * address_;
@property(nonatomic,strong) NSString * city_;
@property(nonatomic,strong) NSString * datetiome_;
@property(nonatomic,strong) NSString * weekday_;
@property(nonatomic,strong) NSString * endDate_;
@property(nonatomic,strong) NSString * introduce_;
@property(nonatomic,strong) NSString * time_;
@property(nonatomic,assign) int       type_;             //1为招聘会，2为宣讲会
@property(nonatomic,strong) NSString * attention_;      //1为关注 0未关注



@end
