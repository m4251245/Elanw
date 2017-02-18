//
//  Subscribe_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/********************************************
 订阅列表的dataModal
 ********************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface Subscribe_DataModal : PageInfo {
    NSString                        *subscribeId_;      //订阅主键
    NSString                        *personId_;         //订阅者姓名
    NSString                        *sId_;              //学校id
    NSString                        *sname_;            //学校名称
    NSString                        *cId_;              //企业id
    NSString                        *cname_;            //企业名称
    NSString                        *regionId_;         //地区id
    NSString                        *subscribeType_;    //订阅类型
    
    BOOL                            bHaveNewMsg_;       //是否有新的消息
    NSString                        *msgCnt_;           //新消息的总数
}

@property(nonatomic,retain) NSString                        *subscribeId_;
@property(nonatomic,retain) NSString                        *personId_;
@property(nonatomic,retain) NSString                        *sId_;
@property(nonatomic,retain) NSString                        *sname_;
@property(nonatomic,retain) NSString                        *cId_;
@property(nonatomic,retain) NSString                        *cname_;
@property(nonatomic,retain) NSString                        *regionId_;
@property(nonatomic,retain) NSString                        *subscribeType_;
@property(nonatomic,assign) BOOL                            bHaveNewMsg_;
@property(nonatomic,retain) NSString                        *msgCnt_;

@end
