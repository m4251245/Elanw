//
//  ELLoadDataView.m
//  jobClient
//
//  Created by 一览iOS on 16/11/4.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELLoadDataView.h"
#import "RequestCon.h"

@interface ELLoadDataView() <LoadDataDelegate>
{
    RequestCon *requestCon_;
}
@end

@implementation ELLoadDataView

-(instancetype)init{
    self = [super init];
    if (self) {
        requestCon_ = [self getNewRequestCon];
    }
    return self;
}

//error get data
-(void) errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    
}
//finish get data
-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    
}
#pragma LoadDataDelegate
-(NSString *) getRequestInditify:(RequestCon *)con
{
    return nil;
}

-(void) dataChanged:(RequestCon *)con
{
    
}

-(void) loadDataBegin:(RequestCon *)con requestType:(int)type
{
    //如果请求含有字符串,则代表需要显示模态加载Loading界面
    NSString *loadingStr = [RequestCon getRequestStr:type];
    if( loadingStr ){
        loadingStr = [NSString stringWithFormat:@"%@",loadingStr];
        [BaseUIViewController showModalLoadingView:YES title:loadingStr status:nil];
    }
}

-(void) loadDataComplete:(RequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr requestType:(int)type
{
    [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
    @try {
        if( code >= Fail ){
            [self errorGetData:con code:code type:type];
        }else{
            [self finishGetData:con code:code type:type dataArr:dataArr];
        }
    }
    @catch (NSException *exception){
    }
    @finally {
    }
}

-(RequestCon *)getNewRequestCon
{
    RequestCon *con = [[RequestCon alloc] init];
    con.validateSeconds_ = 0;
    con.delegate_ = self;
    return con;
}

@end
