//
//  BaseRequest.m
//  Template
//
//  Created by sysweal on 13-9-11.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "BaseRequest.h"
#import "zlib.h"
#import "BaseUIViewController.h"


//请求的基本地址
static NSString *BaseURL = nil;

@implementation BaseRequest

@synthesize bLoading_,url_,bodyMsg_,errorCode_,fileName_,bUploadFile_,bUploadFileCallBack_;

//获取基本的请求地址
+(NSString *) getBaseURL
{
    return BaseURL;
}

//设置基本的请求地址
+(void) setBaseURL:(NSString *)str
{
    BaseURL = str;
}

-(id) init
{
    self = [super init];
    
    receiveData_ = [[NSMutableData alloc] init];
    
    if( !BaseURL ){
//        [BaseRequest setBaseURL:[CommonConfig getValueByKey:@"Base_Address_Release" category:@"Op"]];
        [BaseRequest setBaseURL:SeviceURL];
    }
    
    return self;
}

//是否可以载入数据
-(BOOL) canGetData
{
    return YES;
}

//开始请求
-(void) startConn:(NSString *)action bodyData:(NSData *)bodyData method:(NSString *)method
{
    NSString *bodyMsg = nil;
    if( bodyData )
        bodyMsg = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    [self startConn:action bodyMsg:bodyMsg method:method];
}

//开始请求
-(void) startConn:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method
{
   
    
    if( ![self canGetData] ){
        [MyLog Log:@"canGetData return false, i'll interrupt conn" obj:self];
        
        return;
    }
    self.url_ = action;
    self.bodyMsg_ = bodyMsg;
    
    //重置异常code
    errorCode_ = Success;
    
    //取消以前的请求
    [self stopConn];
    
    bLoading_ = YES;
    
    //默认采用POST
    if( !method ){
        method = @"POST";
    }
    
//    // 修改分页参数
//    NSString *pageParams = [NSString isContainPageSize:bodyMsg];
//    if (pageParams.length > 0 && [bodyMsg containsString:@"conditionArr"]) {
//        NSRange range = [bodyMsg rangeOfString:pageParams];
//        NSString *str1 = [bodyMsg substringToIndex:(range.location-1)];
//        NSString *str2 = [NSString stringWithFormat:@"\"%@\":\"20\"",pageParams];
//        NSString *str3 = [bodyMsg substringFromIndex:range.location+range.length+6];
//        
//        bodyMsg = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
//    }
    
     [MyLog Log:[NSString stringWithFormat:@"url=%@ bodyMsg=%@",action,bodyMsg] obj:self];
    
    [self dataConn:action bodyMsg:bodyMsg method:method];
    
    
}

