//
//  MyCommon.m
//  MBA
//
//  Created by sysweal on 13-11-14.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "FMDatabase.h"

NSString * deviceToken_;

@implementation MyCommon


//获取当前时间
+(NSString*)getNowTime
{
    NSDate * now = [NSDate date];
    
    return now.description;
}

//处理时间(eg:2013-10-1)
+(NSString *) getShortTime:(NSString *)timeStr
{
    return [timeStr substringToIndex:10];
}

//处理时间(eg:10-1)
+(NSString *) getMidTime:(NSString *)timeStr
{
    NSRange range;
    range.location = 5;
    range.length = 5;
    return [timeStr substringWithRange:range];
}

//获取NSDate
+(NSDate *) getDate:(NSString *)timeStr
{
    return [timeStr dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
}

//获取时间Str
+(NSString *) getDateStr:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : format];
    
    return [formatter stringFromDate:date];
}


+ (NSString *)getTimeWithString:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStr longLongValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//给某视图添加点击事件
+(UITapGestureRecognizer *) addTapGesture:(UIView *)view target:(id)target numberOfTap:(int)cnt sel:(SEL)sel
{
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    singleRecognizer.numberOfTapsRequired = cnt; // 单击
    [view addGestureRecognizer:singleRecognizer];
    
    return singleRecognizer;
}

//移除某视图的点击事件
+(void) removeTapGesture:(UIView *)view ges:(UITapGestureRecognizer *)ges
{
    if( ges && view )
        [view removeGestureRecognizer:ges];
}

//从文件反序列化出数据
+(id) unArchiverFromFile:(NSString *)fileName
{
    id fileData;
    @try {
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],fileName]];
        fileData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        fileData = nil;
    }
    @finally {
        
    }
    
    return fileData;
}

//转换HTML实体-当前使用的方法
+(NSString *)translateHTML:(NSString*)html
{
    if( !html || ![html isKindOfClass:[NSString class]] ){
        return @"";
    }
//    if (![html containsString:@"&"] || ![html containsString:@";"]) {
//        return html;
//    }
    
    NSMutableString *str = [NSMutableString stringWithString:html];
    NSRange rang;
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSCaseInsensitiveSearch range:rang];
    
    rang.length = str.length;
    [str replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSCaseInsensitiveSearch range:rang];
    
    rang.length = str.length;
    [str replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSCaseInsensitiveSearch range:rang];
    
    rang.length = str.length;
    [str replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:rang];
    
    rang.length = str.length;
    [str replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSCaseInsensitiveSearch range:rang];
    
    rang.length = str.length;
    [str replaceOccurrencesOfString:@"&apos;" withString:@"'" options:NSCaseInsensitiveSearch range:rang];
    
    rang.length = str.length;
    [str replaceOccurrencesOfString:@"<br/>" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    
    NSRegularExpression *regular;
    regular = [[NSRegularExpression alloc] initWithPattern:@"&[A-Za-z0-9_]{0,10};|&#(\\d{0,10});" 
                                                   options:NSRegularExpressionCaseInsensitive 
                                                     error:nil];
    NSString *string = [regular stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
        
    return string;
    
}

+(NSString *)removeHtmlImg:(NSString *)str{
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"<img(.*?)>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *string = [regular stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@""];
    return string;
}

//将HTML标签去掉
+(NSString *)filterHTML:(NSString *)html
{
    if( !html || ![html isKindOfClass:[NSString class]] ){
        return @"";
    }
    
    NSMutableString *str = [NSMutableString stringWithString:html];
    NSRange rang;
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"&lt;br /&gt;" withString:@"\n" options:NSCaseInsensitiveSearch range:rang];
    html = str;
    
    str = [NSMutableString stringWithString:html];
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"<br />" withString:@"\n" options:NSCaseInsensitiveSearch range:rang];
    html = str;
    
    str = [NSMutableString stringWithString:html];
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSCaseInsensitiveSearch range:rang];
    html = str;
    
    str = [NSMutableString stringWithString:html];
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"<br/>" withString:@"\n" options:NSCaseInsensitiveSearch range:rang];
    html = str;
    
    str = [NSMutableString stringWithString:html];
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"<div>" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    html = str;
    
    str = [NSMutableString stringWithString:html];
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"</div>" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    html = str;
    
    @try {
        NSScanner * scanner = [NSScanner scannerWithString:html];
        NSString * text = nil;
        
        while([scanner isAtEnd]==NO)
        {
            //找到标签的起始位置
            [scanner scanUpToString:@"&lt;" intoString:nil];
            //找到标签的结束位置
            [scanner scanUpToString:@"&gt;" intoString:&text];
            //替换字符
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@&gt;",text] withString:@""];
        }
        
        NSMutableString *str = [NSMutableString stringWithString:html];
        NSRange rang;
        rang.location = 0;
        rang.length = [html length];
        [str replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:rang];
        html = str;
        scanner = [NSScanner scannerWithString:html];
        text = nil;
        while([scanner isAtEnd]==NO)
        {
            //找到标签的起始位置
            [scanner scanUpToString:@"&" intoString:nil];
            //找到标签的结束位置
            [scanner scanUpToString:@";" intoString:&text];
            //替换字符
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;",text] withString:@""];
        }
    }
    @catch (NSException *exception) {
        html = @"";
    }
    @finally {
        
    }
    
    return html;
}

