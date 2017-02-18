//
//  ELTextView.h
//  jobClient
//
//  Created by 一览ios on 16/12/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELTextView : UITextView<UITextViewDelegate>

//@property (nonatomic, strong) UILabel *placeholderLabel;

@property(nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIFont *placeFont;

@property (nonatomic, strong) UIColor *placeColor;

@end
