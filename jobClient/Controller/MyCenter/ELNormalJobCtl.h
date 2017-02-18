//
//  ELNormalJobCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/1/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"

typedef void(^startJobRefreshBlock)();

@interface ELNormalJobCtl : ELBaseListCtl

@property(nonatomic,copy) startJobRefreshBlock startBlock;

@end
