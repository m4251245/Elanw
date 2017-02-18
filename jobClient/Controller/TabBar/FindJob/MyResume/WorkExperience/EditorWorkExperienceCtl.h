//
//  EditorWorkExperienceCtl.h
//  jobClient
//
//  Created by 一览ios on 15/3/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "PreCondictionListCtl.h"

@protocol EditorWorkExperienceDelegate <NSObject>

- (void)editorSuccess;

@end

@interface EditorWorkExperienceCtl : BaseEditInfoCtl<CondictionChooseDelegate>

@property (copy, nonatomic) void (^myBlock)();

@property (weak, nonatomic) IBOutlet UITextField *companyNameTf;
@property (weak, nonatomic) IBOutlet UIButton *secretBtn;
@property (weak, nonatomic) IBOutlet UITextField *positionNameTf;
@property (weak, nonatomic) IBOutlet UIView *WorkDescView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *memberCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyNatureBtn;
@property (weak, nonatomic) IBOutlet UITextField *salaryTextField;

@property(nonatomic, assign) id <EditorWorkExperienceDelegate> delegate;
@property(nonatomic, assign) NSInteger allCount;

@end
