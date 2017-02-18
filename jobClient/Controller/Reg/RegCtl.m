//
//  RegCtlViewController.m
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "RegCtl.h"

@interface RegCtl ()

@end

@implementation RegCtl

@synthesize phoneTf_,nextBtn_,scrollView_,step1Img_,step2Img_,passwordTf_,pwdAgainTf_,nameTf_,jobNameTf_,boyBtn_,girlBtn_,okBtn_,delegate_,step3Img_,codeTf_,nextBtn2_,majorTf_,setAccept_,checkAgreement_,hyBtn_;

-(id) init
{
    self = [super init];
    
   
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"注册";
    [self setNavTitle:@"注册"];
     singleTapRecognizer_ = [MyCommon addTapGesture:scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    singleTapRecognizer_.delegate = self;
	// Do any additional setup after loading the view.
    phoneTf_.delegate = self;
    codeTf_.delegate = self;
    passwordTf_.delegate = self;
    pwdAgainTf_.delegate = self;
    nameTf_.delegate = self;
    jobNameTf_.delegate = self;
    majorTf_.delegate = self;
    
    bAccept_ = YES;
    [setAccept_ setSelected:bAccept_];
    
    //[phoneTf_ becomeFirstResponder];
//    scrollView_.frame = CGRectMake(0, 80, 320, self.view.frame.size.height-80);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    sexStr = @"男";
    [boyBtn_ setImage:[UIImage imageNamed:@"bg_reg2_m"] forState:UIControlStateNormal];
    [girlBtn_ setImage:[UIImage imageNamed:@"bg_reg2_w"] forState:UIControlStateNormal];
    
}



-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    //[super beginLoad:nil exParam:nil];
    
    bAccept_ = YES;
    [setAccept_ setSelected:bAccept_];
    //重置页面
    [scrollView_ setContentOffset:CGPointMake(0, 0)];
    
    [step1Img_ setImage:[UIImage imageNamed:@"step1-1"]];
    [step2Img_ setImage:[UIImage imageNamed:@"step2-2"]];
    [step3Img_ setImage:[UIImage imageNamed:@"step3-2"]];
    
    phoneTf_.text = @"";
    pwdAgainTf_.text = @"";
    passwordTf_.text = @"";
    nameTf_.text = @"";
    jobNameTf_.text = @"";
    codeTf_.text = @"";
    majorTf_.text = @"";
    [hyBtn_ setTitle:@"选择行业/职业" forState:UIControlStateNormal];
    
    [codeBg_ setImage:[UIImage imageNamed:@"bg_reg2_valid2"]];
    [phoneBg_ setImage:[UIImage imageNamed:@"bg_reg_user2"]];
    [psw2Bg_ setImage:[UIImage imageNamed:@"bg_reg_password2-1"]];
    [pswBg_ setImage:[UIImage imageNamed:@"bg_reg_password2"]];
    [nameBg_ setImage:[UIImage imageNamed:@"bg_reg_user2"]];
    [jobBg_ setImage:[UIImage imageNamed:@"bg_reg2_position2"]];
    [majorBg_ setImage:[UIImage imageNamed:@"bg_reg2_industry2"]];
    [sexBg_ setImage:[UIImage imageNamed:@"bg_reg2_gender2"]];
    
    [vLineImg1_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg2_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg3_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg4_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg5_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg6_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg7_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg8_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    mydataModal_ = nil;
    self.navigationController.navigationBarHidden = NO;
    [self updateCom:nil];
}

//验证手机
-(void) verifyPhone
{
    if( [phoneTf_.text length] == 0 ){
        [BaseUIViewController showAlertView:nil msg:@"手机号不能为空" btnTitle:@"关闭"];
        [phoneTf_ becomeFirstResponder];
        return;
    }
    if (![MyCommon isMobile:phoneTf_.text]) {
        [BaseUIViewController showAlertView:nil msg:@"请输入正确的手机号" btnTitle:@"关闭"];
        [phoneTf_ becomeFirstResponder];
        return;
    }
    else{
        [phoneTf_ resignFirstResponder];
    }
    
    if (!phoneCon_) {
        phoneCon_ = [self getNewRequestCon:NO];
    }
    [phoneCon_ regestPhone:phoneTf_.text];
}


//注册手机
-(void) regestPhone
{
    if( [codeTf_.text length] == 0 ){
        [BaseUIViewController showAlertView:nil msg:@"短信验证码不能为空" btnTitle:@"关闭"];
        [phoneTf_ becomeFirstResponder];
        return;
    }
    if ([passwordTf_.text length] == 0) {
        [BaseUIViewController showAlertView:nil msg:@"密码不能为空" btnTitle:@"关闭"];
        [passwordTf_ becomeFirstResponder];
        return;
    }
    if ([pwdAgainTf_.text length] == 0) {
        [BaseUIViewController showAlertView:nil msg:@"请再次填写注册密码" btnTitle:@"关闭"];
        [pwdAgainTf_ becomeFirstResponder];
        return;
        
    }
    if (![passwordTf_.text isEqualToString:pwdAgainTf_.text]) {
        [BaseUIViewController showAlertView:nil msg:@"确认密码不一样" btnTitle:@"关闭"];
        [passwordTf_ becomeFirstResponder];
        return;
    }
    else{
        [phoneTf_ resignFirstResponder];
        [passwordTf_ resignFirstResponder];
        [pwdAgainTf_ resignFirstResponder];
    }

    if (!registerCon_) {
        registerCon_ = [self getNewRequestCon:NO];
    }
    
    [registerCon_ doRegister:phoneTf_.text pwd:pwdAgainTf_.text regSource:MyClientName verifyCode:codeTf_.text];
}

//注册成功
-(void) regestOK
{
    if ([nameTf_.text length] == 0 || [jobNameTf_.text length] == 0 || [hyBtn_.titleLabel.text isEqualToString:@"选择行业/职业"] ) {
        [BaseUIViewController showAlertView:nil msg:@"请填写必要信息" btnTitle:@"关闭"];
        return;
    }
    if (!saveInfoCon_) {
        saveInfoCon_ = [self getNewRequestCon:NO];
    }
    [saveInfoCon_ saveUserInfo:mydataModal_.userId_ job:jobNameTf_.text sex:sexStr pic:@"" name:nameTf_.text trade:hyBtn_.titleLabel.text company:@"" nickname:@"" signature:@"" personIntro:nil expertIntro:nil hkaId:@"" school:@"" zym:@"" rctypeId:@"1"regionStr:nil workAge:nil brithday:nil];
    
    
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_RegestPhone:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                [BaseUIViewController showAutoDismissSucessView:@"验证成功" msg:@"验证码将发送到您手机"];
                [step1Img_ setImage:[UIImage imageNamed:@"step1-2"]];
                [step2Img_ setImage:[UIImage imageNamed:@"step2-1"]];
                [step3Img_ setImage:[UIImage imageNamed:@"step3-2"]];
                scrollView_.contentOffset = CGPointMake(320, 0);
                
            }else{
                NSString *str = dataModal.des_;
                if( !str || ![str isKindOfClass:[NSString class]] ){
                    str = @"请稍候再试";
                }
                
                [BaseUIViewController showAlertView:@"注册失败" msg:str btnTitle:@"确定"];
            }
        }
            break;

        case Request_Register:
        {
            User_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                [BaseUIViewController showAutoDismissSucessView:@"注册成功" msg:nil];
                [step1Img_ setImage:[UIImage imageNamed:@"step1-2"]];
                [step2Img_ setImage:[UIImage imageNamed:@"step2-2"]];
                [step3Img_ setImage:[UIImage imageNamed:@"step3-1"]];
                scrollView_.contentOffset = CGPointMake(640, 0);
                mydataModal_ = dataModal;
                
                //记录友盟统计注册来源数量
                NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
                NSDictionary *dict = @{@"Source" : typeStr};
                [MobClick event:@"registerSource" attributes:dict];
                
                //记录友盟统计注册总数
                NSDictionary *dict1 = @{@"Source" : @"注册总数"};
                [MobClick event:@"registerAmount" attributes:dict1];
                
                
                
            }else{
                NSString *str = dataModal.des_;
                if( !str || ![str isKindOfClass:[NSString class]] ){
                    str = @"请稍候再试";
                }
                
                [BaseUIViewController showAlertView:@"注册失败" msg:str btnTitle:@"确定"];
            }
        }
            break;
        case Request_SaveInfo:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if([dataModal.status_ isEqualToString:Success_Status]){
                //[BaseUIViewController showAutoDismissSucessView:@"注册完成" msg:nil];
                [self showChooseAlertView:11 title:@"注册完成" msg:@"是否马上登录" okBtnTitle:@"马上登录" cancelBtnTitle:@"稍后登录"];
                
                [delegate_ registerOK:self username:phoneTf_.text pwd:pwdAgainTf_.text];

            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"注册失败"  msg:dataModal.des_];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark alertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    
    
}

