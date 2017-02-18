//
//  ELNewOfferListCtl.h
//  jobClient
//
//  Created by YL1001 on 16/10/27.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"

@interface ELNewOfferListCtl : ELBaseListCtl

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isCanLoad;
@property (nonatomic, assign) NSInteger selectTableTag;

@end
