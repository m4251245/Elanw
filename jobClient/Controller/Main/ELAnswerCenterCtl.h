//
//  ELAnswerCenterCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/9/7.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"

@interface ELAnswerCenterCtl : BaseUIViewController

-(void)editorSuccessRefresh;

@property (nonatomic,copy) NSString *userId;
@property(nonatomic,assign) BOOL formPersonCenter;
@property(nonatomic,assign) BOOL showWaitAnswerList;

@end