//跳转到第三步
-(void)next
{
    if( [codeTf_.text length] == 0 ){
        [BaseUIViewController showAlertView:nil msg:@"短信验证码不能为空" btnTitle:@"关闭"];
        [phoneTf_ becomeFirstResponder];
        return;
    }
    if ([passwordTf_.text length] == 0) {
        [BaseUIViewController showAlertView:nil msg:@"密码不能为空" btnTitle:@"关闭"];
        [passwordTf_ becomeFirstResponder];
        return;
    }
    if ([pwdAgainTf_.text length] == 0) {
        [BaseUIViewController showAlertView:nil msg:@"请再次填写注册密码" btnTitle:@"关闭"];
        [pwdAgainTf_ becomeFirstResponder];
        return;
        
    }
    if (![passwordTf_.text isEqualToString:pwdAgainTf_.text]) {
        [BaseUIViewController showAlertView:nil msg:@"确认密码不一样" btnTitle:@"关闭"];
        [passwordTf_ becomeFirstResponder];
        return;
    }
    else{
        [phoneTf_ resignFirstResponder];
        [passwordTf_ resignFirstResponder];
        [pwdAgainTf_ resignFirstResponder];
    }
    [step1Img_ setImage:[UIImage imageNamed:@"step1-2"]];
    [step2Img_ setImage:[UIImage imageNamed:@"step2-2"]];
    [step3Img_ setImage:[UIImage imageNamed:@"step3-1"]];
    scrollView_.contentOffset = CGPointMake(640, 0);

}

