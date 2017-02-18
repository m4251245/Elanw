//
//  DBTools.h
//  Association
//
//  Created by 一览iOS on 14-5-14.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBTools : NSObject
{
    sqlite3   *database;
    NSMutableArray *resulArr;
}

//获取实例
+(DBTools *) defaultDB;

//查询
-(NSMutableArray *) inquire:(NSString *)userId;

//插入数据
-(void) insertTable:(NSString *)type stutas:(NSString *)stutas userId:(NSString *)userId;

//生成推送设置表
-(BOOL) createTable;

//删除表
-(BOOL) deleteTable;

//更新数据库
-(void)updateTable:(NSString *)userId type:(NSString *)type stutas:(NSString *)stutas;

-(BOOL) createTableForSearch;

-(void) insertTableForSearch:(NSString *)personid searchKeyWords:(NSString *)searchKeyWords regionId:(NSString *)regionId regionStr:(NSString *)regionStr tradeId:(NSString *)tradeId tradeStr:(NSString *)tradeStr searchTime:(NSString *)searchTime searchType:(NSString *)searchType;

-(NSMutableArray *) inquireForSearch:(NSString *)userId;

-(BOOL)deleteData:(NSString *)personId searchKeyWords:(NSString *)searchKeyWords regionStr:(NSString *)regionStr tradeStr:(NSString *)tradeStr;

-(BOOL)deleteData:(NSString *)personId;


//附近职位搜索记录数据库
-(BOOL)createNearJobForSearch;

-(void) insertNearJobForSearch:(NSString *)personid searchKeyWords:(NSString *)searchKeyWords  tradeId:(NSString *)tradeId tradeStr:(NSString *)tradeStr;

-(BOOL)deleteData:(NSString *)personId searchKeyWords:(NSString *)searchKeyWords tradeStr:(NSString *)tradeStr;
-(NSMutableArray *) inquireFornearJobSearch:(NSString *)userId;

-(BOOL)deleteNearJobSearchData:(NSString *)personId;

@end
