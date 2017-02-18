//
//  ResetNewPwdCtl.m
//  MBA
//
//  Created by 一览iOS on 14-4-30.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ResetNewPwdCtl.h"

@interface ResetNewPwdCtl ()
{
    NSString * findId_;
}
@property (weak, nonatomic) IBOutlet UIImageView *bgViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *bgViewTwo;

@end

@implementation ResetNewPwdCtl
@synthesize uname_;

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
//    self.navigationItem.title = @"重置密码";
    [self setNavTitle:@"重置密码"];
    [pwdTF_ becomeFirstResponder];
    UIImage *image = [UIImage imageNamed:@"bg_reg1"];
    _bgViewOne.image= [image stretchableImageWithLeftCapWidth:image.size.width*0.4 topCapHeight:image.size.height*0.6];
    _bgViewTwo.image= [image stretchableImageWithLeftCapWidth:image.size.width*0.4 topCapHeight:image.size.height*0.6];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    findId_ = dataModal;
}


-(void)reset
{
    if ([pwdTF_.text length] == 0) {
        [BaseUIViewController showAlertView:@"请输入新密码" msg:nil btnTitle:@"确定"];
        return;
    }
    if ([pwdTF_.text length] < 6 ||[pwdTF_.text length] >20 ||[MyCommon checkSpacialCharacter:@"\"`'#-& " inString:pwdTF_.text]) {
        [BaseUIViewController showAlertView:@"请输入6-20位字符（\"`' # - & 除外），区分大小写" msg:nil btnTitle:@"确定"];
        [pwdTF_ becomeFirstResponder];
        return;
    }

    if ([pwd2TF_.text length] == 0) {
        [BaseUIViewController showAlertView:@"请确认密码" msg:nil btnTitle:@"确定"];
        return;
    }
    if (![pwd2TF_.text isEqualToString:pwdTF_.text]) {
        [BaseUIViewController showAlertView:@"确认密码不一致" msg:nil btnTitle:@"确定"];
        return;
    }
    
    if (!resetCon_) {
        resetCon_ = [self getNewRequestCon:NO];
    }
    [resetCon_ resetPwd:uname_ findId:findId_ newPWD:pwd2TF_.text];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_ResetPhonePwd:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.status_ isEqualToString:Success_Status] )
            {
                pwdTF_.text = @"";
                pwd2TF_.text = @"";
                [BaseUIViewController showAlertView:@"密码重置成功" msg:nil btnTitle:@"确定"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [Manager shareMgr].loginCtl_.navigationController.navigationBarHidden = YES;
            }
            else{
                NSString *des = @"请稍候再试";
                if( dataModal.des_ ){
                    des = dataModal.des_;
                }
                [BaseUIViewController showAlertView:@"重置失败" msg:des btnTitle:@"确定"];
            }

        }
            break;
            
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == commitBtn_) {
        [self reset];
    }
}

@end
