//
//  CheckCodeCtl.m
//  MBA
//
//  Created by 一览iOS on 14-4-30.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "CheckCodeCtl.h"

@interface CheckCodeCtl ()
{
    NSString * findPwdId_;
}

@end

@implementation CheckCodeCtl
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
//    self.navigationItem.title = @"核对验证码";
    [self setNavTitle:@"核对验证码"];
    [codeTF_ becomeFirstResponder];
    UIImage *image = [UIImage imageNamed:@"bg_reg1"];
    bgImageView.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.4 topCapHeight:image.size.height*0.6];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    findPwdId_ = dataModal;
}

-(void)checkCode
{
    if ([codeTF_.text length] == 0) {
        [BaseUIViewController showAlertView:@"验证码不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    
    if (!checkCon_) {
        checkCon_ = [self getNewRequestCon:NO];
    }
    [checkCon_ checkCode:findPwdId_  code:codeTF_.text];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_CheckCode:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.status_ isEqualToString:Success_Status] )
            {
                
                if (!resetCtl_) {
                    resetCtl_ = [[ResetNewPwdCtl alloc] init];
                }
                resetCtl_.uname_ = uname_;
                [self.navigationController pushViewController:resetCtl_ animated:YES];
                [resetCtl_ beginLoad:dataModal.exObj_ exParam:nil];
                codeTF_.text = @"";
                
            }
            else{
                [BaseUIViewController showAutoDismissFailView:@"验证码错误" msg:nil];
            }

        }
            break;
            
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == nextBtn_) {
        [self checkCode];
    }
}


@end
