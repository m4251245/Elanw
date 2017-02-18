//
//  LookHistoryCtl.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
        最近浏览历史
 
 ******************************/

#import <UIKit/UIKit.h>
#import "PreBaseResultListCtl.h"
#import "Xjh_DataModal.h"
#import "Zph_DataModal.h"
#import "Xjh_ZphDetailCtl.h"

//#define LookHistoryCtl_Xib_Name             @"LookHistoryCtl"
//#define LookHistoryCtl_Title                @"最近浏览历史"
//#define LookHistoryCtl_NoDataText           @"暂无数据"
//#define LookHistoryCtl_PageSize             25

@interface LookHistoryCtl : PreBaseResultListCtl {
    
    Xjh_ZphDetailCtl    *detailCtl_;
    
    BOOL    bHaveNewSubscribe_;     //是否新增了订阅
    BOOL    bShowReadImage_;        //是否显示已查看的历史图标
}

@property(nonatomic,assign) BOOL    bHaveNewSubscribe_;

@end
