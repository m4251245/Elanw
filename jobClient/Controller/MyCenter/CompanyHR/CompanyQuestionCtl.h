//
//  CompanyQuestionCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "Answer_DataModal.h"
#import "SubmitAnswerCtl.h"

@protocol CompanyQuestionCtlDelegate <NSObject>

-(void)submitAnswerOK;

@end

@interface CompanyQuestionCtl : BaseListCtl<SubmitAnswerCtlDelegate>

@property(nonatomic,assign) id<CompanyQuestionCtlDelegate> delegate_;

@end
