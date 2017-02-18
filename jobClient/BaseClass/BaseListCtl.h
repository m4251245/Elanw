//
//  BaseListCtl.h
//  Template
//
//  Created by sysweal on 13-9-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/***************************
 
 Ctl BaseList Class
 
 ***************************/

#import "BaseUIViewController.h"
#import "EGORefreshTableView.h"
#import "NoMoreDataCtl.h"
#import "NoDataOkCtl.h"

@interface BaseListCtl : BaseUIViewController<EGORefreshTableDelegate,UITableViewDataSource,UITableViewDelegate>
{
    @public
    IBOutlet    UITableView         *tableView_;
    
    //上拉下拉刷新视图
    EGORefreshTableView				*refreshHeaderView_;    //head ego view
	EGORefreshTableView				*refreshFooterView_;    //footer ego view
    BOOL                            bHeaderEgo_;            //是否有上拉刷新
    BOOL                            bFooterEgo_;            //是否有下拉刷新
    BOOL                            shouldRefresh_;
    //没有数据时的视图
    NoDataOkCtl                     *noDataOkCtl_;          //无数据ctl
    UIView                          *baseTipsView_;
    NSTimer                         *tipsTime_;
}

@property (nonatomic,strong) NoMoreDataCtl  *noMoreDataCtl_;        //上拉刷新时，没有更多数据的ctl
//EGO Fun
-(void) reloadTableViewDataSource:(EGORefreshTableView *)egoView;
-(void) doneLoadingTableViewData:(EGORefreshTableView *)egoView;

@property(nonatomic, assign) BOOL       reloadDateFlag;
@property(nonatomic, assign) BOOL       isChangeNoMoreData;
@property(nonatomic, assign) BOOL       noShowNoDataView;

@property(nonatomic, copy) NSString *noDataTips;
@property(nonatomic, copy) NSString *noDataImgStr;
@property(nonatomic, assign) CGFloat imgTopSpace;
@property(nonatomic, assign) CGFloat noDataViewStartY; 

//获取没有更多数据视图的父视图
-(UIView *) getNoMoreDataSuperView;

//show/hide have more page
-(void) showFooterRefreshView:(BOOL)flag;

- (void)adjustFooterViewFrame;

//show/hide no more data
-(void) showNoMoreDataView:(BOOL)flag;

//获取没有数据时的视图所显示的父视图
-(UIView *) getNoDataSuperView;

//获取没有数据时的视图
-(UIView *) getNoDataView;

//show/hide no data but load ok view
-(void) showNoDataOkView:(BOOL)flag;

//加载更多
-(void) loadMoreData:(RequestCon *)con;

//load detail
-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath;

//重写控制tipsView
-(void)reciveNewMesageAction:(NSNotificationCenter *)notifcation;

-(void)showHeaderView:(BOOL)show;

-(void) showLoadingView:(BOOL)flag;

@end
