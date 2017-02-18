//
//  CondictionListCtl.h
//  MBA
//
//  Created by sysweal on 13-12-15.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

/******************************
 
 条件选择类
 CondictionListCtl
 
 ******************************/

#import "BaseListCtl.h"
#import "CondictionList_DataModal.h"
#import "MyDataBase.h"

//条件选择类型
typedef enum
{
    CondictionType_Hka,         //籍guang
    CondictionType_Region,      //地区的条件选择
    CondictionType_Edu,         //学历
    CondictionType_Zye,         //专业
    CondicitonType_Major,       //专业名称
    CondictionType_Trade,       //行业
    ConditionType_JobGuideQues, //职导问题类型
    CondictionType_TotalTrade,  //总行业
}CondictionType;

@class CondictionListCtl;
@protocol CondictionListDelegate <NSObject>

-(void) condictionListCtlChoosed:(CondictionListCtl *)ctl dataModal:(CondictionList_DataModal *)dataModal;

@end

@interface CondictionListCtl : BaseListCtl<CondictionListDelegate>
{
    NSMutableArray             *dataArr_;
}

@property(nonatomic,assign) BOOL                bHaveSub_;
@property(nonatomic,assign) CondictionType      type_;
@property(nonatomic,strong) CondictionList_DataModal *parentModal_;
@property(nonatomic,assign) id<CondictionListDelegate> delegate_;

//共用的condictionListCtl
+(CondictionListCtl *) shareCtl;

//获取学历arr
+(NSArray *) getEduArr;

//获取总行业类别
+(NSArray*)getTotalTradeArr;

//获取专业类别
+(NSArray *) getZyeCatArr;

//获取某专业下的子arr
+(NSArray *) getMajorArr:(NSString *)zyeId;

//获取问题类型列表
+(NSArray *) getQuesArr;

//获取学历
+(NSString *) getEduStr:(NSString *)edu;

//获取学历id
+(NSString *) getEduId:(NSString *)eduStr;

//获取行业
+(NSString *) getTradeStr:(NSString *)trade;

//获取行业id
+(NSString *) getTradeId:(NSString *)tradeStr;

//获取专业类别id
+(NSString *) getZyeId:(NSString *)zyeStr;

//获取专业名称
+(NSString *) getZyeName:(NSString *)zyeId;

//根据regionId获取regionStr
+(NSString *) getRegionStr:(NSString *)regionId;

//根据regionStr获取regionId
+(NSString *) getRegionId:(NSString *)regionStr;

//根据quesId获取quesStr
+(NSString *)getQuesStr:(NSString*)quesId;

//根据quesStr获取quesId
+(NSString *)getQuesId:(NSString*)quesStr;

//进入某个类型
-(void) getIn:(id<CondictionListDelegate>)delegate type:(CondictionType)type bHaveSub:(BOOL)bHaveSub;

//将nav中的堆栈pop出来
-(void) popCondictionListCtl;

@end
