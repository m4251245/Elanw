//
//  ErrorInfo.m
//  SmartMarketClient
//
//  Created by sysweal on 13-3-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "ErrorInfo.h"

@implementation ErrorInfo

//get error des
+(NSString *) getErrorMsg:(ErrorCode)code
{
    NSString *str = @"未知异常";
    
    
    switch ( code ) {
        case Fail:
            str = @"请求失败";
            break;
        case No_Internet_Error://无网络
            str = @"失去信号了，刷新一下看看";
            break;
        case Init_Internet_Error:
            str = @"初始化网络失败";
            break;
        case Map_InValidate_Error:
            str = @"您未授权本程序使用您的定位功能";
            break;
        case GPS_InValidate_Error:
            str = @"您的设备未开启GPS服务";
            break;
        case Address_SVGeocoder_Error:
            str = @"地理位置信息解析失败";
            break;
        case Cache_NoData:
            str = @"缓存无数据";
            break;
        case Parser_NoData:
            str = @"没有数据,请重试";
            break;
        case Parser_InitError:
            str = @"连接服务器失败";
            break;
        case Parser_FunError:
            str = @"数据未被解析,请重试";
            break;
        case Parser_Error:
            str = @"请求失败,请重试";
            break;
        default:
            break;
    }
    
    return str;
}


@end
