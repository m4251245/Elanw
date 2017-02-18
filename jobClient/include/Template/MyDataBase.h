//
//  MyDataBase.h
//  ClientTemplate
//
//  Created by job1001 job1001 on 12-12-4.
//
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Common.h"

@interface MyDataBase : NSObject{
    sqlite3                 *dataBase_;
}

//获取实例
+(MyDataBase *) defaultDB;

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

//收到推送添加到数据库
-(BOOL)insertPushMessageSQL:(NSString*)messgid  type:(NSString*)type publishname:(NSString*)publishName content:(NSString*)content  time:(NSString*)time  userId:(NSString*)userId beNew:(NSString*)beNew;

//消息已被阅记录到数据库
-(BOOL)insertMessagebRead:(NSString*)messageId userId:(NSString*)userId time:(NSString*)time;

//墨缘收到推送存到数据库
-(BOOL)insertMoyPush:(NSString *)contentId type:(NSString*)type publishname:(NSString*)publishName content:(NSString*)content classId:(NSString*)classId time:(NSString*)time userId:(NSString*)userId beNew:(NSString*)beNew;

-(BOOL)insertMoyNote:(NSString *)contentId publishname:(NSString*)publishName content:(NSString*)content classId:(NSString*)classId time:(NSString*)time userId:(NSString*)userId courseId:(NSString*)courseId isCreate:(BOOL)create;
@end