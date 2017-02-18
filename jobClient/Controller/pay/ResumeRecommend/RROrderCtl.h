//
//  OrderCtl.h
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "RRServiceInfo.h"
@class OrderService_DataModal;

@interface RROrderCtl : BaseEditInfoCtl

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLb;

@property (weak, nonatomic) IBOutlet UIButton *personTypeBtn;

@property (weak, nonatomic) IBOutlet UIButton *versionTypeBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLb;
 
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UILabel *tips1Lb;
@property (weak, nonatomic) IBOutlet UILabel *tips2Lb;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property(nonatomic, copy) NSString *serviceDetailId;

@property (assign, nonatomic) ResumeRecommendStatus applyStatus;

@property (strong, nonatomic) OrderService_DataModal *selectedService;

- (IBAction)personTypeBtnClick:(id)sender;

@end
