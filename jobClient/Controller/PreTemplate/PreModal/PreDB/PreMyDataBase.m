//
//  PreMyDataBase.m
//  ClientTemplate
//
//  Created by job1001 job1001 on 12-12-4.
//
//

#import "PreMyDataBase.h"

static BOOL bHaveOpenBD = NO;

@implementation PreMyDataBase

-(id) init
{
    self = [super init];
    
    if( self )
    {
        if( !bHaveOpenBD )
        {
            [self openDB];
        }
    }
    
    return self;
}


//打开数据库
-(int) openDB
{
    NSString *dbFilePath = [[PreCommon getDir] stringByAppendingPathComponent:Job_DB_FileName];
    //sqlite3_open([dbFilePath UTF8String], &dataBase_);
    
    bHaveOpenBD = YES;
    
    return sqlite3_open([dbFilePath UTF8String], &dataBase_);
}

-(int) closeDB
{
    return sqlite3_close(dataBase_);
}


//删除操作
-(BOOL) deleteSQL:(NSString *)whereStr tableName:(NSString *)tableName;
{
    //[self closeDB];
    //[self openDB];
    
    char *err;
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from %@ where %@",tableName,whereStr];
    
    NSLog(@"[Delete SQL] : %@",sql);
    
    int result = sqlite3_exec(dataBase_, [sql UTF8String], NULL, NULL, &err);
    
    //[self closeDB];
    
    if( result == SQLITE_OK )
    {
        NSLog(@"[Delete SQL] : OK");
        return YES;
    }else
    {
        NSLog(@"[Delete SQL] : Fail");
        return NO;
    }
    
}

//查询操作
-(sqlite3_stmt *) selectSQL:(NSString *)orderByStr fileds:(NSString *)fileds whereStr:(NSString *)whereStr limit:(int)count tableName:(NSString *)tableName
{
    //[self closeDB];
    //[self openDB];
    
    if( !whereStr || whereStr == nil )
    {
        whereStr = [[NSString alloc] initWithFormat:@" where 1=1"];
    }else
        whereStr = [[NSString alloc] initWithFormat:@" where 1=1 and %@",whereStr];
    
    if( !fileds || [fileds isEqualToString:@""] )
    {
        fileds = @"*";
    }
    
    NSString *limitStr;
    if( count > 0 )
    {
        limitStr = [NSString stringWithFormat:@" limit %d",count];
    }else
        limitStr = @"";
    
    NSString *sql ;
    if( orderByStr )
    {
        sql =[[NSString alloc] initWithFormat:@"select %@ from %@  %@ order by  %@ %@",fileds,tableName,whereStr,orderByStr,limitStr];
    }else
        sql =[[NSString alloc] initWithFormat:@"select %@ from %@ %@ %@",fileds,tableName,whereStr,limitStr];
    
    
    NSLog(@"[Select SQL] : %@",sql);
    
    sqlite3_stmt *result ;
    sqlite3_prepare_v2(dataBase_, [sql UTF8String], -1, &result, nil);
    
    //[self closeDB];
    
    return result;
}

//分页查询
-(sqlite3_stmt *) selectSQL:(NSString *)orderByStr fileds:(NSString *)fileds whereStr:(NSString *)whereStr pageIndex:(int)pageIndex pageSize:(int)pageSize tableName:(NSString *)tableName
{
    //[self closeDB];
    //[self openDB];
    
    if( !whereStr || whereStr == nil )
    {
        whereStr = [[NSString alloc] initWithFormat:@" where 1=1"];
    }else
        whereStr = [[NSString alloc] initWithFormat:@" where 1=1 and %@",whereStr];
    
    if( !fileds || [fileds isEqualToString:@""] )
    {
        fileds = @"*";
    }
    
    NSString *sql ;
    if( orderByStr )
    {
        sql =[[NSString alloc] initWithFormat:@"select %@ from %@  %@ order by  %@ limit %d,%d",fileds,tableName,whereStr,orderByStr,pageIndex*pageSize,pageSize];
    }else
        sql =[[NSString alloc] initWithFormat:@"select %@ from %@ %@ limit %d,%d",fileds,tableName,whereStr,pageIndex*pageSize,pageSize];
    
    
    NSLog(@"[Select SQL] : %@",sql);
    
    sqlite3_stmt *result ;
    sqlite3_prepare_v2(dataBase_, [sql UTF8String], -1, &result, nil);
    
    //[self closeDB];
    
    return result;
}

