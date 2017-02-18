//
//  RegionListCtl.h
//  Association
//
//  Created by 一览iOS on 14-3-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "CondictionListCtl.h"
#import "RegionConditionListCtl.h"

@class RegionCtl;
@protocol ChooseHotCityDelegate <NSObject>

-(void)chooseHotCity:(RegionCtl*)ctl  city:(NSString*)city;

@end

@interface RegionCtl : BaseListCtl<CondictionListDelegate>
{
    
    IBOutlet    UIActivityIndicatorView         *getCurrentPlaceIndicatorView_;
    IBOutlet    UIButton                        *jumpBtn_;
    IBOutlet    UIButton                        *chooseLocationBtn_;
    IBOutlet    UIButton                        *locationBtn_;
    IBOutlet    UILabel                         *cityLb_;
    
    NSString                                    *currentPlaceStr_;          //当前位置的str
    
    NSMutableArray                              *hotRegionArr_;             //热门地区arr
    
    BOOL                                        bLocation_;                 //是否能定位
    
    RegionConditionListCtl                      *regionListCtl_;
    
}

@property(nonatomic,assign) id<ChooseHotCityDelegate> delegate_;
@end