#pragma mark 组装请求
-(void)setRequestField:(NSMutableURLRequest*)request  method:(NSString*)method bodyMsg:(NSString *)bodyMsg bUpload:(BOOL)bUpload
{
    [request setHTTPMethod:method];
    if (!bUpload) {
        //拼接参数发起请求
        NSInteger msgLength = [bodyMsg length];
        [request addValue: [NSString stringWithFormat:@"%ld",(long)msgLength] forHTTPHeaderField:@"Content-Length"];
        [request addValue: @"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:[Common  idfvString] forHTTPHeaderField:@"MAC"];
        NSString * userId = [CommonConfig getDBValueByKey:@"user_id"];
        if (!userId) {
            userId = @" ";
        }
        [request setValue:[NSString stringWithFormat:@"%@,%@,iphone_yl1001new_client,%@",userId,[Common idfvString],ClientVersion] forHTTPHeaderField:@"User-Agent"];

        [request addValue:[NSString stringWithFormat:@"%@,iphone_yl1001new_client,%@,%@",userId,[Common idfvString],ClientVersion] forHTTPHeaderField:@"AUTO-MARK"];
        [request addValue:[NSString stringWithFormat:@"APPS_IOS_IPHONE,YL1001_GROUP,%@",ClientVersion] forHTTPHeaderField:@"SYS"];
        [request setHTTPBody:[bodyMsg dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        //二进制形式传输提交数据
        NSString *part1 = [NSString stringWithFormat:@"--*****\r\nContent-Disposition: form-data; name=\"Filedata\";filename=\"%@\"\r\n\r\n",fileName_];
        
        NSMutableData *bodyData = [NSMutableData dataWithBytes:[part1 UTF8String] length:[part1 length]];
        
        NSString *str1 = @"\r\n";
        NSString *str2 = @"--*****--\r\n";
        [bodyData appendData:(NSData *)bodyMsg];
        [bodyData appendBytes:"\r\n" length:[str1 length]];
        [bodyData appendBytes:"--*****--\r\n" length:[str2 length]];
        [request setHTTPMethod:method];
        [request addValue: @"multipart/form-data;boundary=*****" forHTTPHeaderField:@"Content-Type"];
        [request addValue: @"UTF-8" forHTTPHeaderField:@"Charset"];
        [request addValue: @"Keep-Alive" forHTTPHeaderField:@"Connection"];
        
        [request setHTTPBody:bodyData];
    }
    
    
    
}




//组装去网上的请求(让子类来重写此方法)
-(void) dataConn:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method
{
    [MyLog Log:@"start request to get data" obj:self];
    
    if( !bUploadFile_ ){
        @try {
            if( bodyMsg && ![bodyMsg isEqualToString:@""] ){
                bodyMsg = [bodyMsg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSMutableString *webStr = [[NSMutableString alloc] initWithString:bodyMsg];
                NSRange rang;
                rang.location = 0;
                rang.length = [webStr length];
                [webStr replaceOccurrencesOfString:@"@@" withString:@"\\" options:NSCaseInsensitiveSearch range:rang];
                bodyMsg = webStr;
            }
            
            //加密组装
            NSMutableDictionary* dict=[MyDes filterPost:bodyMsg httpPath:action];
            NSString * bodyStr = [NSString stringWithFormat:@"g=%@&p=%@&encode=%@",[[dict objectForKey:@"param"] objectForKey:@"g"],[[dict objectForKey:@"param"] objectForKey:@"p"],[[dict objectForKey:@"param"] objectForKey:@"encode"]];
            
            //组装请求
            NSURL *url = [NSURL URLWithString:[dict objectForKey:@"path"]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                    timeoutInterval:[CommonConfig getRequestTimeOutSeconds]];
            
            
            if( bodyMsg && ![bodyMsg isEqualToString:@""] ){
                [self setRequestField:request method:method bodyMsg:bodyStr bUpload:NO];
                
            }
            
            
            //[self startAFRequest:request];
            //重新发起请求
            conn_ = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
            if (!mgr.isReachable  && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusUnknown) {
                //设置异常code
                errorCode_ = No_Internet_Error;
                
                //直接让请求完成
                [self connectionDidFinishLoading:conn_];
                //[self afConnenctionDidFinishLoading:afCon_];
                
            }
            
            
            if( !conn_ ){
                //设置异常code
                errorCode_ = Init_Internet_Error;
                
                //直接让请求完成
                [self connectionDidFinishLoading:conn_];
                //[self afConnenctionDidFinishLoading:afCon_];
            }
            
        }
        @catch (NSException *exception) {
            [MyLog Log:[NSString stringWithFormat:@"dataConn error!!! action=%@ , bodyMsg=%@",action,bodyMsg] obj:self];
            
            //设置异常code
            errorCode_ = Init_Internet_Error;
            
            //直接让请求完成
            [self connectionDidFinishLoading:conn_];
            //[self afConnenctionDidFinishLoading:afCon_];
        }
        @finally {
            
        }
    }else{
        method = @"POST";
        
        @try {
            //组装请求
            NSURL *url = [NSURL URLWithString:action];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                    timeoutInterval:[CommonConfig getRequestTimeOutSeconds]];
            
            [self setRequestField:request method:method bodyMsg:bodyMsg bUpload:YES];
            
            //[self startAFRequest:request];
            //重新发起请求
            conn_ = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            if( !conn_ ){
                //设置异常code
                self.errorCode_ = Init_Internet_Error;
                
                //直接让请求完成
                [self connectionDidFinishLoading:conn_];
                //[self afConnenctionDidFinishLoading:afCon_];
            }
        }
        @catch (NSException *exception) {
            [MyLog Log:[NSString stringWithFormat:@"dataConn error!!! action=%@ , bodyMsg=%@",action,bodyMsg] obj:self];
            
            //设置异常code
            self.errorCode_ = Init_Internet_Error;
            
            //直接让请求完成
            [self connectionDidFinishLoading:conn_];
            //[self afConnenctionDidFinishLoading:afCon_];
        }
        @finally {
            
        }
    }
    __weak BaseRequest *request = self;
    if (conn_) {
        outDate = [NSDate date];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
             [request timeOut];
        });
    }
}

-(void)timeOut{
    if(bLoading_ && outDate){
        NSTimeInterval timer = -[outDate timeIntervalSinceNow];
        if (timer >= 10) {
            errorCode_ = No_Internet_Error;
            //直接让请求完成
            [self connectionDidFinishLoading:conn_];
        }
    }
}

#pragma mark  NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //release receive data
    [receiveData_ setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    //NSData * unzipData = [self uncompressZippedData:data];
    [receiveData_ appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //设置异常code
    errorCode_ = No_Internet_Error;
    
    //直接让请求完成
    [self connectionDidFinishLoading:conn_];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //调试模式
#ifndef __OPTIMIZE__
    NSString *tempStr = [[NSString alloc] initWithData:receiveData_ encoding:NSUTF8StringEncoding];
    NSData * mydata = [MyDes dataWithBase64EncodedString:tempStr];
    mydata = [MyDes decrypt:mydata];
    tempStr = [[NSString alloc] initWithData:mydata encoding:NSUTF8StringEncoding];
    [MyLog Log:[NSString stringWithFormat:@"receive data size=%lu detail=%@",(unsigned long)[receiveData_ length],tempStr] obj:self];
#endif
    
    [MyLog Log:[NSString stringWithFormat:@"conn finish, code=%d",errorCode_] obj:self];
    
    bLoading_ = NO;
    //conn finish
    [self connFinsih:connection];
    
    //stop conn
    [self stopConn];
    
    outDate = nil;
}


//请求完成
-(void) connFinsih:(NSURLConnection *)conn
{
    //jude code
    if( errorCode_ < Fail ){
        self.lasterDate_ = [NSDate date];
    }
}


//停止请求
-(void) stopConn
{
    [conn_ cancel];
    bLoading_ = NO;
    
    [receiveData_ setLength:0];
}
@end
