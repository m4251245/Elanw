//
//  ELBaseButton.m
//  jobClient
//
//  Created by 一览iOS on 2017/1/16.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELBaseButton.h"

@implementation ELBaseButton

+(nullable ELBaseButton *)getNewButtonWithFont:(nullable UIFont *)font title:(nullable NSString *)title textColor:(nullable UIColor *)textColor normalImageName:(nullable NSString *)normalImgName Target:(nullable id)target action:(nullable SEL)action frame:(CGRect)frame{
    ELBaseButton *button = [ELBaseButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (font) {
        button.titleLabel.font = font;
    }else{
        button.titleLabel.font = FIFTEENFONT_TITLE;
    }
    if (title && ![title isEqualToString:@""]) {
        [button setTitle:title forState:UIControlStateNormal]; 
    }
    if (normalImgName && ![normalImgName isEqualToString:@""]) {
        [button setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    }
    if (textColor) {
        [button setTitleColor:textColor forState:UIControlStateNormal]; 
    }
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
       // [target performSelector:action withObject:button];
    }
    return button;

}

+(nullable ELBaseButton *)getNewButtonWithFont:(nullable UIFont *)font title:(nullable NSString *)title textColor:(nullable UIColor *)textColor Target:(nullable id)target action:(nullable SEL)action frame:(CGRect)frame{
    ELBaseButton *button = [ELBaseButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (font) {
        button.titleLabel.font = font;
    }else{
        button.titleLabel.font = FIFTEENFONT_TITLE;
    }
    if (title && ![title isEqualToString:@""]) {
       [button setTitle:title forState:UIControlStateNormal]; 
    }
    if (textColor) {
       [button setTitleColor:textColor forState:UIControlStateNormal]; 
    }
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

+(nullable ELBaseButton *)getNewButtonWithNormalImageName:(nullable NSString *)normalImgName selectImgName:(nullable NSString *)selectImgName Target:(nullable id)target action:(nullable SEL)action frame:(CGRect)frame{
    ELBaseButton *button = [ELBaseButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (normalImgName && ![normalImgName isEqualToString:@""]) {
        [button setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
    }
    if (selectImgName && ![selectImgName isEqualToString:@""]) {
        [button setImage:[UIImage imageNamed:selectImgName] forState:UIControlStateSelected];    }
    
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

-(void)setLayerCornerRadius:(CGFloat)cornerRadius{
    if (cornerRadius <= 0) {
        return;
    }
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

-(void)setBorderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor{
    if (width <= 0 || !borderColor){
        return;
    }
    self.layer.borderWidth = width;
    self.layer.borderColor = borderColor.CGColor;
}

@end
