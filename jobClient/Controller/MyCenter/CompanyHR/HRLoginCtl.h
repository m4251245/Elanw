//
//  HRLoginCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-4.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "CompanyLogin_DataModal.h"
#import "BaseWebViewCtl.h"

@interface HRLoginCtl : BaseEditInfoCtl
{

    RequestCon            *  loginCon_;
    RequestCon            *  bindcon_;

}

@end
