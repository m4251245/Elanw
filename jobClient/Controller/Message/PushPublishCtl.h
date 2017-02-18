//
//  PushPublishCtl.h
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "Message_DataModal.h"

@interface PushPublishCtl : BaseListCtl
{
    NSMutableArray *  messageArr_;
    
}
@property(nonatomic,assign) int type_;

@end
