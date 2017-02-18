//
//  CondictionPlaceCtl.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


/******************************
 
        地区列表选择模块
 
 ******************************/


#import <UIKit/UIKit.h>
#import "PreBaseUIViewController.h"
//#import "MapCtl.h"
#import "CondictionPlaceCtl_Sub.h"
#import "CondictionList_DataModal.h"
#import "CondictionList_Cell.h"
#import <MapKit/MapKit.h>

//#define CondictionPlaceCtl_Xib_Name             @"CondictionPlaceCtl"
//#define CondictionPlaceCtl_Title                @"选择地区"
//#define GPS_Place_Loading                       @"     正在获取您的当前位置..."
//#define Section_Title_1                         @"您当前所在城市"
//#define Section_Title_2                         @"热门城市"
//#define Section_Title_3                         @"按省选择"

@interface CondictionPlaceCtl : PreBaseUIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource> {
    IBOutlet    UITableView                     *tableView_;
    IBOutlet    UIActivityIndicatorView         *getCurrentPlaceIndicatorView_;
    
    NSString                                    *currentPlaceStr_;          //当前位置的str
    NSMutableArray                              *provinceArr_;              //省份arr
    NSMutableArray                              *hotRegionArr_;             //热门地区arr

    CondictionPlaceCtl_Sub                      *condictionPlaceCtlSub_;    //子集
    
    CLLocationManager                           *lm_;                       //用于获取当前位置座标
    CLGeocoder                           *reverseGeocoder_;          //用于反向解析(通过座标解析出地址)
    //MKPlacemark                                 *currentPlacemark_;
    
    BOOL                                        bLocation_;                 //是否能定位
    BOOL                                        bSubscribePlace_;           //是否是订阅时的地区选择
}
@property(nonatomic,assign) id<CondictionChooseDelegate>                delegate_;
@property(nonatomic,assign) BOOL                                        bSubscribePlace_;

//初始化数据
+(void) initData;

//从文件中反序列化数据(地区)
+(id) loadRegionDataFromFile;

//由regionStr获取regionId
+(NSString *) getRegionId:(NSString *)regionStr;

//获由regionPId
+(NSString *) getRegionPId:(NSString *)regionStr;

//由regionId获取regionStr
+(NSString *) getRegionStr:(NSString *)regionId;

//检查regionid是否是省份的id
+(BOOL) checkRegionIsProvice:(NSString *)regionId;

//检查regionid是否是省份中的id
+(BOOL) checkRegionIsSubProvice:(NSString *)regionId;

//根据regionId获取region的具体位置
+(NSString *) getRegionDetailAddress:(NSString *)regionId;

//由regionStr获取dataModal
+(CondictionList_DataModal *) getDataModalByStr:(NSString *)regionStr;

//检测是否是省份
+(BOOL) checkIsProvince:(NSString *)regionStr;

//更新当前位置
-(void) updateCurrentPlace;

//设置自己的数据
-(void) setData;

//开始获取当前位置
//-(void) updateCurrentPlace;

//设置自己有学校列表
-(void) initSchoolCtl;

//设置子集不需要popBack
-(void) setSubPopBack:(BOOL)flag;

+(NSString *) getRegionDetailAddressExcept:(NSString *)regionId;

@end
