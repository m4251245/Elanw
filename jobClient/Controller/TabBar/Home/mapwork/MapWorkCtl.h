//
//  MapWorkCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-10-6.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import <MapKit/MapKit.h>


@interface MapWorkCtl : BaseUIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate>
{
    __weak IBOutlet    MKMapView    *mapView_;        //基础地图
//    __weak IBOutlet    UIScrollView   *pagScrollView;
    NSMutableArray          *mapMarkerArr_;     //大头针数组
    NSMutableArray          *detailArray;
    NSMutableArray          *dataArray;
    RequestCon              *nearByWorkCon_;
    MKCoordinateRegion      currentRegion_;     //当前所在地
    MKCoordinateSpan        currentSpan_;       //比例尺
    BOOL                    bHaveGetCurrentLocation_;
    CLLocation              *currentLocation_;  //当前所在地的位置座标
    CLLocationManager       *cllocation_;
}

@property(nonatomic,assign)    BOOL    moveFlag;

@end
