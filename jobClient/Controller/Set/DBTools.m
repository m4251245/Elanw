//
//  DBTools.m
//  Association
//
//  Created by 一览iOS on 14-5-14.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "DBTools.h"
#import "PushSetDateModel.h"

static BOOL bHaveOpenBD = NO;

//DB
static DBTools *dbTool;

@implementation DBTools

+(DBTools *) defaultDB
{
    if( !dbTool ){
        dbTool = [[DBTools alloc] init];
    }
    
    return dbTool;
}


-(id) init
{
    self = [super init];
    
    if( self )
    {
        if( !bHaveOpenBD )
        {
            [self opendatabase];
            resulArr = [[NSMutableArray alloc]init];
        }
    }
    
    return self;
}


-(NSString *) databasePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path objectAtIndex:0];
    return [pathname stringByAppendingPathComponent:@"ylpushdatabase.sqlite3"];
}

-(BOOL) opendatabase
{
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) { //根据指定目录打开数据库文件，如果没有就创建一个新的
        sqlite3_close(database);
        NSLog(@"failed to open the database.\n");
        return NO;
    }
    else {
        NSLog(@"open the database successfully.\n");
        return YES;
    }
}

-(BOOL) createTable
{
    
//    if ([self opendatabase] == YES) {
        char *erroMsg;
        NSString *TableName = @"yl_pushset";
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, status TEXT, user_id TEXT)", TableName];//创建一个表    AUTOINCREMENT 这里userid的值是创建表是自动生成的，从1开始依次自增
        
        if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
            sqlite3_close(database);
            NSLog(@"create table failed.\n");
            return NO;
        }
        else {
            NSLog(@"table was created.\n");
            return YES;
        }
//    }
//    else
//        return NO;
}

-(BOOL) deleteTable
{
//    if ([self opendatabase] == YES) {
        char *erroMsg;
        NSString *TableName = @"yl_pushset";
        NSString *createSQL = [NSString stringWithFormat:@"DROP TABLE %@", TableName];//删除表
        if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
            NSLog(@"delete table failed.\n");
            return NO;
        }
        else {
            NSLog(@"delete was created.\n");
            return YES;
        }
//    }
//    else
//        return NO;

}

-(void) ErrorReport:(NSString *)item
{
    char *errorMsg;
    if (sqlite3_exec(database, [item UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"%@ ok\n", item);
    }
    else {
        NSLog(@"error: %s", errorMsg);
        sqlite3_free(errorMsg);
    }
}

-(void) insertTable:(NSString *)type stutas:(NSString *)stutas userId:(NSString *)userId
{
    char *errorMsg;
    //id  type  status  userId;
    NSString *insertSql = [NSString stringWithFormat:@"insert into yl_pushset(type,status,user_id) values ('%@','%@','%@')",type,stutas,userId]; //插入语句
    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"insert ok.\n");
    }
    else {
        NSLog(@"can't insert it to table\n");
        [self ErrorReport:insertSql];
    }
}

//更新数据库
-(void)updateTable:(NSString *)userId type:(NSString *)type stutas:(NSString *)stutas
{
    char *errorMsg;
    //id  type  status  userId;
    NSString *insertSql = [NSString stringWithFormat:@"update yl_pushset set status = '%@' where user_id = '%@' and type = '%@'",stutas, userId, type];
    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"update ok.\n");
    }
    else {
        NSLog(@"update fail.\n");
        [self ErrorReport:insertSql];
    }
}

