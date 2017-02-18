//
//  RegPhoneInputCtl.h
//  jobClient
//绑定手机号
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

typedef NS_ENUM(NSInteger, VarifyType) {
    VarifyTypeBindEmail, //绑定邮箱
    VarifyTypeUpdateEmail, //修改邮箱
    VarifyTypeBindPhone, //绑定手机
    VarifyTypeUpdatePhone, //修改手机
    VarifyTypeUpdatePwdVarifyEmail, //修改密码通过验证邮箱
    VarifyTypeUpdatePwdVarifyPhone, //修改密码通过验证手机
    VarifyTypeThirdLogin //第三方登录
};

@interface AccSetPwdCtl : BaseEditInfoCtl

@property (nonatomic, assign) VarifyType varifyType;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *email;

@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
