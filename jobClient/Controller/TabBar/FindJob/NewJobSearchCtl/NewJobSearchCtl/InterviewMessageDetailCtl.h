//
//  InterviewMessageDetailCtl.h
//  Association
//
//  Created by 一览iOS on 14-6-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"

@interface InterviewMessageDetailCtl : BaseUIViewController
{
    IBOutlet    UIButton       *companyInfoBtn_;         //企业详情
    IBOutlet    UILabel        *companyNameLb_;          //企业名称
    IBOutlet    UILabel        *interviewTimeLb_;        //面试发送时间
    IBOutlet    UIWebView      *webView_;                //面试详情

}

@end
