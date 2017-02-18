//
//  RegFirstCtl.h
//  jobClient
//
//  Created by 一览ios on 14/12/21.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

typedef enum
{
    ThirdLogin = 1, //第三方登录
    NormalRegist //正常注册
} FinishInfoType;

@interface RegInfoOneCtl : BaseEditInfoCtl

@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;

@property (weak, nonatomic) IBOutlet UILabel *userIconDescLb;

@property (weak, nonatomic) IBOutlet UIButton *sexManBtn;

@property (weak, nonatomic) IBOutlet UIButton *sexWomanBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameInputTF;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (assign, nonatomic) FinishInfoType type;

@property (weak, nonatomic) IBOutlet UIButton *protocalBtn;
@property (weak, nonatomic) IBOutlet UIView *protocalView;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (nonatomic,assign) BOOL isNeedBack;

@end
