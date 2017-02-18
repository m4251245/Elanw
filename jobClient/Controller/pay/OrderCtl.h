//
//  OrderCtl.h
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface OrderCtl : BaseEditInfoCtl

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLb;

@property (weak, nonatomic) IBOutlet UIButton *personTypeBtn;

@property (weak, nonatomic) IBOutlet UIButton *versionTypeBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLb;
 
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)personTypeBtnClick:(id)sender;

@end