//查询数据库
-(NSMutableArray *) inquire:(NSString *)userId
{
    [resulArr removeAllObjects];
    //char *errMsg;
    NSString *inquireSQL = [NSString stringWithFormat:@"select * from yl_pushset where user_id='%@'",userId];
    sqlite3_stmt *statement;
    /*
     [注：]
     sqlite3_prepare_v2把一条SQL语句（这里是inquireSQL）解析到sqlite3_stmt结构中
     试了一下这里使用sqlite3_prepare的结果是完全一样的
     [最后面有这两个函数的实现]
     */
    
        //id  type  status  userId;
    if (sqlite3_prepare_v2(database, [inquireSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"select ok.\n");
        while (sqlite3_step(statement) == SQLITE_ROW) {
//            NSString *idkey = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            NSString *type = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSString *status = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding]; //这里的0是userid在sql语句中的索引，因为我们要查询的内容有userid和name，所以userid的索引为0，name的索引为1
            NSString *userId = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            
            PushSetDateModel *model = [[PushSetDateModel alloc]init];
            model.type_ = type;
            model.stutas_ = status;
            model.userId_ = userId;
            [resulArr addObject:model];
        }
    }
    else {
        [self ErrorReport:inquireSQL];
    }
    sqlite3_finalize(statement);
       return resulArr;
}



//for search
-(BOOL) createTableForSearch
{
    
    if ([self opendatabase] == YES) {
        char *erroMsg;
        NSString *TableName = @"search_table";
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY AUTOINCREMENT,person_id TEXT,search_key_words TEXT, region_id TEXT, region_str TEXT,trade_id TEXT,trade_str TEXT,search_time TEXT,search_type TEXT)", TableName];//创建一个表    AUTOINCREMENT 这里userid的值是创建表是自动生成的，从1开始依次自增
        
        if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
            sqlite3_close(database);
            NSLog(@"create table failed.\n");
            return NO;
        }
        else {
            NSLog(@"table was created.\n");
            return YES;
        }
    }
    else
        return NO;
}

-(void) insertTableForSearch:(NSString *)personid searchKeyWords:(NSString *)searchKeyWords regionId:(NSString *)regionId regionStr:(NSString *)regionStr tradeId:(NSString *)tradeId tradeStr:(NSString *)tradeStr searchTime:(NSString *)searchTime searchType:(NSString *)searchType
{
    char *errorMsg;
    NSString *insertSql = [NSString stringWithFormat:@"insert into search_table(person_id,search_key_words, region_id, region_str,trade_id,trade_str,search_time,search_type) values ('%@','%@','%@','%@','%@','%@','%@','%@')",personid,searchKeyWords,regionId,regionStr,tradeId,tradeStr,searchTime,searchType]; //插入语句
    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"insert ok.\n");
    }
    else {
        NSLog(@"can't insert it to table\n");
        [self ErrorReport:insertSql];
    }
}


-(NSMutableArray *) inquireForSearch:(NSString *)userId
{
    [resulArr removeAllObjects];
    //char *errMsg;
    NSString *inquireSQL = [NSString stringWithFormat:@"select * from search_table where person_id='%@' order by id desc",userId];
    sqlite3_stmt *statement;
    /*
     [注：]
     sqlite3_prepare_v2把一条SQL语句（这里是inquireSQL）解析到sqlite3_stmt结构中
     试了一下这里使用sqlite3_prepare的结果是完全一样的
     [最后面有这两个函数的实现]
     */
//    personid,searchKeyWords,regionId,regionStr,tradeId,tradeStr,searchTime,searchType]; //插入语句

    //id  type  status  userId;
    if (sqlite3_prepare_v2(database, [inquireSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"select ok.\n");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //            NSString *idkey = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            NSString *searchKeyWords = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            NSString *regionId = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding]; //这里的0是userid在sql语句中的索引，因为我们要查询的内容有userid和name，所以userid的索引为0，name的索引为1
            NSString *regionStr = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            NSString *tradeId = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            NSString *tradeStr = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            NSString *searchTime = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            NSString *searchType = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            
            SearchParam_DataModal *model = [[SearchParam_DataModal alloc]init];
            model.searchKeywords_ = searchKeyWords;
            model.regionId_ = regionId;
            model.regionStr_ = regionStr;
            model.tradeId_ = tradeId;
            model.tradeStr_ = tradeStr;
            model.searchType_ = [searchType integerValue];
            model.searchTime_ = searchTime;
            [resulArr addObject:model];
        }
    }
    else {
        [self ErrorReport:inquireSQL];
    }
    sqlite3_finalize(statement);
    return resulArr;
}

//删除
-(BOOL)deleteData:(NSString *)personId searchKeyWords:(NSString *)searchKeyWords regionStr:(NSString *)regionStr tradeStr:(NSString *)tradeStr
{
    char *errorMsg;
    NSString *insertSql = [NSString stringWithFormat:@"delete from search_table where person_id='%@' and search_key_words='%@' and region_str='%@' and trade_str='%@'",personId,searchKeyWords,regionStr,tradeStr];
    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"delete ok.\n");
        return YES;
    }
    else {
        NSLog(@"delete fail! \n");
        [self ErrorReport:insertSql];
        return NO;
    }
}

