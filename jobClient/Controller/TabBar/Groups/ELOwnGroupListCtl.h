//
//  ELOwnGroupListCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/7/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"

@interface ELOwnGroupListCtl : ELBaseListCtl

@property (nonatomic,assign) BOOL finishRefresh;

-(void)refreshLoad:(RequestCon *)con;

//用于点击状态栏和双击底部导航
-(void)tableViewContentSizeZero;

@end
