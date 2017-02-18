//
//  TLoginTradeInputCtl.h
//  jobClient
//
//  Created by 一览ios on 15/1/6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
@class User_DataModal;

@interface TLoginTradeInputCtl : BaseEditInfoCtl

@property (nonatomic, strong) User_DataModal *inDataModal;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *tradeErrorLb;

@property (weak, nonatomic) IBOutlet UITextField *tradeTF;

@property (weak, nonatomic) IBOutlet UITextField *jobTF;
- (IBAction)jobTF_EndOnExit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tradeBtn;

@end
