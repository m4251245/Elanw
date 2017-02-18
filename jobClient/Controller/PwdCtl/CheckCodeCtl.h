//
//  CheckCodeCtl.h
//  MBA
//
//  Created by 一览iOS on 14-4-30.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "ResetNewPwdCtl.h"


@interface CheckCodeCtl : BaseUIViewController
{
    IBOutlet UITextField * codeTF_;
    IBOutlet UIButton    * nextBtn_;
    __weak IBOutlet UIImageView *bgImageView;
    
    RequestCon              * checkCon_;
    ResetNewPwdCtl          * resetCtl_;
    
    
}
@property(nonatomic,strong) NSString * uname_;

@end
