//
//  PreCommonConfig.m
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PreCommonConfig.h"
#import "PreCommon.h"

@implementation PreCommonConfig


//get service address
+(NSString *) getServiceDefaultAddress
{
    return [NSString stringWithFormat:@"%@&user=%@&pwd=%@",WebServiceAddress,Op_User,Op_Pwd];
}

//get alert view release seconds
+(int) getAlertViewReleaseSeconds
{
	return AlertView_Release_Seconds;
}

//get bg name
+(NSString *) getBgName
{
    return BG_Default;
}

//由时间获取bg
+(NSString *) getBgNameByTime
{
    NSString *str = @"bg_moon@2x.png";
    
    int hour = [[[[PreCommon getCurrentDateTime] substringFromIndex:11] substringToIndex:2] intValue];
    
    //如果是早上
    if( hour >= 6 && hour <= 10 ){
        str = @"bg_morning@2x.jpg";
    }
    //中午
    else if( hour > 10 && hour <= 16 )
    {
        str = @"bg_moon@2x.png";
    }
    //下午
    else if( hour > 16 && hour <= 19 ){
        str = @"bg_aftermoon@2x.jpg";
    }
    //晚上
    else{
        str = @"bg_night@2x.png";
    }
    
    return str;
}

//get search bg name
+(NSString *) getSearchBarBgName
{
    return BG_SearchBar;
}

//由星期获取颜色
+(UIColor *) getWeekDayColor:(NSString *)week
{
    UIColor *color = [UIColor grayColor];
    
    //星期一
    if( [week isEqualToString:@"星期一"] ){
        color = [UIColor colorWithRed:90.0/255.0 green:193.0/255.0 blue:140.0/255 alpha:1];
    }
    //星期二
    else if( [week isEqualToString:@"星期二"] ){
        color = [UIColor colorWithRed:194.0/255.0 green:214.0/255.0 blue:105.0/255 alpha:1];
    }
    //星期三
    else if( [week isEqualToString:@"星期三"] ){
        color = [UIColor colorWithRed:241.0/255.0 green:153.0/255.0 blue:129.0/255 alpha:1];
    }
    //星期四
    else if( [week isEqualToString:@"星期四"] ){
        color = [UIColor colorWithRed:253.0/255.0 green:104.0/255.0 blue:107.0/255 alpha:1];
    }
    //星期五
    else if( [week isEqualToString:@"星期五"] ){
        color = [UIColor colorWithRed:217.0/255.0 green:139.0/255.0 blue:180.0/255 alpha:1];
    }
    //星期六
    else if( [week isEqualToString:@"星期六"] ){
        color = [UIColor colorWithRed:131.0/255.0 green:158.0/255.0 blue:181.0/255 alpha:1];
    }
    //星期日
    else if( [week isEqualToString:@"星期日"] ){
        color = [UIColor colorWithRed:222.0/255.0 green:200.0/255.0 blue:98.0/255 alpha:1];
    }
    
    return color;
}

//获取恢色边框颜色
+(UIColor *) getBoundsGrayColor
{
    return [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
}

//获取请求的操时时间
+(int) getRequestTimeOutSeconds
{
    return Request_TimeOut_Seconds;
}

@end
