//
//  MyAccessoryList.h
//  jobClient
//
//  Created by 一览ios on 15/8/14.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

typedef void(^returnTypeblock)(BOOL flag);

@interface MyAccessoryList : BaseListCtl

- (void)startEditor;
- (void)stopEditro;
@property(nonatomic,copy) returnTypeblock block;

@end