+(NSString *)MyfilterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

+(NSString *)MyfilterHTMLExceptBr:(NSString *)html
{
    if( !html || ![html isKindOfClass:[NSString class]] ){
        return @"";
    }
    
    NSMutableString *str = [NSMutableString stringWithString:html];
    NSRange rang;
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"&lt;br /&gt;" withString:@"\n" options:NSCaseInsensitiveSearch range:rang];
    html = str;
    
    str = [NSMutableString stringWithString:html];
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"<br />" withString:@"\n" options:NSCaseInsensitiveSearch range:rang];
    html = str;
    
    str = [NSMutableString stringWithString:html];
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSCaseInsensitiveSearch range:rang];
    html = str;
    
    str = [NSMutableString stringWithString:html];
    rang.location = 0;
    rang.length = [html length];
    [str replaceOccurrencesOfString:@"<br/>" withString:@"\n" options:NSCaseInsensitiveSearch range:rang];
    html = str;

    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

//去掉双重\n
+(NSString *) filterDoubleWrapLine:(NSString *)str
{
    if( !str || ![str isKindOfClass:[NSString class]] ){
        return @"";
    }
    
    NSMutableString *myStr = nil;
    while ( 1 ) {
        myStr = [NSMutableString stringWithString:str];
        NSRange rang;
        rang.location = 0;
        rang.length = [myStr length];
        NSInteger cnt = [myStr replaceOccurrencesOfString:@"\n\n" withString:@"\n" options:NSCaseInsensitiveSearch range:rang];
    
        if( cnt == 0 ){
            break;
        }
        
        str = myStr;
    }
    
    NSRange rang;
    rang.location = 0;
    rang.length = [myStr length] > 2 ? 2 : [myStr length];
    [myStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    
    return myStr;
}


+(NSString*)removeStyleHtml:(NSString*)html{
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<style></style>"]];
    
    
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        
        [componentsToKeep addObject:[components objectAtIndex:i]];
        
    }
    
    
    
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    
    return plainText;
}

+ (NSString *)removeHTML2:(NSString *)html{
    
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        
        [componentsToKeep addObject:[components objectAtIndex:i]];
        
    }
    
    
    
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    
    return plainText; 
    
}

//+(NSString *)encodeToPercentEscapeString: (NSString *) input
//{
//    NSString *outputStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                            (CFStringRef)input,
//                                            NULL,
//                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                            kCFStringEncodingUTF8);
//    //自定义需要编码的特殊字符
//    return outputStr;
//}

