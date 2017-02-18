//
//  RegSendSmsCodeCtl.h
//  jobClient
//
//  Created by 一览ios on 14/12/25.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import <MessageUI/MessageUI.h>

@interface RegSendSmsCodeCtl : BaseUIViewController<MFMessageComposeViewControllerDelegate>

@property(nonatomic, copy) NSString *phone;

@property (weak, nonatomic) IBOutlet UILabel *msgContentLb;

@property (weak, nonatomic) IBOutlet UILabel *msgToLb;

@property (weak, nonatomic) IBOutlet UIButton *editSmsBtn;

@property (weak, nonatomic) IBOutlet UIButton *sendedSmsBtn;

@property (weak, nonatomic) IBOutlet UILabel *phoneLb;

- (IBAction)editMsg:(id)sender;

- (IBAction)goRegist:(id)sender;

@end
