//
//  ELBaseLabel.m
//  jobClient
//
//  Created by 一览iOS on 2017/1/17.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELBaseLabel.h"

@implementation ELBaseLabel

+(nullable ELBaseLabel *)getNewLabelWithFont:(nullable UIFont *)font title:(nullable NSString *)title textColor:(nullable UIColor *)textColor Target:(nullable id)target action:(nullable SEL)action frame:(CGRect)frame{
    ELBaseLabel *label = [[ELBaseLabel alloc] init];
    label.frame = frame;
    if (font) {
        label.font = font;
    }else{
        label.font = FIFTEENFONT_TITLE;
    }
    if (title && ![title isEqualToString:@""]) {
        label.text = title; 
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (target && action){
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    }
    return label;
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
