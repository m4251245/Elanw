//
//  ResetPwdCtl.h
//  Association
//
//  Created by 一览iOS on 14-2-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"


@interface ResetPwdCtl : BaseUIViewController<UITextFieldDelegate>
{
    RequestCon  * setCon_;
}

@property(nonatomic,weak)   IBOutlet    UIView          *contentView_;
@property(nonatomic,weak)   IBOutlet    UITextField     *oldPwdTf_;
@property(nonatomic,weak)   IBOutlet    UITextField     *pwdTf_;
@property(nonatomic,weak)   IBOutlet    UITextField     *rePwdTf_;
@property(nonatomic,weak)   IBOutlet    UIButton        *setBtn_;

//修改密码
-(void) setPwd;


@end
