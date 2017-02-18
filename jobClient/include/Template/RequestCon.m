 //
//  RequestCon.m
//  Template
//
//  Created by sysweal on 13-9-11.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "RequestCon.h"

//缓存策略
static CacheMode    cacheMode = -1;

@implementation RequestCon

@synthesize requestType_,bLoadMore_,bCacheData_,dataArr_,storeType_,loadStats_,pageInfo_,prePageInfo_,validateSeconds_,cacheSeconds_,section_,index_,object_,delegate_,requestInditify_,bInterrupt_,conBeInterrupt_;

//如果请求含有字符串,则代表需要显示模态加载Loading界面
+(NSString *) getRequestStr:(int)type
{
    return nil;
}

-(id) init
{
    self = [super init];
    
    dataArr_ = [[NSMutableArray alloc] init];
    
    validateSeconds_ = 0;
    cacheSeconds_ = 0;
    return self;
}

//设置是否直接刷新的Flag
-(void) setFresh:(BOOL)flag
{
    bFresh_ = flag;
}

//清除数据
-(void) clearData
{
    [dataArr_ removeAllObjects];
}


//添加数据
-(void) addDataModal:(NSArray *)arr parserType:(int)type
{
    if( arr )
    {
        [dataArr_ addObjectsFromArray:arr];
    }
}

//获取请求的Key
-(NSString *) getConnKey{
    return [NSString stringWithFormat:@"%@+%@",self.url_,self.bodyMsg_];
}

//初始化分页信息
-(void) initPageInfo
{
    pageInfo_ = [[PageInfo alloc] init];
    prePageInfo_ = [[PageInfo alloc] init];
}

//重置分页信息
-(void) resetPageInfo
{
    if(!pageInfo_){
        pageInfo_ = [[PageInfo alloc] init];
    }
    pageInfo_.currentPage_ = 0;
    pageInfo_.pageSize_ = 0;
    pageInfo_.pageCnt_ = 0;
    pageInfo_.totalCnt_ = 0;
}

//获取数据缓存类型
-(DataType) getDataType:(int)requestType{
    return Data_File;
}

//获取Cache数据的有数期
-(long) getCacheValidateSeconds:(int)requestType{
    return bFresh_ ? 0 : cacheSeconds_;
}

//是否可以载入数据
-(BOOL) canGetData
{
    BOOL flag = NO;
    
    NSString *inditify = [delegate_ getRequestInditify:self];
    
    //还没有加载过
    if( loadStats_ == FinishLoad && !self.lasterDate_ ){
        flag = YES;
    }
    //有效期已过
    else if( loadStats_ == FinishLoad && self.lasterDate_ && [[NSDate date] timeIntervalSinceDate:self.lasterDate_] > validateSeconds_ ){
        flag = YES;
    }
    //加载出错,但分页的时候加载出错不算
    else if( loadStats_ == ErrorLoad && ((!pageInfo_ || (pageInfo_ && [dataArr_ count] == 0)) || (self.lasterDate_ && [[NSDate date] timeIntervalSinceDate:self.lasterDate_] > validateSeconds_)) ){
		flag = YES;
	}
    //加载成功,分页数据为零时
    else if( loadStats_ == FinishLoad && pageInfo_ && [dataArr_ count] == 0 ){
        flag = YES;
    }
    //如果需要刷新
    else if( bFresh_ ){
        flag = YES;
    }
    
    //如果请求标识不一样
    if( (!requestInditify_ && inditify) || (requestInditify_ && !inditify) || ![requestInditify_ isEqualToString:inditify] ){
        flag = YES;
        
        //设置还未加载过
        self.lasterDate_ = nil;
        
        //此时还需要将自己存放的数据清空
        [dataArr_ removeAllObjects];
        
        //告诉代理
        [delegate_ dataChanged:self];
    }
    
    return flag;
}

