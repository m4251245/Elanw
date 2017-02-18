//
//  CondictionPlaceCtl_2.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
        地区列表选择模块
            (第二层)
 ******************************/

#import <UIKit/UIKit.h>
#import "PreBaseUIViewController.h"
#import "CondictionPlaceCtl_School.h"
#import "CondictionList_DataModal.h"

//#define CondictionPlaceCtl_Sub_Xib_Name               @"CondictionPlaceCtl_Sub"


@interface CondictionPlaceCtl_Sub : PreBaseUIViewController<UITableViewDelegate,UITableViewDataSource> {
    IBOutlet    UITableView                         *tableView_;
    
    
    NSMutableArray                                  *arr_;          //结果集
    
    CondictionPlaceCtl_School                       *schoolCtl_;    //学校列表
    
    BOOL                                            bNeedPopBack_;  //是否需要popBack
}
@property(nonatomic,assign) id<CondictionChooseDelegate>                delegate_;
@property(nonatomic,retain) CondictionPlaceCtl_School                   *schoolCtl_; 
@property(nonatomic,assign) BOOL                                        bNeedPopBack_;

//设置数据
-(void) setData:(NSArray *)dataArr;

//设置学校ctl
-(void) initSchoolCtl;

//释放学校ctl
-(void) releaseSchoolCtl;

//获取学校列表
-(void) getSchoolList:(CondictionList_DataModal *)dataModal;

@end
