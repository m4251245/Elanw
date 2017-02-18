//
//  ELRequest.h
//  jobClient
//
//  Created by 一览ios on 15/8/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "AccessToken_DataModal.h"

typedef void (^finishLoad)(NSDictionary *dic);

typedef void (^myBlock)(NSInteger tokenType,NSDictionary *dic);

@interface ELRequest : NSObject
{
    
}

/**
 *  post请求
 *
 *  @param bodyMsg  请求的参数<json的字符串>
 *  @param opName   方法名
 *  @param versionFlag  是否带版本号（yes表示带）
 *  @param funcName 类名
 *  @param success  请求成功的block回调
 *  @param failure  请求失败的block回掉
 */
+(void)postbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag  success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure;

#pragma mark 带进度条
+(void)postbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag   progressFlag:(BOOL)progressFlag progressMsg:(NSString *)progressMsg success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure;

#pragma mark get 请求
+(void)getMsgWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure;

//#pragma mark 该方法已经过时
//-(void)postbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag progressFlag:(BOOL)progressFlag progressMsg:(NSString *)progressMsg success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess
//           failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure;

#pragma mark - 2016.11.21日新加的另一种类型的请求
//不带进度显示信息
+(void)newBodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag  success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess
          failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure;
//带进度显示信息
+(void)newPostbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag   progressFlag:(BOOL)progressFlag progressMsg:(NSString *)progressMsg success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure;

#pragma mark - 2016.12.20日新加的另一种类型的请求
//不带进度显示信息
+(void)newThreeBodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag  success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess
               failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure;
//带进度显示信息
+(void)newThreePostbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName requestVersion:(BOOL)versionFlag   progressFlag:(BOOL)progressFlag progressMsg:(NSString *)progressMsg success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure;


#pragma mark 取消请求
+ (void)cancelAllRequest;

+(ELRequest*) sharedELRequest;

#pragma mark - 请求token的方法
-(void)requestWithUserName:(NSString *)user pwd:(NSString *)pwd baseUrl:(NSString *)baseUrl block:(finishLoad)block;

#pragma mark - 请求封装
//不带进度显示信息
+(void)newBodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName tokenType:(AccessTokenType)tokenType userName:(NSString *)user pwd:(NSString *)pwd modelType:(AccessToken_DataModal *)tokenModel serviceURL:(NSString *)serviceUrl version:(NSString *)version requestVersion:(BOOL)versionFlag  success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess;

//带进度显示信息
+(void)newPostbodyMsg:(NSString *)bodyMsg op:(NSString *)opName func:(NSString *)funcName tokenType:(AccessTokenType)tokenType userName:(NSString *)user pwd:(NSString *)pwd modelType:(AccessToken_DataModal *)tokenModel serviceURL:(NSString *)serviceUrl version:(NSString *)version requestVersion:(BOOL)versionFlag   progressFlag:(BOOL)progressFlag progressMsg:(NSString *)progressMsg success:(void (^)(NSURLSessionDataTask *operation, id result))requestSuccess failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))requestFailure;

@end
