//
//  ELDBHelper.m
//  jobClient
//
//  Created by 一览ios on 16/10/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELDBHelper.h"
#import "FMDatabase.h"
@implementation ELDBHelper
+(FMDatabase *)getDB{
    static FMDatabase *db = nil;
    if (!db) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/MyDB.db",NSHomeDirectory()];
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path]) {
            db = [FMDatabase databaseWithPath:path];
        }
        else{
            db = [FMDatabase databaseWithPath:path];
            if ([db open]) {
                NSString *createSQ = @"create table IF NOT EXISTS MyjobsearchTable(id integer primary key autoincrement,logo text,jtzw text,updatetime text,cname text,xzdy text,benefits text,regionname text,gznum text,edus text,is_ky text,positionId text,zptype text);create table IF NOT EXISTS MyjobBrokerTable(id integer primary key autoincrement,id_ text,expertIntroduce_ text,gznum_ text,iname_ text,is_jjr text,zw_ text,img_ text,myselfIsAgented text,isHaveBroker text);create table IF NOT EXISTS NewsListTable(id integer primary key autoincrement,title varchar(50),content varchar(100),type varchar(20),cnt int,time dateTime,info text,infoId varchar(20),personId varchar(20),action varchar(20),qi_id_isdefault varchar(10),article_id varchar(20));create table IF NOT EXISTS LeaveMsgTable(id integer primary key autoincrement,toUserId varchar(30),msgId varchar(30),isSend varchar(10),personIName varchar(30),personPic varchar(200),content text,voiceTime varchar(20),date dataTime,imageUrl_ varchar(200),article_id varchar(30),qi_id_isdefault varchar(20),tagName varchar(20),msgUploadStatus int,personId varchar(50),groupId varchar(50),messageType int,attString text,);";
                [db executeStatements:createSQ];
                [db close];
            }
        }
    }
    return db;
}
@end
