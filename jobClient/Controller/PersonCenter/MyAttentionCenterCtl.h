//
//  MyAttentionCenterCtl.h
//  jobClient
//
//  Created by 一览ios on 15/4/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "MyAudienceListCtl.h"

@interface MyAttentionCenterCtl : BaseUIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *redLineImagev;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *midBtn;
@property (weak, nonatomic) IBOutlet UILabel  *leftCountLb;
@property (weak, nonatomic) IBOutlet UILabel  *midCountLb;
@property (weak, nonatomic) IBOutlet UILabel  *rightCountLb;

@end
