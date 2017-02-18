//
//  Common.m
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PreCommon.h"
#import <EventKitUI/EventKitUI.h> 
#import "NSString+Size.h"

@implementation PreCommon

//检测字符串是否为空
+(BOOL) checkStringIsNull:(const char *)str
{	
	const char *temp = str;
	while ( temp ) 
	{
		if( *temp == '\0' )
		{
			break;
		}
		
		if( *temp != 32 && *temp != '\n' )
		{
			return NO;
		}
		
		temp++;
	}
	
	return YES;
}

//转换字符到xml数据格式,(暂时只转换"&","<",">"),并且" ' "不处理
+(NSString *) converStringToXMLSoapString:(NSString *)str
{
    if( !str || str == nil )
    {
        return nil;
    }
    
    NSMutableString *newStr = [[[NSMutableString alloc] initWithString:str] autorelease];
    
    NSRange rang;
    rang.length = [newStr length];
    rang.location = 0;
    [newStr replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSUTF8StringEncoding range:rang];
    
    rang.length = [newStr length];
    rang.location = 0;
    [newStr replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSUTF8StringEncoding range:rang];
    
    rang.length = [newStr length];
    rang.location = 0;
    [newStr replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSUTF8StringEncoding range:rang];
    
    rang.length = [newStr length];
    rang.location = 0;
    [newStr replaceOccurrencesOfString:@"'" withString:@"" options:NSUTF8StringEncoding range:rang];
    
    return newStr;
}

//转换到URL请求字符
+(NSString *) convertStringToURLString:(NSString *)str
{
    if( !str || [str isEqualToString:@""] )
    {
        return [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    NSString *temp = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)str,NULL,(CFStringRef)@"!*'();:@&=+-$,/?%#[]",kCFStringEncodingUTF8);
    [temp autorelease];

    return temp;
}


//获取当前时间
+(NSString *) getCurrentDateTime
{
    return [[NSDate date] stringWithFormatDefault];
}

//由NSDate获取日期
+(NSString *) getDateStr:(NSDate *)date
{
    return [date stringWithFormat:@"yyyy-MM-dd"];
}

//判断手机号码是否正确
+(BOOL) isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else 
    {
        return NO;
    }
}

//获取硬件id
+(NSString *) getDeviceID
{
    return @"123456789";
    
//    //获取设备id号
//    UIDevice *device = [UIDevice currentDevice];//创建设备对象
//    NSString *deviceUID = [[[NSString alloc] initWithString:[device uniqueIdentifier]] autorelease];
//    
//    return deviceUID;
}

//获取目录
+(NSString *) getDir
{
    NSString *documentsDirectory = NSHomeDirectory();
    documentsDirectory = [NSString stringWithFormat:@"%@/Library/Caches",documentsDirectory];
        
    return documentsDirectory;
}

//获取星期
+(NSString *) getWeekDay:(NSString *)dateStr
{
    if( !dateStr || [dateStr isEqualToString:@""] || [dateStr length] < 10 ){
        return 0;
    }
    NSDate *date = [dateStr dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease]; 
    NSDateComponents *weekdayComponents = [gregorian components:(NSCalendarUnitWeekday) fromDate:date];
    
    NSString *weekStr = @"未知";
    switch ( [weekdayComponents weekday] ) {
        case 1:
            weekStr = @"星期日";
            break;
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
        default:
            weekStr = @"未知";
            break;
    }
            
    return weekStr;
}

//根据text获取自己的高度
+(float) getDynHeight:(NSString *)text objWidth:(float)width font:(UIFont *)font
{
    float height = 0.0;
    CGSize titleBrandSizeForHeight = [text sizeNewWithFont:font];
    CGSize titleBrandSizeForLines = [text sizeNewWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    int lines = ceil(titleBrandSizeForLines.height/titleBrandSizeForHeight.height);
    if (lines <= 1) {
        height = titleBrandSizeForHeight.height;
    }else {
        height = lines*titleBrandSizeForHeight.height;
    }
    
    return height;
}

//根据text动态的设置lb
+(float) setLbByText:(UILabel *)lb text:(NSString *)text font:(UIFont *)font
{
    if( !font ){
        font = lb.font;
    }
    
    float height = 0.0;
    lb.text = text;
    lb.font = font;
    CGSize titleBrandSizeForHeight = [text sizeNewWithFont:font];
    CGSize titleBrandSizeForLines = [text sizeNewWithFont:font constrainedToSize:CGSizeMake(lb.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    int lines = ceil(titleBrandSizeForLines.height/titleBrandSizeForHeight.height);
    if (lines <= 1) {
        height = titleBrandSizeForHeight.height;
    }else {
        height = lines*titleBrandSizeForHeight.height;
    }
    
    lb.numberOfLines = lines;
    
    [lb setFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y, lb.frame.size.width, height)];
    
    return height;
}

//获取行数
+(int) getLbLines:(UILabel *)lb text:(NSString *)text
{
    CGSize titleBrandSizeForHeight = [text sizeNewWithFont:lb.font];
    CGSize titleBrandSizeForLines = [text sizeNewWithFont:lb.font constrainedToSize:CGSizeMake(lb.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return ceil(titleBrandSizeForLines.height/titleBrandSizeForHeight.height);
}

//检测是否是直辖城
+(BOOL) checkIsDirectCity:(NSString *)regionStr
{
    BOOL bDirectCity = NO;
    if( regionStr )
    {
        if( [regionStr isEqualToString:@"北京"] || [regionStr isEqualToString:@"上海"] || [regionStr isEqualToString:@"天津"] || [regionStr isEqualToString:@"重庆"] )
        {
            bDirectCity = YES;
        }
    }
    
    return bDirectCity;
}

//获取切片文件名
+(NSString *) getIntroductFileName
{
    //return [NSString stringWithFormat:@"introduct_%@",Client_Current_Version];
    return [NSString stringWithFormat:@"introduct_%@",@"1.6"];
}

+(BOOL) getEKEventEnable
{
//    __block BOOL flag = YES;
//    //    // Get the event store object
//    EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
//    //request to sys db
//    if( [eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)] ){
//        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL bEnable,NSError *err)
//         {
//             NSLog(@"%d",bEnable);
//            flag = bEnable;
//         }
//        ];
//    }
    
    return YES;
}

+(id) archiverToFile:(NSArray *)dataArray fileName:(NSString *)fileName
{
    NSString *documentsDirectory = NSHomeDirectory();
    documentsDirectory = [NSString stringWithFormat:@"%@/Library/Caches",documentsDirectory];
    
	if(!documentsDirectory)
	{
		return false;
	}
	
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [NSKeyedArchiver archiveRootObject:dataArray toFile:appFile];
    
    return nil;
}

+(id) unArchiverFromFile:(NSString *)fileName
{
    NSString *documentsDirectory = NSHomeDirectory();
    documentsDirectory = [NSString stringWithFormat:@"%@/Library/Caches",documentsDirectory];
    
	if(!documentsDirectory)
	{
		return nil;
	}
	
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    id fileData;
    @try {
        fileData = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    }
    @catch (NSException *exception) {
        fileData = nil;
    }
    @finally {
        
    }
    
    return fileData;
}

@end
