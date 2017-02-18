//
//  QRCodeGenerator+LogoView.m
//  二维码Logo_Demo
//
//  Created by netdev-mac02 on 14-7-14.
//  Copyright (c) 2014年 cjh. All rights reserved.
//

#import "QRCodeGenerator+LogoView.h"

@implementation QRCodeGenerator (LogoView)

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size LogoImage:(UIImage *)Logo
{
    
    UIImage * QRImage = [QRCodeGenerator qrImageForString:string imageSize:size];
//    CGImageRef midImage = QRImage.CGImage;
//    CGImageRef midLogo = Logo.CGImage;
//    UIGraphicsBeginImageContext(CGSizeMake(size, size));
//    CGContextRef ctx=UIGraphicsGetCurrentContext();
//    CGContextDrawImage(ctx, CGRectMake(0, 0, size, size), midImage);
//    CGContextDrawImage(ctx, CGRectMake(size/2-size/10, size/2-size/10, size/5, size/5), midLogo);
//    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIGraphicsBeginImageContext(CGSizeMake(size, size));
//    CGContextRef ctx1=UIGraphicsGetCurrentContext();
//    CGContextDrawImage(ctx1, CGRectMake(0, 0, size, size), img.CGImage);
//    UIImage *img1=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return QRImage;
}

@end
