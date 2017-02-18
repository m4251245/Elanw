//
//  BaseList2.h
//  jobClient
//
//  Created by 一览ios on 15/8/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELBaseUIViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"
#import "PageInfo.h"
#import "ELPersonCenterCtl.h"

@interface ELBaseListCtl:ELBaseUIViewController<ELEGORefreshTableDelegate,UITableViewDataSource,UITableViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    NSMutableArray  *_dataArray;//数据源数组
    BOOL _reloading;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PageInfo *pageInfo;        //分页信息
@property (strong, nonatomic) NSString *noDataImgStr;    //没有请求到数据时候的图片
@property (strong, nonatomic) NSString *noDataString;    //没有请求到数据时候的提示
@property (nonatomic, assign) CGFloat noDataTopSpace;    //没有请求到数据图片顶部距离
@property (nonatomic, assign) BOOL    headerRefreshFlag;    //是否有需要下拉刷新
@property (assign, nonatomic) BOOL    footerRefreshFlag;    //是否有需要上拉加载更多
@property (assign, nonatomic) BOOL    showNoDataViewFlag;    //显示没有数据的view
@property (assign, nonatomic) BOOL    showNoMoreDataViewFlag;    //显示没有数据的view

// create/remove footer/header view, reset the position of the footer/header views
@property (nonatomic,assign) BOOL noRefershLoadData;

-(void)setFooterView;
-(void)removeFooterView;
-(void)createHeaderView;
-(void)removeHeaderView;

// overide methods
-(void)beginToReloadData:(ELEGORefreshPos)aRefreshPos;
-(void)finishReloadingData;
-(void)refreshDataSource;
// force to refresh
-(void)showRefreshHeader:(BOOL)animated;

//解析分页信息
-(void)parserPageInfo:(NSDictionary *)dic;

//请求数据源
- (void)beginLoad:(id)param exParam:(id)exParam;

//刷新加载
- (void)refreshLoad;

- (void)loadDataScource;

//无数据提示
-(void)showRefreshNoDateView:(BOOL) flag;

- (IBAction)btnResponse:(id)sender;

-(void)showNoMoreDataView:(BOOL)flag;

#pragma mark 分页信息字符
- (NSString *)getPageQueryStr:(NSInteger)pageSize;

-(void)refreshEGORefreshView;

//重新计算底卡片位置
- (void)adjustFooterViewFrame;

@property (nonatomic, copy) NSString *noNetworkStr;

@end
