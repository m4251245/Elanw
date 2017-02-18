//
//  RegionConditionListCtl.h
//  jobClient
//
//  Created by YL1001 on 14-8-20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CondictionListCtl.h"

//如果不再24字母中,则用FirstChar_Ex来代替
#define FirstChar_Ex        @"#"

@interface RegionConditionListCtl : CondictionListCtl
{
    NSMutableArray                      *charArr_;
    NSMutableArray                      *sectionArr_;
}

@end
