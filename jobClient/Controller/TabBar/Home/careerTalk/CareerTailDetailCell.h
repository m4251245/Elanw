//
//  CareerTailDetailCell.h
//  jobClient
//
//  Created by 一览iOS on 14-7-9.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareerTailDetailCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel      *tipsLb_;
@property(nonatomic,weak) IBOutlet UILabel      *tipsTitle_;
@property(nonatomic,weak) IBOutlet UILabel      *companyNameLb_;
@property(nonatomic,weak) IBOutlet UIWebView    *webView_;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webHeight;


@end
