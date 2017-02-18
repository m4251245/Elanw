//
//  InterViewListCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-11-5.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "InterviewAnswerCtl.h"

typedef void(^interViewListBlock)();
@interface InterViewListCtl : BaseListCtl<InterviewAnswerCtlDelegate>
{
    NSString    *userId;
}

@property(nonatomic,assign) BOOL        isMyCenter;

@property(nonatomic,copy) interAnserBlock block;

@end
