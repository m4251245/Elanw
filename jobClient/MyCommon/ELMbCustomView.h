//
//  ELMbCustomView.h
//  jobClient
//
//  Created by 一览iOS on 16/8/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ViewTypeAlert,
    ViewTypeActivity
}ViewType;

@interface ELMbCustomView : UIView
{
    UIView *backView;
    UILabel *contentLable;
    UIActivityIndicatorView *_activity;
}

-(instancetype)initWithType:(ViewType)type content:(NSString *)content;

@end
