//
//  JobFairDetailCell.h
//  jobClient
//
//  Created by 一览iOS on 14-7-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobFairDetailCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel   *tipsLb_;
@property(nonatomic,weak) IBOutlet UIWebView    *tipsWebView_;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@end