+(NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


//判断是否为正确的邮箱格式
+(BOOL)isValidateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

//判断以1开头的十一位字符串
+(BOOL)isMobile:(NSString*)mobileNum
{
    NSString * MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

//判断正确的手机格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
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

//转换html实体
+(NSString *) convertHTML:(NSString *)html
{
    if (!html) {
        return @"";
    }
    NSMutableString *str = [[NSMutableString alloc] initWithString:html];
    
    NSArray *arr = [NSArray arrayWithObjects:@"&lt;",@"&gt;",@"&quot;",@"&amp;", nil];
    NSArray *convertArr = [NSArray arrayWithObjects:@"<",@">",@"\"",@"&", nil];
    
    for ( int i = 0 ; i < [arr count]; ++i ) {
        NSRange rang;
        rang.location = 0;
        rang.length = [str length];
        
        NSString *tmpStr = [arr objectAtIndex:i];
        [str replaceOccurrencesOfString:tmpStr withString:[convertArr objectAtIndex:i] options:NSCaseInsensitiveSearch range:rang];
    }
    
    return str;
}


//处理上传内容中的特殊符号
+(NSString*)convertContent:(NSString *)str
{
    NSMutableString *webStr = [[NSMutableString alloc] init];
    [webStr appendFormat:@"%@",str];
    
    NSRange rang;
    rang.location = 0;
    rang.length = [webStr length];
    [webStr replaceOccurrencesOfString:@"'" withString:@"\\'" options:NSCaseInsensitiveSearch range:rang];
    
    return webStr;
}

+(NSString*)removeWarpLine:(NSString *)str
{
    if( !str || ![str isKindOfClass:[NSString class]] ){
        return @"";
    }
    NSMutableString * myStr = [NSMutableString stringWithString:str];
    NSRange rang;
    rang.location = 0;
    rang.length = [myStr length] ;
    
    [myStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [myStr length] ;
    
    [myStr replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [myStr length] ;
    
    [myStr replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [myStr length] ;
    
    [myStr replaceOccurrencesOfString:@"mdash;" withString:@"--" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [myStr length] ;
    
    [myStr replaceOccurrencesOfString:@"&ldquo;" withString:@"“" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [myStr length] ;
    
    [myStr replaceOccurrencesOfString:@"&rdquo;" withString:@"”" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [myStr length] ;
    
    return myStr;
}


//转换html样式
+(NSMutableString*)convertHtmlStyle:(NSString*)str
{
//    NSMutableString * webStr = [[NSMutableString alloc] initWithString:@"<div style=\"color:#313131;letter-spacing:1.6px;line-height:30px;font-size:16px;text-indent:2em;word-wrap: break-word;word-break: normal;\">"];
    NSMutableString * webStr = [[NSMutableString alloc] initWithString:@"<div>"];
    NSString * endstr = @"</div>";
    
    [webStr appendFormat:@"%@",str];
    
    [webStr appendFormat:@"%@",endstr];
    
    return webStr;
}

//check if have get token str
+(NSString *) getTokenStr
{
    //NSString* docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"TokenStr.plist"];
//     NSString *docPath=[[NSBundle mainBundle]pathForResource:@"TokenStr" ofType:@"plist"];
//    NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:docPath];
//    
//    NSString * str = [dic objectForKey:@"TokenString"];
//    
//    return str;
    
    NSString * str = [CommonConfig getDBValueByKey:Config_Key_DeviceToken];
    return str;
    
}


+(void) haveGetToken:(NSString *)tokenStr
{
   // NSString *path=[[NSBundle mainBundle]pathForResource:@"TokenStr" ofType:@"plist"];
    
//    NSString* docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"TokenStr.plist"];
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:docPath] == NO) {
//        NSError* error = nil;
//        // 移动到Documents沙盒目录下
//        
//        [[NSFileManager defaultManager] moveItemAtPath:path toPath:docPath error:&error];
//        if (error != nil) {
//            NSLog(@"Move File Error : %@", error);
//        }
//    }
//    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:path];
//    
//    [dic setValue:tokenStr forKey:@"TokenString"];
//    [dic writeToFile:path atomically:YES];
    [CommonConfig setDBValueByKey:Config_Key_DeviceToken value:tokenStr];
}

//获取设备唯一标识
+(NSString*)getUUID
{
    NSString *uuid = [MyCommon getKeyUUID];
    if (!uuid || [uuid isEqualToString:@""]) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        NSMutableString * mutableStr = [[NSMutableString alloc] initWithString:result];
        NSRange rang;
        rang.location = 0;
        rang.length = [mutableStr length] ;
        [mutableStr replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:rang];
        uuid = mutableStr;
        [MyCommon saveKeyUUID:uuid];
    }
    return uuid;
}

static NSString *const KEY_ONE = @"uuid.app.allinfo";
static NSString *const KEY_PASSWORD = @"uuid.app.password";

+(void)saveKeyUUID:(NSString *)uuid
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:uuid forKey:KEY_PASSWORD];
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys: (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
                                          KEY_ONE, (__bridge_transfer id)kSecAttrService,
                                          KEY_ONE, (__bridge_transfer id)kSecAttrAccount,
                                          (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
                                          nil];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:dic] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}
+(NSString *)getKeyUUID
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys: (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
                                          KEY_ONE, (__bridge_transfer id)kSecAttrService,
                                          KEY_ONE, (__bridge_transfer id)kSecAttrAccount,
                                          (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
                                          nil];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            
        } @finally {
        }
    }
    NSMutableDictionary *dic = (NSMutableDictionary *)ret;
    return [dic objectForKey:KEY_PASSWORD];
}


+(NSString*)convertImagePath:(NSString*)imgpath
{
    NSInteger index = [MyCommon IndexOfContainingString:@"." FromString:imgpath type:NO];
    NSMutableString * str = [[NSMutableString alloc] initWithString:imgpath];
    [str insertString:@"_200_140" atIndex:index-1];
    
    return str;
}



+(NSString *)getNSString:(NSString *)_string atIndex:(NSInteger)_index  type:(BOOL)type

{
    
    NSString *tempString;
    
    tempString = nil;
    
    if((_string)&&(_index>=0))
    {
        //先计算索引值是否大于字符串的长度，如果大于字符串的长度则索引指向字符串的最后一个位置
        if(_index>=[_string length])
        {
            _index = [_string length];
        }
        
        if(_index==0)
        {
            _index = 1;
            tempString = [_string substringToIndex:_index];
        }
        else
        {
            tempString = [[_string substringToIndex:_index]substringFromIndex:(_index-1)];
        }
    }
    
    return tempString;
}

#pragma mark 从所给的字符串中找出某个字符串的位置

/*
 
 //从所给的字符串中找出某个字符串的位置
 
 findment表示要查找的字符；
 
 scrString表示资源字符串
 
 */

+(NSInteger)IndexOfContainingString:(NSString *)findment FromString:(NSString *)scrString type:(BOOL)type
{
    
    NSInteger index = 0;
    //正序，从字符串第一位开始
    if (type) {
        for(NSInteger i=0;i<=[scrString length];i++)
        {
            NSString *tempString = [MyCommon getNSString:scrString atIndex:i type:type];
            if([tempString isEqualToString:findment])
            {
                index = i;
                break;
            }
        }
    }
    //反序，从字符串最后一位开始
    else{
        for(NSInteger i=[scrString length];i>=0;i--)
        {
            NSString *tempString = [MyCommon getNSString:scrString atIndex:i type:type];
            if([tempString isEqualToString:findment])
            {
                index = i;
                break;
            }
        }
    }
    return index;
}


//获取星期
+(NSString *) getWeekDay:(NSString *)dateStr
{
    if( !dateStr || [dateStr isEqualToString:@""] || [dateStr length] < 10 ){
        return 0;
    }
    NSDate *date = [dateStr dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
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


//获取后台运行的状态
+(NSString*)getEnterBackgroundStatus
{
    NSString * str = [CommonConfig getDBValueByKey:Config_Key_BackgroundStatus];
    return str;
}

//设置后台运行的状态
+(void)setEnterBackgroundStatus:(NSString*)status
{
    [CommonConfig setDBValueByKey:Config_Key_BackgroundStatus value:status];
}

//时间戳转换成时间
+(NSString*)getDateStrFromTimestamp:(NSString*)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

//毫秒级时间戳转换成时间
+(NSString *) getDateWithMsecTime:(NSString *)timeStr
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(小时or天)+前 (比如，3天前、1小时前)
 */
+(NSString *) CompareCurrentTimeByTheEndOfDay:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) < 24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) < 2){
        result = [NSString stringWithFormat:@"昨天"];
    }
    else{
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    return  result;
}

+(NSString *)compareCurrentTimePrestige:(NSDate*)compareDate currentString:(NSString *)prestigeDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) < 24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <= 7){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else{
        NSString *year = [prestigeDate substringWithRange:NSMakeRange(0,4)];
        NSString *month = [prestigeDate substringWithRange:NSMakeRange(5,2)];
        NSString *day = [prestigeDate substringWithRange:NSMakeRange(8,2)];
        if ([month integerValue] < 10) {
            month = [NSString stringWithFormat:@"%ld",(long)[month integerValue]];
        }
        if ([day integerValue] < 10) {
            day = [NSString stringWithFormat:@"%ld",(long)[day integerValue]];
        }
        result = [NSString stringWithFormat:@"%@/%@/%@",year,month,day];
    }
    
    return  result;
}

