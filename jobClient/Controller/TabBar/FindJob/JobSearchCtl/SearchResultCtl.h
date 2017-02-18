//
//  SearchResultCtl.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
            职位搜索结果
 
 ******************************/

#import <UIKit/UIKit.h>
#import "PreBaseResultListCtl.h"
#import "SearchResultList_Cell.h"
#import "JobSearch_DataModal.h"
#import "SearchParam_DataModal.h"
#import "HistoryTableView.h"
#import "ExRequetCon.h"
//#import "MyResumeCtl.h"
#import "DBTools.h"

#define SearchResultCtl_Xib_Name            @"SearchResultCtl"
#define SearchResultCtl_Title               @"职位搜索结果"
#define TableHeight_SearchResult            56
#define Result_Add_Cnt                      50000
#define ZW_HaveRead_Max_HistoryDay          -3

@class SearchResultCtl;
@protocol SearchResultDelegate <NSObject>

-(void) searchFinished:(SearchResultCtl *)ctl;
-(void) searchBack;
@end

@interface SearchResultCtl : PreBaseResultListCtl {
    IBOutlet    UIButton                    *applyBtn_;     //申请职位
    IBOutlet    UIButton                    *favBtn_;       //收藏职位
    IBOutlet    UIImageView                 *bottomImageView_;
    
    SearchParam_DataModal                   *searchParam_;  //搜索参数
    PreRequestCon                              *zwPreRequestCon_; //用于申请,收藏职位
    
    NSString                                *currentSearchURL_;
    NSString                                *historyURL_;   //
    NSString                                *titleStr_;     //自己的标题
    BOOL                                    bLoadByHistory_;
    BOOL                                    bOtherZWResult_;//是否只是职位列表
    BOOL                                    bChangeTitle_;  //是否需要更改标题
    
    //用于批处理
    int                                     currentOperateIndex_;   //当前要处理的index,主要用于连续申请，收藏职位
    int                                     successCount_;          //成功数
    int                                     failCount_;             //失败数
    int                                     processCount_;          //总共处理数量
    BOOL                                    bResumeFail_;           //由于简历不完整而造成的错误
    NSString                                *failMsg_;              //失败原因
    NSMutableArray                          *applyJobArr_;
    DBTools                                 *db_;
}

@property(nonatomic,weak) id<SearchResultDelegate>  delegate_;
@property(nonatomic,strong) NSString        *type_;
//搜索职位
-(void) search:(NSString *)searchURL title:(NSString *)title;

//获取搜索时的条件str
-(NSString *) getSearchCondictionStr:(SearchParam_DataModal *)dataModal;

//初始化连续申请，收藏信息
-(void) initOperateInfo;

//查看数据库中是否存在此条职位
-(BOOL) checkZWIsExistInDB:(NSString *)zwId;

//将搜索条件写入数据库中
-(void) writeSearchParamToHistoryDB;

//获取选中职位数量
-(int) getSelectCnt;

//设置标题
-(void) setMyTitle;


//订阅选中职位
-(void) loadFavSelectZW;

//申请选中职位
-(void) loadApplySelectZW;

@end

extern UIImage *selectOnImage;
extern UIImage *selectOffImage;
