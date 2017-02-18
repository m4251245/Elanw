//
//  RegPhoneCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-1.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"

@protocol RegisterPhoneOKDelegate <NSObject>

-(void)registerPhoneOK:(User_DataModal*)user  userName:(NSString*)name pwd:(NSString*)pwd;

@end

@interface RegPhoneCtl : BaseEditInfoCtl

{
    IBOutlet  UITextField  * phoneTF_;
    IBOutlet  UITextField  * verifyCodeTF_;
    IBOutlet  UITextField  * pwdTF_;
    IBOutlet  UIButton     * sendCodeBtn_;
    IBOutlet  UIButton     * nextBtn_;
    IBOutlet  UIView       * pwdView_;
    IBOutlet UIButton      * checkAgreement_;
    
    RequestCon             * phoneCon_;
    RequestCon             * registerCon_;
    
}

@property (weak, nonatomic) IBOutlet UIView *phoneBgView;

@property (weak, nonatomic) IBOutlet UIView *codeBgView;

@property (weak, nonatomic) IBOutlet UIView *pwdBgView;

@property(nonatomic,assign) id<RegisterPhoneOKDelegate> delegate_;

@property (weak, nonatomic) IBOutlet UIButton *noCodeBtn;

-(IBAction)startTime:(id)sender;




@end
