//
//  GiveAdviceCtl.h
//  MBA
//
//  Created by sysweal on 13-12-11.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"

//#define GiveAdviceMsg_MaxLength         120
//#define GiveAdviceMsg_MinLength         5
static int GiveAdviceMsg_MaxLength = 120;
static int GiveAdviceMsg_MinLength = 5;

@interface GiveAdviceCtl :BaseEditInfoCtl
{
    IBOutlet    UIView                      *contentView_;
    IBOutlet    UITextField                 *phoneNumTextField_;            //联系方式tf
    IBOutlet    UITextField                 *emailTextField_;
//    IBOutlet    UITextField                 *desPromptTf_;          //用于提示的tf
//    IBOutlet    UILabel                     *lengthLb_;             //字数lb
    IBOutlet    UITextView                  *msgTextView_;          //要提交的msg
    IBOutlet    UIButton                    *sumbitBtn_;            //提交按扭
    RequestCon                      *adviceCon_;
    IBOutlet    UILabel             *placeholderLb_;
    
}

@end
