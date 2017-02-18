//
//  PushInviteCtl.h
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "Message_DataModal.h"
#import "InterviewMessageListCtl.h"
#import "ResumeVisitorListCtl.h"


@interface PushInviteCtl : BaseListCtl
{
    NSMutableArray *  messageArr_;
    InterviewMessageListCtl    *resumeNotifyCtl_;          //面试通知记录
    ResumeVisitorListCtl     *companyLookedDetailCtl_;   //被阅记录详情
}


@end
