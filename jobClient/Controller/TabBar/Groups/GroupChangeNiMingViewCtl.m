//
//  GroupChangeNiMingViewCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-4-23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "GroupChangeNiMingViewCtl.h"

@interface GroupChangeNiMingViewCtl ()




@end

@implementation GroupChangeNiMingViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nChangeImage.image = [UIImage imageNamed:@""];
    self.sChangeImage.image = [UIImage imageNamed:@"redduihao"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWithHide)];
    
    [self.backView addGestureRecognizer:tap];
    
}


-(void)viewWithShow:(UIImage *)sImage sName:(NSString *)sName nImage:(UIImage *)nImage nName:(NSString *)nName isNiMing:(BOOL)isNiMing
{
    [self.sTitleImage setImage:sImage];
    self.sTitleLable.text = sName;
    
    [self.nTitleImage setImage:nImage];
    self.nTitleLable.text = nName;
    
    if (isNiMing) {
        self.nChangeImage.image = [UIImage imageNamed:@"redduihao"];
        self.sChangeImage.image = [UIImage imageNamed:@""];
    }
    else
    {
        self.nChangeImage.image = [UIImage imageNamed:@""];
        self.sChangeImage.image = [UIImage imageNamed:@"redduihao"];
    }
    self.isShowView = YES;
}

-(void)viewWithHide
{
    [self.view removeFromSuperview];
    self.isShowView = NO;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self viewWithHide];
    [_changeNiMingDelegate changeNiMingWithBtnRespone:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changBtnRespone:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            self.nChangeImage.image = [UIImage imageNamed:@"redduihao"];
            self.sChangeImage.image = [UIImage imageNamed:@""];
            break;
        case 200:
            self.nChangeImage.image = [UIImage imageNamed:@""];
            self.sChangeImage.image = [UIImage imageNamed:@"redduihao"];
            break;
        default:
            break;
    }
    [_changeNiMingDelegate changeNiMingWithBtnRespone:sender];  
    [self viewWithHide];
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
