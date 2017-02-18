//
//  ToReportCtl.h
//  jobClient
//
//  Created by YL1001 on 14/11/28.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "GCPlaceholderTextView.h"
#import "ExRequetCon.h"
//#import "Article_DataModal.h"
#import "ELSalaryModel.h"

@interface ToReportCtl : BaseListCtl<UITextViewDelegate>
{
    IBOutlet GCPlaceholderTextView * reasonTX_;
    ELSalaryModel * inModal_;
    
    RequestCon      *   submitCon_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
}

@end
