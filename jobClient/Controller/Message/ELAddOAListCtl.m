//
//  ELAddOAListCtl.m
//  jobClient
//
//  Created by YL1001 on 16/4/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELAddOAListCtl.h"

@interface ELAddOAListCtl ()

@end

@implementation ELAddOAListCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (IBAction)btnClick:(UIButton *)sender {
    
    [_addOADelegate btnResponeWithIndex:sender.tag];
    [self hideView];
}


- (void)showViewCtl
{
    [_addOADelegate hideOABtnView:NO];
    self.view.frame = [UIScreen mainScreen].bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.view];
}

- (void)hideView
{
    [_addOADelegate hideOABtnView:YES];
    [self.view removeFromSuperview];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