+(NSString *)getWhoLikeMeListCurrentTime:(NSDate *)date currentTimeString:(NSString *)str
{
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long timeOne = timeInterval;
    long temp = 0;
    
    NSString *year = [str substringWithRange:NSMakeRange(0,4)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *confromTimespStr = [formatter stringFromDate:[NSDate date]];
    NSString *currentYear = [confromTimespStr substringWithRange:NSMakeRange(0,4)];
    
    NSString *currentStr = [NSString stringWithFormat:@"%@ 00:00:00",[confromTimespStr substringWithRange:NSMakeRange(0,10)]];
    long timeTwo = -[[self getDate:currentStr] timeIntervalSinceNow];
    
    NSString *result;
    if (timeInterval < 0) {
        return @"刚刚";
    }
    else if (timeInterval < 60)
    {
        temp = timeInterval;
        result = [NSString stringWithFormat:@"%ld秒前",temp];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if(timeOne <= timeTwo + 60*60*24){
        result = [NSString stringWithFormat:@"昨天"];
    }
    else if ((timeOne <= timeTwo + 60*60*24*2)){
        result = [NSString stringWithFormat:@"前天"];
    }
    else if([year isEqualToString:currentYear])
    {
        result = [str substringWithRange:NSMakeRange(5,5)];
    }
    else
    {
        result = [str substringWithRange:NSMakeRange(2,8)];
    }
    
    return result;
}

//包含特殊字符
+(BOOL)checkSpacialCharacter:(NSString *)str inString:(NSString*)myString
{
    NSRange urgentRange = [myString rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString:str]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

//获取多少天之前的时间字符串
+(NSString*)getdateStrBeforeSomeDay:(int)days
{
    NSTimeInterval  timeInterval = days*24*60*60;
    timeInterval = -timeInterval;
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];

    NSString * str = [MyCommon getDateStr:date format:@"yyyy-MM-dd HH:mm:ss"];
    return str;
    
}


//获取版本是否显示欢迎页
+(NSString *)getVersionShowLogo:(NSString*)aversion
{
    NSString * str = [CommonConfig getDBValueByKey:aversion];
    return str;
}


//设置每个版本的显示欢迎页面
+(void)setVersion:(NSString*)aVersion showLogo:(NSString*)value
{
    [CommonConfig setDBValueByKey:aVersion value:value];
}


//获取某个页面是否显示功能引导
+(NSString*)getShowModalForView:(NSString*)view
{
    NSString * str = [CommonConfig getDBValueByKey:view];
    return str;
}

//设置某个页面是否显示功能引导
+(void)setShowModalForView:(NSString*)view status:(NSString*)status
{
    [CommonConfig setDBValueByKey:view value:status];
}

//去除内容首部的空格
+(NSString*)removeSpaceAtHead:(NSString*)content
{
    int index = 0;
    for (int i = 0; i < [content length]; ++i) {
        NSLog(@"%@",[[content substringFromIndex:i] substringToIndex:i+1]);
        if ([[[content substringFromIndex:i] substringToIndex:i+1] isEqualToString:@" "]) {
            
            index = i;
        }
        else{
            break;
        }
    }

    return [content substringFromIndex:index];
}

//去除内容所有的空格、回车、换行
+(NSString *)removeAllSpace:(NSString *)content
{
    //去掉换行
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    //去掉回车
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //去掉空格
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    return content;
}

//去除两边空格回车
+(NSString *)removeSpaceAtSides:(NSString *)content
{
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return content;
}


+(NSString *) utf8ToUnicode:(NSString *)string
{
    
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
    {
        unichar _char = [string characterAtIndex:i];
        NSString *str = [string substringWithRange:NSMakeRange(i,1)];
        //判断是否为英文和数字
        if (_char <= '9' && _char >='0')
        {
            [s appendFormat:@"%@",str];
        }
        else if(_char >='a' && _char <= 'z')
        {
            [s appendFormat:@"%@",str];
        }
        else if(_char >='A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",str];
        }else if ([str isEqualToString:@"<"] || [str isEqualToString:@">"]){
            [s appendFormat:@"%@",str];
        }
        else
        {
            NSString * str =  [NSString stringWithFormat:@"0000%x",[string characterAtIndex:i]];
            NSRange range;
            range.length = 4;
            range.location = [str length]-4;
            str = [str substringWithRange:range];
            [s appendFormat:@"@@u%@",str];
        }
    }
    
    return s;
}

//判断字符串中是否包含emoji表情
+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}


// 去HTML 标签
+ (NSString *)removeHtmlTags:(NSString *)htmlString
{
    {
        NSScanner * scanner = [NSScanner scannerWithString:htmlString];
        NSString * text = nil;
        while([scanner isAtEnd]==NO)
        {
            //找到标签的起始位置
            [scanner scanUpToString:@"<" intoString:nil];
            //找到标签的结束位置
            [scanner scanUpToString:@">" intoString:&text];
            //替换字符
            htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        }
        //    NSString * regEx = @"<([^>]*)>";
        //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
        return htmlString;
    }
}


//查看数据库中是否存在此条职位
+(BOOL) checkMessageIsExistInDB:(NSString *)messageId  userId:(NSString*)userId
{
    NSString *personId = userId;
    if( !personId ){
        return NO;
    }
    NSString *whereStr = [[NSString alloc] initWithFormat:@"messageId=%@ and user_id=%@",messageId,personId];
    sqlite3_stmt *result = [[MyDataBase defaultDB] selectSQL:@"create_data desc" fileds:@"_id" whereStr:whereStr limit:1 tableName:@"message_MarkRead"];
    BOOL bFind = NO;
    while ( sqlite3_step(result) == SQLITE_ROW )
    {
        bFind = YES;
        break;
    }
    sqlite3_finalize(result);
    
    return bFind;
}

+ (NSString *)substringExceptLastEmoji:(NSString *)emojiStr
{
    if (!emojiStr || [emojiStr isEqualToString:@""]) {
        return @"";
    }
    if ([emojiStr hasSuffix:@"]"]) {
        NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:Custom_Emoji_Regex options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray * emojis = [expression matchesInString:emojiStr options:NSMatchingWithTransparentBounds range:NSMakeRange(0, emojiStr.length)];
        NSInteger count = emojis.count;
        if (count > 0) {
            NSTextCheckingResult *result = emojis[count -1 ];
            NSRange range = result.range;
            NSString *resultStr = [emojiStr substringWithRange:range];
            NSString *path = [[NSBundle mainBundle]pathForResource:@"emoticons.plist" ofType:nil];
            NSArray *emojiArr = [NSArray arrayWithContentsOfFile:path];
            NSString *results;
            for (NSDictionary *dic in emojiArr) {
                NSString *name = dic[@"chs"];
                if ([name isEqualToString:resultStr]) {
                    results = [emojiStr substringToIndex:range.location];
                    break;
                }
            }
            if (results) {
                return results;
            }
        }
    }
    return emojiStr;
}

//快速排序
+(NSMutableArray*)quickSort:(NSMutableArray *)arr left:(int)left right:(int)right
{
    if (left < right) {
        id key = arr[left];
        int low = left;
        int high = right;
        while (low < high) {
            while (low < high && [arr[high] integerValue] > [key integerValue]) {
                high --;
            }
            [arr replaceObjectAtIndex:low withObject:arr[high]];
            while (low < high && [arr[low] integerValue] < [key integerValue]) {
                low ++ ;
            }
            [arr replaceObjectAtIndex:high withObject:arr[low]];
        }
        [arr replaceObjectAtIndex:low withObject:key];
        
        [MyCommon quickSort:arr left:left right:low-1];
        [MyCommon quickSort:arr left:low+1 right:right];
    }
    return  arr;
}


//为nil时设置成空字符串
+(NSString*)getEmtyStrFromNil:(NSString*)str
{
    if (!str) {
        str = @"";
    }else{
        if ([str isKindOfClass:[NSString class]]) {
            if ([str isEqual:[NSNull null]] || [str isEqualToString:@"null"]) {
                str = @"";
            }
        }
    }
    return str;
}

// 是否wifi
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


#pragma mark-读取数据库里的头像
-(NSString*)getLianMengImage:(NSString*)str
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [Common getSandBoxPath:@"lianmeng_image.sqlite"];
    if( ![fileManager fileExistsAtPath:filePath] ){
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],@"lianmeng_image.sqlite"]];
        [data writeToFile:[Common getSandBoxPath:@"lianmeng_image.sqlite"] atomically:YES];
    }
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    if ([database open])
    {
        FMResultSet *set = [database executeQuery:str];
        while ([set next]) {
            
        NSString * imageName = [set stringForColumn:@"value"];
        return imageName;
        }
        
    }
    
    return @"Gender100-nan.png";
}

