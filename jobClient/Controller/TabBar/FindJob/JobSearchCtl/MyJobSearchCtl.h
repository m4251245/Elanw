//
//  MyJobSearchCtl.h
//  Association
//
//  Created by sysweal on 14-3-28.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "PreBaseResultListCtl.h"
#import "PreCondictionListCtl.h"
#import "CondictionListCtl.h"
#import "RegionCtl.h"
#import "PositionDetailCtl.h"
#import "DataSelectedCtl.h"
#import "ExRequetCon.h"
#import "DBTools.h"
#import "CustomSearchBar.h"
#import "ConditionItemCtl.h"
#import "ConditionDataModel.h"
#import <CoreLocation/CoreLocation.h>
#import "ConditionCtl.h"

//CondictionListDelegate,CondictionChooseDelegate,ConditionItemCtlDelegate,ChooseHotCityDelegate
@protocol JobSearchMessageDelegate <NSObject>

-(void)jobSearchMessageDelegateModal:(JobSearch_DataModal *)modal;

@end

@interface MyJobSearchCtl : BaseListCtl<UITextFieldDelegate,DataSelectedCtlDelegate,UISearchBarDelegate,CLLocationManagerDelegate>
{
    CondictionList_DataModal        *regionDataModal_;          //用户选择了哪个regionDataModal
    CondictionList_DataModal        *tradeDataModal_;           //用户选中的行业信息
    
    NSString                        *lastSearchTime_;
    NSMutableArray                  *publicTimeArray_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    RequestCon                      *findWorkCon_;
    SearchParam_DataModal           *searchParam_;
    NSMutableArray                  *dataArray_;
    
    IBOutlet UIView *buttonView_;
    NSString        *locationCity_;
    DBTools         *db_;
    BOOL               searchDefaul_;
    
    IBOutlet  UIView        *headView;
    RequestCon              *jobSubscribedCon_;
    RequestCon              *sortCon_;              //请求顶部四个按钮的排序
    NSMutableArray          *jobSubscribedArray_;
    NSArray                 *payMentArray;
    int                     _index;
    NSArray                 *colorArr_;         //颜色数组
    UISearchBar             *searchBar_;
    
    IBOutlet UIView *adView;//广告位
    RequestCon *_adCon;
    
    CLLocation             *_currentLocation;  //当前所在地的位置座标
    CLLocationManager      *_cllocation;
    NSString               *_locationCity;
}

@property (weak, nonatomic) UIView *adView2;

@property (nonatomic, weak) IBOutlet    UIView      *searchContentView_;
//@property (nonatomic, weak) IBOutlet    UIButton    *regionBtn_;
//@property (weak, nonatomic) IBOutlet    UIButton    *tradeBtn;
//@property (weak, nonatomic) IBOutlet    UIButton    *salaryBtn;
//@property (weak, nonatomic) IBOutlet    UIButton    *screenBtn;

@property(nonatomic,assign) int type_;
@property(nonatomic,assign) BOOL    isFromMessage_;
@property(nonatomic ,strong) NSString   *messageRegionId_;
@property(nonatomic ,strong) NSString   *messageKw_;

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *titleSearchBtn;

@property (weak, nonatomic) IBOutlet UIView *titleSearchView;

@property (strong, nonatomic) IBOutlet UIView *typeChangeView;

@property(weak,nonatomic) id <JobSearchMessageDelegate> messageDelegate;

@property(nonatomic,assign) BOOL fromMessageList;

@property (nonatomic, assign) BOOL isPop;
//获取搜索时需要的dataModal
-(SearchParam_DataModal *)getSearchDataModal;

//点击底部导航按钮回到顶部刷新列表
-(void)refreshBtnList;

- (void)statusBarTouchedAction;


@end

