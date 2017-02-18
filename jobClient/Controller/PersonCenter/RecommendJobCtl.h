//
//  RecommendJobCtl.h
//  jobClient
//
//  Created by 一览ios on 15/11/19.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"

typedef void(^FinishLoadBlock)(CGFloat height, BOOL isNoData);

@interface RecommendJobCtl : ELBaseListCtl

@property(nonatomic, copy) NSString *otherUserId;

@property(nonatomic, copy) FinishLoadBlock finishBlock;

@end
