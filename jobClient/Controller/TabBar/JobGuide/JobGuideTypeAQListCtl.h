//
//  JobGuideTypeAQListCtl.h
//  jobClient
//
//  Created by YL1001 on 15/8/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "RequestCon.h"
#import "CondictionListCtl.h"

@interface JobGuideTypeAQListCtl : BaseListCtl
{
    NSMutableArray *imageConArr_;/**< 用于加载图片 */
}

@property (nonatomic,assign) BOOL showTradeChange;
@property (nonatomic,strong) CondictionList_DataModal *tradeModel; 

@end
