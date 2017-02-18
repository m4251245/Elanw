//
//  OfferPartyResumeEnumeration.h
//  jobClient
//
//  Created by YL1001 on 16/9/19.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

//顾问offer派简历列表
typedef NS_ENUM(NSInteger, OPResumeListType) {
    OPResumeListTypeAllResume = 0,          //所有人才
    OPResumeListTypeConfirmToAttend = 1,    //确认参加
    OPResumeListTypePrimaryElection = 5,    //通过初选
    OPResumeListTypeHasPresent = 4,         //已到场
    OPResumeListTypeReceiveOffer = 6,       //已发offer
    OPResumeListTypeWorked = 7,             //已上岗
};

//企业offer派简历列表
typedef NS_ENUM(NSInteger, ComResumeListType) {
    ComResumeListTypeAllPerson = 3,          //所有人才
    ComResumeListTypePrimaryElection = 5,    //筛选简历（通过初选）
    ComResumeListTypeHasPresent = 4,         //其他已到场（已到场）
    ComResumeListTypeToInterview = 10,       //等候面试
    ComResumeListTypeHasInterviewed = 11,    //已面试
};

//简历状态
typedef NS_ENUM(NSInteger, OPResumeType) {
    OPResumeTypenotOperating = 0,          //待处理/
    OPResumeTypeAdvisersRecommend = 1,     //顾问推荐/
    OPResumeTypeInterviewSelfDeliver,      //主动投递/
    OPResumeTypeConfirmFit,                //合适
    OPResumeTypeNoConfirFit,               //不合适
    OPResumeTypeToInterview,               //等候面试/
    OPResumeTypeInterviewed,               //面试通过/
    OPResumeTypeInterviewUnqualified,      //面试不通过/
    OPResumeTypeSendOffer,                 //已发offer/
    OPResumeTypeWorked,                    //已上岗
    OPResumeTypeUnRecommend,               //未推荐
    OPResumeTypePresent,                   //已到场/
    OPResumeTypeLeaved,                    //已离场
    OPResumeTypeWait,                      //待确定/
    OPResumeTypeGivedUpInterview           //已放弃面试
};

@interface OfferPartyResumeEnumeration : NSObject

@end
