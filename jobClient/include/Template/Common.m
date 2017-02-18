//
//  Common.m
//  SmartMarketClient
//
//  Created by sysweal on 13-3-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "Common.h"
#import "NSString+Size.h"

@implementation Common

//获取硬件id
+(NSString *) getDeviceID
{
    //获取设备id号
    //UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *deviceUID = @"";//[NSString stringWithString:[device uniqueIdentifier]];
    
    return deviceUID;
}

//获取本地文件存储目录
+(NSString *) getLocalStoreDir
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    return docPath;
}

//获取当前时间
+(NSString *) getCurrentDateTime
{
    return [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

//由NSDate获取日期
+(NSString *) getDateStr:(NSDate *)date
{
    if( !date ){
        return nil;
    }
    return [date stringWithFormat:@"yyyy-MM-dd"];
}

//格式化数字(主要用于计算器)
+(NSString *) formatNumber:(float)num precision:(int)precision
{
    NSString *str = nil;
    
    switch ( precision ) {
        case 0:
            str = [NSString stringWithFormat:@"%.0f",num];
            break;
        case 1:
            str = [NSString stringWithFormat:@"%.1f",num];
            break;
        case 2:
            str = [NSString stringWithFormat:@"%.2f",num];
            break;
        case 3:
            str = [NSString stringWithFormat:@"%.3f",num];
            break;
        case 4:
            str = [NSString stringWithFormat:@"%.4f",num];
            break;
        case 5:
            str = [NSString stringWithFormat:@"%.5f",num];
            break;
        case 6:
            str = [NSString stringWithFormat:@"%.6f",num];
            break;
        case 7:
            str = [NSString stringWithFormat:@"%.7f",num];
            break;
        default:
            str = [NSString stringWithFormat:@"%.8f",num];
            break;
    }
    
    return str;
}

//根据名称获取其中沙盒中的目录
+(NSString *) getSandBoxPath:(NSString *)name
{
    NSString *documentsDirectory = [Common getLocalStoreDir];
    return [documentsDirectory stringByAppendingPathComponent:name];
}

//根据名称获取其中App中的目录
+(NSString *) getResourcePath:(NSString *)name
{
    NSString *resourceDirectory = [[NSBundle mainBundle] resourcePath];
    return [resourceDirectory stringByAppendingPathComponent:name];
}

//检测文件是否存在
+(BOOL) checkFileExist:(NSString *)path
{
    if( !path || path == nil )
    {
        return NO;
    }
    
    BOOL bExist = YES;
        
    FILE *pFile;
    pFile = fopen([path UTF8String], "r");
    
    if( pFile )
    {
        bExist = YES;
        fclose(pFile);
    }else
        bExist = NO;
 
    return bExist;
    
}

//复制文件
+(BOOL) copyFile:(NSString *)srcPath desPath:(NSString *)desPath
{
    NSData *data = [NSData dataWithContentsOfFile:srcPath];
    return [data writeToFile:desPath atomically:YES];
}

//复制App中的文件到指定目录
+(BOOL) copyAppFile:(NSString *)name desPath:(NSString *)desPath
{
    NSString *path = [Common getResourcePath:name];
    return [Common copyFile:path desPath:desPath];
}

////是否wifi
//+(BOOL) isEnableWIFI
//{
//    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
//}
//
////是否3G
//+(BOOL) isEnable3G
//{
//    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
//}

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
    CGSize titleBrandSizeForLines = [text sizeNewWithFont:font constrainedToSize:CGSizeMake(lb.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
    int lines = ceil(titleBrandSizeForLines.height/titleBrandSizeForHeight.height);
    if (lines <= 1) {
        height = titleBrandSizeForHeight.height;
    }else {
        height = lines*titleBrandSizeForHeight.height;
    }
    
    height = height > 21 ? height : 21;
    
    lb.numberOfLines = lines;
    [lb setFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y, lb.frame.size.width, height)];
    
    return height;
}

//根据text动态的设置lb(有最大行数的限制)
+(float) setLbByText:(UILabel *)lb text:(NSString *)text font:(UIFont *)font maxLine:(int)maxLine
{
    if( !font ){
        font = lb.font;
    }
    
    float height = 0.0;
    lb.text = text;
    lb.font = font;
    CGSize titleBrandSizeForHeight = [text sizeNewWithFont:font];
    CGSize titleBrandSizeForLines = [text sizeNewWithFont:font constrainedToSize:CGSizeMake(lb.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
    int lines = ceil(titleBrandSizeForLines.height/titleBrandSizeForHeight.height);
    
    lines = lines > maxLine ? maxLine : lines;
    
    if (lines <= 1) {
        height = titleBrandSizeForHeight.height;
    }else {
        height = lines*titleBrandSizeForHeight.height;
    }
    
    //height = height > 21 ? height : 21;
    
    lb.numberOfLines = lines;
    [lb setFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y, lb.frame.size.width, height)];
    
    return height;
}

+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

//打电话
+(BOOL) giveCall:(NSString *)number
{
    BOOL flag = TRUE;
    if( !number || [number isEqualToString:@""] )
    {
        flag = FALSE;
        return flag;
    }
    
    //去除电话中的 "(" 与 ")" 与 "-" 等符号
    NSMutableString *phoneNum = [[NSMutableString alloc] initWithString:[[number componentsSeparatedByString:@","] objectAtIndex:0]];
    
    NSRange rang;
    rang.length = [phoneNum length];
    rang.location = 0;
    [phoneNum replaceOccurrencesOfString:@"(" withString:@"" options:NSUTF8StringEncoding range:rang];
    
    rang.length = [phoneNum length];
    rang.location = 0;
    [phoneNum replaceOccurrencesOfString:@")" withString:@"" options:NSUTF8StringEncoding range:rang];
    
    rang.length = [phoneNum length];
    rang.location = 0;
    [phoneNum replaceOccurrencesOfString:@"-" withString:@"" options:NSUTF8StringEncoding range:rang];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    
    return flag;
}


#pragma mark macAddress
+(NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    [MyLog Log:outstring obj:nil];
    
    return outstring;
}

//获取设备唯一标识
+(NSString*)getUUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    //NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    //NSLog(@"%@",result);
    return @"0032389472389472389472389";
}



+(NSString *) utf8ToUnicode:(NSString *)string
{
    
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
        
    {
        
        unichar _char = [string characterAtIndex:i];
        
        //判断是否为英文和数字
        
        if (_char <= '9' && _char >='0')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
            
        }
        
        else if(_char >='a' && _char <= 'z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
            
            
            
        }
        
        else if(_char >='A' && _char <= 'Z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
            
            
            
        }
        
        else if (_char == '_')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        
        else
            
        {
            NSString * str =  [NSString stringWithFormat:@"0000%x",[string characterAtIndex:i]];
            NSRange range;
            range.length = 4;
            range.location = [str length]-4;
            str = [str substringWithRange:range];
            [s appendFormat:@"u%@",str];
            
        }
        
    }
    return s;
}

+(NSString *)idfvString
{
//    return @"C6481EEB-7818-4CFD-99B6-E8516D4E6494";
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    else
        return @"AAA";
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] < 6.0) {
//        return @"AAA";
//    }
//    else
//        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (void)creatFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:path contents:[NSData data] attributes:nil];
}
@end
