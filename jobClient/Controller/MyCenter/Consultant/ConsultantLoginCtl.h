//
//  ConsultantLoginCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface ConsultantLoginCtl :BaseEditInfoCtl
{
    __weak IBOutlet UIImageView *bgImagev1;
    __weak IBOutlet UIImageView *bgImagev2;
    __weak IBOutlet UIImageView *topImagev;
    __weak IBOutlet UITextField *userNameTF;
    __weak IBOutlet UITextField *passwdTf;
    __weak IBOutlet UIButton *loginBtn;
    __weak IBOutlet UIButton *changLoginModelBtn;
    __weak IBOutlet UIButton    *backBtn;
}
@end
