//
//  BindCtl.h
//  jobClient
//
//  Created by 一览ios on 15/12/21.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "RegCustomTextField.h"
#import "CodeInputCtl.h"

@interface BindCtl : BaseEditInfoCtl


@property (nonatomic, strong) User_DataModal *inDataModal;
@property (nonatomic, assign) VarifyType varifyType;
@property (weak, nonatomic) IBOutlet UILabel *summaryLb;
@property (weak, nonatomic) IBOutlet RegCustomTextField *emailOrPhoneTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *email;

@end
