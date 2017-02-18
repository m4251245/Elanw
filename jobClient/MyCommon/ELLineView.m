//
//  ELLineView.m
//  jobClient
//
//  Created by 一览iOS on 16/8/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELLineView.h"

@interface ELLineView()
{
    UIColor *_lineColor;
}

@end

@implementation ELLineView

-(instancetype)initWithFrame:(CGRect)frame WithColor:(UIColor *)lineColor{
    self = [super init];
    if (self) {
        self.frame = frame;
        if (lineColor) {
             _lineColor = lineColor;
        }else{
            _lineColor = UIColorFromRGB(0xe0e0e0);
        }
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    //指定矩形
    CGRect rectangle = CGRectMake(0.0f, 0.0f,rect.size.width,
                                  rect.size.height);
    //将矩形添加到路径中
    CGPathAddRect(path,NULL,
                  rectangle);
    //获取上下文
    CGContextRef currentContext =
    UIGraphicsGetCurrentContext();
    
    //将路径添加到上下文
    CGContextAddPath(currentContext, path);
    
    //设置矩形填充色
    [_lineColor setFill];
    
    //矩形边框颜色
    [_lineColor setStroke];
    
    //边框宽度
    CGContextSetLineWidth(currentContext,0);
    
    //绘制
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    CGPathRelease(path);
    
    /*
    
    CGFloat width = rect.size.width < rect.size.height ? rect.size.width:rect.size.height;
    
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    //指定直线样式
    
    CGContextSetLineCap(context,
                        kCGLineCapSquare);
    
    //直线宽度
    
    CGContextSetLineWidth(context,
                          width);
    
    //设置颜色
    [_lineColor setStroke];
    
//    //CGContextSetRGBStrokeColor(context,
//                               224/255.0, 224/255.0, 224/255.0, 1.0);
    
    //开始绘制
    
    CGContextBeginPath(context);
    
    //画笔移动到点(31,170)
    
    CGContextMoveToPoint(context,
                         0,0);
    //下一点
    
    CGContextAddLineToPoint(context,
                            CGRectGetMaxX(rect),CGRectGetMaxY(rect));
    //绘制完成
    CGContextStrokePath(context);
     */
}

@end
