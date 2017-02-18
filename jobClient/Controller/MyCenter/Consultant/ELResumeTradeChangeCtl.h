//
//  ELResumeTradeChangeCtl.h
//  
//
//  Created by 一览iOS on 15/11/9.
//
//

#import "BaseListCtl.h"
#import "CondictionList_DataModal.h"
#import "CondictionTradeCtl.h"

@protocol TradeChangeDelegate <NSObject>

-(void)tradeChangeDelegateModa:(CondictionList_DataModal *)Modal;

@end

@interface ELResumeTradeChangeCtl : BaseListCtl

@property(nonatomic,strong) NSMutableArray *arrDataList;

@property(nonatomic,weak) id <TradeChangeDelegate> changeDelegate;

@property (nonatomic,retain)CondictionList_DataModal *selectedVO;

@end
