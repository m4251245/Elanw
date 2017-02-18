//
//  FindPasswordCtl.h
//  Association
//
//  Created by 一览iOS on 14-2-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"


@interface FindPasswordCtl : BaseUIViewController
{
    IBOutlet UIView * bigView_;
    IBOutlet UIView * smallView_;
    IBOutlet UITextField * emailTF_;
    IBOutlet UIButton * commitBtn_;
    
    RequestCon    *  findPwCon_;
    
}

@end
