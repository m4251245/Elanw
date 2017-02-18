//
//  WebLinkCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"

@interface WebLinkCtl : BaseUIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView * webview_;
    NSString    *time_;
    NSString    *md5Scr_;
}
@end
