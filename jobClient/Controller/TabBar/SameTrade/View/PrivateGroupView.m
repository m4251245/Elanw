//
//  PrivateGroupView.m
//  jobClient
//
//  Created by 一览ios on 16/6/25.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PrivateGroupView.h"

@interface PrivateGroupView ()

@end

@implementation PrivateGroupView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PrivateGroupView" owner:self options:nil] firstObject];
        self.operationBtn.layer.cornerRadius = 5;
        self.operationBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.operationBtn.layer.borderWidth = 1;
        self.operationBtn.enabled = YES;
    }
    return self;
}

- (void)showPrivateGroupEntrance:(NSString *)rel
{
    self.operationBtn.layer.cornerRadius = 5;
    self.operationBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.operationBtn.layer.borderWidth = 1;
    self.operationBtn.enabled = YES;
    NSString *title;
    NSInteger code = [rel integerValue];
    self.operationBtn.enabled = NO;
    switch (code) {
        case 10:
        {
            title = @"申请加入";
            self.operationBtn.enabled = YES;
        }
            break;
        case 20:
        {
            title = @"等待审核";
        }
            break;
        case 30:
        {
            title = @"已加入";
        }
            break;
        default:
            break;
    }
    
    [self.operationBtn setTitle:title forState:UIControlStateNormal];
}

@end
