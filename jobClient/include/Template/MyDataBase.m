//
//  MyDataBase.m
//  ClientTemplate
//
//  Created by job1001 job1001 on 12-12-4.
//
//

#import "MyDataBase.h"

static BOOL bHaveOpenBD = NO;

//DB
static MyDataBase *db;

@implementation MyDataBase

//获取实例
+(MyDataBase *) defaultDB
{
    if( !db ){
        db = [[MyDataBase alloc] init];
    }
    
    return db;
}

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
    NSString *dbFilePath = [Common getSandBoxPath:DB_FileName];
    
    bHaveOpenBD = YES;
    
    int  result = sqlite3_open([dbFilePath UTF8String], &dataBase_);
    
    return result;
}

-(int) closeDB
{
    return sqlite3_close(dataBase_);
}

//删除操作
-(BOOL) deleteSQL:(NSString *)whereStr tableName:(NSString *)tableName;
{
    //[self closeDB];
    [self openDB];
    
    char *err;
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from %@ where %@",tableName,whereStr];
    
    //NSLog(@"[Delete SQL] : %@",sql);
    
    int result = sqlite3_exec(dataBase_, [sql UTF8String], NULL, NULL, &err);
    
    [self closeDB];
    
    if( result == SQLITE_OK )
    {
       // NSLog(@"[Delete SQL] : OK");
        return YES;
    }else
    {
        //NSLog(@"[Delete SQL] : Fail");
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
        whereStr = @" where 1=1";
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
    
    
   // NSLog(@"[Select SQL] : %@",sql);
    
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
        whereStr = @" where 1=1";
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
    
    
    //NSLog(@"[Select SQL] : %@",sql);
    
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
    
    //NSLog(@"[Update SQL] : %@",sql);
    
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
//    [self openDB];
    
    char *err;
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into %@(%@) values(%@)",tableName,columnsName,columnsValue];
    
    //NSLog(@"[Insert SQL] : %@",sql);
    
    int result = sqlite3_exec(dataBase_, [sql UTF8String], NULL, NULL, &err);
    
//    [self closeDB];
    
    if( result == SQLITE_OK )
    {
        //NSLog(@"[DB Insert] : OK!");
        return YES;
    }else
    {
        NSLog(@"[DB Insert] : Fail! for error: %d",result);
        
        return NO;
    }
}


//收到推送添加到数据库
-(BOOL)insertPushMessageSQL:(NSString*)messgid  type:(NSString*)type publishname:(NSString*)publishName content:(NSString*)content time:(NSString *)time userId:(NSString *)userId beNew:(NSString *)beNew
{
    char *err;
    
    NSString * sql1 =[[NSString alloc] initWithFormat:@"CREATE TABLE yl_message (be_new TEXT,user_id TEXT,_id INTEGER PRIMARY KEY ,messageId TEXT,time TEXT,type TEXT,publishName TEXT,content TEXT)"];
    int result1 = sqlite3_exec(dataBase_, [sql1 UTF8String], NULL, NULL, &err);
    NSLog(@"%d",result1);
    
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into %@(%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@','%@')",DB_Table_Message,@"messageId",@"type",@"publishName",@"content",@"time",@"user_id",@"be_new",messgid,type,publishName,content,time,userId,beNew];
    
    
    int result = sqlite3_exec(dataBase_, [sql UTF8String], NULL, NULL, &err);
    
    //[self closeDB];
    
    if( result == SQLITE_OK )
    {
        //NSLog(@"[DB Insert] : OK!");
        return YES;
    }else
    {
        //NSLog(@"[DB Insert] : Fail!");
        
        return NO;
    }
    
}

//消息已被阅记录到数据库
-(BOOL)insertMessagebRead:(NSString*)messageId userId:(NSString*)userId time:(NSString*)time
{
    char *err;
    
    NSString * sql1 =[[NSString alloc] initWithFormat:@"CREATE TABLE message_MarkRead (user_id TEXT,_id INTEGER PRIMARY KEY ,messageId TEXT,time TEXT)"];
    int result1 = sqlite3_exec(dataBase_, [sql1 UTF8String], NULL, NULL, &err);
    NSLog(@"%d",result1);
    
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into %@(%@,%@,%@) values('%@','%@','%@')",@"message_MarkRead",@"messageId",@"time",@"user_id",messageId,time,userId];
    
    
    int result = sqlite3_exec(dataBase_, [sql UTF8String], NULL, NULL, &err);
    
    //[self closeDB];
    
    if( result == SQLITE_OK )
    {
        //NSLog(@"[DB Insert] : OK!");
        return YES;
    }else
    {
        //NSLog(@"[DB Insert] : Fail!");
        
        return NO;
    }

}

//墨缘收到推送存到数据库
-(BOOL)insertMoyPush:(NSString *)contentId type:(NSString*)type publishname:(NSString*)publishName content:(NSString*)content classId:(NSString*)classId time:(NSString*)time userId:(NSString*)userId beNew:(NSString*)beNew
{
    char *err;
    
    NSString * sql1 =[[NSString alloc] initWithFormat:@"CREATE TABLE moy_message (be_new TEXT,user_id TEXT,_id INTEGER PRIMARY KEY ,contentId TEXT,time TEXT,type TEXT,publishName TEXT,content TEXT,classId TEXT)"];
    int result1 = sqlite3_exec(dataBase_, [sql1 UTF8String], NULL, NULL, &err);
    NSLog(@"%d",result1);
    
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into %@(%@,%@,%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@','%@','%@',%@)",DB_Table_MoyuanMessage,@"contentId",@"type",@"publishName",@"content",@"time",@"user_id",@"be_new",@"classId",contentId,type,publishName,content,time,userId,beNew,classId];
    
    
    int result = sqlite3_exec(dataBase_, [sql UTF8String], NULL, NULL, &err);
    
    //[self closeDB];
    
    if( result == SQLITE_OK )
    {
        //NSLog(@"[DB Insert] : OK!");
        return YES;
    }else
    {
        //NSLog(@"[DB Insert] : Fail!");
        
        return NO;
    }

    
}


-(BOOL)insertMoyNote:(NSString *)contentId publishname:(NSString*)publishName content:(NSString*)content classId:(NSString*)classId time:(NSString*)time userId:(NSString*)userId courseId:(NSString*)courseId  isCreate:(BOOL)create
{
    char *err;
    if (create) {
        NSString * sql1 =[[NSString alloc] initWithFormat:@"CREATE TABLE moy_note (courseId TEXT,user_id TEXT,_id INTEGER PRIMARY KEY AUTOINCREMENT,time TEXT,publishName TEXT,content TEXT,classId TEXT)"];
        int result1 = sqlite3_exec(dataBase_, [sql1 UTF8String], NULL, NULL, &err);
        
        if( result1 == SQLITE_OK )
        {
            //NSLog(@"[DB Insert] : OK!");
            return YES;
        }else
        {
            //NSLog(@"[DB Insert] : Fail!");
            
            return NO;
        }

    }
    
    
    else
    {
        NSString *sql = [[NSString alloc] initWithFormat:@"insert into %@(%@,%@,%@,%@,%@,%@) values('%@','%@','%@','%@','%@',%@)",@"moy_note",@"publishName",@"content",@"time",@"user_id",@"classId",@"courseId",publishName,content,time,userId,classId,courseId];
        
        
        int result = sqlite3_exec(dataBase_, [sql UTF8String], NULL, NULL, &err);
        
        //[self closeDB];
        
        if( result == SQLITE_OK )
        {
            //NSLog(@"[DB Insert] : OK!");
            return YES;
        }else
        {
            //NSLog(@"[DB Insert] : Fail!");
            
            return NO;
        }

    }
    
    
}


@end
