//
//  RangeChooseCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-10-14.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "RangeDataMocel.h"

@protocol RangeChooseCtlDelegate <NSObject>

- (void)rangeChoose:(RangeDataMocel *)range_;

@end

@interface RangeChooseCtl : BaseListCtl
{
    NSMutableArray  *rangeArray_;
    id <RangeChooseCtlDelegate> delegate;
}

@property (nonatomic,assign) id<RangeChooseCtlDelegate> delegate_;

@end
