//
//  AspectantDiscussSuccessCtl.m
//  jobClient
//
//  Created by YL1001 on 15/9/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "AspectantDiscussSuccessCtl.h"
#import "ELAspDisServiceCtl.h"
#import "ELMyAspectantDiscussCtl.h"


@interface AspectantDiscussSuccessCtl ()

@end

@implementation AspectantDiscussSuccessCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.title = @"购买成功";
        leftBarBtn_.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _backBtn.layer.cornerRadius = 3;
    _orderDetailBtn.layer.cornerRadius = 3;
}

- (void)btnResponse:(id)sender
{
    [self.navigationController popToViewController:[Manager shareMgr].yuetanBackCtl animated:YES];
}

- (void)backBarBtnResponse:(id)sender
{
    [self.navigationController popToViewController:[Manager shareMgr].yuetanBackCtl animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


@end
