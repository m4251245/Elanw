//
//  GroupMemberCtl.h
//  Association
//
//  Created by YL1001 on 14-5-13.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "Groups_DataModal.h"

@class ELGroupDetailModal;

@interface GroupMemberCtl : BaseListCtl
{
    NSMutableArray          *imageConArr_;  //用于加载图片
    RequestCon          * attentionCon_;
}

@property(nonatomic,retain)ELGroupDetailModal  *myDataModal;

@end
