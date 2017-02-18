//
//  XJHSchoolCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-4-24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListCtl.h"

@protocol schoolChangeDelegare <NSObject>

-(void)schoolId:(NSString *)schoolId andName:(NSString *)schoolName;

@end

@interface XJHSchoolCtl : BaseListCtl

@property (nonatomic,weak) id <schoolChangeDelegare> schoolChangeDelegate;

@property (nonatomic,strong) NSString *regionId;
@property (nonatomic,strong) NSString *currentSchool;
@property (weak, nonatomic) IBOutlet UITableView *tableVIewOne;

@end
