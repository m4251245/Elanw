//
//  CompanyMapCtl.m
//  jobClient
//
//  Created by YL1001 on 15/6/11.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CompanyMapCtl.h"
#import "ZWDetail_DataModal.h"
#import "CustomPointAnnotation.h"
#import "PositionDetailCtl.h"

@interface CompanyMapCtl ()
{
    ZWDetail_DataModal *zwDetailModal;
}

@end

@implementation CompanyMapCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        mapMarkerArr_ = [[NSMutableArray alloc] init];
        currentSpan_ = MKCoordinateSpanMake(2000, 2000);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"公司位置";
    [self setNavTitle:@"公司位置"];
    [self.view addSubview:mapView_];
    mapView_.delegate = self;
    mapView_.userLocation.title = @"当前公司位置";
    mapView_.showsUserLocation = YES;
    mapMarkerArr_ = [[NSMutableArray alloc] init];
    
    cllocation_ = [[CLLocationManager alloc] init];
    cllocation_.desiredAccuracy = kCLLocationAccuracyBest;
    cllocation_.distanceFilter = 10;
    if (IOS8)
    {
        [cllocation_ requestWhenInUseAuthorization];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    cllocation_.delegate = self;
    [cllocation_ startUpdatingLocation];
//    self.navigationItem.title = @"公司位置";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [cllocation_ stopUpdatingLocation];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    zwDetailModal = dataModal;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    currentLocation_ = [[CLLocation alloc] initWithLatitude:[zwDetailModal.latNum doubleValue] longitude:[zwDetailModal.longnum doubleValue]];
    
    CLLocationCoordinate2D coord = [currentLocation_ coordinate];
    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [mapView_ setRegion:region animated:NO];
    
    CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake([zwDetailModal.latNum doubleValue], [zwDetailModal.longnum doubleValue]);
    [mapMarkerArr_ addObject:annotation];
    [mapView_ addAnnotations:mapMarkerArr_];
    
    
    [cllocation_ stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        [BaseUIViewController showAlertView:@"请打开定位服务" msg:@"请在手机系统的“隐私”->“定位服务”中启动定位服务" btnTitle:@"确定"];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        NSLog(@"error= %ld",(long)[error code]);
        [BaseUIViewController showAlertView:@"网络请求失败" msg:@"无法获取位置信息" btnTitle:@"确定"];
    }
}



#pragma mark- MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if( annotation == mapView_.userLocation )
        return nil;
    MKPinAnnotationView  *pinView = nil;
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[mapView_ dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                     initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    CustomPointAnnotation *a = annotation;
    pinView.animatesDrop    = YES;
    pinView.canShowCallout  = YES;
    [pinView setTag:a.markTag];
    pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [pinView setSelected:YES animated:NO];
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (view.tag == 0) {
        return;
    }
    NSInteger index = view.tag-1000;
    MKPinAnnotationView *v = (MKPinAnnotationView *)view;
    v.pinColor = MKPinAnnotationColorGreen;
    MKPointAnnotation *anno = [mapMarkerArr_ objectAtIndex:index];
    [mapView_ setCenterCoordinate:anno.coordinate animated:YES];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (view.tag == 0) {
        return;
    }
    MKPinAnnotationView *v = (MKPinAnnotationView *)view;
    v.pinColor = MKPinAnnotationColorRed;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MKPinAnnotationView  *pinView = (MKPinAnnotationView*)view;
    CustomPointAnnotation *annotation = pinView.annotation;
    ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
    dataModel.companyID_ = annotation.companyId_;
    dataModel.companyName_ = annotation.companyName_;
    dataModel.zwID_ = annotation.positionId;
    dataModel.companyLogo_ = annotation.companyLogo;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
