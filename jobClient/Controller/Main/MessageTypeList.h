//
//  MessageTypeList.h
//  jobClient
//
//  Created by 一览ios on 15/4/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "Message_DataModal.h"

typedef void(^messageBlock)(NSInteger msgCnt, NSInteger leaveMsgCnt, NSInteger phoneCnt);

@interface MessageTypeList :BaseListCtl <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, copy) messageBlock _block;

-(void)refreshLeaveCount;

@end
