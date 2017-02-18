//
//  BindCtl.h
//  jobClient
//
//  Created by 一览ios on 15/12/21.
//  Copyright © 2015年 YL1001. All rights reserved.
//


#import "BaseEditInfoCtl.h"
#import "RegCustomTextField.h"
#import "AccSetPwdCtl.h"

@interface CodeInputCtl : BaseEditInfoCtl

@property (nonatomic, assign)VarifyType varifyType;

@property (weak, nonatomic) IBOutlet UILabel *summaryLb;

@property (weak, nonatomic) IBOutlet RegCustomTextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;

@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *email;

@property (nonatomic, strong) User_DataModal *inDataModal;

@end