//请求
-(void) dataConn:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method
{
    //set inditify
    self.requestInditify_ = [delegate_ getRequestInditify:self];
    
    bCacheData_ = NO;
    
    //set loadStat
    if( pageInfo_ && pageInfo_.currentPage_ > 0 ){
        loadStats_ = InLoadMore;
        
        bLoadMore_ = YES;
    }else{
        loadStats_ = InReload;
    }
  
    if ([delegate_ respondsToSelector:@selector(loadDataBegin:requestType:)]) {
        [delegate_ loadDataBegin:self requestType:requestType_];
    }
    
    //保留中断时的信息
    self.interruptAction_ = action;
    self.interruptMsg_ = bodyMsg;
    self.interruptMethod_ = method;
    
    //requestType_=0代表是图片的加载
    if( requestType_ != 0 && !self.bUploadFile_ && delegate_ && [delegate_ respondsToSelector:@selector(dataConnShouldInterrupt:aciton:bodyMsg:method:)] ){
        if( ![delegate_ dataConnShouldInterrupt:self aciton:action bodyMsg:bodyMsg method:method] ){
            [self dataConnRecover:nil token:nil];
        }else{
            //请求被中段了，需要delegate_来回调dataConnRecover继续函数的执行
            [delegate_ loadDataComplete:self code:self.errorCode_  dataArr:dataArr_ requestType:requestType_];
        }
    }else{
        [self dataConnRecover:nil token:nil];
    }
}

//请求恢复
-(void) dataConnRecover:(NSString *)sercet token:(NSString *)token
{
    //取出中断点的信息
    NSString *action = self.interruptAction_;
    NSString *bodyMsg = self.interruptMsg_;
    NSString *method = self.interruptMethod_;
    
    //删除中断时的信息
    self.interruptAction_ = nil;
    self.interruptMsg_ = nil;
    self.interruptMethod_ = nil;
    
    //如果安全凭证有值了
    if( sercet && token && action){
        //替换掉action中的值
        NSMutableString *str = [[NSMutableString alloc] initWithString:action];
        NSRange rang;
        rang.location = 0;
        rang.length = [str length];
        [str replaceOccurrencesOfString:@"secret=" withString:@"sercet_pre=" options:NSLiteralSearch  range:rang];
        rang.location = 0;
        rang.length = [str length];
        [str replaceOccurrencesOfString:@"access_token=" withString:@"access_token_pre=" options:NSLiteralSearch  range:rang];
        
        //将新的值拼上去
        [str appendFormat:@"&secret=%@&access_token=%@",sercet,token];
        action = str;
    }
    
    //get and set cache mode
    if( cacheMode == -1 ){
        cacheMode = [[CommonConfig getValueByKey:@"Local_Cache_Mode" category:@"ClientBaseInfo"] intValue];
    }
    [MyLog Log:[NSString stringWithFormat:@"cacheMode=%d",cacheMode] obj:self];
    
    //判断数据缓存
    NSData *cacheData = NULL;
    if( !self.bUploadFile_ ){
        if( cacheMode == Cache_Only ){
            //取缓存(此时不用去管cacheSeconds)
            cacheData = [DataManger getData:[self getConnKey] cacheSeconds:-1 type:[self getDataType:requestType_]];
        }else{
            //取缓存
            cacheData = [DataManger getData:[self getConnKey] cacheSeconds:[self getCacheValidateSeconds:requestType_] type:[self getDataType:requestType_]];
        }
    }
    
    //如果已经找到了缓存数据，则不再去网上请求数据
    if( cacheData ){
        bCacheData_ = YES;
        [receiveData_ appendData:cacheData];
        
        [self performSelector:@selector(connectionDidFinishLoading:) withObject:NULL afterDelay:0.4];

    }else
        [super dataConn:action bodyMsg:bodyMsg method:method];
}

