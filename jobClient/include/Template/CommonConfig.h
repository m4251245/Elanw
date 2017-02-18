//
//  Common_Config.h
//  SmartMarketClient
//
//  Created by sysweal on 13-3-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/****************************
 
       CommonConfig配置类
 
 ****************************/

#import <Foundation/Foundation.h>
//#import "GDataXMLNode.h"
#import "MyDataBase.h"
#import "AccessToken_DataModal.h"
@class GDataXMLNode;
#define Config_XML_Name                             @"Config.xml"
#define DB_FileName                                 @"base_db.sqlite"

#define WebService_User                             @"iphone"
#define WebService_Pwd                              @"123"

//DB里面的TableName
#define DB_Table_LocalCache                         @"local_cache"
#define DB_Table_Config                             @"config"
//数据库中的推送消息表
#define DB_Table_Message                            @"yl_message"
#define DB_Table_MoyuanMessage                      @"moy_message"

#define DES_KEY                                     @"M*JOB@10"


#define StatusHeight                                20.0
#define MainWidth                                   [[UIScreen mainScreen] bounds].size.height
#define MainHeight                                  ([[UIScreen mainScreen] bounds].size.width - StatusHeight)
#define TabBar_Height                               60.0
#define NavBar_Height                               44.0

#define SubBtn_BG_On                                @"btn_service_on.png"
#define SubBtn_BG_Off                               @"btn_service_off.png"


//动画ID
#define AnimatID_SelfModel                          @"CtlSelfModel"
#define AnimatID_FullModel                          @"CtlFullModel"

@interface CommonConfig : NSObject
{
    
}

//获取请求的超时时间
+(int) getRequestTimeOutSeconds;

//提示框自动消失的时间
+(int) getAlertViewReleaseSeconds;

//由Key获取值(category分类)
+(NSString *) getValueByKey:(NSString *)key category:(NSString *)category;

//获取key对应的设置值
+(NSString *) getDBValueByKey:(NSString *)key;

//设置key对应的设置值
+(BOOL) setDBValueByKey:(NSString *)key value:(NSString *)value;

//获取分页大小
+(int) getPageSize;

//获取key对应的脸萌头像值
+(NSString *)getLianMengImageValueByKey:(NSString *)key;

@end

