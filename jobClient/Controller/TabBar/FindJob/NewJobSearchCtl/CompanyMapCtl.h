//
//  CompanyMapCtl.h
//  jobClient
//
//  Created by YL1001 on 15/6/11.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import <MapKit/MapKit.h>

@protocol CompanyMapCtlDelegate <NSObject>

- (void)backSuccess;

@end

@interface CompanyMapCtl : BaseUIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    
    __weak IBOutlet MKMapView *mapView_;
    
    NSMutableArray                          *mapMarkerArr_;     //大头针数组
    MKCoordinateRegion                      currentRegion_;     //当前所在地
    MKCoordinateSpan                        currentSpan_;       //比例尺
    CLLocation                              *currentLocation_;  //当前所在地的位置座标
    CLLocationManager                       *cllocation_;
}

@property (nonatomic, assign) BOOL moveFlag;

@end
