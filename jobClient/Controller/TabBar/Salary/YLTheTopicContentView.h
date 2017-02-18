//
//  YLTheTopicContentView.h
//  jobClient
//
//  Created by 一览iOS on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLTheTopicContentView : UIView

@property(strong,nonatomic)UIView *backView;
@property(strong,nonatomic)UILabel *contentLb;
@property(strong,nonatomic)UILabel *percentageLb;
@property(assign,nonatomic)CGFloat percentageF;

-(void)showView:(CGFloat)percentage;
-(void)hideView;

@end
