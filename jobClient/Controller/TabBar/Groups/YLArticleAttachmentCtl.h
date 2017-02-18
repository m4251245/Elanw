//
//  YLArticleAttachmentCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "YLMediaModal.h"

@interface YLArticleAttachmentCtl : BaseUIViewController

@property (nonatomic,strong) YLMediaModal *dataModal;
@property (nonatomic,assign) BOOL isPushFavoriteListCtl;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,assign) BOOL fromArticleList;

@end

