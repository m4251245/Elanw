//
//  ServiceInfoCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "NJKWebViewProgress.h"
#import "ExRequetCon.h"
#import "WebViewJavascriptBridge.h"

@interface ServiceInfoCtl : BaseUIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    IBOutlet UIWebView      * webView_;
    RequestCon              * jiebangCon_;
    WebViewJavascriptBridge     *bridge;
    UIWebView               *callWebView;
    BOOL                    loadFlag;
}

@end
