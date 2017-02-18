//
//  LearnTechniqueCtl.h
//  jobClient
//
//  Created by 一览ios on 15/2/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol LearnTechniqueProtocol <NSObject>

@optional
- (void)updateTechniqueTags:(NSArray *)tags;

@end

@interface LearnTechniqueCtl : BaseUIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *tradeView;
@property (weak, nonatomic) IBOutlet UIView *tagView;
//需要传递的参数
@property (strong, nonatomic) NSMutableArray *selectedTags;
@property (weak, nonatomic) IBOutlet UIView *selectedTagView;

@property (weak, nonatomic) IBOutlet UIButton *tradeBtn;
@property (copy, nonatomic) NSString *tradeId;
@property (weak, nonatomic) IBOutlet UILabel *hotTagLb;
@property (weak, nonatomic)  id<LearnTechniqueProtocol> delegate;

@property (nonatomic,assign) BOOL fromExpertCtl;

@end
