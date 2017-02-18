//
//  FindPwdCtl.m
//  MBA
//
//  Created by sysweal on 13-12-21.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "FindPwdCtl.h"


@interface FindPwdCtl ()
{

    __weak IBOutlet UIImageView *backGroundImage;
}
@end

@implementation FindPwdCtl

@synthesize emailTf_,findBtn_;

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

    [self setNavTitle:@"找回密码"];
	// Do any additional setup after loading the view.
    
    [emailTf_ becomeFirstResponder];
    UIImage *bgImage = [UIImage imageNamed:@"bg_reg1"];
    backGroundImage.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.4 topCapHeight:bgImage.size.height*0.6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    emailTf_.text = @"";
    [emailTf_ becomeFirstResponder];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

//找回密码
-(void) findPwd
{
    NSString *phoneNum = [emailTf_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(![phoneNum isMobileNumValid]){
        [BaseUIViewController showAlertView:@"请输入正确的手机号码" msg:nil btnTitle:@"确定"];
        [emailTf_ becomeFirstResponder];
        return;
    }

    if( !findCon_ ){
        findCon_ = [self getNewRequestCon:NO];
    }
    
    [findCon_ findPwd:emailTf_.text];
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_FindPhonePwd:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.status_ isEqualToString:Success_Status] )
            {
                
                if (!checkCodeCtl_) {
                    checkCodeCtl_ = [[CheckCodeCtl alloc] init];
                }
                checkCodeCtl_.uname_ = emailTf_.text;
                [BaseUIViewController showAutoDismissSucessView:@"验证码已经发送" msg:nil];
                [self.navigationController pushViewController:checkCodeCtl_ animated:YES];
                [checkCodeCtl_ beginLoad:dataModal.exObj_ exParam:nil];
                emailTf_.text = @"";
            }
            else{
                if ([dataModal.code_ isEqualToString:@"50"]) {
                    [BaseUIViewController showAutoDismissFailView:@"获取验证码失败" msg:nil];
                }else if([dataModal.code_ isEqualToString:@"3"]){
                    [BaseUIViewController showAutoDismissFailView:@"每天最多获取5条验证码,请稍后再试" msg:nil];
                }else if ([dataModal.code_ isEqualToString:@"20"]){
                    [BaseUIViewController showAutoDismissFailView:@"用户尚未注册" msg:nil];
                }else{
                    [BaseUIViewController showAutoDismissFailView:@"获取验证码失败" msg:nil];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

-(void) btnResponse:(id)sender
{
    if( sender == findBtn_ ){
        [self findPwd];
    }
}

-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [[Manager shareMgr].loginCtl_.navigationController setNavigationBarHidden:YES animated:NO];
    //[Manager shareMgr].loginCtl_.navigationController.navigationBarHidden = YES;
    
}


@end
