//
//  MyDes.m
//  Template
//
//  Created by YL1001 on 14/12/9.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "MyDes.h"
#import <CommonCrypto/CommonCryptor.h>

static NSString* DES_KEYS_VALUE=@"M*JOB@10";

static NSString* DES_ENCODE_VALUE = @"F036E6429EEF3332";

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation MyDes

/************************************************************
 函数名称 : - (NSMutableDictionary*)filterPost:(NSMutableDictionary*)postParams httpPath:(NSString*)path
 函数描述 : 根据传入的postParams请求参数,path请求路径
 输出参数 : N/A
 返回参数 : (NSMutableDictionary *)最终加密好的URL和参数
 **********************************************************/
+ (NSMutableDictionary*)filterPost:(NSString*)postParams httpPath:(NSString*)path{
    
    //最终返回的字典
    NSMutableDictionary* dictFilter=[[NSMutableDictionary alloc]init];
    
    //将链接拆分
    NSMutableDictionary* urlDict=[MyDes convertPath:path];
    
    //将参数拼接成字符串
    //NSString* poststr=[MyDes dealpost:postParams];
    
    //加密url
    //NSString* get=[desuntil encryptStr:urlDict[@"func"] keys:DES_KEYS_VALUE];
    NSData * get = [MyDes encryptByte:urlDict[@"func"]];
    //加密参数
    //NSString* post=[desuntil encryptStr:postParams keys:DES_KEYS_VALUE];
    NSData * post = [MyDes encryptByte:postParams];
//    //base64编码后获取到get
    NSString* getStr=[MyDes base64EncodedStringFrom:get];
//    
//    //base64编码后获取到post
    NSString* postStr=[MyDes base64EncodedStringFrom:post];
    
    //对get和post进行URL编码
    NSString* getUrl=[MyDes encodeToPercentEscapeString:getStr];
//    
    NSString* postUrl=[MyDes encodeToPercentEscapeString:postStr];
    
    NSMutableDictionary* dict=[MyDes getOverPost:getUrl post:postUrl];
    
    NSString* stringPath=[NSString stringWithFormat:@"%@/index_des.php",urlDict[@"url"]];
    
    [dictFilter setObject:stringPath forKey:@"path"];
    
    [dictFilter setObject:dict forKey:@"param"];
    
    return dictFilter;
}

/************************************************************
 函数名称 : - (NSString *)encodeToPercentEscapeString: (NSString *) input
 函数描述 : URL编码
 输出参数 : N/A
 返回参数 : (NSString *)
 **********************************************************/
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

/************************************************************
 函数名称 : - (NSString *)decodeFromPercentEscapeString: (NSString *) input
 函数描述 : URL解码
 输出参数 : N/A
 返回参数 : (NSString *)
 **********************************************************/
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/************************************************************
 函数名称 : - (NSMutableDictionary*)getOverPost:(NSString*)get post:(NSString*)p encode:(NSString*)encodeStr
 函数描述 : 将加密后的URL和post封装到NSMutableDictionary
 输出参数 : N/A
 返回参数 : (NSMutableDictionary *)
 **********************************************************/
+ (NSMutableDictionary*)getOverPost:(NSString*)get post:(NSString*)p{
    
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    
    [dict setObject:get forKey:@"g"];
    
    [dict setObject:p forKey:@"p"];
    
    [dict setObject:@"base64" forKey:@"encode"];
    
    return dict;
}

/************************************************************
 函数名称 : - (NSData*) encryptByte:(NSString*)data
 函数描述 : 将指定的数据进行DES加密
 输出参数 : N/A
 返回参数 : 加密后的数据
 **********************************************************/
+ (NSData*) encryptByte:(NSString*)data{
    //使用密钥key转变为NSData*
    NSData* desEncode=[MyDes DESEncrypt:[data dataUsingEncoding:NSUTF8StringEncoding] WithKey:DES_KEYS_VALUE];
    return desEncode;
}

/************************************************************
 函数名称 : - (NSData*)decrypt:(NSString*)data
 函数描述 : 对指定的数据进行DES解密
 输出参数 : N/A
 返回参数 : 解密后的数据
 **********************************************************/
+ (NSData*)decrypt:(NSData*)data{
    NSData* desDecode=[MyDes DESDecrypt:data  WithKey:DES_KEYS_VALUE];
    return desDecode;
}

/************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 **********************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 **********************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 **********************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil){
        return [NSData data];
//        [NSException raise:NSInvalidArgumentException format:nil];
    }
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSUTF8StringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 **********************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

/************************************************************
 函数名称 : - (NSString*)dealpost:(NSMutableDictionary*)postParams
 函数描述 : 将指定的参数转变为NSString对象
 输出参数 : N/A
 返回参数 : 转换后的NSString
 **********************************************************/
+ (NSString*)dealpost:(NSMutableDictionary*)postParams{
    
    //创建可变字符串
    NSMutableString* mutableString=[[NSMutableString alloc]init];
    
    //先得到里面所有的键值   objectEnumerator得到里面的对象  keyEnumerator得到里面的键值
    NSEnumerator * enumerator = [postParams keyEnumerator];
    
    //定义一个不确定类型的对象
    id object;
    while(object = [enumerator nextObject])
    {
        id objectValue = [postParams objectForKey:object];
        if(objectValue != nil)
        {
            [mutableString appendFormat:@"&%@=%@",object,objectValue];
        }
    }
    
    return mutableString;
}


/************************************************************
 函数名称 : - (NSMutableDictionary*)convertPath:(NSString*)path
 函数描述 : 将传入的URL链接进行分割
 输出参数 : N/A
 返回参数 : 返回字典,其中key=url时,返回?前的数据,key=func时返回？后的数据,包括webservice的函数名和类名
 **********************************************************/
+ (NSMutableDictionary*)convertPath:(NSString*)path{
    //非空判断
    if(path==nil||[path isEqualToString:@""]){
        return nil;
    }
    
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    
    NSRange funcRange=[path rangeOfString:@"?"];
    
    
    NSRange urlRange=[path rangeOfString:@"index.php"];
    if ([path containsString:@"indexp.php"]) {
        urlRange=[path rangeOfString:@"indexp.php"];
    }
    if (funcRange.location!=NSNotFound) {
        NSString* func=[path substringFromIndex:funcRange.location];
        [dict setObject:func forKey:@"func"];
    }
    
    if (urlRange.location!=NSNotFound) {
        NSString* url=[path substringToIndex:urlRange.location-1];
        [dict setObject:url forKey:@"url"];
    }
    
    return dict;
}

@end
