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

//typedef void(^seletedblock)(ZWModel *model);

@interface PositonType : BaseUIViewController

@property (strong,nonatomic)   ZWModel *inzwmodel;    /**< */

@property (nonatomic,copy) void (^block)(ZWModel *model);

@property (strong,nonatomic)   NSString *type;    /**<默认职业类型  1 region */
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@end
