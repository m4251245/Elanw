//
//  ResetNewPwdCtl.h
//  MBA
//
//  Created by 一览iOS on 14-4-30.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"

@interface ResetNewPwdCtl : BaseUIViewController
{
    IBOutlet  UITextField   *  pwdTF_;
    IBOutlet  UITextField   *  pwd2TF_;
    IBOutlet  UIButton      *  commitBtn_;
    
    RequestCon          *  resetCon_;
    
}

@property(nonatomic,strong) NSString * uname_;

@end
