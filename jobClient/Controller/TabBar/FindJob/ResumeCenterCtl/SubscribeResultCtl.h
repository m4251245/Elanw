//
//  SubscribeResultCtl.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
            订阅结果
 
 ******************************/

#import <UIKit/UIKit.h>
#import "LookHistoryCtl.h"
#import "Subscribe_DataModal.h"

#define SubscribeResultCtl_Title            @"订阅结果"
#define SubscribeResultCtl_PageSize         25


//订阅已经阅读代理
@protocol SubscribeReadDelegate <NSObject>

//阅读成功
-(void) subscribeHaveReadOK:(NSString *)subscribeId;

@end

@interface SubscribeResultCtl : LookHistoryCtl {
    
    PreRequestCon                      *readCon_;
    
    Subscribe_DataModal             *subscribeDataModal_;
}

@property(nonatomic,assign) id<SubscribeReadDelegate>       delegate_;

@end
