//
//  EditorManifestoCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-11-7.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "EditorManifestoCtl.h"

@interface EditorManifestoCtl ()

@end

@implementation EditorManifestoCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        rightNavBarStr_ = @"保存";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([_type isEqualToString:@"1"]) {
//            self.navigationItem.title = @"我的职业宣言";
        [self setNavTitle:@"我的职业宣言"];
    }else{
//            self.navigationItem.title = @"个人简介";
        [self setNavTitle:@"个人简介"];
    }
    manifestTextv_.delegate = self;
    manifestTextv_.layer.cornerRadius = 2.5;
    manifestTextv_.layer.masksToBounds = YES;
//    manifestTextv_.layer.borderWidth = 0.5;
//    manifestTextv_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
}

//设置右按扭的属性
//- (void)setRightBarBtnAtt
//{
//    [rightBarBtn_ setTitle:@"保存" forState:UIControlStateNormal];
//    rightBarBtn_.layer.cornerRadius = 2.0;
//    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
//    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBarBtn_ setFrame:CGRectMake(0, 0, 45, 31)];
//    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
//}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (inModel_.userModel_ !=nil ) {
        if ([_type isEqualToString:@"1"]) {
            [manifestTextv_ setText:inModel_.userModel_.signature_];
        }else{
            [manifestTextv_ setText:inModel_.userModel_.expertIntroduce_];
        }
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:nil];
    inModel_ = dataModal;
    [self updateCom:nil];
}

- (void)rightBarBtnResponse:(id)sender
{
    if ([manifestTextv_ isFirstResponder]) {
        [manifestTextv_ resignFirstResponder];
    }
    if ([[MyCommon removeSpaceAtHead:manifestTextv_.text] isEqualToString:@""]) {
        if ([_type isEqualToString:@"1"]) {
            [BaseUIViewController showAlertView:nil msg:@"请输入职业宣言" btnTitle:@"知道了"];
        }else{
            [BaseUIViewController showAlertView:nil msg:@"请输入个人简介" btnTitle:@"知道了"];
        }
        return;
    }
    if (!editCon_) {
        editCon_ = [self getNewRequestCon:NO];
    }
    if ([_type isEqualToString:@"1"]) {
        [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:nil trade:nil company:nil nickname:nil signature:[MyCommon removeSpaceAtHead:manifestTextv_.text] personIntro:nil expertIntro:nil  hkaId:nil school:nil zym:nil rctypeId:@"1" regionStr:nil workAge:nil brithday:nil];
    }else{
        if (inModel_.userModel_.isExpert_) {
            [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:nil trade:nil company:nil nickname:nil signature:nil  personIntro:nil expertIntro:[MyCommon removeSpaceAtHead:manifestTextv_.text]  hkaId:nil school:nil zym:nil rctypeId:@"1" regionStr:nil workAge:nil brithday:nil];
        }
        else
        {
            [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:nil trade:nil company:nil nickname:nil signature:nil  personIntro:[MyCommon removeSpaceAtHead:manifestTextv_.text] expertIntro:nil  hkaId:nil school:nil zym:nil rctypeId:@"1" regionStr:nil workAge:nil brithday:nil];
        }
        
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_SaveInfo:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if([dataModal.status_ isEqualToString:Success_Status]){
                
                if ([_type isEqualToString:@"1"])
                {
                    inModel_.userModel_.signature_ = [MyCommon removeSpaceAtHead:manifestTextv_.text];
                }
                else{
                    inModel_.userModel_.expertIntroduce_ = [MyCommon removeSpaceAtHead:manifestTextv_.text];
                }
                
                if (self.block) {
                    self.block();
                }
                
                [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:@"请稍后再试"];
            }
        }
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([manifestTextv_ isFirstResponder]) {
        [manifestTextv_ resignFirstResponder];
    }
}

- (void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    if ([manifestTextv_ isFirstResponder]) {
        [manifestTextv_ resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
