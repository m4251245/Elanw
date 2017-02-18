//
//  Event_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/********************************************
 关注事件的dataModal
 ********************************************/

#import <Foundation/Foundation.h>
#import "PreCommon.h"
#import "Xjh_DataModal.h"

//#define Notes_Default_Text              [NSString stringWithFormat:@"%@事件提醒",Client_Name]


@interface Event_DataModal : Xjh_DataModal {
    NSString                    *eventId_;              //事件id
    
    NSString                    *navTitle_;             //导航标题
//    NSString                    *id_;                   //主键id
    
    BOOL                        bRepeat_;               //是否需要重复
    BOOL                        bAllDay_;               //是否一整天
//    NSString                    *title_;                //事件标题
    NSString                    *location_;             //事件地点
    NSString                    *startDate_;            //开始时间
    NSString                    *endDate_;              //结果时间
    NSString                    *firstAlertDateTime_;   //第一次响铃时间
    NSString                    *secondAlertDateTime_;  //第二次响铃时间
    NSString                    *notes_;                //备注
    
//    NSString                    *cid_;                  //公司id
//    NSString                    *cname_;                //公司名称
//    NSString                    *sid_;                  //学校id
//    NSString                    *sname_;                //学校名称
//    NSString                    *regionId_;             //举办地区
//    NSString                    *addr_;                 //举办地点
//    NSString                    *sdate_;                //开始时间
}

@property(nonatomic,retain) NSString                    *eventId_;
@property(nonatomic,retain) NSString                    *navTitle_;
//@property(nonatomic,retain) NSString                    *id_;
@property(nonatomic,assign) BOOL                        bRepeat_;
@property(nonatomic,assign) BOOL                        bAllDay_;
//@property(nonatomic,retain) NSString                    *title_;
@property(nonatomic,retain) NSString                    *location_;
@property(nonatomic,retain) NSString                    *startDate_;
@property(nonatomic,retain) NSString                    *endDate_;
@property(nonatomic,retain) NSString                    *firstAlertDateTime_;
@property(nonatomic,retain) NSString                    *secondAlertDateTime_;
@property(nonatomic,retain) NSString                    *notes_;
//@property(nonatomic,retain) NSString                    *cid_;
//@property(nonatomic,retain) NSString                    *cname_;
//@property(nonatomic,retain) NSString                    *sid_;
//@property(nonatomic,retain) NSString                    *sname_;
//@property(nonatomic,retain) NSString                    *regionId_;
//@property(nonatomic,retain) NSString                    *addr_;
//@property(nonatomic,retain) NSString                    *sdate_;


@end