#pragma mark - 根据年龄和性别获取查询的key
-(NSString*)setKey:(NSString*)sex age:(NSString*)age
{
    NSString * sexStr = @"";
    NSString * ageStr = @"";
    int randomIndex = 1 + arc4random() % 3;
    if ([sex isEqualToString:@"2"]) {
        sexStr = @"girl";
    }
    else
        sexStr = @"boy";
    
    if ([age integerValue] < 30) {
        ageStr = @"30";
    }
    else if ([age integerValue] >= 30 && [age integerValue] < 40){
        ageStr = @"40";
    }
    else if ([age integerValue] >= 40 && [age integerValue] < 50){
        ageStr = @"50";
    }
    else if ([age integerValue] >= 50 ){
        ageStr = @"60";
    }
    
    return [NSString stringWithFormat:@"%@_%@%d",sexStr,ageStr,randomIndex];
}

#pragma mark - 获取查询语句
-(NSString*)sqlStr:(NSString*)key
{
    return  [NSString stringWithFormat:@"select * from user_image where key='%@'",key];
}


//随机生成两个数之间的随机数
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
    
}

//swf格式链接转换
+(NSString *)getWithFileSwf:(NSString *)fileswf
{
    NSInteger k = 0;
    for (NSInteger i = fileswf.length-1;i>=0;i--) {
        NSString *str= [fileswf substringWithRange:NSMakeRange(i,1)];
        if([str isEqualToString:@"."])
        {
            k = fileswf.length - i;
            break;
        }
    }
    NSMutableString *str1 = [[NSMutableString alloc] initWithFormat:@"%@",fileswf];
    [str1 deleteCharactersInRange:NSMakeRange(str1.length - k,k)];
        
    [str1 replaceCharactersInRange:[str1 rangeOfString:@"/swf/"] withString:@"/img/"];
        
    NSString *str2 = @"";
    for (NSInteger s = str1.length-1;s>=0;s--) {
        NSString *str= [str1 substringWithRange:NSMakeRange(s,1)];
        if([str isEqualToString:@"/"])
        {
            str2 =[str1 substringFromIndex:s];
            break;
        }
    }
    return [NSString stringWithFormat:@"%@%@_1.jpg",str1,str2];
}

