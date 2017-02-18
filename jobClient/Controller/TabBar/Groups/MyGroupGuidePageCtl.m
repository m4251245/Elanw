//
//  MyGroupGuidePageCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-3-27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyGroupGuidePageCtl.h"

@interface MyGroupGuidePageCtl ()
{
    BOOL isLastPage;
}
@end

@implementation MyGroupGuidePageCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isLastPage = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:tap];
    [self.view sendSubviewToBack:backView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tap:(UITapGestureRecognizer *)sender
{
    if (!isLastPage) {
        jobImage.hidden = NO;
        jobNameImage.hidden = NO;
        companyImage.hidden = YES;
        companyNameImage.hidden = YES;
        isLastPage = YES;
    }
    else
    {
        [self.view removeFromSuperview];
    }
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
