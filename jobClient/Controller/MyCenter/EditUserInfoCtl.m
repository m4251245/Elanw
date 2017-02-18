//
//  EditUserInfoCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "EditUserInfoCtl.h"
#import "TSLocateView.h"

@interface EditUserInfoCtl ()

@end

@implementation EditUserInfoCtl
@synthesize nameTF_,nicknameTF_,signatureTF_,tradeTF_,companyTF_,jobTF_,sexTF_,delegate_,regionBtn_,regionLb_,hyBtn_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        rightNavBarStr_ = @"确定";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"编辑资料";
    [self setNavTitle:@"编辑资料"];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [rightBarBtn_ setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -10)];
    }
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    nameTF_.text = inModal_.name_;
    nicknameTF_.text = inModal_.nickname_;
    signatureTF_.text = inModal_.motto_;
    tradeTF_.text = inModal_.zym_;
    if (!inModal_.job_ || [inModal_.job_ isEqual:[NSNull null]]||[inModal_.job_ isEqualToString:@""]) {
        [hyBtn_ setTitle:@"选择行业/职业" forState:UIControlStateNormal];
    }
    else
        [hyBtn_ setTitle:inModal_.job_ forState:UIControlStateNormal];
    jobTF_.text = inModal_.zye_;
    sexTF_.text = inModal_.sex_;
    companyTF_.text = inModal_.company_;
    regionLb_.text = [NSString stringWithFormat:@"%@ %@",inModal_.regionProvince_,inModal_.regionCity_];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [nameTF_ becomeFirstResponder];
    
    inModal_ = dataModal;
    
    
    [super beginLoad:dataModal exParam:exParam];
    
    [self updateCom:nil];
}

-(void)saveUserInfo
{
    if ([nameTF_.text isEqualToString:@""]) {
        [BaseUIViewController showAutoDismissFailView:@"姓名不能为空" msg:@""];
        return;
    }
   
    if (!editCon_) {
        editCon_ = [self getNewRequestCon:NO];
    }
    if (!hkaId_||hkaId_ == nil || [hkaId_ isEqualToString:@""]) {
        hkaId_ = inModal_.regionHka_;
    }
    NSString * trade = hyBtn_.titleLabel.text;
    if ([trade isEqualToString:@"选择行业/职业"]) {
        trade = @"";
    }
    [editCon_ saveUserInfo:inModal_.userId_ job:jobTF_.text sex:sexTF_.text pic:inModal_.img_ name:nameTF_.text trade:trade company:companyTF_.text nickname:nicknameTF_.text signature:signatureTF_.text  personIntro:nil expertIntro:nil hkaId:hkaId_ school:@"" zym:@"" rctypeId:@"1" regionStr:nil workAge:nil brithday:nil];
    
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_SaveInfo:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if([dataModal.status_ isEqualToString:Success_Status]){
//                NSString *nickNameStr = nicknameTF_.text;
//                nickNameStr = [nickNameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
//                nickNameStr = [nickNameStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//                nickNameStr = [nickNameStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                NSUserDefaults *defaul = [NSUserDefaults standardUserDefaults];
//                [defaul setObject:nickNameStr forKey:@"TEMPNICKNAME"];
        
                User_DataModal *model = [Manager getUserInfo];
                
                model.name_ = nameTF_.text;
                model.nickname_ = nicknameTF_.text;
                model.zye_ = jobTF_.text;
                model.hka_ = regionLb_.text;
                model.trade_ = hyBtn_.titleLabel.text;
                if ([model.trade_ isEqualToString:@"选择行业/职业"]) {
                    model.trade_ = @"";
                }
                [Manager setUserInfo:model];
                
                [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [delegate_ editUserInfoOk:self];
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange:) name:@"USERINFOCHANGOK" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USERINFOCHANGOK" object:nil];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    
    if(buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        hkaId_ = location.id_;
        regionLb_.text = [NSString stringWithFormat:@"%@ %@",location.state,location.city];
    }
    
}

-(void)btnResponse:(id)sender
{
    if (sender == regionBtn_) {
        [nameTF_ resignFirstResponder];
        [nicknameTF_ resignFirstResponder];
        [sexTF_ resignFirstResponder];
        [jobTF_ resignFirstResponder];
        [tradeTF_ resignFirstResponder];
        [signatureTF_ resignFirstResponder];
        [companyTF_ resignFirstResponder];
        TSLocateView *regionView = [[TSLocateView alloc] initWithTitle:@"选择城市" delegate:self];
        [regionView setTag:1000];
        
        if (!transparency_) {
            transparency_ = [[TransparencyView alloc]init];
            transparency_.delegate_ = self;
            transparency_.tag = 2000;
        }
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:transparency_];
        [regionView showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
    }
    if (sender == hyBtn_) {
        if (!userHyListCtl_) {
            userHyListCtl_ = [[UserHYListCtl alloc] init];
            userHyListCtl_.delegate_ = self;
        }
        [self.navigationController pushViewController:userHyListCtl_ animated:YES];
        [userHyListCtl_ beginLoad:nil exParam:nil];
    }
}

-(void)removeView
{
    TSLocateView *regionView = (TSLocateView *)[[UIApplication sharedApplication].delegate.window.rootViewController.view viewWithTag:1000];
    if (regionView != nil) {
        [regionView  cancel:nil];
    }
}

-(void)rightBarBtnResponse:(id)sender
{
    [self saveUserInfo];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    TSLocateView *regionView = (TSLocateView *)[self.view viewWithTag:1000];
    if (regionView != nil) {
        [regionView  cancel:nil];
    }
}


#pragma ChooseHyDelegate
-(void)chooseHy:(NSString *)hyStr zy:(NSString *)zyStr
{
    [hyBtn_ setTitle:zyStr forState:UIControlStateNormal];
}


-(void)backToReg
{
    
}


@end
