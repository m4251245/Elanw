//
//  ConsultantAddVisitCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "Comment_DataModal.h"

@protocol ConsultantAddVisitCtlDelegate <NSObject>

-(void)addSuccess;

@end

@interface ConsultantAddVisitCtl : BaseEditInfoCtl


@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLb;
@property (nonatomic,assign) id<ConsultantAddVisitCtlDelegate> delegate;
@property (nonatomic,strong) Comment_DataModal *comment_DataModal;

@end
