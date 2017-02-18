//
//  ServiceInfo.h
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//简历直推

#import "BaseUIViewController.h"

typedef NS_ENUM(NSInteger, ResumeRecommendStatus) {
    ResumeRecommendApply = 1,//申请
    ResumeRecommendExamine,//审核
    ResumeRecommendPay,//支付
    ResumeRecommendFinish//完成
};

@interface RRServiceInfo : BaseUIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
 
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (assign, nonatomic) ResumeRecommendStatus applyStatus;

@end
