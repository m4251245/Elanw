//
//  SysTemSetCtl.h
//  jobClient
//
//  Created by 一览ios on 15/7/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"


@interface SysTemSetCtl : BaseListCtl
{
    __weak IBOutlet UIButton *btnOutLogin;
    NSString *updateUrl_;
}


//在后台检测版本
-(void) checkVersionByHide;


@end