+(NSString *)removePhoneNumberSpaceString:(NSString *)str
{
    if( !str || ![str isKindOfClass:[NSString class]] ){
        return @"";
    }
    NSMutableString * myStr = [NSMutableString stringWithString:str];
    for (NSInteger i=0 ; i< myStr.length; i++)
    {
        NSString *strOne = [myStr substringWithRange:NSMakeRange(i,1)];
        NSString *strTwo = [strOne stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        if (strTwo.length > 0) {
            [myStr deleteCharactersInRange:NSMakeRange(i,1)];
        }
    }
    return myStr;
}

+(NSString *)removeEmojiString:(NSString *)str
{
    if( !str || ![str isKindOfClass:[NSString class]] ){
        return @"";
    }
    NSMutableString * myStr = [NSMutableString stringWithString:str];
    for (NSInteger i=0 ; i< myStr.length; i++) {
        NSString *strOne = [myStr substringWithRange:NSMakeRange(i,1)];
        if ([MyCommon isContactEmojiString:strOne])
        {
            [myStr deleteCharactersInRange:NSMakeRange(i,1)];
        }
    }
    return myStr;
}

+(BOOL)isContactEmojiString:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;

}

+(NSString *)getAddressBookUUID
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"AddressBookUUID"];
    if (!uuid) {
        uuid = [MyCommon getUUID];
        [user setObject:uuid forKey:@"AddressBookUUID"];
        [user synchronize];
    }
    return uuid;
}