//- (BOOL)deleteData:(NSString *)personId searchKeyWords:(NSString *)searchKeyWords rangStr:(NSString *)rangStr tradeStr:(NSString *)tradeStr
//{
//    char *errorMsg;
//    NSString *insertSql = [NSString stringWithFormat:@"delete from search_table where person_id='%@' and search_key_words='%@' and rang_str='%@' and trade_str='%@'", personId, searchKeyWords, rangStr, tradeStr];
//    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK)
//    {
//        NSLog(@"delete ok.\n");
//        return YES;
//    }
//    else {
//        NSLog(@"delete fail! \n");
//        [self ErrorReport:insertSql];
//        return NO;
//    }
//}

//清空数据
-(BOOL)deleteData:(NSString *)personId
{
    char *errorMsg;
    NSString *insertSql = [NSString stringWithFormat:@"delete from search_table where person_id='%@'",personId];
    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"delete ok.\n");
        return YES;
    }
    else {
        NSLog(@"delete fail! \n");
        [self ErrorReport:insertSql];
        return NO;
    }
}


//for nearJobsearch
-(BOOL)createNearJobForSearch
{
    
    if ([self opendatabase] == YES) {
        char *erroMsg;
        NSString *TableName = @"nearJobSearch_table";
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY AUTOINCREMENT,person_id TEXT,search_key_words TEXT)", TableName];//创建一个表    AUTOINCREMENT 这里userid的值是创建表是自动生成的，从1开始依次自增
        if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &erroMsg) != SQLITE_OK) {
            sqlite3_close(database);
            NSLog(@"create table failed.\n");
            return NO;
        }
        else {
            NSLog(@"table was created.\n");
            return YES;
        }
    }
    else
        return NO;
}

-(void) insertNearJobForSearch:(NSString *)personid searchKeyWords:(NSString *)searchKeyWords  tradeId:(NSString *)tradeId tradeStr:(NSString *)tradeStr
{
    char *errorMsg;

    NSString *insertSql = [NSString stringWithFormat:@"insert into nearJobSearch_table(person_id,search_key_words) values ('%@','%@')",personid,searchKeyWords]; //插入语句

    
    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"insert ok.\n");
    }
    else {
        NSLog(@"can't insert it to table\n");
        [self ErrorReport:insertSql];
    }
}

-(BOOL)deleteData:(NSString *)personId searchKeyWords:(NSString *)searchKeyWords tradeStr:(NSString *)tradeStr
{
    char *errorMsg;
    NSString *insertSql = [NSString stringWithFormat:@"delete from nearJobSearch_table where person_id='%@' and search_key_words='%@'",personId,searchKeyWords];
    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"delete ok.\n");
        return YES;
    }
    else {
        NSLog(@"delete fail! \n");
        [self ErrorReport:insertSql];
        return NO;
    }
}

-(NSMutableArray *) inquireFornearJobSearch:(NSString *)userId
{
    [resulArr removeAllObjects];
    //char *errMsg;
    NSString *inquireSQL = [NSString stringWithFormat:@"select * from nearJobSearch_table where person_id='%@' order by id desc",userId];

    sqlite3_stmt *statement;
    /*
     [注：]
     sqlite3_prepare_v2把一条SQL语句（这里是inquireSQL）解析到sqlite3_stmt结构中
     试了一下这里使用sqlite3_prepare的结果是完全一样的
     [最后面有这两个函数的实现]
     */

    
    //id  type  status  userId;
    if (sqlite3_prepare_v2(database, [inquireSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"select ok.\n");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            //            NSString *idkey = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            NSString *searchKeyWords = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            SearchParam_DataModal *model = [[SearchParam_DataModal alloc]init];
            model.searchKeywords_ = searchKeyWords;
            [resulArr addObject:model];
        }
    }
    else {
        [self ErrorReport:inquireSQL];
    }
    sqlite3_finalize(statement);
    return resulArr;
}

//清空数据
-(BOOL)deleteNearJobSearchData:(NSString *)personId
{
    char *errorMsg;
    NSString *insertSql = [NSString stringWithFormat:@"delete from nearJobSearch_table where person_id='%@'",personId];
    if (sqlite3_exec(database, [insertSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"delete ok.\n");
        return YES;
    }
    else {
        NSLog(@"delete fail! \n");
        [self ErrorReport:insertSql];
        return NO;
    }
}



@end
