//
//  SalaryListFrame.h
//  jobClient
//
//  Created by 一览ios on 15/4/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ELSalaryModel;

#define kContentWidth 270
#define kMarginTop 30
#define kJingHuaMarginBottom 10
#define kToolBarHeight 25
#define kToolBarMarginTop 20

#define kToolBarMarginBottom 25

@interface SalaryListFrame : NSObject

@property (strong, nonatomic) ELSalaryModel *articleModel;

@property (assign, nonatomic) CGRect jingHuaLbFrame;

@property (assign, nonatomic) CGRect contentLbFrame;

@property (assign, nonatomic) CGRect toolBarFrame;

@property (assign, nonatomic) CGRect lineFrame;

@property (assign, nonatomic) CGFloat height;

@end
