//
//  FaceContentUtil.h
//  jobClient
//
//  Created by 一览ios on 15/1/21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceContentUtil : NSObject

@property (nonatomic, assign) CGFloat width;

+ (UIView *)assembleMessageView : (NSString *)message width:(CGFloat)width;

@end
