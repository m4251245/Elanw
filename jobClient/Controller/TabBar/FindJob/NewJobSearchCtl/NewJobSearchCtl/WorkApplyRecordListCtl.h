//
//  WorkApplyRecordListCtl.h
//  Association
//
//  Created by 一览iOS on 14-6-23.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "BaseListCtl.h"
#import "ExRequetCon.h"

@interface WorkApplyRecordListCtl : BaseListCtl
{
    RequestCon          *recordCon_;            //获取申请列表
    NSMutableArray      *recordDataArray_;      //获取申请列表数据
}

@property (nonatomic,assign) BOOL isPop;

@end
