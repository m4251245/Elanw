//
//  SubscribedJobsCtl.h
//  Association
//
//  Created by 一览iOS on 14-4-17.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"


@interface SubscribedJobsCtl : BaseListCtl
{
    IBOutlet UIButton * searchBtn_;
    RequestCon      * deleteCon_;   //用于删除订阅的请求
    
    
}

@property(nonatomic,assign) int  type_;   //区分不同入口

@end
