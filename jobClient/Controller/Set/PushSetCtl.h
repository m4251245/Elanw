//
//  PushSetCtl.h
//  Association
//
//  Created by 一览iOS on 14-5-10.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PushCustomCell.h"
#import "DBTools.h"
#import "ExRequetCon.h"

@interface PushSetCtl : BaseUIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView        *pushTableView_;
    IBOutlet UISwitch           *pushSwitch_;
    IBOutlet UIView             *topView_;
    NSMutableArray              *pushNameArray_;
    DBTools                     *db_;
    NSMutableArray              *dateArr_;
    NSInteger                         setCount_;
    NSInteger                         cellSwitchTag_;
    NSMutableArray              *conArray_;
    BOOL                        totalFlag_;
}

@end
