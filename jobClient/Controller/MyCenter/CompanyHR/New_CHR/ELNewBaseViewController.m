//
//  ELNewBaseViewController.m
//  jobClient
//
//  Created by 一览ios on 16/7/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewBaseViewController.h"
#import "MyLog.h"
@interface ELNewBaseViewController ()<UIAlertViewDelegate>

@end

@implementation ELNewBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark--设置左边按钮
-(void)leftButtonItem:(NSString *)itemImg{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImage:[UIImage imageNamed:itemImg] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger width = -10;
    negativeSpacer.width = width;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:itemImg] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick:)];
}

#pragma mark--设置返回按钮
-(void)backButtonItem:(NSString *)itemImg{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:itemImg] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
}

#pragma mark--设置右边按钮
-(void)rightButtonItem:(NSString *)itemImg{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:itemImg] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
}

-(void)rightButtonItemWithTitle:(NSString *)itemTitle{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 75, 44);
    [rightBtn setTitle:itemTitle forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.contentHorizontalAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

#pragma mark--左边按钮点击
-(void)leftBtnClick:(id)button{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"leftBtnClick");
}

#pragma mark--back按钮点击
-(void)backBtnClick:(id)button{
    NSLog(@"backBtnClick");
}

#pragma mark--右边按钮
-(void)rightBtnClick:(id)button{
    NSLog(@"rightBtnClick");
}

#pragma mark--配置alertView
-(UIAlertView *) showChooseAlertView:(int)type title:(NSString *)title msg:(NSString *)msg okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:okBtnTitle,cancelBtnTitle,nil];
    alert.tag = type;
    [alert show];
    return alert;
}

#pragma mark alertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark - 设置标题
- (void)setNavTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.center = CGPointMake(ScreenWidth/2, self.navigationController.navigationBar.height/2);
    label.bounds = CGRectMake(0, 0, 150, 44);
    label.font = [UIFont systemFontOfSize:17];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
