//
//  QRCodeGenerator+LogoView.h
//  二维码Logo_Demo
//
//  Created by netdev-mac02 on 14-7-14.
//  Copyright (c) 2014年 cjh. All rights reserved.
//

#import "QRCodeGenerator.h"

@interface QRCodeGenerator (LogoView)

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size LogoImage:(UIImage *)Logo;

@end
