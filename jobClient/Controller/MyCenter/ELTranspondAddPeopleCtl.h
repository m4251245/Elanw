//
//  ELTranspondAddPeopleCtl.h
//  jobClient
//
//  Created by 一览iOS on 2017/1/19.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"

typedef void (^ConfirmBlcok)(void);

@interface ELTranspondAddPeopleCtl : BaseUIViewController

@property (nonatomic,strong) NSMutableArray *dataArr_;
@property (nonatomic,copy) ConfirmBlcok block;

@end
