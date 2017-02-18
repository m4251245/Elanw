//
//  RegFirstCtl.h
//  jobClient
//
//  Created by 一览ios on 14/12/21.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "RegInfoThreeCtl.h"

@interface RegInfoTwoCtl : BaseEditInfoCtl< SelectTradeCtlDelegate>

//职场达人
@property (weak, nonatomic) IBOutlet UIButton *talentBtn;
//应届生
@property (weak, nonatomic) IBOutlet UIButton *graduateBtn;

//@property (weak, nonatomic) IBOutlet UITextField *trade_hangye;//行业

@property (weak, nonatomic) IBOutlet UITextField *tradeTF;//职业

@property (weak, nonatomic) IBOutlet UITextField *schoolTF;

@property (weak, nonatomic) IBOutlet UITextField *majorTF;

@property (weak, nonatomic) IBOutlet UIView *talentView;

@property (weak, nonatomic) IBOutlet UIView *graduateView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn1;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn2;

@property (assign, nonatomic)BOOL type;

@end
