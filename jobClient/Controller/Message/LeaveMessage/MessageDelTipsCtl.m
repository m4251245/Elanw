//
//  MessageDelTipsCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/1.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MessageDelTipsCtl.h"

@interface MessageDelTipsCtl ()

@end

@implementation MessageDelTipsCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelDelBtnClick:)]];
    if (_msgTipsType == MsgTipsTypeHideUser) {//屏蔽用户
        [_tipsBtn setTitle:@"屏蔽此人后不再接受TA的消息" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _maskView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0.5;
    }];
}

- (IBAction)delMsgBtnClick:(id)sender
{
    if (_delMessageBlock) {
        _delMessageBlock(_row);
    }
    [self.view removeFromSuperview];
}


- (IBAction)cancelDelBtnClick:(id)sender
{
    [self.view removeFromSuperview];
}
@end