-(void) btnResponse:(id)sender
{
    if( sender == nextBtn_ ){
        [self verifyPhone];
        
        
     }
    if (sender == nextBtn2_) {
        [self regestPhone];
        
        
    }
    if (sender == okBtn_) {
        [self regestOK];
        
    }
    if (sender == boyBtn_) {
        sexStr = @"男";
        [boyBtn_ setImage:[UIImage imageNamed:@"bg_reg2_m"] forState:UIControlStateNormal];
        
        [girlBtn_ setImage:[UIImage imageNamed:@"bg_reg2_w"] forState:UIControlStateNormal];
    }
    if (sender == girlBtn_) {
        sexStr = @"女";
        [boyBtn_ setImage:[UIImage imageNamed:@"bg_reg2_w"] forState:UIControlStateNormal];
        
        [girlBtn_ setImage:[UIImage imageNamed:@"bg_reg2_m"] forState:UIControlStateNormal];
    }
    
    if (sender == setAccept_) {
        bAccept_ = !bAccept_;
        [setAccept_ setSelected:bAccept_];
        if (bAccept_) {
            nextBtn_.enabled = YES;
            nextBtn_.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:44.0/255.0 blue:47.0/255.0 alpha:1.0];
        }
        else
        {
            nextBtn_.enabled = NO;
            nextBtn_.backgroundColor = [UIColor lightGrayColor];
        }
        
    }
    if (sender == checkAgreement_) {
        if (!agreementCtl_) {
            agreementCtl_ = [[AgreementCtl alloc] init];
        }
        [self.navigationController pushViewController:agreementCtl_ animated:YES];
        
    }
    if (sender == hyBtn_) {
        
        [jobNameTf_ resignFirstResponder];
        userHyListCtl_ = [[UserHYListCtl alloc] init];
        userHyListCtl_.delegate_ = self;
        
        [self.navigationController pushViewController:userHyListCtl_ animated:YES];
        [userHyListCtl_ beginLoad:nil exParam:nil];
    }
    
    
}

#pragma ChooseHyDelegate 
-(void)chooseHy:(NSString *)hyStr zy:(NSString *)zyStr
{
    [scrollView_ setContentOffset:CGPointMake(640, 0) animated:NO];
    [hyBtn_ setTitle:zyStr forState:UIControlStateNormal];
    
}

-(void)backToReg
{
    [scrollView_ setContentOffset:CGPointMake(640, 0) animated:NO];
}

