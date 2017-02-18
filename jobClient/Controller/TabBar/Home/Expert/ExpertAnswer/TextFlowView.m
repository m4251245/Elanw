//
//  TextFlowView.m
//  Paoma
//
//  Created by wu wxj on 11-9-7.
//  Copyright 2011年 tt. All rights reserved.
//

#import "TextFlowView.h"
#import "NSString+Size.h"

@implementation TextFlowView

#pragma mark -
#pragma mark 内部调用

#define SPACE_WIDTH 50
#define LABEL_NUM 2

//改变一个TRect的起始点位置，但是其终止店点的位置不变，因此会导致整个框架大小的变化
- (CGRect)moveNewPoint:(CGPoint)point rect:(CGRect)rect
{
    CGSize tmpSize;
    tmpSize.height = rect.size.height + (rect.origin.y - point.y);
    tmpSize.width = rect.size.width + (rect.origin.x - point.x);
    return CGRectMake(point.x, point.y, tmpSize.width, tmpSize.height);
}
//开启定时器
- (void)startRun
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

//关闭定时器
- (void)cancelRun
{
    if (_timer)
    {
        [_timer invalidate];
    }
}

//定时器执行的操作
- (void)timerAction
{
    static CGFloat offsetOnce = -1;
    _XOffset += offsetOnce;
    if (_XOffset +  _textSize.width <= 0)
    {
        _XOffset += _textSize.width;
        _XOffset += SPACE_WIDTH;
    }
    [self setNeedsDisplay];
    
}

//计算在给定字体下，文本仅显示一行需要的框架大小
- (CGSize)computeTextSize:(NSString *)text
{
    if (text == nil)
    {
        return CGSizeMake(0, 0);
    }
    CGSize boundSize = CGSizeMake(MAXFLOAT, 16);
    CGSize stringSize = [_text sizeNewWithFont:_font constrainedToSize:boundSize lineBreakMode:NSLineBreakByWordWrapping];
    return stringSize;
}


- (id)initWithFrame:(CGRect)frame Text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _text = text;
        _frame = frame;
        //默认的字体大小
        _font = [UIFont systemFontOfSize:16.0f];
        self.backgroundColor = [UIColor clearColor];
        //初始化标签
        //判断是否需要滚动效果
        _textSize = [self computeTextSize:text];
        //需要滚动效果
        if (_textSize.width > frame.size.width)
        {
            _needFlow = YES;
            [self startRun];
        }
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, _color.CGColor);
    // Drawing code
    CGFloat startYOffset = (rect.size.height - _textSize.height)/2;
    CGPoint origin = rect.origin;
    if (_needFlow == YES)
    {
        rect = [self moveNewPoint:CGPointMake(_XOffset, startYOffset) rect:rect];
        while (rect.origin.x <= rect.size.width+rect.origin.x)
        {
            [_text drawInRect:rect withAttributes:@{NSForegroundColorAttributeName:_color,NSFontAttributeName:_font}];
            //[_text drawInRect:rect withFont:_font];
            rect = [self moveNewPoint:CGPointMake(rect.origin.x+_textSize.width+SPACE_WIDTH, rect.origin.y) rect:rect];
        }
        
    }
    else
    {
        //在控件的中间绘制文本
        origin.x = (rect.size.width - _textSize.width)/2;
        origin.y = (rect.size.height - _textSize.height)/2;
        rect.origin = origin;
        [_text drawInRect:rect withAttributes:@{NSForegroundColorAttributeName:_color,NSFontAttributeName:_font}];
        //[_text drawInRect:rect withFont:_font];
    }
}


#pragma mark -
#pragma mark 外部调用
- (void)setFont:(UIFont *)font
{
    _font = font;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
}

- (void)setColor:(UIColor *)color
{
    _color = color;
}

@end
