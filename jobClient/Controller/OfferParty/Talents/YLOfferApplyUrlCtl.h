//
//  YLOfferApplyUrlCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/7/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "OfferPartyTalentsModel.h"

typedef void(^RefreshJoin)(BOOL isJoin);

@interface YLOfferApplyUrlCtl : BaseUIViewController

@property(nonatomic,strong) OfferPartyTalentsModel *modal;
@property(nonatomic,assign) BOOL resumeComplete;
@property (nonatomic,copy) RefreshJoin joibBlock;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
