//
//  YLOfferListCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/7/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
@class personTagModel;

@interface YLOfferListCtl : BaseListCtl

@property (weak, nonatomic)     IBOutlet UITextField  *keywordsTF;
@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIButton *jobBtn;
@property (nonatomic, strong) personTagModel *selectJob;

@property (nonatomic,retain) UIView *bgView;

-(void)hideRegionChangeView;

@end
