//
//  ELNewLeaveMsgDAO.m
//  jobClient
//
//  Created by 一览ios on 2017/1/5.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELNewLeaveMsgDAO.h"
#import "LeaveMessage_DataModel.h"
#import "ELDBHelper.h"
#import "FMDatabase.h"
@implementation ELNewLeaveMsgDAO
#pragma mark--添加单条
-(BOOL)save:(LeaveMessage_DataModel *)vo{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isSuccess = [db executeUpdate:@"insert into LeaveMsgTable(toUserId,msgId,isSend,personIName,personPic,content,voiceTime,date,imageUrl_,article_id,qi_id_isdefault,tagName,msgUploadStatus,personId,groupId,messageType,attString) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",vo.toUserId,vo.msgId,vo.isSend,vo.personIName,vo.personPic,vo.content,vo.voiceTime,vo.date,vo.imageUrl_,vo.article_id,vo.qi_id_isdefault,vo.tagName,[NSNumber numberWithInteger:vo.msgUploadStatus],vo.personId,vo.groupId,[NSNumber numberWithInteger:vo.messageType],vo.attString];
        [db close];
        return isSuccess;
    }
}

#pragma mark--删除
-(BOOL)deleteData:(NSString *)msgId info:(NSString *)groupId personId:(NSString *)personId{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isSuccess = [db executeUpdate:@"DELETE FROM LeaveMsgTable where msgId=? and groupId=? and personId=?",msgId,groupId,personId];
        [db close];
        return isSuccess;
    }
}

-(BOOL)deleteAll{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isSuccess = [db executeUpdate:@"DELETE FROM LeaveMsgTable"];
        [db close];
        return isSuccess;
    }
}

#pragma mark--查找
-(NSArray *)showAll:(NSString *)personId groupId:(NSString *)groupId{
    FMDatabase *db = [ELDBHelper getDB];
    if (![db open]) {
        return nil;
    }
    else{
        FMResultSet *set = nil;
        NSMutableArray *arr = [NSMutableArray array];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM LeaveMsgTable where groupId='%@' and personId='%@'",groupId,personId];
        set = [db executeQuery:sql];
        while([set next]){
            LeaveMessage_DataModel *vo = [LeaveMessage_DataModel new];
            vo.toUserId = [set stringForColumnIndex:1];
            vo.msgId = [set stringForColumnIndex:2];
            vo.isSend = [set stringForColumnIndex:3];
            vo.personIName = [set stringForColumnIndex:4];
            vo.personPic = [set stringForColumnIndex:5];
            vo.content = [set stringForColumnIndex:6];
            vo.voiceTime = [set stringForColumnIndex:7];
            vo.date = [set stringForColumnIndex:8];
            vo.imageUrl_ = [set stringForColumnIndex:9];
            vo.article_id = [set stringForColumnIndex:10];
            vo.qi_id_isdefault = [set stringForColumnIndex:11];
            vo.tagName = [set stringForColumnIndex:12];
            vo.msgUploadStatus = [set intForColumnIndex:13];
            vo.personId = [set stringForColumnIndex:14];
            vo.groupId = [set stringForColumnIndex:15];
            vo.messageType = [set intForColumnIndex:16];
            vo.attString = [[NSMutableAttributedString alloc] initWithString:[set stringForColumnIndex:17]];
            [arr addObject:vo];
        }
        
        [db close];
        return arr;
    }
}

-(LeaveMessage_DataModel *)findByMsgId:(NSString *)msgId info:(NSString *)groupId personId:(NSString *)personId{
    FMDatabase *db = [ELDBHelper getDB];
    if (![db open]) {
        return nil;
    }
    else{
        FMResultSet *set = nil;
        LeaveMessage_DataModel *vo = nil;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM LeaveMsgTable where msgId='%@' and groupId='%@' and personId='%@'",msgId,groupId,personId];
        set = [db executeQuery:sql];
        while([set next]){
            vo = [LeaveMessage_DataModel new];
            vo.toUserId = [set stringForColumnIndex:1];
            vo.msgId = [set stringForColumnIndex:2];
            vo.isSend = [set stringForColumnIndex:3];
            vo.personIName = [set stringForColumnIndex:4];
            vo.personPic = [set stringForColumnIndex:5];
            vo.content = [set stringForColumnIndex:6];
            vo.voiceTime = [set stringForColumnIndex:7];
            vo.date = [set stringForColumnIndex:8];
            vo.imageUrl_ = [set stringForColumnIndex:9];
            vo.article_id = [set stringForColumnIndex:10];
            vo.qi_id_isdefault = [set stringForColumnIndex:11];
            vo.tagName = [set stringForColumnIndex:12];
            vo.msgUploadStatus = [set intForColumnIndex:13];
            vo.personId = [set stringForColumnIndex:14];
            vo.groupId = [set stringForColumnIndex:15];
            vo.messageType = [set intForColumnIndex:16];
            vo.attString = [[NSMutableAttributedString alloc] initWithString:[set stringForColumnIndex:17]];
        }
  
        [db close];
        return vo;
    }

}

#pragma mark--更新
-(BOOL)updateData:(NSArray *)dataArr{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i<[dataArr count]; i++) {
                LeaveMessage_DataModel * vo = [dataArr objectAtIndex:i];
                LeaveMessage_DataModel *selectVO = [self findByMsgId:vo.msgId info:vo.groupId personId:vo.personId];
                if (selectVO) {
                        BOOL isSuccess = [db executeUpdate:@"UPDATE LeaveMsgTable SET toUserId=?,msgId=?,isSend=?,personIName=?,personPic=?,content=?,voiceTime=?,date=?,imageUrl_=?,article_id=?,qi_id_isdefault=?,tagName=?,msgUploadStatus=?,personId=?,groupId=?,messageType=? attString=? where msgId=? and groupId=? and personId=?",vo.toUserId,vo.msgId,vo.isSend,vo.personIName,vo.personPic,vo.content,vo.voiceTime,vo.date,vo.imageUrl_,vo.article_id,vo.qi_id_isdefault,vo.tagName,[NSNumber numberWithInteger:vo.msgUploadStatus],vo.personId,vo.groupId,[NSNumber numberWithInteger:vo.messageType],vo.attString,vo.msgId,vo.groupId,vo.personId];
                        if (!isSuccess) {
                            NSLog(@"update Failure");
                        }
                    
                }
                else{
                    [self save:vo];
                }
            }
            [db close];
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            if (!isRollBack) {
                [db commit];
            }
        }
        return !isRollBack;
    }
}

-(BOOL)updateOneData:(LeaveMessage_DataModel *)vo{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isSuccess = [db executeUpdate:@"UPDATE LeaveMsgTable SET toUserId=?,msgId=?,isSend=?,personIName=?,personPic=?,content=?,voiceTime=?,date=?,imageUrl_=?,article_id=?,qi_id_isdefault=?,tagName=?,msgUploadStatus=?,personId=?,groupId=?,messageType=? attString=? where msgId=? and groupId=? and personId=?",vo.toUserId,vo.msgId,vo.isSend,vo.personIName,vo.personPic,vo.content,vo.voiceTime,vo.date,vo.imageUrl_,vo.article_id,vo.qi_id_isdefault,vo.tagName,[NSNumber numberWithInteger:vo.msgUploadStatus],vo.personId,vo.groupId,[NSNumber numberWithInteger:vo.messageType],vo.attString,vo.msgId,vo.groupId,vo.personId];
        if (!isSuccess) {
            NSLog(@"update Failure");
        }
        [db close];
        return isSuccess;
    }
    return NO;
}
@end
