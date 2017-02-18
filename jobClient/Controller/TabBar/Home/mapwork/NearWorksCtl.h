//
//  NearWorksCtl.h
//  jobClient
//
//  Created by YL1001 on 15/6/10.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "CondictionList_DataModal.h"
#import "RangeDataMocel.h"
#import "RangeChooseCtl.h"
#import "MapWorkCtl.h"
#import "RequestCon.h"

//RangeChooseCtlDelegate,CondictionChooseDelegate
@interface NearWorksCtl : BaseListCtl<UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{

    
    BOOL isFromMessage_;

    RangeDataMocel             *rangeModel_;
//    MapWorkCtl                 *mapWorkCtl;
    NSMutableArray             *jobSubscribedArray_;
    int                        index;
    
    __weak IBOutlet UIImageView *image_;
    
    //地图
    MKMapView    *mapView_;        //基础地图
    MKCoordinateRegion                      currentRegion_;     //当前所在地
    MKCoordinateSpan                        currentSpan_;       //比例尺
    BOOL                                    bHaveGetCurrentLocation_;
    CLLocation                              *currentLocation_;  //当前所在地的位置座标
    CLLocationManager                       *cllocation_;
}

@property(nonatomic ,strong) NSString        *messageRegionId_;
@property(nonatomic ,strong) NSString        *messageKw_;

@property(nonatomic ,weak) IBOutlet    UILabel     *rangeContentLb_;
@property(nonatomic ,weak) IBOutlet    UIButton    *rangeBtn_;

@property(nonatomic ,weak) IBOutlet    UILabel     *tradeContentLb_;
@property(nonatomic ,weak) IBOutlet    UIButton    *tradeBtn_;
@property(nonatomic ,weak) IBOutlet    UIView       *topView;
@property(nonatomic ,weak) IBOutlet UILabel *positionLb_;
@property(nonatomic ,weak) IBOutlet UIButton *positionBtn_;
@property(nonatomic ,assign)    BOOL searchDefaul;
@property(nonatomic ,weak) IBOutlet    UIButton    *searchBtn_;
@property(nonatomic ,strong)    SearchParam_DataModal     *searchModel_;
@end
