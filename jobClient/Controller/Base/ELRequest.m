//
//  ELRequest.m
//  jobClient
//
//  Created by 一览ios on 15/8/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELRequest.h"
#import "AFSecurityPolicy.h"
#import "Manager.h"

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL YES
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
//#define certificate @"www.job1001.com"

@implementation ELRequest
{
    AFHTTPSessionManager *manager;
}


static ELRequest *instance = nil;
static dispatch_once_t onceToken;

+(ELRequest*) sharedELRequest {
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    if (!mgr.isReachable  && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusUnknown) {
        [BaseUIViewController showAlertViewContent:@"当前网络可能没有连接" toView:nil second:1.0 animated:YES];
    }
    dispatch_once(&onceToken, ^{
        if(instance == nil) {
            instance = [[super allocWithZone:NULL]init];
        }
    });
    return instance;
}

#pragma mark - 默认请求
//不带进度显示信息
+(void)postbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag  success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess
        failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure {
    ELRequest* request = [self sharedELRequest];
    AccessToken_DataModal *accessTokenModal = [Manager shareMgr].accessTokenModal;
    return [request postbodyMsg:bodyMsg op:opName func:funcName requestVersion:versionFlag?Request_Version:nil progressFlag:NO progressMsg:nil seviceUrl:SeviceURL sercet:accessTokenModal.sercet_
                    accessToken:accessTokenModal.accessToken_ success:requestSuccess failure:requestFailure];
}

//带进度显示信息
+(void)postbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag   progressFlag:(BOOL)progressFlag progressMsg:(NSString *)progressMsg success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure
{
    if (progressFlag) {
        [BaseUIViewController showLoadView:YES content:progressMsg view:nil];
    }
    ELRequest* request = [self sharedELRequest];
    AccessToken_DataModal *accessTokenModal = [Manager shareMgr].accessTokenModal;
    [request postbodyMsg:bodyMsg op:opName func:funcName requestVersion:versionFlag?Request_Version:nil progressFlag:progressFlag progressMsg:progressMsg seviceUrl:SeviceURL
                  sercet:accessTokenModal.sercet_
             accessToken:accessTokenModal.accessToken_ success:requestSuccess failure:requestFailure];
}

#pragma mark - 2016.11.21日新加的另一种类型的请求
//不带进度显示信息
+(void)newBodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag  success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess
           failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure {
    ELRequest* request = [self sharedELRequest];
    AccessToken_DataModal *accessTokenModal = [Manager shareMgr].accessTokenNewModal;
    if (!accessTokenModal) {
        [[Manager shareMgr] configToken:AccessTokenTypeTwo userName:@"jjr" pwd:@"jjr889900" modelType:[Manager shareMgr].accessTokenNewModal baseUrl:NewSeviceURL];
    }
    [request postbodyMsg:bodyMsg op:opName func:funcName requestVersion:versionFlag?New_Request_Version:nil progressFlag:NO progressMsg:nil seviceUrl:NewSeviceURL sercet:accessTokenModal.sercet_
                    accessToken:accessTokenModal.accessToken_ success:requestSuccess failure:requestFailure];
}

//带进度显示信息
+(void)newPostbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag   progressFlag:(BOOL)progressFlag progressMsg:(NSString *)progressMsg success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure
{
    if (progressFlag) {
        [BaseUIViewController showLoadView:YES content:progressMsg view:nil];
    }
    ELRequest* request = [self sharedELRequest];
    AccessToken_DataModal *accessTokenModal = [Manager shareMgr].accessTokenNewModal;
    if (!accessTokenModal) {
        [[Manager shareMgr] configToken:AccessTokenTypeTwo userName:@"jjr" pwd:@"jjr889900" modelType:[Manager shareMgr].accessTokenNewModal baseUrl:NewSeviceURL];
    }
    [request postbodyMsg:bodyMsg op:opName func:funcName requestVersion:versionFlag?New_Request_Version:nil progressFlag:progressFlag progressMsg:progressMsg seviceUrl:NewSeviceURL
                  sercet:accessTokenModal.sercet_
             accessToken:accessTokenModal.accessToken_ success:requestSuccess failure:requestFailure];
}

#pragma mark - 2016.12.20日新加的另一种类型的请求
//不带进度显示信息
+(void)newThreeBodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag  success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess
          failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure {
    ELRequest* request = [self sharedELRequest];
    AccessToken_DataModal *accessTokenModal = [Manager shareMgr].accessTokenThreeModal;
    if (!accessTokenModal) {
        [[Manager shareMgr] configToken:AccessTokenTypeThree userName:@"recommend" pwd:@"recommend123" modelType:[Manager shareMgr].accessTokenThreeModal baseUrl:NewSeviceURL];
    }
    [request postbodyMsg:bodyMsg op:opName func:funcName requestVersion:versionFlag?New_Request_Version:nil progressFlag:NO progressMsg:nil seviceUrl:NewSeviceURL sercet:accessTokenModal.sercet_
             accessToken:accessTokenModal.accessToken_ success:requestSuccess failure:requestFailure];
}

