//
//  DataSelectedCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-9-2.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@protocol DataSelectedCtlDelegate <NSObject>

@optional
- (void)sendDataSelected:(NSMutableArray *)timeArray;

@end

@interface DataSelectedCtl : BaseListCtl
{
    NSArray *dataArray_;
    NSArray *dataValueArray_;
    id <DataSelectedCtlDelegate> delegate_;
}
@property(nonatomic,strong)    id <DataSelectedCtlDelegate> delegate_;

@end
