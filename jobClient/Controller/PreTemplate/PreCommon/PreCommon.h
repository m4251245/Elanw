//
//  PreCommon.h
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
		
			Common
 Author:Bruce
 ***************************/


#import <Foundation/Foundation.h>
#import "PreErrorInfo.h"
#import "PreCommonConfig.h"
#import "MD5.h"
#import "ErrorInfo.h"

@interface PreCommon : NSObject {

}

//检测字符串是否为空
+(BOOL) checkStringIsNull:(const char *)str;

//转换字符到xml数据格式,(暂时只转换"&","<",">"),并且" ' "不处理
+(NSString *) converStringToXMLSoapString:(NSString *)str;

//转换到URL请求字符
+(NSString *) convertStringToURLString:(NSString *)str;

//获取当前时间
+(NSString *) getCurrentDateTime;

//由NSDate获取日期
+(NSString *) getDateStr:(NSDate *)date;

//判断手机号码是否正确
+(BOOL) isMobileNumber:(NSString *)mobileNum;

//获取硬件id
+(NSString *) getDeviceID;

//获取目录
+(NSString *) getDir;

//获取星期
+(NSString *) getWeekDay:(NSString *)dateStr;

//根据text获取自己的高度
+(float) getDynHeight:(NSString *)text objWidth:(float)width font:(UIFont *)font;

//根据text动态的设置lb
+(float) setLbByText:(UILabel *)lb text:(NSString *)text font:(UIFont *)font;

//获取行数
+(int) getLbLines:(UILabel *)lb text:(NSString *)text;

//检测是否是直辖城
+(BOOL) checkIsDirectCity:(NSString *)regionStr;

//获取切片文件名
+(NSString *) getIntroductFileName;

//日程是否可用
+(BOOL) getEKEventEnable;

//数据归档
+(id) archiverToFile:(NSArray *)dataArray fileName:(NSString *)fileName;

@end
