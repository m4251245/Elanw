//
//  SearchResult_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

/********************************************
 职位详情的查询结果DataModal
 ********************************************/

#import <Foundation/Foundation.h>
#import "JobSearch_DataModal.h"

@interface ZWDetail_DataModal : JobSearch_DataModal {

    NSString                *peopleCount_;              //需要的人数
    NSString                *edus_;                     //学历要求
    NSString                *moneyCount_;               //薪资
    NSString                *yearCount_;                //工作年限
    NSString                *zwJianJie_;                //职位简介
    NSString                *companyAddr_;              //企业地址
    
    //兼职/实习新增的属性
    NSString                *sexs_;                     //性别
    NSString                *languages_;                //语言
    NSString                *phone_;                    //电话
}

@property(nonatomic,retain) NSString                *peopleCount_;
@property(nonatomic,retain) NSString                *edus_;
@property(nonatomic,retain) NSString                *moneyCount_;
@property(nonatomic,retain) NSString                *yearCount_;
@property(nonatomic,retain) NSString                *zwJianJie_;
@property(nonatomic,retain) NSString                *companyAddr_;
@property(nonatomic,retain) NSString                *sexs_;
@property(nonatomic,retain) NSString                *languages_;
@property(nonatomic,retain) NSString                *phone_;
@property(nonatomic,retain) NSString                *personId_;
@property(nonatomic,retain) NSString                *keyword_;
@property(nonatomic,retain) NSString                *tradeId_;
@property(nonatomic,retain) NSString                *searchTime_;  //订阅时间
@property(nonatomic,retain) NSString                *tradeName_;    //行业
@property(nonatomic,retain) NSString                *companyLogo_;
@property(nonatomic,retain) NSString                *resumeNum_;
@property(nonatomic,retain) NSString                *resumeNewNum_;
@property(nonatomic,strong) NSString                *zprenshu;
@end
