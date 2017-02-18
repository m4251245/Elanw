//
//  AddAppraiseView.h
//  jobClient
//
//  Created by YL1001 on 15/8/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAppraiseView : UIView<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *tipLb_;

@property (strong, nonatomic) IBOutlet UITextView *textView_;
@property (strong, nonatomic) IBOutlet UIButton *commitBtn_;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn_;






@end
