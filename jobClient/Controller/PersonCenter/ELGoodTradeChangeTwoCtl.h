//
//  ELGoodTradeChangeTwoCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/11/19.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@protocol ChangeGoodTradeDelegate <NSObject>

@optional
-(void)changeGoodTradeWithArr:(NSArray *)arrData;

@end

@interface ELGoodTradeChangeTwoCtl : BaseListCtl

@property(nonatomic,weak) id <ChangeGoodTradeDelegate> changeDelegate;

@property(nonatomic,weak) NSMutableArray *selectNameArr;

@end
