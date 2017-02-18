//
//  ELEvaluationResumeCtl.h
//  jobClient
//
//  Created by YL1001 on 16/8/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@protocol evaluationDelegate <NSObject>

- (void)refreshResume;

@end
/**
 评价简历（企业后台）
 */
@interface ELEvaluationResumeCtl : BaseEditInfoCtl

@property (nonatomic, strong) User_DataModal *userModel;
@property (nonatomic, copy) NSString *companyId;

@property (nonatomic, assign) id<evaluationDelegate> delegate;

@end
