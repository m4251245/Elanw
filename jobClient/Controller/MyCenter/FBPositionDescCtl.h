//
//  FBPositionDescCtl.h
//  jobClient
//
//  Created by 一览ios on 15/10/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ZWModel.h"

typedef void(^seletedblock)();

@interface FBPositionDescCtl : BaseEditInfoCtl

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (strong,nonatomic)   ZWModel *inzwmodel;    /**< */
@property (nonatomic,copy) seletedblock block;


@end
