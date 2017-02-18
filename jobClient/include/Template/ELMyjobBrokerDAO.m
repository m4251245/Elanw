//
//  ELMyjobBrokerDAO.m
//  jobClient
//
//  Created by 一览ios on 16/10/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELMyjobBrokerDAO.h"
#import "Expert_DataModal.h"
#import "ELDBHelper.h"
#import "FMDatabase.h"
@implementation ELMyjobBrokerDAO
#pragma mark--保存单条数据
-(BOOL)save:(Expert_DataModal *)vo{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isSuccess = [db executeUpdate:@"insert into MyjobBrokerTable(id_,expertIntroduce_,gznum_,iname_,is_jjr,zw_,img_,myselfIsAgented,isHaveBroker) values(?,?,?,?,?,?,?,?,?)",vo.id_,vo.expertIntroduce_,vo.gznum_,vo.iname_,vo.is_jjr,vo.zw_,vo.img_,vo.myselfIsAgented,vo.isHaveBroker];
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
        BOOL isSuccess = [db executeUpdate:@"DELETE FROM MyjobBrokerTable"];
        [db close];
        return isSuccess;
    }
}

#pragma mark--遍历数据库并返回所有数据
-(Expert_DataModal *)showAll{
    FMDatabase *db = [ELDBHelper getDB];
    if (![db open]) {
        return nil;
    }
    else{
        Expert_DataModal *vo = [Expert_DataModal new];
        FMResultSet *set = nil;
        NSLog(@"%d",[self isTableOK:@"MyjobBrokerTable"]);
        set = [db executeQuery:@"SELECT * FROM MyjobBrokerTable"];
        while([set next]){
            vo.id_ = [set stringForColumnIndex:1];
            vo.expertIntroduce_ = [set stringForColumnIndex:2];
            vo.gznum_ = [set stringForColumnIndex:3];
            vo.iname_ = [set stringForColumnIndex:4];
            vo.is_jjr = [set stringForColumnIndex:5];
            vo.zw_ = [set stringForColumnIndex:6];
            vo.img_ = [set stringForColumnIndex:7];
            vo.myselfIsAgented = [set stringForColumnIndex:8];
            vo.isHaveBroker = [set stringForColumnIndex:9];
        }
        [db close];
        return vo;
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
