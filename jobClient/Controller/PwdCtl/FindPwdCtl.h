//
//  FindPwdCtl.h
//  MBA
//
//  Created by sysweal on 13-12-21.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "CheckCodeCtl.h"

@interface FindPwdCtl : BaseUIViewController
{
    RequestCon      *findCon_;
    CheckCodeCtl    *checkCodeCtl_;
}

@property(nonatomic,weak)   IBOutlet    UITextField *emailTf_;
@property(nonatomic,weak)   IBOutlet    UIButton    *findBtn_;

//找回密码
-(void) findPwd;

@end
