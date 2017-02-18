//
//  ResetPwdCtl.m
//  Association
//
//  Created by 一览iOS on 14-2-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ResetPwdCtl.h"
#import "AssociationAppDelegate.h"

@interface ResetPwdCtl ()

@end

@implementation ResetPwdCtl
@synthesize oldPwdTf_,pwdTf_,rePwdTf_,setBtn_,contentView_;
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
//    self.navigationItem.title = @"修改密码";
    [self setNavTitle:@"修改密码"];
    // Do any additional setup after loading the view from its nib.
    
    oldPwdTf_.delegate = self;
    pwdTf_.delegate = self;
    rePwdTf_.delegate = self;
    contentView_.backgroundColor = [UIColor clearColor];
    
    //设置圆角
    CALayer *layer=[contentView_ layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:1.0];
    [layer setBorderColor:[[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//修改密码
-(void) setPwd
{
    if( [oldPwdTf_.text length] == 0 ){
        [BaseUIViewController showAlertView:@"请输入当前密码" msg:nil btnTitle:@"确定"];
        [oldPwdTf_ becomeFirstResponder];
        return;
    }
    
    if( [pwdTf_.text length] == 0 ){
        [BaseUIViewController showAlertView:@"请输入新密码" msg:nil btnTitle:@"确定"];
        [pwdTf_ becomeFirstResponder];
        return;
    }
    if ([pwdTf_.text length] < 6 ||[pwdTf_.text length] >20 ||[MyCommon checkSpacialCharacter:@"\"`'#-& " inString:pwdTf_.text]) {
        [BaseUIViewController showAlertView:@"请输入6-20位字符（\"`' # - & 除外），区分大小写" msg:nil btnTitle:@"确定"];
        [pwdTf_ becomeFirstResponder];
        return;
    }
    
    if( [rePwdTf_.text length] == 0 ){
        [BaseUIViewController showAlertView:@"请输入确认密码" msg:nil btnTitle:@"确定"];
        [rePwdTf_ becomeFirstResponder];
        return;
    }
    
    if( ![pwdTf_.text isEqualToString:rePwdTf_.text] ){
        [BaseUIViewController showAlertView:@"确认密码不正确" msg:nil btnTitle:@"确定"];
        return;
    }
    
    if( [oldPwdTf_.text isEqualToString:pwdTf_.text] ){
        [BaseUIViewController showAlertView:@"新旧密码不能一样" msg:nil btnTitle:@"确定"];
        [pwdTf_ becomeFirstResponder];
        return;
    }
    
    if( !setCon_ ){
        setCon_ = [self getNewRequestCon:NO];
    }
    
    
    NSString * old = [MyCommon convertContent:oldPwdTf_.text];
    NSString * newpw = [MyCommon convertContent:pwdTf_.text];
    
    [setCon_ resetPassword:[Manager getUserInfo].userId_ oldPwd:old newPwd:newpw];
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_ResetPwd:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                [BaseUIViewController showAutoDismissAlertView:@"密码修改成功" msg:nil seconds:1.0];
                
//                oldPwdTf_.text = @"";
//                pwdTf_.text = @"";
//                rePwdTf_.text =@"";
                
                [Manager shareMgr].isNeedRefresh = YES;
                
                User_DataModal *userModal = [User_DataModal new];
                userModal.uname_ = [Manager getUserInfo].uname_;
                userModal.pwd_ = pwdTf_.text;
                AssociationAppDelegate *delegate = (AssociationAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![Manager shareMgr].loginCtl_) {
                    [Manager shareMgr].loginCtl_ = [[LoginCtl alloc] init];
                }
                delegate.window.rootViewController = [Manager shareMgr].loginCtl_;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistSuccess" object:nil userInfo:@{@"key":userModal}];
                
                

//                [Manager shareMgr].haveLogin = NO;
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
//                     [[Manager shareMgr] loginOut];
                    [[Manager shareMgr].loginCtl_ login:0];
                });
            }else{
                [BaseUIViewController showAlertView:@"修改失败" msg:dataModal.des_ btnTitle:@"确定"];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if( textField == oldPwdTf_ ){
        [pwdTf_ becomeFirstResponder];
    }else if( textField == pwdTf_ ){
        [rePwdTf_ becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void) btnResponse:(id)sender
{
    if(sender == setBtn_ ){
        [self setPwd];
    }
}

@end
