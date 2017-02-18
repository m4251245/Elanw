//
//  ResumePreviewController.h
//  Association
//
//  Created by 一览iOS on 14-6-26.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"

typedef void(^resumeBackBlock)();

@interface ResumePreviewController : BaseUIViewController<UIWebViewDelegate>
{
    IBOutlet    UIWebView    *webView_;
    NSString    *resumePath_;
    RequestCon  *shareLogsCon_;
    IBOutlet UIActivityIndicatorView    *activity_;
}

@property(nonatomic,copy) resumeBackBlock block;

@property(nonatomic,assign) BOOL showTranspontResumeBtn;
@property(nonatomic,assign) BOOL formMessage;

@end
