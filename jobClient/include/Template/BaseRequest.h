//
//  BaseRequest.h
//  Template
//
//  Created by sysweal on 13-9-11.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/****************************
 
        数据加载基类
 
 ****************************/

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Reachability.h"
#import "MyDes.h"

@interface BaseRequest : NSObject{
    NSURLConnection         *conn_;             //数据请求
    NSMutableData           *receiveData_;      //收到的数据
    NSDate *outDate;
}

@property(nonatomic,assign) BOOL            bLoading_;          //是否正在加载
@property(nonatomic,strong) NSString        *url_;              //请求的完整地址
@property(nonatomic,strong) NSString        *bodyMsg_;          //请求的body内容
@property(nonatomic,strong) NSDate          *lasterDate_;       //最近请求的成功时间
@property(nonatomic,assign) ErrorCode       errorCode_;
@property(nonatomic,strong) NSString        *fileName_;
@property(nonatomic,assign) BOOL            bUploadFile_;
@property(nonatomic,assign) BOOL            bUploadFileCallBack_;

//获取基本的请求地址
+(NSString *) getBaseURL;

//设置基本的请求地址
+(void) setBaseURL:(NSString *)str;

//是否可以载入数据
-(BOOL) canGetData;

//开始请求
-(void) startConn:(NSString *)action bodyData:(NSData *)bodyData method:(NSString *)method;

//开始请求
-(void) startConn:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method;

-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

//组装去网上的请求(让子类来重写此方法,子类可以根据缓存等策略来重写调用数据的具体方法)
-(void) dataConn:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method;

//请求完成(让子类来重写此方法)
-(void) connFinsih:(NSURLConnection *)conn;

//停止请求
-(void) stopConn;

@end
