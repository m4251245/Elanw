//
//  ResumePreviewCtl.h
//  jobClient
//
//  Created by job1001 job1001 on 12-2-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/*****************************
 
            预览简历
*****************************/

#import <UIKit/UIKit.h>
#import "PreBaseUIViewController.h"
#import "ResumePath_DataModal.h"


#define ResumePreviewCtl_Xib_Name               @"ResumePreviewCtl"
#define ResumePreview_Title                     @"简历预览"

#define ShowResumeType                          @"100"

@interface ResumePreviewCtl : PreBaseUIViewController<UIWebViewDelegate> {
    IBOutlet    UIWebView               *webView_;
    IBOutlet    UILabel                 *statusLb_;
    IBOutlet    UIActivityIndicatorView *indicatorView_;
    
    ResumePath_DataModal                *dataModal_;

}

//更新状态栏
-(void) updateStatusLabel:(NSString *)text haveError:(BOOL)flag;

@end
