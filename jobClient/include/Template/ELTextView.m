//
//  ELTextView.m
//  jobClient
//
//  Created by 一览ios on 16/12/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELTextView.h"

@implementation ELTextView

- (void)setPlaceholder:(NSString *)placeholder
{
    UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 17)];
    placeholderLabel.tag = 1000;
    placeholderLabel.text = placeholder;
    
    if (_placeFont) {
        placeholderLabel.font = _placeFont;
    }else{
        placeholderLabel.font = [UIFont systemFontOfSize:16];
    }
    
    if (_placeColor) {
        placeholderLabel.textColor = _placeColor;
    }else{
        placeholderLabel.textColor = UIColorFromRGB(0xbdbdbd);
    }
    
    [self addSubview:placeholderLabel];
    self.delegate = self;
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    
//    [textView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        textView.subviews[idx].hidden = YES;
//    }];
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if (textView.text.length <= 0) {
//        
//        [textView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            textView.subviews[idx].hidden = NO;
//        }];
//    }else
//    {
//        [textView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            textView.subviews[idx].hidden = YES;
//        }];
//        
//    }
//    
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
