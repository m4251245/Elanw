//
//  PreMyDataBase.h
//  ClientTemplate
//
//  Created by job1001 job1001 on 12-12-4.
//
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "PreCommon.h"

@interface PreMyDataBase : NSObject{
    sqlite3                 *dataBase_;
}

//打开数据库
-(int) openDB;

//关闭数据库
-(int) closeDB;

//删除操作
-(BOOL) deleteSQL:(NSString *)whereStr tableName:(NSString *)tableName;

//查询操作
-(sqlite3_stmt *) selectSQL:(NSString *)orderByStr fileds:(NSString *)fileds whereStr:(NSString *)whereStr limit:(int)count tableName:(NSString *)tableName;

//分页查询
-(sqlite3_stmt *) selectSQL:(NSString *)orderByStr fileds:(NSString *)fileds whereStr:(NSString *)whereStr pageIndex:(int)pageIndex pageSize:(int)pageSize tableName:(NSString *)tableName;

//更新操作
-(BOOL) updateSQL:(NSString *)newColumnsKeyAndValue whereStr:(NSString *)whereStr tableName:(NSString *)tableName;

//插入操作
-(BOOL) insertSQL:(NSString *)columnsName columnsValue:(NSString *)columnsValue tableName:(NSString *)tableName;

//创建推送表
-(BOOL)createPushTable;

//增加推送项
-(BOOL)insertTable:(NSString *)userId msgType:(NSString *)msgType pushStatus:(NSString *)status;

//查询推送设置
- (sqlite3_stmt *)queryTable:(NSString*)userId;

@end
