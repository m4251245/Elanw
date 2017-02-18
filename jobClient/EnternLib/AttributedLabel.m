//
//  AttributedLabel.m
//  MobileOffice
//
//  Created by HuangJingbo on 13-12-10.
//  Copyright (c) 2013年 da zhan. All rights reserved.
//

#import "AttributedLabel.h"
#import <CoreImage/CoreImage.h>
#import <Foundation/Foundation.h>

@implementation AttributedLabel
@synthesize attributedString,labelTag;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [attributedString release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect{
    
    for (CATextLayer *textlayer in self.layer.sublayers) {
        if (textlayer != nil && textlayer.retainCount > 1) {
            [textlayer removeFromSuperlayer];
        }
    }
    CGContextRef context=UIGraphicsGetCurrentContext();
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.wrapped = YES;
    
    if (isRetina) {
        [textLayer setContentsScale:2];
    }else{
        [textLayer setContentsScale:1];
    }
    textLayer.string = attributedString;
    textLayer.frame = CGRectMake(11, 11, self.frame.size.width, self.frame.size.height);
//    [self.layer addSublayer:textLayer];

    [textLayer drawInContext:context];
    
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attributedString = nil;
    }else{
        self.attributedString = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    }
}

- (void)setColorWord
{

}


// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)color.CGColor
                       range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [attributedString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CTFontCreateWithName((CFStringRef)font.fontName,
                                                      font.pointSize,
                                                      NULL)
                       range:NSMakeRange(location, length)];
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [attributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                       value:(id)[NSNumber numberWithInt:style]
                       range:NSMakeRange(location, length)];
}

@end
