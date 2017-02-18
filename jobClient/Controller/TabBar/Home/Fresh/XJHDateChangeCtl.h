//
//  XJHDateChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-4-24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListCtl.h"

@protocol  dataChangeDelegate <NSObject>

-(void)changeCurrentTimeType:(NSString *)timeName timeId:(NSString *)timeId;

@end

@interface XJHDateChangeCtl : BaseListCtl

@property (nonatomic,strong) NSString *currentTime;
@property (nonatomic,weak) id <dataChangeDelegate> timeDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOne;

@end