//带进度显示信息
+(void)newThreePostbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag   progressFlag:(BOOL)progressFlag progressMsg:(NSString *)progressMsg success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure
{
    if (progressFlag) {
        [BaseUIViewController showLoadView:YES content:progressMsg view:nil];
    }
    ELRequest* request = [self sharedELRequest];
    AccessToken_DataModal *accessTokenModal = [Manager shareMgr].accessTokenThreeModal;
    if (!accessTokenModal) {
        [[Manager shareMgr] configToken:AccessTokenTypeThree userName:@"recommend" pwd:@"recommend123" modelType:[Manager shareMgr].accessTokenThreeModal baseUrl:NewSeviceURL];
    }
    [request postbodyMsg:bodyMsg op:opName func:funcName requestVersion:versionFlag?New_Request_Version:nil progressFlag:progressFlag progressMsg:progressMsg seviceUrl:NewSeviceURL
                  sercet:accessTokenModal.sercet_
             accessToken:accessTokenModal.accessToken_ success:requestSuccess failure:requestFailure];
}


#pragma mark - 请求封装
//不带进度显示信息
+(void)newBodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName tokenType:(AccessTokenType)tokenType userName:(NSString *)user pwd:(NSString *)pwd modelType:(AccessToken_DataModal *)tokenModel serviceURL:(NSString *)serviceUrl version:(NSString *)version requestVersion:(BOOL)versionFlag  success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess
               failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure {
    ELRequest* request = [self sharedELRequest];
    AccessToken_DataModal *accessTokenModal = tokenModel;
    if (!accessTokenModal) {
        [[Manager shareMgr] configToken:tokenType userName:user pwd:pwd modelType:tokenModel baseUrl:serviceUrl];
    }
    [request postbodyMsg:bodyMsg op:opName func:funcName requestVersion:versionFlag?version:nil progressFlag:NO progressMsg:nil seviceUrl:serviceUrl sercet:accessTokenModal.sercet_
             accessToken:accessTokenModal.accessToken_ success:requestSuccess failure:requestFailure];
}

//带进度显示信息
+(void)newPostbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName tokenType:(AccessTokenType)tokenType userName:(NSString *)user pwd:(NSString *)pwd modelType:(AccessToken_DataModal *)tokenModel serviceURL:(NSString *)serviceUrl version:(NSString *)version requestVersion:(BOOL)versionFlag   progressFlag:(BOOL)progressFlag progressMsg:(NSString *)progressMsg success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure
{
    if (progressFlag) {
        [BaseUIViewController showLoadView:YES content:progressMsg view:nil];
    }
    ELRequest* request = [self sharedELRequest];
    AccessToken_DataModal *accessTokenModal = tokenModel;
    if (!accessTokenModal) {
        [[Manager shareMgr] configToken:tokenType userName:user pwd:pwd modelType:tokenModel baseUrl:serviceUrl];
    }
    [request postbodyMsg:bodyMsg op:opName func:funcName requestVersion:versionFlag?version:nil progressFlag:progressFlag progressMsg:progressMsg seviceUrl:serviceUrl
                  sercet:accessTokenModal.sercet_
             accessToken:accessTokenModal.accessToken_ success:requestSuccess failure:requestFailure];
}



#pragma mark - 请求调用的唯一方法
-(void)postbodyMsg:(NSString *)bodyMsg op:(NSString *)opName 
              func:(NSString *)funcName 
              requestVersion:(NSString *)versionFlag 
              progressFlag:(BOOL)progressFlag 
              progressMsg:(NSString *)progressMsg 
              seviceUrl:(NSString *)seviceUrl
              sercet:(NSString *)sercet
              accessToken:(NSString *)accessToken
              success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess
              failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure
{
    NSMutableDictionary *dict = nil;
    NSString *httpPath = nil;
    if (versionFlag) {
         httpPath = [NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",seviceUrl,sercet,accessToken,opName,funcName,versionFlag];
    }else{
        httpPath = [NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",seviceUrl,sercet,accessToken,opName,funcName];
    }
    NSLog(@"请求信息：%@\n bodyMsg=%@", httpPath, bodyMsg);
    
//    //修改分页参数
//    NSString *pageParams = [NSString isContainPageSize:bodyMsg];
//    if (pageParams.length > 0) {
//        NSRange range = [bodyMsg rangeOfString:pageParams];
//        NSString *str1 = [bodyMsg substringToIndex:(range.location-1)];
//        NSString *str2 = [NSString stringWithFormat:@"\"%@\":\"20\"",pageParams];
//        NSString *str3 = [bodyMsg substringFromIndex:range.location+range.length+6];
//        
//        bodyMsg = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
//    }
    
    dict = [MyDes filterPost:bodyMsg httpPath:httpPath];
    //加密
    NSString *path = [dict objectForKey:@"path"];
    NSDictionary *paramDic = [dict objectForKey:@"param"];
    
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    manager.requestSerializer.timeoutInterval = 10.f;
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];  
    [securityPolicy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:securityPolicy];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //头文件设置
    NSString * userId = [CommonConfig getDBValueByKey:Config_Key_UserID];
    if (!userId) {
        userId = @" ";
    }
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[Common  idfvString] forHTTPHeaderField:@"MAC"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@,%@,iphone_yl1001new_client,%@",userId,[Common idfvString],ClientVersion] forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@,%@,iphone_yl1001new_client,%@",userId,[Common idfvString],ClientVersion] forHTTPHeaderField:@"AUTO-MARK"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"APPS_IOS_IPHONE,YL1001_GROUP,%@",ClientVersion] forHTTPHeaderField:@"SYS"];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    [manager POST:path parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (progressFlag) {
            [self hideProgress];
        }
        id dic = nil;
        //解密
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:enc];
        responseObject = [MyDes dataWithBase64EncodedString:str];
        responseObject = [MyDes decrypt:responseObject];
        NSError *error = nil;
        
        if (responseObject != nil) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        }
        if (error != nil) {
            NSLog(@"解析错误------------------------------\n%@",error.description);
        }else{
            NSLog(@"返回结果%@ bodyMsg=%@========================\n%@",httpPath, bodyMsg, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        }
        if (requestSuccess) {
            if (dic == nil || [dic isKindOfClass:[NSNull class]]) {
                dic = @{};
            }
            requestSuccess(task,dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (progressMsg) {
            [self hideProgress];
        }
        NSLog(@"请求错误------------------------------\n%@",error.description);
        if (requestFailure) {
            requestFailure(task,error);
        }

    }];
}

