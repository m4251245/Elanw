//
//  SalaryCompareQueryListCtl.h
//  jobClient
//
//  Created by 一览ios on 15/3/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface SalaryCompareQueryListCtl : BaseListCtl
{
    NSString *is_free;
}
@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (weak, nonatomic) IBOutlet UIButton *goUseBtn;


@end