-(void)backBarBtnResponse:(id)sender
{
    if (scrollView_.contentOffset.x > 0) {
        [self showChooseAlertView:1 title:@"温馨提示" msg:@"现在退出，数据将会丢失，注册需重新开始，确定退出？" okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
        return;
    }
    
    [codeTf_ resignFirstResponder];
    [majorTf_ resignFirstResponder];
    [pwdAgainTf_ resignFirstResponder];
    [passwordTf_ resignFirstResponder];
    [phoneTf_ resignFirstResponder];
    [nameTf_ resignFirstResponder];
    [jobNameTf_ resignFirstResponder];
    phoneTf_.text = @"";
    pwdAgainTf_.text = @"";
    passwordTf_.text = @"";
    nameTf_.text = @"";
    jobNameTf_.text = @"";
    codeTf_.text = @"";
    majorTf_.text = @"";
    [hyBtn_ setTitle:@"选择行业/职业" forState:UIControlStateNormal];
    [super backBarBtnResponse:sender];
    
    [Manager shareMgr].loginCtl_.navigationController.navigationBarHidden = YES;
    
    
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [super alertViewChoosed:alertView index:index type:type];
    switch (type) {
        case 1:
        {
            [codeTf_ resignFirstResponder];
            [majorTf_ resignFirstResponder];
            [pwdAgainTf_ resignFirstResponder];
            [passwordTf_ resignFirstResponder];
            [phoneTf_ resignFirstResponder];
            [nameTf_ resignFirstResponder];
            [jobNameTf_ resignFirstResponder];
            [super backBarBtnResponse:nil];
            
            [Manager shareMgr].loginCtl_.navigationController.navigationBarHidden = YES;
        }
            break;
        case 11:
        {
            
            [[Manager shareMgr].loginCtl_ login:0];
        }
            break;
        default:
            break;
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 11:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark  UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if( textField == codeTf_ ){
        [passwordTf_ becomeFirstResponder];
    }
    else if(textField == passwordTf_)
    {
        [pwdAgainTf_ becomeFirstResponder];
    }
    else if(textField == pwdAgainTf_)
    {
        [nameTf_ becomeFirstResponder];
    }
    else if(textField == jobNameTf_ )
    {
        [majorTf_ becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == phoneTf_ ){
        [phoneBg_ setImage:[UIImage imageNamed:@"bg_reg_user"]];
        [vLineImg1_ setImage:[UIImage imageNamed:@"bg_vertical2"]];
    }
    if (textField == codeTf_) {
        [codeBg_ setImage:[UIImage imageNamed:@"bg_reg2_valid"]];
        [vLineImg2_ setImage:[UIImage imageNamed:@"bg_vertical2"]];
        [pswBg_ setImage:[UIImage imageNamed:@"bg_reg_password2"]];
        [psw2Bg_ setImage:[UIImage imageNamed:@"bg_reg_password2-1"]];
        [nameBg_ setImage:[UIImage imageNamed:@"bg_reg_user2"]];
        [vLineImg3_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [vLineImg4_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [vLineImg5_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    }
    if (textField == passwordTf_) {
        [codeBg_ setImage:[UIImage imageNamed:@"bg_reg2_valid2"]];
        [vLineImg2_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [pswBg_ setImage:[UIImage imageNamed:@"bg_reg_password"]];
        [psw2Bg_ setImage:[UIImage imageNamed:@"bg_reg_password2-1"]];
        [nameBg_ setImage:[UIImage imageNamed:@"bg_reg_user2"]];
        [vLineImg3_ setImage:[UIImage imageNamed:@"bg_vertical2"]];
        [vLineImg4_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [vLineImg5_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    }
    if (textField == pwdAgainTf_) {
        [codeBg_ setImage:[UIImage imageNamed:@"bg_reg2_valid2"]];
        [vLineImg2_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [pswBg_ setImage:[UIImage imageNamed:@"bg_reg_password2"]];
        [psw2Bg_ setImage:[UIImage imageNamed:@"bg_reg_password-2"]];
        [nameBg_ setImage:[UIImage imageNamed:@"bg_reg_user2"]];
        [vLineImg3_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [vLineImg4_ setImage:[UIImage imageNamed:@"bg_vertical2"]];
        [vLineImg5_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    }
    if (textField == nameTf_) {
        [codeBg_ setImage:[UIImage imageNamed:@"bg_reg2_valid2"]];
        [vLineImg2_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [pswBg_ setImage:[UIImage imageNamed:@"bg_reg_password2"]];
        [psw2Bg_ setImage:[UIImage imageNamed:@"bg_reg_password2-1"]];
        [nameBg_ setImage:[UIImage imageNamed:@"bg_reg_user"]];
        [vLineImg3_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [vLineImg4_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [vLineImg5_ setImage:[UIImage imageNamed:@"bg_vertical2"]];
        self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-45, self.view.frame.size.width,self.view.frame.size.height);
    }
    if (textField == jobNameTf_) {
        [jobBg_ setImage:[UIImage imageNamed:@"bg_reg2_position"]];
        [vLineImg6_ setImage:[UIImage imageNamed:@"bg_vertical2"]];
        [majorBg_ setImage:[UIImage imageNamed:@"bg_reg2_valid2"]];
        [vLineImg7_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    }
    if (textField == majorTf_) {
        [jobBg_ setImage:[UIImage imageNamed:@"bg_reg2_position2"]];
        [vLineImg6_ setImage:[UIImage imageNamed:@"bg_vertical"]];
        [majorBg_ setImage:[UIImage imageNamed:@"bg_reg2_valid"]];
        [vLineImg7_ setImage:[UIImage imageNamed:@"bg_vertical2"]];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [codeBg_ setImage:[UIImage imageNamed:@"bg_reg2_valid2"]];
    [phoneBg_ setImage:[UIImage imageNamed:@"bg_reg_user2"]];
    [psw2Bg_ setImage:[UIImage imageNamed:@"bg_reg_password2-1"]];
    [pswBg_ setImage:[UIImage imageNamed:@"bg_reg_password2"]];
    [nameBg_ setImage:[UIImage imageNamed:@"bg_reg_user2"]];
    [jobBg_ setImage:[UIImage imageNamed:@"bg_reg2_position2"]];
    [majorBg_ setImage:[UIImage imageNamed:@"bg_reg2_industry2"]];
    [sexBg_ setImage:[UIImage imageNamed:@"bg_reg2_gender2"]];
    
    [vLineImg1_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg2_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg3_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg4_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg5_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg6_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg7_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    [vLineImg8_ setImage:[UIImage imageNamed:@"bg_vertical"]];
    if (textField == nameTf_) {
        self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+45, self.view.frame.size.width,self.view.frame.size.height);
    }
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [codeTf_ resignFirstResponder];
    [majorTf_ resignFirstResponder];
    [pwdAgainTf_ resignFirstResponder];
    [passwordTf_ resignFirstResponder];
    [phoneTf_ resignFirstResponder];
    [nameTf_ resignFirstResponder];
    [jobNameTf_ resignFirstResponder];

}


//根据注册来源获取上传统计的字符串
+(NSString*)getRegTypeStr:(RegisteType)type
{
    NSString* str = @"未知";
    switch (type) {
        case FromXW:
        {
            str = @"薪闻";
        }
            break;
        case FromXZ:
        {
            str = @"薪指";
        }
            break;
        case FromZD:
        {
            str = @"职导";
        }
            break;
        case FromQZ:
        {
            str = @"求职";
        }
            break;
        case FromSQ:
        {
            str = @"社群";
        }
            break;
        case FromHJ:
        {
            str = @"行家";
        }
            break;
        case FromZTDH:
        {
            str = @"职同道合";
        }
            break;
        case FromYL:
        {
            str = @"一览";
        }
            break;
        case FromMe:
        {
            str = @"我";
        }
            break;
        case FromMore:
        {
            str = @"更多";
        }
            break;
        case FromNotKnown:
        {
            str = @"登录页";
        }
            break;
        case FromMessage:
        {
            str = @"消息";
        }
            break;
        case FromZph:
        {
            str = @"招聘会";
        }
            break;
        case FromXjh:
        {
            str = @"宣讲会";
            
        }
            break;
        case FromMessageSet:
        {
            str = @"消息设置";
        }
            break;
        default:
            break;
    }
    
    return str;
}

//ios5 中的bug
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isMemberOfClass:[UIButton class]]||[touch.view isMemberOfClass:[UITextField class]]) {
        //放过button和textfield点击拦截
        return NO;
    }else{
        return YES;
    }
    
}





@end
