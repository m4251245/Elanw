//
//  ELInterviewRefundCtl.h
//  jobClient
//
//  Created by YL1001 on 15/11/18.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface ELInterviewRefundCtl : BaseEditInfoCtl<UITextViewDelegate>
{
    IBOutlet UIButton *finishedBtn;
    IBOutlet UIButton *unfinishedBtn;
    IBOutlet UITextView *reasonTV;
    IBOutlet UIButton *confirmBtn;
}


@end