-(void) connFinsih:(NSURLConnection *)conn
{
    //开始解析
    if( !jsonParser_ ){
        jsonParser_ = [[JSONParser alloc] init];
        jsonParser_.delegate_ = self;
    }
    
    //去解析数据
    if( self.errorCode_ < Fail ){
        [jsonParser_ parserJSON:receiveData_ strData:nil requestType:requestType_];
    }
    //已经发生异常
    else{
        //如果采用的是智能缓存,则还需要到缓存中去取一次数据
        if( cacheMode == Cache_Auto ){
            //去缓存去找一次数据(此时不用去管validateSeconds)
            NSData *cacheData = [DataManger getData:[self getConnKey] cacheSeconds:-1 type:[self getDataType:requestType_]];
            
            if( cacheData ){
                [MyLog Log:@"have find cache data" obj:self];
                
                bCacheData_ = YES;
                
                [jsonParser_ parserJSON:cacheData strData:nil requestType:requestType_];
            }else{
                [MyLog Log:@"didn't find cache data" obj:self];
                
                [self parserFinish:jsonParser_ code:Cache_NoData dataArr:nil requestType:requestType_];
            }
        }else{
            [self parserFinish:jsonParser_ code:self.errorCode_ dataArr:nil requestType:requestType_];
        }
    }
}


-(void) stopConn
{
    //取消延迟函数
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectionDidFinishLoading:) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(afConnenctionDidFinishLoading:) object:nil];
    
    if( loadStats_ != FinishLoad ){
        loadStats_ = ErrorLoad;
    }
    [super stopConn];
}

-(void)stopConnWhenBack
{
    [self stopConn];
    delegate_ = nil;
}

#pragma ParserDelegate
-(void) parserFinish:(JSONParser *)parser code:(ErrorCode)code dataArr:(NSArray *)arr requestType:(int)type
{
    self.errorCode_ = code;
    
    //存入缓存中
    if( !bCacheData_ && self.errorCode_ < Fail && cacheMode > Cache_Off ){
        [DataManger saveData:[self getConnKey] data:receiveData_ type:[self getDataType:requestType_]];
    }
    
    if( code < Fail ){
        loadStats_ = FinishLoad;
    }else{
        loadStats_ = ErrorLoad;
    }
    
    //处理数据以及分页等，最后回调回去
    @try {
        //处理分页
        if( pageInfo_ ){
            if( code <= Success ){
                @try {
                    if( pageInfo_.currentPage_ == 0 ){
                        [self clearData];
                    }
                }
                @catch (NSException * e) {
                    [MyLog Log:@"PageInfo Error!" obj:self];
                }
                @finally {
                    ++pageInfo_.currentPage_;
                    
                    //记下分页信息
                    prePageInfo_.currentPage_ = pageInfo_.currentPage_;
                    prePageInfo_.pageCnt_ = pageInfo_.pageCnt_;
                }
            }else{
                //error load
                //recover page info
                pageInfo_.currentPage_ = prePageInfo_.currentPage_;
                pageInfo_.pageCnt_ = prePageInfo_.pageCnt_;
            }
        }else{
            [self clearData];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        //如果需要缓存数据
        if( storeType_ >= TempStoreType ){
            [MyLog Log:[NSString stringWithFormat:@"i'll store the dataArr , storeType_=%d",storeType_] obj:self];
            
            [self addDataModal:arr parserType:type];
        }else{
            [MyLog Log:@"didn't store the dataArr" obj:self];
        }
        
        [MyLog Log:[NSString stringWithFormat:@"dataArr's cnt=%lu",(unsigned long)[dataArr_ count]] obj:self];
        
        if( [dataArr_ count] > 0 ){
            id obj = [dataArr_ objectAtIndex:0];
            
            if( [obj isKindOfClass:[PageInfo class]] ){
                PageInfo *pageInfo = obj;
                pageInfo_.totalCnt_ = pageInfo.totalCnt_;
                pageInfo_.pageCnt_ = pageInfo.pageCnt_;
            }
        }
        
        //设置数据的获取时间
        if( code < Fail ){
            self.lasterDate_ = [NSDate date];
            
            //if( !self.lasterDate_ || !bCacheData_ ){
            //    self.lasterDate_ = [NSDate date];
            //}
        }
        
        //加调回去
        @try {
            [delegate_ loadDataComplete:self code:code dataArr:arr requestType:type];
        }
        @catch (NSException *exception) {
            [MyLog Log:@"loadDataComplete happen error!!!" obj:self];
        }
        @finally {
            
        }
                
        bLoadMore_ = NO;
    }
}

//获安全凭证(由外界来复写此方法)
-(void) getAccessToken:(NSString *)user pwd:(NSString *)pwd time:(long)time
{
    //外界复写此方法
}

@end
