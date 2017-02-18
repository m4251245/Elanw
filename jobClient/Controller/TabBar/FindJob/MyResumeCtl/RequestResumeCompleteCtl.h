//
//  RequestResumeCompleteCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-11-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "ResumeCompleteModel.h"

@protocol RequestResumeCompleteCtlDelegate <NSObject>

- (void)GetCompleteSuccess:(ResumeCompleteModel *)model;

@end
@interface RequestResumeCompleteCtl : BaseUIViewController

@property(nonatomic,assign) id<RequestResumeCompleteCtlDelegate> delegate;

@end
