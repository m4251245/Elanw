//
//  ELBeGoodAtTradeChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/10/29.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "personTagModel.h"

@protocol BeGoodAtChangeDelegate <NSObject>

@optional
- (void)updateTechniqueTags:(NSArray *)tags;

@end

@interface ELBeGoodAtTradeChangeCtl : BaseUIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *tradeView;
//需要传递的参数
@property (strong, nonatomic) NSMutableArray *selectedTags;
@property (weak, nonatomic) IBOutlet UIView *selectedTagView;

@property (weak, nonatomic) IBOutlet UIButton *tradeBtn;
@property (copy, nonatomic) NSString *tradeId;
@property (weak, nonatomic)  id<BeGoodAtChangeDelegate> delegate;
@property (nonatomic,assign) BOOL fromExpertCtl;

@property (nonatomic,strong) personTagModel *tradeModel;

@end
