//
//  Common.h
//  SmartMarketClient
//
//  Created by sysweal on 13-3-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/****************************
 
           Common类
 
 ****************************/


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonConfig.h"
#import "ErrorInfo.h"
//#import "JSONKit.h"
#import "SBJson.h"
#import "MD5.h"
#import "MyLog.h"
#import <netdb.h>
#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <AdSupport/ASIdentifierManager.h>

@interface Common : NSObject
{

}

//获取硬件id
+(NSString *) getDeviceID;

//获取本地文件存储目录
+(NSString *) getLocalStoreDir;

//获取当前时间
+(NSString *) getCurrentDateTime;

//由NSDate获取日期
+(NSString *) getDateStr:(NSDate *)date;

//格式化数字(主要用于计算器)
+(NSString *) formatNumber:(float)num precision:(int)precision;

//根据名称获取其中沙盒中的目录
+(NSString *) getSandBoxPath:(NSString *)name;

//根据名称获取其中App中的目录
+(NSString *) getResourcePath:(NSString *)name;

//检测文件是否存在
+(BOOL) checkFileExist:(NSString *)path;

//复制文件
+(BOOL) copyFile:(NSString *)srcPath desPath:(NSString *)desPath;

//复制App中的文件到指定目录
+(BOOL) copyAppFile:(NSString *)name desPath:(NSString *)desPath;

////是否wifi
//+(BOOL) isEnableWIFI;
//
////是否3G
//+(BOOL) isEnable3G;

//根据text获取自己的高度
+(float) getDynHeight:(NSString *)text objWidth:(float)width font:(UIFont *)font;

//根据text动态的设置lb
+(float) setLbByText:(UILabel *)lb text:(NSString *)text font:(UIFont *)font;

//根据text动态的设置lb(有最大行数的限制)
+(float) setLbByText:(UILabel *)lb text:(NSString *)text font:(UIFont *)font maxLine:(int)maxLine;

+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

//打电话
+(BOOL) giveCall:(NSString *)number;

+(NSString *) macaddress;

//获取设备唯一标识
+(NSString*)getUUID;

+(NSString *) utf8ToUnicode:(NSString *)string;

//获取idfv
+(NSString *)idfvString;
//创建文件
+ (void)creatFileWithPath:(NSString *)path;
@end
