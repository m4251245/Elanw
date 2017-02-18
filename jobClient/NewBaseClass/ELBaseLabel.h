//
//  ELBaseLabel.h
//  jobClient
//
//  Created by 一览iOS on 2017/1/17.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELBaseLabel : UILabel

+(nullable ELBaseLabel *)getNewLabelWithFont:(nullable UIFont *)font title:(nullable NSString *)title textColor:(nullable UIColor *)textColor Target:(nullable id)target action:(nullable SEL)action frame:(CGRect)frame;

-(void)setLayerCornerRadius:(CGFloat)cornerRadius;

-(void)setBorderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor;

@end
