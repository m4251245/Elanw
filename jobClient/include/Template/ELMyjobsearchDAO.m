//
//  ELMyjobsearchDAO.m
//  jobClient
//
//  Created by 一览ios on 16/10/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELMyjobsearchDAO.h"
#import "NewJobPositionDataModel.h"
#import "ELDBHelper.h"
#import "FMDatabase.h"

@implementation ELMyjobsearchDAO
#pragma mark--保存单条数据
-(BOOL)save:(NewJobPositionDataModel *)vo{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        
        BOOL isSuccess = [db executeUpdate:@"insert into MyjobsearchTable(logo,jtzw,updatetime,cname,xzdy,benefits,regionname,gznum,edus,is_ky,positionId,zptype) values(?,?,?,?,?,?,?,?,?,?,?,?)",vo.logo,vo.jtzw,vo.updatetime,vo.cname,vo.xzdy,vo.benefits,vo.regionname,vo.gznum,vo.edus,vo.is_ky,vo.positionId,vo.zptype];
        [db close];
        return isSuccess;
    }
}

#pragma mark--通过公司名删除单条数据（不准确，可以改成positionId）
-(BOOL)deleteData:(NSString *)companyName{
    FMDatabase * db = [ELDBHelper getDB];
    if (![db open]) {
        return NO;
    }
    else{
        BOOL isSuccess = [db executeUpdate:@"DELETE FROM MyjobsearchTable where cname = ?",companyName];
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
        BOOL isSuccess = [db executeUpdate:@"DELETE FROM MyjobsearchTable"];
        [db close];
        return isSuccess;
    }
}

#pragma mark--遍历数据库并返回所有数据
-(NSArray *)showAll{
    NSMutableArray *arr = [NSMutableArray array];
    FMDatabase *db = [ELDBHelper getDB];
    if (![db open]) {
        return nil;
    }
    else{
        FMResultSet *set = nil;
        NSLog(@"%d",[self isTableOK:@"MyjobsearchTable"]);
        set = [db executeQuery:@"SELECT * FROM MyjobsearchTable"];
        while([set next]){
            NewJobPositionDataModel *vo = [NewJobPositionDataModel new];
            vo.logo = [set stringForColumnIndex:1];
            vo.jtzw = [set stringForColumnIndex:2];
            vo.updatetime = [set stringForColumnIndex:3];
            vo.cname = [set stringForColumnIndex:4];
            vo.xzdy = [set stringForColumnIndex:5];
            vo.benefits = [set stringForColumnIndex:6];
            vo.regionname = [set stringForColumnIndex:7];
            vo.gznum = [set stringForColumnIndex:8];
            vo.edus = [set stringForColumnIndex:9];
            vo.is_ky = [set stringForColumnIndex:10];
            vo.positionId = [set stringForColumnIndex:11];
            vo.zptype = [set stringForColumnIndex:12];
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