//更新操作
-(BOOL) updateSQL:(NSString *)newColumnsKeyAndValue whereStr:(NSString *)whereStr tableName:(NSString *)tableName
{
    //[self closeDB];
    //[self openDB];
    
    char *err;
    NSString *sql = [[NSString alloc] initWithFormat:@"update %@ set %@ where %@",tableName,newColumnsKeyAndValue,whereStr];
    
    NSLog(@"[Update SQL] : %@",sql);
    
    int result = sqlite3_exec(dataBase_, [sql UTF8String], NULL, NULL, &err);
    
    //[self closeDB];
    
    if( result == SQLITE_OK )
    {
        return YES;
    }else
        return NO;
}

//插入操作
-(BOOL) insertSQL:(NSString *)columnsName columnsValue:(NSString *)columnsValue tableName:(NSString *)tableName
{
    //[self closeDB];
    //[self openDB];
    
    char *err;
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into %@(%@) values(%@)",tableName,columnsName,columnsValue];
    
    NSLog(@"[Insert SQL] : %@",sql);
    
    int result = sqlite3_exec(dataBase_, [sql UTF8String], NULL, NULL, &err);
    
    //[self closeDB];
    
    if( result == SQLITE_OK )
    {
        NSLog(@"[DB Insert] : OK!");
        return YES;
    }else
    {
        NSLog(@"[DB Insert] : Fail!");
        
        return NO;
    }
}

//创建推送表
-(BOOL)createPushTable{
    char *errorMsg;
    NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE yipushset(id INTEGER PRIMARY KEY,user_id TEXT,type TEXT,push_status TEXT)"];
    if(sqlite3_exec(dataBase_, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"数据表创建失败");
        sqlite3_free(errorMsg);
        return NO;
    }
    else{
        NSLog(@"数据表创建成功");
        return YES;
    }
}


//更新推送设置
-(BOOL)updatePushSet:(NSString *)userId msgType:(NSString *)msgType pushStatus:(NSString *)status
{
    char *errorMsg;
    NSString *createSQL =
    [NSString stringWithFormat:@"update yipushset set type = '%@' where user_id = '%@' and push_status='%@'",msgType, userId, status];
    if(sqlite3_exec(dataBase_, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"更新推送状态成功");
        return NO;
    }
    else{
        NSLog(@"更新推送状态失败");
        return YES;
    }
}

//查询推送设置
- (sqlite3_stmt *)queryTable:(NSString*)userId{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * From yipushset where user_id = '%@'",userId];
    NSLog(@"sql %@",sql);
    sqlite3_stmt *result;
    sqlite3_prepare_v2(dataBase_, [sql UTF8String], -1, &result, nil);
    sqlite3_step(result);
    return result;
}

//插入新的推送项
-(BOOL)insertTable:(NSString *)userId msgType:(NSString *)msgType pushStatus:(NSString *)status
{
    char *errorMsg;
    NSString *sql = [NSString stringWithFormat:@"insert into yipushset(user_id,type,push_status) values(‘%@’,'%@','%@')",userId,msgType,status];
    if (sqlite3_exec(dataBase_, [sql UTF8String],NULL, NULL, &errorMsg)!=SQLITE_OK) {
        return YES;
    }else{
        sqlite3_free(errorMsg);
        return NO;
    }
}

@end
