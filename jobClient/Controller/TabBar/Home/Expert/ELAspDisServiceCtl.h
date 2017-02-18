//
//  ELAspDisServiceCtl.h
//  jobClient
//
//  Created by YL1001 on 15/9/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "Order.h"

@interface ELAspDisServiceCtl : BaseEditInfoCtl
{
    
    IBOutlet UIView *serviceBgView;
    
    IBOutlet UIView *bgView;
    IBOutlet UIView *personInfoBgView;
    IBOutlet UITextField *phoneNum;
    IBOutlet UITextView *questionTV;
    IBOutlet UILabel *tipsLb1;
    
    IBOutlet UITextView *personInfoTV;
    IBOutlet UILabel *tipsLb2;
    
    IBOutlet UIButton *agreeBtn;
    IBOutlet UIButton *rulesBtn;
    IBOutlet UIButton *discussBtn;
    
    IBOutlet UIView *alertView;
    IBOutlet UILabel *costMoneyLb;
    IBOutlet UILabel *orderNumLb;
    IBOutlet UILabel *serContentLb;
    IBOutlet UIButton *cancelBtn;
    IBOutlet UIButton *sureBtn;
    
    Order *_payOrder;
}

@property (nonatomic,assign) BOOL isShowCourse;

@end
