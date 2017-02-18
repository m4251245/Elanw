//
//  TextSpecial.h
//  ceshi
//
//  Created by 一览iOS on 16/11/11.
//  Copyright © 2016年 client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TextSpecial : NSObject

@property (nonatomic,assign) NSRange range;//点击内容的位置
@property (nonatomic,strong) UIColor *color;//链接点击是的背景色
@property (nonatomic,strong) NSString *key;
@property (nonatomic,assign) BOOL isLink;

@end
