//
//  MapWorkCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-10-6.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "MapWorkCtl.h"
#import "CustomPointAnnotation.h"
#import "ZWDetail_DataModal.h"
#import "PositionDetailCtl.h"
#import <CoreLocation/CoreLocation.h>

#import "NearPositionDataModel.h"

#import "AdvertisementView.h"

//#define floatX 10
//static int floatX = 10;CardTapClickDelegate

@interface MapWorkCtl ()
{
    SearchParam_DataModal                   *inSearchModel_;
    AdvertisementView *cardView;
}

@end

@implementation MapWorkCtl
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        mapMarkerArr_ = [[NSMutableArray alloc] init];
        currentSpan_ = MKCoordinateSpanMake(2000, 2000);
        bHaveGetCurrentLocation_    = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavTitle:@"附近职位"];
    [self.view addSubview:mapView_];
    mapView_.delegate = self;
    mapView_.userLocation.title = @"您的当前位置";
    mapView_.showsUserLocation = YES;
    
    mapMarkerArr_ = [[NSMutableArray alloc]init];
    detailArray = [[NSMutableArray alloc]init];
    dataArray  = [[NSMutableArray alloc]init];
    
    cllocation_ = [[CLLocationManager alloc]init];
    cllocation_.desiredAccuracy = kCLLocationAccuracyBest;
    cllocation_.distanceFilter = 10;
    
    
    [self addNotify];
    [cllocation_ startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    cardView.hidden = NO;
    cllocation_.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    cardView.hidden = YES;
    [cllocation_ stopUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
  
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation_ = [locations lastObject];

    currentRegion_.center = currentLocation_.coordinate;
    currentRegion_.span = currentSpan_;
        if (IOS8) {
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentRegion_.center,currentRegion_.span.latitudeDelta, currentRegion_.span.longitudeDelta);
            MKCoordinateRegion adjustedRegion = [mapView_ regionThatFits:viewRegion];
            [mapView_ setRegion:adjustedRegion animated:NO];
        }else{
            CLLocationCoordinate2D coords = mapView_.userLocation.location.coordinate;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coords,currentRegion_.span.latitudeDelta, currentRegion_.span.longitudeDelta);
            MKCoordinateRegion adjustedRegion = [mapView_ regionThatFits:viewRegion];
            [mapView_ setRegion:adjustedRegion animated:NO];
        }
    
    //开始载入数据
    if (bHaveGetCurrentLocation_ == YES) {
        [self getMapData:currentLocation_];
    }
    [cllocation_ stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        if (IOS8)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在 “设置-隐私-定位服务” 中进行设置" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"去设置", nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在 “设置-隐私-定位服务” 中进行设置" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alertView show];
        }

    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        NSLog(@"error= %ld",(long)[error code]);
        [BaseUIViewController showAlertView:@"网络请求失败" msg:@"无法获取位置信息" btnTitle:@"确定"];
    }
}

#pragma mark--通知
-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notified:) name:@"RealAnnonation" object:nil];
}

-(void)notified:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    NSInteger idx = [dic[@"realNum"] integerValue];
    [mapView_ selectAnnotation:[mapMarkerArr_ objectAtIndex:idx] animated:YES];
}

#pragma mark--请求数据
-(void)getMapData:(CLLocation *)userLocation
{
    //请求数据
    NSString *lat = [NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
    if (!nearByWorkCon_) {
        nearByWorkCon_ = [self getNewRequestCon:NO];
    }
    
    NSInteger range = [inSearchModel_.rangStr_ integerValue];
    
    if (inSearchModel_.jobNum > 100) {
        [nearByWorkCon_ nearWorksWithLng:lng Lat:lat Range:range keWord:inSearchModel_.searchKeywords_ tradeId:inSearchModel_.tradeId_ page:nearByWorkCon_.pageInfo_.currentPage_ pageSize:inSearchModel_.jobNum geo_diff:1];
    }
    else
    {
        [nearByWorkCon_ nearWorksWithLng:lng Lat:lat Range:range keWord:inSearchModel_.searchKeywords_ tradeId:inSearchModel_.tradeId_ page:nearByWorkCon_.pageInfo_.currentPage_ pageSize:100 geo_diff:1];
    }
    
}

#pragma mark--加载数据
-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_nearWords:
        {
            dataArray = [dataArr mutableCopy];

            if ([dataArray count] == 0) {
                [BaseUIViewController showAlertView:nil msg:@"未搜索到相关职位" btnTitle:@"知道了"];
                return;
            }
            cardView = [[AdvertisementView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 105, ScreenWidth, 100)];
            cardView.imgArray = dataArray;
            [self.view addSubview:cardView];
            
            for (int i=0; i<[dataArray count]; i++) {
                NearPositionDataModel *model = [dataArr objectAtIndex:i];
                CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake([model.latnum doubleValue], [model.Longnum doubleValue]);
                annotation.title = model.cname;
                annotation.companyId_ = model.uid;
                annotation.companyName_ = model.cname;
                annotation.positionId = model.positionId;
                annotation.companyLogo = model.logopath;
                annotation.markTag = 1000+i;
                [mapMarkerArr_ addObject:annotation];
            }
            [mapView_ addAnnotations:mapMarkerArr_];

        }
            break;
        default:
            break;
    }
}


#pragma mark--代理
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark- MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if( annotation == mapView_.userLocation )
        return nil;
    static NSString *defaultPinID = @"com.invasivecode.pin";
    MKPinAnnotationView  *pinView = (MKPinAnnotationView *)[mapView_ dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ){
        pinView = [[MKPinAnnotationView alloc]
                   initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    
    CustomPointAnnotation *a = annotation;
//    pinView.animatesDrop    = YES;
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToRealAnnonationIdx" object:nil userInfo:@{@"toRealNum":@(index)}];
//    [pagScrollView setContentOffset:CGPointMake((self.view.frame.size.width-20)*index, 0) animated:YES];
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
    bHaveGetCurrentLocation_ = NO;
    ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
    dataModel.companyID_ = annotation.companyId_;
    dataModel.companyName_ = annotation.companyName_;
    dataModel.zwID_ = annotation.positionId;
    dataModel.companyLogo_ = annotation.companyLogo;
    PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
    if (inSearchModel_.searchKeywords_ ==nil || [[MyCommon removeSpaceAtSides:inSearchModel_.searchKeywords_] isEqualToString:@""]) {
        positionCtl.type_ = 2;   //企业详情
    }else{
        positionCtl.type_ = 1;  //职位详情
    }
    [self.navigationController pushViewController:positionCtl animated:YES];
    [positionCtl beginLoad:dataModel exParam:nil];
}

- (void)backBarBtnResponse:(id)sender
{
    cardView.hidden = YES;
    [super backBarBtnResponse:sender];
    cardView = nil;
    [cardView removeFromSuperview];
    bHaveGetCurrentLocation_ = YES;
    [cllocation_ stopUpdatingLocation];
    if (bHaveGetCurrentLocation_ == YES) {
        [mapView_ removeAnnotations:mapView_.annotations];
        [mapMarkerArr_ removeAllObjects];
        [cllocation_ stopUpdatingLocation];
        cllocation_.delegate = nil;
    }
    for (UIView *v in detailArray) {
        [v removeFromSuperview];
    }
    [detailArray removeAllObjects];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inSearchModel_ = dataModal;
}

-(void)dealloc{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    mapView_ = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
