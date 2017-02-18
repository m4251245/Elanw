//
//  PositonType.h
//  jobClient
//
//  Created by 一览ios on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "FMDatabase.h"
#import "ZWModel.h"

typedef void(^seletedRegionBlock)(NSString *regionName,NSString *regionId,BOOL selectHotCity);

@interface FBRegionCtl : BaseUIViewController

@property (strong,nonatomic)   ZWModel *inzwmodel;    /**< */

@property (nonatomic,copy) seletedRegionBlock block;

@property (strong,nonatomic)   NSString *type;    /**<默认职业类型  1 region  2没有push返回*/
@property(nonatomic, strong) UITableView *tableView1;
@property(nonatomic, strong) UITableView *tableView2;

@property(nonatomic,assign) BOOL showQuanGuo;

@property(nonatomic,copy) NSString *selectName;
@property(nonatomic,copy) NSString *selectId;

@property(nonatomic,assign) BOOL selectHotCity;//是否是从热门城市里选择
@property(nonatomic,assign) BOOL showLocation;//是否显示定位

@property(nonatomic,assign) BOOL isShowLocation;//是否显示初始定位

@property(nonatomic,assign) BOOL isModify;

@end

@interface ELRegionCtl : FBRegionCtl

@end
