//
//  BaseWebViewCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-4.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "NJKWebViewProgress.h"

@interface BaseWebViewCtl : BaseUIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property(nonatomic,weak) IBOutlet  UIWebView  *    webView_;
@property(nonatomic,weak) IBOutlet  UIButton   *    backBtn_;
@property(nonatomic,weak) IBOutlet  UIButton   *    closeBtn_;

- (NSString *)encryptionId:(NSString *)personId;
- (NSString *)changeLinkUrl:(NSString *)url PersonId:(NSString *)personId;

@end
