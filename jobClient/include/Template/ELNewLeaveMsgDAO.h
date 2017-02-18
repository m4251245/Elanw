//
//  ELNewLeaveMsgDAO.h
//  jobClient
//
//  Created by 一览ios on 2017/1/5.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LeaveMessage_DataModel;
@interface ELNewLeaveMsgDAO : NSObject

-(BOOL)save:(LeaveMessage_DataModel *)vo;
-(BOOL)deleteData:(NSString *)msgId info:(NSString *)groupId personId:(NSString *)personId;

-(BOOL)deleteAll;

-(NSArray *)showAll:(NSString *)personId groupId:(NSString *)groupId;
-(LeaveMessage_DataModel *)findByMsgId:(NSString *)msgId info:(NSString *)groupId personId:(NSString *)personId;

-(BOOL)updateData:(NSArray *)dataArr;
-(BOOL)updateOneData:(LeaveMessage_DataModel *)vo;

@end
