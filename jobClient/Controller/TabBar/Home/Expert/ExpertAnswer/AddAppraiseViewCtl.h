//
//  AddAppraiseViewCtl.h
//  jobClient
//
//  Created by YL1001 on 15/8/13.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol buttonDelegate <NSObject>

- (void)setTextViewLayout;
- (void)btnResponeWitnIndex:(NSInteger)index;
- (void)hideView;

@end

@interface AddAppraiseViewCtl : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *lucencyView_;
@property (strong, nonatomic) IBOutlet UIView *bgView_;
@property (strong, nonatomic) IBOutlet UILabel *tipLb_;
@property (strong, nonatomic) IBOutlet UITextView *textView_;
@property (strong, nonatomic) IBOutlet UIButton *commitBtn_;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn_;
@property (strong, nonatomic) IBOutlet UIView *alertTipsView_;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewCenterY;


@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isSuccessCommit;

@property (nonatomic,weak) id<buttonDelegate> btnDelegate;

- (void)showViewCtl;
//- (void)hideView;
- (void)showTextOnly;

@end
