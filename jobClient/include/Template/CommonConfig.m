//
//  Common_Config.m
//  SmartMarketClient
//
//  Created by sysweal on 13-3-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "CommonConfig.h"
#import "Common.h"
#import "GDataXMLNode.h"

@implementation CommonConfig

//获取请求的超时时间
+(int) getRequestTimeOutSeconds
{
    static int timeOutSeconds = 0;
    if( timeOutSeconds == 0 ){
        timeOutSeconds = [[CommonConfig getValueByKey:@"RequestTimeOut_Second" category:@"Time"] intValue];
        timeOutSeconds = timeOutSeconds > 0 ? timeOutSeconds : 20;
    }
    
    return timeOutSeconds;
}

//提示框自动消失的时间
+(int) getAlertViewReleaseSeconds
{
    static int alertViewReleaseSeconds = 0;
    
    if( alertViewReleaseSeconds == 0 ){
        alertViewReleaseSeconds = [[CommonConfig getValueByKey:@"AlertViewAutoDismiss_Second" category:@"Time"] intValue];
        alertViewReleaseSeconds = alertViewReleaseSeconds > 0 ? alertViewReleaseSeconds : 20;
    }
    
    return alertViewReleaseSeconds;
}

//由Key获取值(category分类)
+(NSString *) getValueByKey:(NSString *)key category:(NSString *)category
{
    NSString *value = nil;
    
    
    if( key && ![key isEqualToString:@""] ){
        NSError *err;
        NSString *path = [Common getResourcePath:Config_XML_Name];
        NSData  *data = [NSData dataWithContentsOfFile:path];
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        
        if( !err ){
            NSString *xPath;
            if( category ){
                xPath = [NSString stringWithFormat:@"/root/%@/item",category];
            }else
                xPath = [NSString stringWithFormat:@"/root/item"];
            
            NSArray	*docElements = [doc.rootElement nodesForXPath:xPath error:&err];
            
            for ( GDataXMLElement *element in docElements )
            {
                NSString *tempKey   = [[[element elementsForName:@"key"] objectAtIndex:0] stringValue];
                NSString *tempValue = [[[element elementsForName:@"value"] objectAtIndex:0] stringValue];
                
                if( [key isEqualToString:tempKey] ){
                    value = tempValue;
                    break;
                }
            }
        }
    }
    
    //NSLog(@"[%@]<getValueByKey> : key=>%@ category=>%@ value=>%@",[self class],key,category,value);
    
    return value;
}

//获取key对应的设置值
+(NSString *) getDBValueByKey:(NSString *)key
{
    NSString *value = nil;
    
//    sqlite3_stmt *result = [[MyDataBase defaultDB] selectSQL:nil fileds:@"value" whereStr:[NSString stringWithFormat:@"key='%@'",key] limit:1 tableName:DB_Table_Config];
//    
//    while ( sqlite3_step(result) == SQLITE_ROW )
//    {
//        //data
//        char *rowData_0 = (char *)sqlite3_column_text(result, 0);
//        value = [[NSString alloc] initWithCString:rowData_0 encoding:NSUTF8StringEncoding];
//
//        //value = [NSString stringWithFormat:@"%s",rowData_0];
//    }
//    sqlite3_finalize(result);
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"commonConfigDicData"];
    if (dic) {
        value = [dic objectForKey:key];
    }
    return value;
}

//设置key对应的设置值
+(BOOL) setDBValueByKey:(NSString *)key value:(NSString *)value
{
    if (!value) {
        return NO;
    }
    BOOL flag = NO;
//    //先将以前的删除
//    [[MyDataBase defaultDB] deleteSQL:[NSString stringWithFormat:@"key='%@'",key] tableName:DB_Table_Config];
//    
//    //插入新数据
//    NSString *columnsName = [[NSString alloc] initWithFormat:@"key,value,create_datetime"];
//    NSString *columnsValue = [[NSString alloc] initWithFormat:@"'%@','%@','%@'",key,value,[Common getCurrentDateTime]];
//    
//    //插入数据
//    flag = [[MyDataBase defaultDB] insertSQL:columnsName columnsValue:columnsValue tableName:DB_Table_Config];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"commonConfigDicData"];
    NSMutableDictionary *dicOne;
    if (dic) {
        dicOne = [[NSMutableDictionary alloc] initWithDictionary:dic];
    }else{
        dicOne = [[NSMutableDictionary alloc] init];
    }
    [dicOne setObject:value forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:dicOne forKey:@"commonConfigDicData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return flag;
}

//获取分页大小
+(int) getPageSize
{
    static int pageSize;
    
    if( !pageSize )
    pageSize = [[CommonConfig getValueByKey:@"Page_Size" category:@"ClientBaseInfo"] intValue];
    
    return pageSize;
}


//获取key对应的脸萌头像值
+(NSString *)getLianMengImageValueByKey:(NSString *)key
{
    NSString *value = nil;
    
    sqlite3_stmt *result = [[MyDataBase defaultDB] selectSQL:nil fileds:@"value" whereStr:[NSString stringWithFormat:@"key='%@'",key] limit:1 tableName:@"LianMengImage"];
    
    while ( sqlite3_step(result) == SQLITE_ROW )
    {
        //data
        char *rowData_0 = (char *)sqlite3_column_text(result, 0);
        value = [[NSString alloc] initWithCString:rowData_0 encoding:NSUTF8StringEncoding];
        
        //value = [NSString stringWithFormat:@"%s",rowData_0];
    }
    sqlite3_finalize(result);
    
    return value;
}


@end
