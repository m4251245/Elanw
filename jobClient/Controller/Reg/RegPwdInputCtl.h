//
//  RegPwdInputCtl.h
//  jobClient
//
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface RegPwdInputCtl : BaseEditInfoCtl<UITextFieldDelegate>

@property (strong, nonatomic) User_DataModal *inDataModal;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;
- (IBAction)endOnExit:(id)sender;
- (IBAction)hasAccBtnClick:(id)sender;

@end
