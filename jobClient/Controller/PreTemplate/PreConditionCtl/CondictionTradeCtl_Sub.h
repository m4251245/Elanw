//
//  CondictionTradeCtl_Sub.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
 行业列表选择模块(子列表)
 
 ******************************/

#import <UIKit/UIKit.h>
#import "PreBaseUIViewController.h"
#import "PreCondictionListCtl.h"

//#define CondictionTradeCtl_Sub_Xib                @"CondictionTradeCtl_Sub"

@interface CondictionTradeCtl_Sub : PreBaseUIViewController<UITableViewDelegate,UITableViewDataSource> {
    IBOutlet    UITableView                     *tableView_;
    
    NSMutableArray                              *dataArr_;
}

@property(nonatomic,assign) id<CondictionChooseDelegate>                delegate_;

//设置数据
-(void) setData:(NSArray *)dataArr;

@end
