//
//  ELPositionAddEmailCtl.h
//  jobClient
//
//  Created by 一览ios on 16/11/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

typedef void(^seletedblock)();

@interface ELPositionAddEmailCtl : BaseEditInfoCtl

@property (nonatomic,copy) seletedblock block;
//@property(nonatomic, copy) NSString *email;
@property (strong,nonatomic)   ZWModel *inzwmodel;    /**< */
@end
