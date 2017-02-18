//
//  ELBecomeExpertTypeExplainCtl.m
//  jobClient
//
//  Created by YL1001 on 15/10/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBecomeExpertTypeExplainCtl.h"

@interface ELBecomeExpertTypeExplainCtl (){
    
    __weak IBOutlet UILabel *labelOne;
    __weak IBOutlet UILabel *labelTwo;
    __weak IBOutlet UILabel *labelThree;
}

@end

@implementation ELBecomeExpertTypeExplainCtl

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//     self.navigationItem.title = @"行家类型说明";
    [self setNavTitle:@"行家类型说明"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    [labelOne setAttributedText:[[NSAttributedString alloc] initWithString:@"专业智囊团：由行业/专业领域的资深专家提供相关行业/专业的辅导和帮助" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}]];
    [labelTwo setAttributedText:[[NSAttributedString alloc] initWithString:@"职业生涯规划与发展导师团：由职业规划师、认证生涯导师、心理咨询师、资深领导力教练等专业人士为您的生涯规划与发展、工作生活平衡、身心健康和个人成长多方面提供辅导和帮助" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}]];
    [labelThree setAttributedText:[[NSAttributedString alloc] initWithString:@"能够帮助人才推荐一些适合的岗位，并做好人才的管理提升工作，在招聘领域拥有长期工作经验和较高的专业度" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}]];
    [self.view layoutSubviews];
}


- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
