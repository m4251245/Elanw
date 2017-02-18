//
//  ELNewsListDAO.m
//  jobClient
//
//  Created by 一览ios on 2016/12/23.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewsListDAO.h"
#import "ELNewNewsListVO.h"
#import "ELDBHelper.h"
#import "FMDatabase.h"
@implementation ELNewsListDAO
#pragma mark--保存单条数据
-(BOOL)save:(ELNewNewsListVO *)vo{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isSuccess = [db executeUpdate:@"insert into NewsListTable(title,content,type,cnt,time,info,infoId,personId,action,qi_id_isdefault,article_id) values(?,?,?,?,?,?,?,?,?,?,?)",vo.title,vo.content,vo.type,vo.cnt,vo.time,vo.jsonStr,vo.infoId,vo.personId,vo.action,vo.qi_id_isdefault,vo.article_id];
        //[db close];
        return isSuccess;
    }
}

#pragma mark--更新所有数据
-(BOOL)updateData:(NSArray *)dataArr{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i<[dataArr count]; i++) {
                ELNewNewsListVO * vo = [dataArr objectAtIndex:i];
                ELNewNewsListVO *selectVO = [self findByType:vo.type info:vo.infoId personId:vo.personId close:NO];
                if (selectVO) {
                    if([vo.cnt isKindOfClass:[NSNumber class]]){
                        if (!([vo.type isEqualToString:@"oa_msg"])) {
                            if ([vo.action isEqualToString:@"upsert"]) {
                                if([vo.all_cnt integerValue]!=10000){
                                    vo.cnt = vo.all_cnt;
                                }
                                else{
                                    NSInteger allCnt = [vo.cnt integerValue] + [selectVO.cnt integerValue];
                                    vo.cnt = [NSNumber numberWithInteger:allCnt];
                                }
                            }
                            else{
                                NSInteger allCnt = [vo.cnt integerValue] + [selectVO.cnt integerValue];
                                vo.cnt = [NSNumber numberWithInteger:allCnt];
                            }
                        }
                        BOOL isSuccess = [db executeUpdate:@"UPDATE NewsListTable SET title=?,content=?,cnt=?,time=?,info=?,action=?,qi_id_isdefault=?,article_id=? where type=? and infoId=? and personId=?",vo.title,vo.content,vo.cnt,vo.time,vo.jsonStr,vo.action,vo.qi_id_isdefault,vo.article_id,vo.type,vo.infoId,vo.personId];
                        if (!isSuccess) {
                            NSLog(@"update Failure");
                        }
                    }
                }
                else{
                    [self save:vo];
                }
            }
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
        [db close];
        return !isRollBack;
    }
}

#pragma mark--更新单挑数据
-(BOOL)updateOneData:(ELNewNewsListVO *)vo{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        
        if([vo.cnt isKindOfClass:[NSNumber class]]){
            BOOL isSuccess = [db executeUpdate:@"UPDATE NewsListTable SET title=?,content=?,cnt=?,time=?,info=?,action=?,qi_id_isdefault=?,article_id=? where type=? and infoId=? and personId=?",vo.title,vo.content,vo.cnt,vo.time,vo.jsonStr,vo.action,vo.qi_id_isdefault,vo.article_id,vo.type,vo.infoId,vo.personId];
            if (!isSuccess) {
                NSLog(@"update Failure");
            }
            [db close];
            return isSuccess;
        }
        
    }
    return NO;
}


#pragma mark--通过type名删除单条数据
-(BOOL)deleteData:(NSString *)infoId  type:(NSString *)type{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isSuccess = [db executeUpdate:@"DELETE FROM NewsListTable where infoId=? and type=?",infoId,type];
        [db close];
        return isSuccess;
    }
}

#pragma mark--删除数据库中的所有数据
-(BOOL)deleteAll
{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isSuccess = [db executeUpdate:@"DELETE FROM NewsListTable"];
        [db close];
        return isSuccess;
    }
}

#pragma mark--查找
-(ELNewNewsListVO *)findByType:(NSString *)type info:(NSString *)infoId personId:(NSString *)personId close:(BOOL)close{
    FMDatabase *db = [ELDBHelper getDB];
    if (![db open]) {
        return nil;
    }
    else{
        FMResultSet *set = nil;
        ELNewNewsListVO *vo = nil;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM NewsListTable where type='%@' and infoId='%@' and personId='%@'",type,infoId,personId];
        set = [db executeQuery:sql];
        while([set next]){
            vo = [ELNewNewsListVO new];
            vo.title = [set stringForColumnIndex:1];
            vo.content = [set stringForColumnIndex:2];
            vo.type = [set stringForColumnIndex:3];
            vo.cnt = [NSNumber numberWithInt:[set intForColumnIndex:4]];
            vo.time = [set stringForColumnIndex:5];
            vo.jsonStr = [set stringForColumnIndex:6];
            vo.infoId = [set stringForColumnIndex:7];
            vo.personId = [set stringForColumnIndex:8];
            vo.action = [set stringForColumnIndex:9];
            vo.qi_id_isdefault = [set stringForColumnIndex:10];
            vo.article_id = [set stringForColumnIndex:11];
        }
        if (close) {
            [db close];
        }
        
        return vo;
    }
    
}

#pragma mark--遍历数据库并返回所有数据
-(NSArray *)showAll:(NSString *)personId{
    //NSInteger pEnd = pStart + pSize;
    NSMutableArray *arr = [NSMutableArray array];
    FMDatabase *db = [ELDBHelper getDB];
    if (![db open]) {
        return nil;
    }
    else{
        FMResultSet *set = nil;
        NSLog(@"%d",[self isTableOK:@"NewsListTable"]);
        set = [db executeQuery:@"SELECT * FROM NewsListTable where personId=? ORDER BY time DESC",personId];
        while([set next]){
            ELNewNewsListVO *vo = [ELNewNewsListVO new];
            vo.title = [set stringForColumnIndex:1];
            vo.content = [set stringForColumnIndex:2];
            vo.type = [set stringForColumnIndex:3];
            vo.cnt = [NSNumber numberWithInt:[set intForColumnIndex:4]];
            vo.time = [set stringForColumnIndex:5];
            vo.jsonStr = [set stringForColumnIndex:6];
            vo.infoId = [set stringForColumnIndex:7];
            vo.personId = [set stringForColumnIndex:8];
            vo.action = [set stringForColumnIndex:9];
            vo.qi_id_isdefault = [set stringForColumnIndex:10];
            vo.article_id = [set stringForColumnIndex:11];
            [arr addObject:vo];
        }
        [db close];
        return arr;
    }
    return nil;
}

#pragma mark--检测数据库中是否存在表
- (BOOL)isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [[ELDBHelper getDB] executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?",tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %ld", (long)count);
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}
@end
