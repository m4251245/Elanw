//
//  ProgramQuestion_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-8-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/****************************************
 项目测试题dataModal
 ****************************************/

#import <Foundation/Foundation.h>
#import "Answer_DataModal.h"

@interface ProgramQuestion_DataModal : NSObject {
    NSString                            *id_;
    NSString                            *question_;
    NSString                            *type_;
    NSString                            *classFlag_;
    NSString                            *otherFlag_;
    NSString                            *classType_;
    
    int                                 totalCnt_;          //测试题总数
    int                                 testCnt_;           //已测题数
    int                                 lessCnt_;           //剩作题数
    
    NSMutableArray                      *answerArr_;        //回答选项(里面存放Answer_DataModal)
}

@property(nonatomic,retain) NSString                            *id_;
@property(nonatomic,retain) NSString                            *question_;
@property(nonatomic,retain) NSString                            *type_;
@property(nonatomic,retain) NSString                            *classFlag_;
@property(nonatomic,retain) NSString                            *otherFlag_;
@property(nonatomic,retain) NSString                            *classType_;
@property(nonatomic,retain) NSMutableArray                      *answerArr_;
@property(nonatomic,assign) int                                 totalCnt_;
@property(nonatomic,assign) int                                 testCnt_;
@property(nonatomic,assign) int                                 lessCnt_;

@end
