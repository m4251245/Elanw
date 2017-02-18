//
//  ELJobTypeChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/5/30.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TradeZWModel.h"

typedef void(^jobChageBlock)(TradeZWModel *model);

@interface ELJobTypeChangeCtl : BaseUIViewController

@property(nonatomic,assign) NSInteger type;
@property(nonatomic,copy) NSString *jobId;
@property(nonatomic,copy) jobChageBlock block;

@end
