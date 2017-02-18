//
//  CondictionPlaceCtl_School.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
    学校列表选择模块
 
 ******************************/

#import <UIKit/UIKit.h>
#import "PreBaseResultListCtl.h"
#import "CondictionList_DataModal.h"
#import "PreCondictionListCtl.h"

//#define CondictionPlaceCtl_School_Xib_Name          @"CondictionPlaceCtl_School"


@interface CondictionPlaceCtl_School : PreBaseResultListCtl {
    IBOutlet    UIButton                        *chooseBtn_;        //选择
    CondictionList_DataModal                    *dataModal_;        //被外界赋值    
    BOOL                                        bMutable_;          //是否可多选
    BOOL                                        bAttentionAtt_;     //是否显示有关注属性
}

@property(nonatomic,assign) id<CondictionChooseDelegate>                delegate_;
@property(nonatomic,assign) BOOL                                        bMutable_;
@property(nonatomic,assign) BOOL                                        bAttentionAtt_;

@end
