//
//  Zph_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/********************************************
 招聘会的dataModal
 ********************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"
#import "PreCommon.h"

//事件类型
typedef enum 
{
    Event_Null,                 //无
    Event_Seminar,              //宣讲会
    Event_Recruitment,          //招聘会
}EventType;

@interface Zph_DataModal : PageInfo {
    NSString                    *id_;       //主键
    NSString                    *title_;    //
    NSString                    *sname_;    //学校宣讲会标题
    NSString                    *sid_;      //学校id名称
    NSString                    *regionId_; //举办地区
    NSString                    *addr_;     //举办地点
    NSString                    *sdate_;    //开始时间
    
    NSString                    *week_;     //星期
    
    BOOL                        bHaveAdd_;  //是否已经参与
    int                         addCnt_;    //参与人数
    
    BOOL                        bRead_;     //是否已阅
    EventType                   eventType_; //事件类型
    
    int                         attentionCnt_;//关注数量
}
@property(nonatomic,retain) NSString                    *id_;
@property(nonatomic,retain) NSString                    *title_;
@property(nonatomic,retain) NSString                    *sid_;
@property(nonatomic,retain) NSString                    *sname_;
@property(nonatomic,retain) NSString                    *regionId_;
@property(nonatomic,retain) NSString                    *addr_;
@property(nonatomic,retain) NSString                    *sdate_;
@property(nonatomic,retain) NSString                    *week_;
@property(nonatomic,assign) BOOL                        bHaveAdd_;
@property(nonatomic,assign) int                         addCnt_;
@property(nonatomic,assign) BOOL                        bRead_;
@property(nonatomic,assign) EventType                   eventType_;
@property(nonatomic,assign) int                         attentionCnt_;

@end
