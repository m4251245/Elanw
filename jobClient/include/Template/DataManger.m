//
//  DataManger.m
//  Template
//
//  Created by sysweal on 13-9-18.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "DataManger.h"

@implementation DataManger

//存放数据
+(void) saveData:(NSString *)key data:(NSData *)data type:(DataType)type
{
    if( !key || !data ){
        [MyLog Log:@"DataManager saveData Fail,key or data is null" obj:NULL];
        
        return;
    }else{
        [MyLog Log:[NSString stringWithFormat:@"DataManager saveData<key=%@,dataLength=>%lu>",key,(unsigned long)[data length]] obj:NULL];
    }
    
    switch ( type ) {
        case Data_DB:
        {
            BOOL bSuccess = FALSE;
            
            NSString *valueStr = [[NSString alloc]
                                  initWithBytes:[data bytes]
                                  length:[data length]
                                  encoding:NSUTF8StringEncoding];
            
            if( valueStr && ![valueStr isEqualToString:@""] ){
                //先将以前的删除
                [[MyDataBase defaultDB] deleteSQL:[NSString stringWithFormat:@"key='%@'",key] tableName:DB_Table_LocalCache];
                
                //插入新数据
                NSString *dateStr = [Common getCurrentDateTime];
                NSString *columnsName = [[NSString alloc] initWithFormat:@"key,value,create_datetime"];
                NSString *columnsValue = [[NSString alloc] initWithFormat:@"'%@','%@','%@'",key,valueStr,dateStr];
                
                //插入数据
                bSuccess = [[MyDataBase defaultDB] insertSQL:columnsName columnsValue:columnsValue tableName:DB_Table_LocalCache];
            }
            
            if( bSuccess ){
                [MyLog Log:@"DataManager save data to db OK" obj:NULL];
            }else{
                [MyLog Log:@"DataManager save data to db Fail" obj:NULL];
            }
        }
            break;
        case Data_File:
        {
            BOOL bSuccess = [data writeToFile:[Common getSandBoxPath:[MD5 getMD5:key]] atomically:YES];
            
            if( bSuccess ){
                [MyLog Log:@"DataManager Write File OK" obj:NULL];
            }else{
                [MyLog Log:@"DataManager Write File Fail" obj:NULL];
            }
        }
            break;
        default:
            break;
    }

}

//获取数据据(cacheSeconds 0:返回null <0:不会判断缓存时间 >0:根据缓存时间返回数据)
+(NSData *) getData:(NSString *)key cacheSeconds:(long)seconds type:(DataType)type
{
//    [MyLog Log:[NSString stringWithFormat:@"DataManager getData<key=%@ type=%d>",key,type] obj:NULL];
    
    if( seconds == 0 ){
        [MyLog Log:@"DataManager the validate seconds is 0 , i return null to you" obj:nil];
        return nil;
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    switch ( type ) {
        case Data_DB:
        {
            NSString *timeStr = @"1=1";
            if( seconds > 0 ){
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:seconds];
                NSString *dateStr = [Common getDateStr:date];
                timeStr = [NSString stringWithFormat:@"create_datetime>='%@'",dateStr];
            }
            sqlite3_stmt *result = [[MyDataBase defaultDB] selectSQL:nil fileds:@"value" whereStr:[NSString stringWithFormat:@"key='%@' and %@",key,timeStr] limit:1 tableName:DB_Table_LocalCache];
            
            while ( sqlite3_step(result) == SQLITE_ROW )
            {
                //data
                char *rowData_0 = (char *)sqlite3_column_text(result, 0);
                [data setData:[NSData dataWithBytes:rowData_0   length:strlen(rowData_0)]];
            }
            sqlite3_finalize(result);
            
            if( [data length] <= 0 ){
                [MyLog Log:@"DataManger can't find data in DB" obj:NULL];
            }else{
                [MyLog Log:@"DataManger find data in DB" obj:NULL];
            }
        }
            break;
        case Data_File:
        {
            //先到App所在的沙盒中去找
            NSString *filePath = [Common getSandBoxPath:[MD5 getMD5:key]];
            [data setData:[NSData dataWithContentsOfFile:filePath]];
            
            //如果沙盒中没有，再到App中的资源文件中去找
            if( [data length] >0 ){
                [MyLog Log:@"DataManager find file data in SandBox" obj:NULL];
            }else{
                NSString *filePath = [Common getResourcePath:[MD5 getMD5:key]];
                
                [data setData:[NSData dataWithContentsOfFile:filePath]];
                
                if( [data length] > 0 ){
                    [MyLog Log:@"DataManager find file data in App" obj:NULL];
                }else{
                    [MyLog Log:@"DataManager can't find file data in SandBox or App" obj:NULL];
                }
            }
        }
            break;
        default:
            break;
    }
    
    if( [data length] <= 0 ){
        data = NULL;
    }
    
    return data;
}

@end
