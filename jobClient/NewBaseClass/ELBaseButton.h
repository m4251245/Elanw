//
//  ELBaseButton.h
//  jobClient
//
//  Created by 一览iOS on 2017/1/16.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELBaseButton : UIButton

@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,assign) BOOL isShow;

+(nullable ELBaseButton *)getNewButtonWithFont:(nullable UIFont *)font title:(nullable NSString *)title textColor:(nullable UIColor *)textColor normalImageName:(nullable NSString *)normalImgName Target:(nullable id)target action:(nullable SEL)action frame:(CGRect)frame;

+(nullable ELBaseButton *)getNewButtonWithFont:(nullable UIFont *)font title:(nullable NSString *)title textColor:(nullable UIColor *)textColor Target:(nullable id)target action:(nullable SEL)action frame:(CGRect)frame;

+(nullable ELBaseButton *)getNewButtonWithNormalImageName:(nullable NSString *)normalImgName selectImgName:(nullable NSString *)selectImgName Target:(nullable id)target action:(nullable SEL)action frame:(CGRect)frame;

-(void)setLayerCornerRadius:(CGFloat)cornerRadius;

-(void)setBorderWidth:(CGFloat)width borderColor:(nullable UIColor *)borderColor;

@end