+(NSString *)getRandString:(NSString *)personId
{
    NSInteger index1 = arc4random() % 10;
    NSInteger index2 = arc4random() % 10;
    NSInteger index3 = arc4random() % 10;
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:personId];
    [str insertString:[NSString stringWithFormat:@"%ld",(long)index1] atIndex:str.length];
    [str insertString:[NSString stringWithFormat:@"%ld",(long)index2] atIndex:3];
    [str insertString:[NSString stringWithFormat:@"%ld",(long)index3] atIndex:0];
    
    NSString *subStr = @"background";
    NSString *strTwo = @"";
    
    for (NSInteger i = 0;i <str.length; i++)
    {
        NSString *strOne = [subStr substringWithRange:NSMakeRange([[str substringWithRange:NSMakeRange(i,1)] integerValue],1)];
        strTwo = [NSString stringWithFormat:@"%@%@",strTwo,strOne];
    }
    return strTwo;
}

+(CGSize)creatHeightWidthSize:(CGSize)size andSize:(CGSize)sizeOne
{
    CGFloat frameW = size.width;
    CGFloat frameH = size.height;
    CGFloat height = 0;
    CGFloat width = 0;
    if (frameW/(frameH*1.0) >= sizeOne.width/(sizeOne.height*1.0)) {
        if (frameW <= sizeOne.width) {
            height = frameH;
            width = frameW;
        }
        else
        {
            height = (sizeOne.width * frameH)/(frameW * 1.0);
            width = sizeOne.width;
        }
    }
    else
    {
        if (frameH <= sizeOne.height) {
            width = frameW;
            height = frameH;
        }
        else
        {
            width = (sizeOne.height *frameW)/(frameH *1.0);
            height = sizeOne.height;
        }
    }
    return CGSizeMake(width,height);
}

