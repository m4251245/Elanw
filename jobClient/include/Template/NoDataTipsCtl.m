//
//  NoDataTipsCtl.m
//  jobClient
//
//  Created by 一览ios on 15/8/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "NoDataTipsCtl.h"

@interface NoDataTipsCtl ()

@end

@implementation NoDataTipsCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_titleStr) {
        _titleLb.text = _titleStr;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
