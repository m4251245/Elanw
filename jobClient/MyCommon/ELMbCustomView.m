//
//  ELMbCustomView.m
//  jobClient
//
//  Created by 一览iOS on 16/8/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELMbCustomView.h"

#define kMarginTop 18
#define kMarginLeft 20
#define kMaxWidth 274

@implementation ELMbCustomView

-(instancetype)initWithType:(ViewType)type content:(NSString *)content{
    self = [super init];
    if (self){
        self.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-100);
        backView = [[UIView alloc] init];
        backView.alpha = 0.9;
        backView.backgroundColor = UIColorFromRGB(0x212121);
        backView.layer.cornerRadius = 8.0;
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        if (type == ViewTypeActivity){
            if (!content || [content isEqualToString:@""]) {
                _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [self addSubview:_activity];
                _activity.center = self.center;
                [_activity startAnimating];
                backView.frame = CGRectMake(0,0,60,60);
                backView.center = self.center;
            }else{
                contentLable = [[UILabel alloc] init];
                contentLable.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
                contentLable.textColor = [UIColor whiteColor];
                contentLable.numberOfLines = 0;
                contentLable.frame = CGRectMake(0,0,(kMaxWidth-40-(2*kMarginLeft)),MAXFLOAT);
                contentLable.text = content;
                [contentLable sizeToFit];
                contentLable.center = self.center;
                CGRect frame = contentLable.frame;
                frame.origin.x += 20;
                contentLable.frame = frame;
                [self addSubview:contentLable];
                
                _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [self addSubview:_activity];
                _activity.center = self.center;
                _activity.frame = CGRectMake(CGRectGetMinX(contentLable.frame)-40,_activity.frame.origin.y,20,20);
                [_activity startAnimating];
                
                backView.frame = CGRectMake(0,0,2*kMarginLeft+contentLable.frame.size.width+40,contentLable.frame.size.height + 2*kMarginTop);
                backView.center = self.center;
            }
        }else{
            contentLable = [[UILabel alloc] init];
            contentLable.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
            contentLable.numberOfLines = 0;
            contentLable.textColor = [UIColor whiteColor];
            contentLable.frame = CGRectMake(0,0,kMaxWidth-(2*kMarginLeft),MAXFLOAT);
            contentLable.text = content;
            [contentLable sizeToFit];
            contentLable.center = self.center;
            [self addSubview:contentLable];
            backView.frame = CGRectMake(0,0,2*kMarginLeft+contentLable.frame.size.width,contentLable.frame.size.height + 2*kMarginTop);
            backView.center = self.center;
        }
    }
    return self;
}

@end
