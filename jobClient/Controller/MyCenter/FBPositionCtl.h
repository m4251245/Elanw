//
//  FBPositionCtl.h
//  jobClient
//
//  Created by 一览ios on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "CompanyInfo_DataModal.h"

typedef void(^seletedblock)();

@interface FBPositionCtl : BaseEditInfoCtl

@property (weak, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet UIButton *fbBtn;
@property (weak, nonatomic) IBOutlet UITextField *positionTf;
@property (weak, nonatomic) IBOutlet UIButton *fabuwangzBtn;
@property (weak, nonatomic) IBOutlet UIButton *bumenBtn;
@property (weak, nonatomic) IBOutlet UIButton *zwleixingBtn;
@property (weak, nonatomic) IBOutlet UIButton *workageBtn;
@property (weak, nonatomic) IBOutlet UIButton *salaryBtn;
@property (weak, nonatomic) IBOutlet UITextField *zprenshuTf;
@property (weak, nonatomic) IBOutlet UITextField *emailTf;
@property (weak, nonatomic) IBOutlet UIButton *workAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *xueliBtn;
@property (weak, nonatomic) IBOutlet UIButton *zwmiaoshuBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;

@property(nonatomic,strong) CompanyInfo_DataModal *companyDetailModal;

@property (nonatomic,assign) BOOL isEditorStatus;
@property (nonatomic,copy) seletedblock block;

@end
