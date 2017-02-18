//
//  PCLoginAuthCtl.h
//  jobClient
//
//  Created by 一览ios on 14/12/18.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"

@interface PCLoginAuthCtl : BaseUIViewController

@property (weak, nonatomic) IBOutlet UILabel *summaryLb;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *companyId;
@property(nonatomic, copy) NSString *companyName;

- (IBAction)loginBtnClick:(id)sender;

- (IBAction)cancelLoginBtnClick:(id)sender;

@end
