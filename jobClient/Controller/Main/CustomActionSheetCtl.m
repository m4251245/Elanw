//
//  CustomActionSheetCtl.m
//  jobClient
//
//  Created by 一览ios on 15/10/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CustomActionSheetCtl.h"

@interface CustomActionSheetCtl ()

@end

@implementation CustomActionSheetCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topView.layer.cornerRadius = 4.0;
    _topView.layer.masksToBounds = YES;
    _btn4.layer.cornerRadius = 4.0;
    _btn4.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
