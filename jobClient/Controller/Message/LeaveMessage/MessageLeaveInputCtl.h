//
//  MessageLeaveInputCtl.h
//  jobClient
//
//  Created by 一览ios on 14/12/10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ExRequetCon.h"
#import "BaseUIViewController.h"

@interface MessageLeaveInputCtl : BaseUIViewController<UITextViewDelegate>

@property(nonatomic, weak)  IBOutlet    UILabel     *nameLb;
@property(nonatomic, weak)  IBOutlet    UITextView  *contentTv;
@property(nonatomic, weak)  IBOutlet    UILabel     *promptLb;

@end
