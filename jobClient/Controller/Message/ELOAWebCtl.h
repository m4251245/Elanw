//
//  ELOAWebCtl.h
//  jobClient
//
//  Created by YL1001 on 16/5/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseWebViewCtl.h"

@interface ELOAWebCtl : BaseWebViewCtl

@property(nonatomic,copy)void (^myBlock)(BOOL isRefesh);

@property(nonatomic,assign)BOOL isPop;

@end
