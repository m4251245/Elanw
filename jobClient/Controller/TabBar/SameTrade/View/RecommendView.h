//
//  RecommendView.h
//  jobClient
//
//  Created by 一览ios on 15/8/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RecommendBtnBlock)(NSString *type);

@interface RecommendView : UIView

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) RecommendBtnBlock btnBlick;

@end
