//
//  MJPhoto.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhoto.h"

@implementation MJPhoto

#pragma mark 截图
- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView
{
    _srcImageView = srcImageView;
    _placeholder = [self getPlaceholderImage:srcImageView.image];
    if (srcImageView.clipsToBounds) {
        _capture = [self capture:srcImageView];
    }
}

-(UIImage *) getPlaceholderImage:(UIImage *)image{
    UIImage *bottomImage =[UIImage imageNamed:@""];
    //UIImage*image =[UIImage imageNamed:@"top.png"];
    //UIImage *image = [UIImage imageNamed:@"bg_Photo_album2.png"];
    
    CGSize newSize =CGSizeMake([[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.height - 20));
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Apply supplied opacity
    [image drawInRect:CGRectMake((newSize.width-80)/2.0,(newSize.height-80)/2.0,80,80) blendMode:kCGBlendModeNormal alpha:0.8];
    
    UIImage*newImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end