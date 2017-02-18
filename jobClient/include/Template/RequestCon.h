//
//  RequestCon.h
//  Template
//
//  Created by sysweal on 13-9-11.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/****************************
 
        数据连接类
 
 ****************************/

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "PageInfo.h"
#import "JSONParser.h"
#import "DataManger.h"

//load state
typedef enum{
	FinishLoad,         //加载完成
	ErrorLoad,          //加载出错
	InReload,           //正在加载
	InLoadMore,         //正在加载更多
    InterruptLoad,      //中断加载
}LoadStats;

//store type
typedef enum{
    NeverStoreType,     //从不存储
    TempStoreType,      //临时存储
    ForeverStoreType,   //永远存储
}DataStoreType;

//缓存策略
typedef enum
{
    Cache_Null  = -1,
    Cache_Off   = 0,    //不采用缓存(直接到网络上请求数据)
    Cache_Auto  = 1,    //采用智能缓存(如果网络没有数据，然后自动去取Cache中的数据)
    Cache_Only  = 2,    //只采用缓存模式(如果Cache中没有数据，依然去取网络)
}CacheMode;

@class RequestCon;

//load protocol
@protocol LoadDataDelegate <NSObject>

//load data finish
-(void) loadDataComplete:(RequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr requestType:(int)type;
//get the requetInditify
-(NSString *) getRequestInditify:(RequestCon *)con;

@optional

//clear request dataArr's data
-(void) dataChanged:(RequestCon *)con;

//start load data
-(void) loadDataBegin:(RequestCon *)con requestType:(int)type;

//request should be interrupt
-(BOOL) dataConnShouldInterrupt:(RequestCon *)con aciton:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method;

@end

@interface RequestCon : BaseRequest<ParserDelegate>{
    BOOL                    bFresh_;            //是否直接刷新数据
    BOOL                    bLocalData_;        //是否是本地数据
    int                     requestType_;       //请求类型
    
    JSONParser              *jsonParser_;       //解析json
    NSString                *serviceAddress_;   //请求的地址
}

@property(nonatomic,assign) int                     requestType_;         //是否是加载更多
@property(nonatomic,assign) BOOL                    bLoadMore_;         //是否是加载更多
@property(nonatomic,assign) BOOL                    bCacheData_;        //是否是缓存数据
@property(nonatomic,strong) NSMutableArray          *dataArr_;          //数据集
@property(nonatomic,assign) DataStoreType           storeType_;         //数据存放类型
@property(nonatomic,assign) LoadStats               loadStats_;         //加载状态
@property(nonatomic,strong) PageInfo                *pageInfo_;         //分页信息(默认没有此值,否则代表有分页)
@property(nonatomic,strong) PageInfo                *prePageInfo_;      //上次请求的分页信息
@property(nonatomic,assign) long                    validateSeconds_;   //数据有效期(用于控制是否可以开始请求的时间)
@property(nonatomic,assign) long                    cacheSeconds_;      //缓存有效期(用于设置请求的缓存有效期)
@property(nonatomic,assign) int                     section_;           //索引
@property(nonatomic,assign) int                     index_;             //索引
@property(nonatomic, weak) id                      object_;            //产生请求的指针
@property(nonatomic, weak) id<LoadDataDelegate>    delegate_;          //代理
@property(nonatomic,strong) NSString                *requestInditify_;  //请求标识
@property(nonatomic,assign) BOOL                    bInterrupt_;        //是否被中断了
@property(nonatomic,strong) NSString                *interruptAction_;  //被中断时的actoin
@property(nonatomic,strong) NSString                *interruptMsg_;     //被中断时的msg
@property(nonatomic,strong) NSString                *interruptMethod_;  //被中断时的Method_
@property(nonatomic, weak) RequestCon              *conBeInterrupt_;   //被中断者

@property(nonatomic,assign) BOOL isResumePhoto;

//如果请求含有字符串,则代表需要显示模态加载Loading界面
+(NSString *) getRequestStr:(int)type;

//设置是否直接刷新的Flag
-(void) setFresh:(BOOL)flag;

//清除数据
-(void) clearData;

//添加数据
-(void) addDataModal:(NSArray *)arr parserType:(int)type;

//获取请求的Key
-(NSString *) getConnKey;

//初始化分页信息
-(void) initPageInfo;

//重置分页信息
-(void) resetPageInfo;

//获取数据缓存类型
-(DataType) getDataType:(int)requestType;

//获取Cache数据的有数期
-(long) getCacheValidateSeconds:(int)requestType;

//请求恢复
-(void) dataConnRecover:(NSString *)sercet token:(NSString *)token;

//获安全凭证(由外界来复写此方法)
-(void) getAccessToken:(NSString *)user pwd:(NSString *)pwd time:(long)time;

//页面返回时请求中断
-(void)stopConnWhenBack;


@end