+(NSMutableAttributedString *)changeColorString:(NSString *)string changeString:(NSString *)changeString
{
    NSMutableAttributedString *attString;
    
    if ([string containsString:@"<font color=red>"])
    {
        attString = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    }
    else
    {
        NSString *stringThree = string;
        if ([stringThree rangeOfString:changeString options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            NSString *str = [string substringWithRange:[stringThree rangeOfString:changeString options:NSCaseInsensitiveSearch]];
            stringThree = [stringThree stringByReplacingOccurrencesOfString:str withString:[NSString stringWithFormat:@"<font color=red>%@</font>",str]];
            attString = [[NSMutableAttributedString alloc] initWithData:[stringThree dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        }
        else
        {
            attString = [[NSMutableAttributedString alloc] initWithString:stringThree];
        }
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
               [dic setObject:FOURTEENFONT_CONTENT forKey:NSFontAttributeName];
               [attString addAttributes:dic range:NSMakeRange(0,attString.length)];
    
    return attString;
}

//浮点数判断
+(BOOL)isPureFloat:(NSString*)string
{
    NSString *string1 = string;
    NSScanner* scan = [NSScanner scannerWithString:string1];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//纯数字判断
+(BOOL)isPureNumber:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    BOOL isOfferId = [scan scanInt:&val] && [scan isAtEnd];
    return isOfferId;
}

/**
 UITextView字数限制处理
 * TipLb      自定义的提示Label
 * numLb      可输入字数Label
 * textView
 * wordsNum   可输入最大字数
 */
+(void)dealLabNumWithTipLb:(UILabel *)TipLb numLb:(UILabel *)numLb textView:(UITextView *)textView wordsNum:(NSInteger)wordsNum
{
    if (TipLb) {
        if (textView.text.length > 0)
        {
            TipLb.hidden = YES;
        }
        else
        {
            TipLb.hidden = NO;
        }
    }
    
    NSInteger length = textView.text.length;
    length = wordsNum - length;
    if (numLb) {
        numLb.text = [NSString stringWithFormat:@"%ld",(long)length];
        if (length <= 0) {
            numLb.text = @"0";
        }
    }
    
    NSString *lang = [textView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) { // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (textView.text.length > wordsNum) {
                textView.text = [textView.text substringToIndex:wordsNum];
            }
        }
    }else{
        if (textView.text.length > wordsNum) {
            textView.text = [textView.text substringToIndex:wordsNum];
        }
    }
}

/**
 UITextField字数限制处理
 * numLb      可输入字数Label
 * textField
 * wordsNum   可输入最大字数
 */
+(void)limitTextFieldTextNumberWithTextField:(UITextField *)textField wordsNum:(NSInteger)wordsNum numLb:(UILabel *)numLb
{
    NSInteger length = textField.text.length;
    length = wordsNum - length;
    if (numLb) {
        numLb.text = [NSString stringWithFormat:@"%ld",(long)length];
        if (length <= 0) {
            numLb.text = @"0";
        }
    }
    
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {//如果输入的时中文
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (textField.text.length > wordsNum) {
                textField.text = [textField.text substringToIndex:wordsNum];
            }
        }
    }else{
        if (textField.text.length > wordsNum) {
            textField.text = [textField.text substringToIndex:wordsNum];
        }
    }
}
/**
 *  处理txt
 *  @param textField textField description
 *  @param maxNum    maxNum description
 */
+(void)dealTxtFiled:(UITextField *)textField maxLength:(NSInteger)maxNum{
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxNum) {
                textField.text = [toBeString substringToIndex:maxNum];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxNum) {
            textField.text = [toBeString substringToIndex:maxNum];
        }
    }
}

+ (UIViewController *)viewController:(id)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
