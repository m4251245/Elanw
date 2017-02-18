//
//  ELBecomeExpertIntroCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/12/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBecomeExpertIntroCtl.h"

@interface ELBecomeExpertIntroCtl ()

@end

@implementation ELBecomeExpertIntroCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"行家介绍"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64)];
    backImage.image = [UIImage imageNamed:@"bgImageView"];
    [self.view addSubview:backImage];
    
    CGFloat heightOne = ((ScreenWidth-16)*187)/304.0;
    CGFloat heightTwo = ((ScreenWidth-16)*190)/304.0;
    CGFloat heightThree = ((ScreenWidth-16)*240)/304.0;
    CGFloat height = heightOne + heightTwo + heightThree + 24;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(ScreenWidth,height+8);
    [self.view addSubview:scrollView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(8,8,ScreenWidth-16,heightOne)];
    image.image = [UIImage imageNamed:@"expertimagead"];
    [scrollView addSubview:image];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(8,heightOne+16,ScreenWidth-16,heightTwo)];
    image.image = [UIImage imageNamed:@"hangjiatequantwo"];
    [scrollView addSubview:image];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(8,heightOne+heightTwo+24,ScreenWidth-16,heightThree)];
    image.image = [UIImage imageNamed:@"apply_expert_conditionn"];
    [scrollView addSubview:image];
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