- (void)hideProgress
{
    [BaseUIViewController showLoadView:NO content:nil view:nil];
}

+ (void)getMsgWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))requestSuccess failure:(void (^)(NSURLSessionDataTask *, NSError *))requestFailure
{
    ELRequest* request = [self sharedELRequest];
    return [request getMsgWithUrl:url parameters:parameters success:requestSuccess failure:requestFailure];
}

#pragma mark get请求
- (void)getMsgWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))requestSuccess failure:(void (^)(NSURLSessionDataTask *, NSError *))requestFailure
{
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id dic = nil;
        NSError *error = nil;
        if (responseObject != nil && ![responseObject isKindOfClass:[NSDictionary class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        }else{
            dic = responseObject;
        }
        if (error != nil) {
            NSLog(@"解析错误------------------------------\n%@",error.description);
        }else{
            if (requestSuccess) {
                if (dic == nil || [dic isKindOfClass:[NSNull class]]) {
                    dic = @{};
                }
                requestSuccess(task,dic);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (requestFailure) {
            requestFailure(task,error);
        }
    }];
}

#pragma mark 取消请求
+ (void)cancelAllRequest
{
    ELRequest* request = [self sharedELRequest];
    [request cancelAllRequest];
}

- (void)cancelAllRequest
{
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    [manager.operationQueue cancelAllOperations];
}

#pragma mark - token请求方法
-(void)requestWithUserName:(NSString *)user pwd:(NSString *)pwd baseUrl:(NSString *)baseUrl block:(finishLoad)block{
    NSMutableDictionary *dict = nil;
    NSString *bodyMsg = [NSString stringWithFormat:@"user=%@&pwd=%@&time=%f&vflag=1",user,pwd,[NSDate timeIntervalSinceReferenceDate]];
    NSString *function = [CommonConfig getValueByKey:@"Init_Op" category:@"Op"];
    NSString *op = [CommonConfig getValueByKey:@"Init_Table" category:@"Op"];
    NSString *httpPath = [NSString stringWithFormat:@"%@&op=%@&func=%@",baseUrl,op,function];
    dict = [MyDes filterPost:bodyMsg httpPath:httpPath];
    //加密
    NSString *path = [dict objectForKey:@"path"];
    NSDictionary *paramDic = [dict objectForKey:@"param"];
    
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    manager.requestSerializer.timeoutInterval = 10.f;
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:securityPolicy];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //头文件设置
    NSString * userId = [CommonConfig getDBValueByKey:Config_Key_UserID];
    if (!userId) {
        userId = @" ";
    }
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[Common  idfvString] forHTTPHeaderField:@"MAC"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@,%@,iphone_yl1001new_client,%@",userId,[Common idfvString],ClientVersion] forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@,%@,iphone_yl1001new_client,%@",userId,[Common idfvString],ClientVersion] forHTTPHeaderField:@"AUTO-MARK"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"APPS_IOS_IPHONE,YL1001_GROUP,%@",ClientVersion] forHTTPHeaderField:@"SYS"];
    
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    
    [manager POST:path parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = nil;
        //解密
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:enc];
        responseObject = [MyDes dataWithBase64EncodedString:str];
        responseObject = [MyDes decrypt:responseObject];
        NSError *error = nil;
        
        if (responseObject != nil) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        }
        if ([dic isKindOfClass:[NSDictionary class]]) {
            block(dic);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"www.job1001.com" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    if (certData) {
        securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    }
    
    return securityPolicy;
}



@end
