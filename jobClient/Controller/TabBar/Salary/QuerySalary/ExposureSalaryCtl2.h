//
//  ExposureSalaryCtl2.h
//  jobClient
//
//  Created by 一览ios on 15/5/18.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h" 

@interface ExposureSalaryCtl2 : BaseUIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *jobTF;
@property (weak, nonatomic) IBOutlet UITextField *salaryTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *companyview;
@property (weak, nonatomic) IBOutlet UIView *jobView;
@property (weak, nonatomic) IBOutlet UIView *salaryView;
@property (weak, nonatomic) IBOutlet UIView *cityView;


@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UIButton *noNamePublishBtn;//匿名发布

@property (weak, nonatomic) IBOutlet UIView *cotentView;//内容容器
@property (weak, nonatomic) IBOutlet UIImageView *edgeImgv;//底部边缘
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) UITextField *currentTF;

@property(nonatomic, copy) void (^finishBlock) (BOOL shouldRefresh);

@property(nonatomic, copy) NSString *exposureUserNum;//曝工资的用户

@property(nonatomic, copy) NSString *selectRegionId;//选择的地区ID

#pragma mark 点击消失
- (void)viewTaped:(UIGestureRecognizer *)sender;

@end
