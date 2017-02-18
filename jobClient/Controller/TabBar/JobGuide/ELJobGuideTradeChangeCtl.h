//
//  ELJobGuideTradeChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/9/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseUIViewController.h"

@protocol ELTradeChangeDelegate <NSObject>

-(void)tradeChangeWithArr:(CondictionList_DataModal *)dataModal;

@end

@interface ELJobGuideTradeChangeCtl : ELBaseUIViewController

@property (nonatomic,strong) CondictionList_DataModal *selectChangeModal;
@property (nonatomic,weak) id <ELTradeChangeDelegate> tradeDelegate;
@property (nonatomic,assign) BOOL showAllChange;

@end
