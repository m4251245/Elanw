//
//  ELStopJobCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/1/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"

typedef void(^stopJobRefreshBlock)();

@interface ELStopJobCtl : ELBaseListCtl

@property (nonatomic,copy) stopJobRefreshBlock stopBlock;

@end
