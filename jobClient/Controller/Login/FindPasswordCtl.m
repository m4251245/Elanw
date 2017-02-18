//
//  FindPasswordCtl.m
//  Association
//
//  Created by 一览iOS on 14-2-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "FindPasswordCtl.h"

@interface FindPasswordCtl ()

@end

@implementation FindPasswordCtl

-(id)init
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
//    self.navigationItem.title = @"找回密码";
    [self setNavTitle:@"找回密码"];
    //设置圆角
    
    CALayer *layer=[bigView_ layer];
    [layer setMasksToBounds:NO];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:5.0];
    [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    //设置圆角
    
    CALayer *layer2=[smallView_ layer];
    [layer2 setMasksToBounds:NO];
    [layer2 setBorderWidth:1.0];
    [layer2 setCornerRadius:5.0];
    [layer2 setBorderColor:[[UIColor blueColor] CGColor]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    emailTF_.text = @"";
    [emailTF_ becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //self.navigationController.navigationBarHidden = NO;
}

-(void)findPw
{
    if (!findPwCon_) {
        findPwCon_ = [self getNewRequestCon:NO];
    }
    
    if ([emailTF_.text length] == 0 ) {
        [BaseUIViewController showAlertView:@"提交失败" msg:@"邮箱不能为空" btnTitle:@"确定"];
        return;
    }
    
    [findPwCon_ findPassword:emailTF_.text];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_FindPassword:
        {
            @try {
                Status_DataModal * dataModal = [dataArr objectAtIndex:0];
                if ([dataModal.status_ isEqualToString:Success_Status]) {
                    [BaseUIViewController showAutoDismissSucessView:@"" msg:@"邮件发送成功，请查收！"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [Manager shareMgr].loginCtl_.navigationController.navigationBarHidden = YES;
                }
                else
                {
                    [BaseUIViewController showAlertView:@"发送失败" msg:dataModal.des_ btnTitle:@"确定"];
                }
            }
            @catch (NSException *exception) {
                [MyLog Log:exception.description obj:self];
            }
            @finally {
                
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
        [self findPw];
        [emailTF_ resignFirstResponder];
    }
}

-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    
    emailTF_.text= @"";
    [[Manager shareMgr].loginCtl_.navigationController setNavigationBarHidden:YES animated:NO];
    //[Manager shareMgr].loginCtl_.navigationController.navigationBarHidden = YES;
    
}

@end
