//
//  ProfessionView.h
//  jobClient
//
//  Created by 一览ios on 15/4/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class personTagModel;

@interface ProfessionView : UIView

@property (strong, nonatomic) NSArray *tagArray;

@property(nonatomic, copy) void (^professionBtnBlock)(personTagModel *tagModel);

@end
