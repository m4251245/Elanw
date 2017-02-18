//
//  WorkResume_DataModal.h
//  jobClient
//
//  Created by job1001 job1001 on 12-2-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/********************************
 
 简历修改->工作经历dataModal
 ********************************/


#import <Foundation/Foundation.h>


@interface WorkResume_DataModal : NSObject {
    NSString                        *workId_;           //主键
    NSString                        *personId_;         //...
    
    NSString                        *companyName_;      //公司名称
    NSString                        *bCompanySercet_;   //是否对公司名称保密
    NSString                        *startDate_;        //开始时间
    NSString                        *endDate_;          //结束时间 
    NSString                        *yuangong_;         //公司规模
    NSString                        *cxz_;              //公司性质
    NSString                        *zw_;               //职位分类
    NSString                        *zwName_;           //职位名称
    NSString                        *bSalarySercet_;    //所有薪酬都保密
    NSString                        *monthSalary_;      //月薪
    NSString                        *yearSalary_;       //年薪
    NSString                        *yearBouns_;        //年终奖
    NSString                        *des_;              //工作描述
    NSString                        *bOversea_;         //是否有海外工作经历
    
    NSString                        *bToNow_;           //是否是到至今
    NSString                        *bShow_;            //是否显示
}

@property(nonatomic,retain) NSString                        *workId_;
@property(nonatomic,retain) NSString                        *personId_;
@property(nonatomic,retain) NSString                        *companyName_;
@property(nonatomic,retain) NSString                        *bCompanySercet_;
@property(nonatomic,retain) NSString                        *startDate_;
@property(nonatomic,retain) NSString                        *endDate_;
@property(nonatomic,retain) NSString                        *yuangong_;
@property(nonatomic,retain) NSString                        *cxz_;
@property(nonatomic,retain) NSString                        *zw_;
@property(nonatomic,retain) NSString                        *zwName_;
@property(nonatomic,retain) NSString                        *bSalarySercet_;
@property(nonatomic,retain) NSString                        *monthSalary_;
@property(nonatomic,retain) NSString                        *yearSalary_;
@property(nonatomic,retain) NSString                        *yearBouns_;
@property(nonatomic,retain) NSString                        *des_;
@property(nonatomic,retain) NSString                        *bOversea_;
@property(nonatomic,retain) NSString                        *bToNow_;
@property(nonatomic,retain) NSString                        *bShow_;


@end
