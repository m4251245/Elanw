//
//  WXPayClient.m
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "WXPayClient.h"
#import "ASIHTTPRequest.h"
#import "CommonUtil.h"
#import "Constant.h"
#import "Order.h"
#import "GDataXMLNode.h"
#import "NSString+URLEncoding.h"

NSString *AccessTokenKey = @"access_token";
NSString *PrePayIdKey = @"prepayid";
NSString *errcodeKey = @"errcode";
NSString *errmsgKey = @"errmsg";
NSString *expiresInKey = @"expires_in";



/**
 *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
 */
NSString * const WXAppId = @"wx0c293be2aa3f0e7e";


/**
 *  微信公众平台商户模块生成的ID（商户号）
 */
NSString * const WXPartnerId = @"1232505002";

/**
 * 微信开放平台和商户约定的密钥
 * 正式时的值为f79eeb79ac945d39de4f04d89b32f511
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXAppSecret = @"19a6744cf912084943df30c475164bdc";

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXAppKey = @"L8LrMqqeGRxST5reouB0K66CaYAWpqhAVsq7ggKkxHCOastWksvuX1uvmvQclxaHoYd3ElNBrNO2DHnnzgfVG9Qs473M3DTOZug5er46FhuGofumV8H2FVR9qkjSlC5K";

/**
 * 微信开放平台和商户约定的财付通支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXPartnerKey = @"8934e7d15453e97507ef794cf7b0519d";






@interface WXPayClient ()

@property (nonatomic, strong) ASIHTTPRequest *request;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, copy) NSString *traceId;

@end

@implementation WXPayClient

#pragma mark - Public

+ (instancetype)shareInstance 
{
    static WXPayClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[WXPayClient alloc] init];
    });
    return sharedClient;
}

- (void)payProduct
{
    [self getPrepayId];
}

#pragma mark - 主体流程
- (NSMutableData *)getProductArgs
{
    self.timeStamp = [self genTimeStamp];
    self.nonceStr = [self genNonceStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:WXAppId forKey:@"appid"];
    [params setObject:_order.productName forKey:@"body"];
    [params setObject:WXPartnerId forKey:@"mch_id"];
    [params setObject:self.timeStamp forKey:@"nonce_str"];
    [params setObject:@"http://www.job1001.com/inc/pay/weixin/notify_url.php" forKey:@"notify_url"];
    [params setObject:_order.tradeNO forKey:@"out_trade_no"];
    NSString *ip = [CommonUtil getIPAddress:YES];
    [params setObject:ip forKey:@"spbill_create_ip"];
    NSString *totalFee = [NSString stringWithFormat:@"%.lf", [_order.amount doubleValue]*100];
    [params setObject:totalFee forKey:@"total_fee"];
    [params setObject:@"APP" forKey:@"trade_type"];
    [params setObject:[self genSign:params] forKey:@"sign"];

    NSString *postStr = [self dictionaryToXml:params];
    return (NSMutableData *)[postStr dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)dictionaryToXml:(NSDictionary *)dict
{
    NSMutableString *xmlStr = [[NSMutableString alloc]initWithString:@"<xml>"];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [xmlStr appendFormat:@"<%@>%@</%@>", key, obj, key];
    }];
    [xmlStr appendString:@"</xml>"];
    NSLog(@"%@", xmlStr);
    return [NSString stringWithFormat:@"%@", xmlStr];
}

- (void)getPrepayId
{
    NSString *getPrepayIdUrl = [NSString stringWithFormat:@"https://api.mch.weixin.qq.com/pay/unifiedorder"];
    //订单数据
    NSMutableData *postData = [self getProductArgs];
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getPrepayIdUrl]];
    [self.request addRequestHeader:@"Content-Type" value:@"application/xml"];
    [self.request addRequestHeader:@"Accept" value:@"application/xml"];
    [self.request setRequestMethod:@"POST"];
    [self.request setPostBody:postData];
    
    __weak WXPayClient *weakSelf = self;
    __weak ASIHTTPRequest *weakRequest = self.request;
    
    [self.request setCompletionBlock:^{
        NSString *result = [[NSString alloc]initWithData:[weakRequest responseData] encoding:NSUTF8StringEncoding];
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:result options:0 error:nil];
        GDataXMLElement *rootEle = [document rootElement];
        NSArray *array = [rootEle children];
        NSString *prePayId = nil;
        NSString *errMsg;
        for (int i = 0; i < [array count]; i++) {
            GDataXMLElement *ele = [array objectAtIndex:i];
            
            // 根据标签名判断
            if ([[ele name] isEqualToString:@"prepay_id"]) {
                prePayId = [ele stringValue];
            }
            if ([[ele name] isEqualToString:@"err_code_des"]) {
                errMsg = [ele stringValue];
            }
        }
        
        
        if (prePayId) {
            NSLog(@"--- PrePayId: %@", prePayId);
            
            // 调起微信支付
            PayReq *request   = [[PayReq alloc] init];
            
            request.partnerId = WXPartnerId;
            request.prepayId  = prePayId;
            request.package   = @"Sign=WXPay";
            request.nonceStr  = weakSelf.nonceStr;
            request.timeStamp = (UInt32)[weakSelf.timeStamp longLongValue];
            
            // 构造参数列表
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:WXAppId forKey:@"appid"];
            [params setObject:request.partnerId forKey:@"partnerid"];
            [params setObject:request.prepayId forKey:@"prepayid"];
            [params setObject:request.package forKey:@"package"];
            [params setObject:request.nonceStr forKey:@"noncestr"];
            [params setObject:weakSelf.timeStamp forKey:@"timestamp"];
            
            request.sign = [weakSelf genSign:params];
            
            // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
            [WXApi sendReq:request];
        } else {
            [weakSelf showAlertWithTitle:@"错误" msg:errMsg];
        }
    }];
    [self.request setFailedBlock:^{
        [weakSelf showAlertWithTitle:@"错误" msg:@"获取 PrePayId 失败"];
    }];
    [self.request startAsynchronous];
}


#pragma mark - 生成各种参数

- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

/**
 * 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪
 */
- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"crestxu_%@", [self genTimeStamp]];
}

- (NSString *)genOutTradNo
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)genPackage
{
    // 构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary]; 
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:@"千足金箍棒" forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    [params setObject:@"http://weixin.qq.com" forKey:@"notify_url"];
    [params setObject:[self genOutTradNo] forKey:@"out_trade_no"]; 
    [params setObject:WXPartnerId forKey:@"partner"];
    [params setObject:[CommonUtil getIPAddress:YES] forKey:@"spbill_create_ip"]; 
    [params setObject:@"1" forKey:@"total_fee"];    // 1 =＝ ¥0.01
    
    NSArray *keys = [params allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) { 
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    
    [package appendString:@"key="];
    [package appendString:WXPartnerKey]; // 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[CommonUtil md5:[package copy]] uppercaseString]; 
    package = nil;
    
    // 生成 packageParamsString
    NSString *value = nil;  
    package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];

    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    
    NSLog(@"--- Package: %@", result);
    
    return result;
}

- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) { 
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    [sign appendString:@"key=19a6744cf912084943df30c475164bdc"];
//    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    NSString *signString = [sign copy];
    
//    NSString *result = [CommonUtil sha1:signString];
    NSString *result = [[CommonUtil md5:signString] uppercaseString];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}




#pragma mark - Alert
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg
{    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                    message:msg 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] postNotificationName:HUDDismissNotification object:nil userInfo:nil];
}

@end
