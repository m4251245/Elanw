//
//  RegSmsCodeInputCtl.h
//  jobClient
//
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
@class User_DataModal;

@interface RegSmsCodeInputCtl : BaseEditInfoCtl

@property (nonatomic, strong) User_DataModal *inDataModal;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;

@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *noCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property(nonatomic, assign)BOOL isThirdBanderPhoneNum;

- (IBAction)hasAccBtnClick:(id)sender;

@end
