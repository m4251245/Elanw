//
//  SameTradeListCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-10-23.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "MessageContact_DataModel.h"
//#import "MessageDailogListCtl.h"

@protocol SameTradeListCtlDelegate <NSObject>

@optional
-(void)finishGetMyData;
-(void)sameTradeMessageModal:(id)modal;

@end

@interface SameTradeListCtl : BaseListCtl<UISearchBarDelegate>
{
    RequestCon          *attentionCon_;
    RequestCon          *newCountCon_;
    RequestCon          *adCon_;
    NSInteger                 index_;
    BOOL   bKeyboardShow_;
    BOOL   bSearchKeyBoardShow_;
    NSIndexPath         *selectedIndexpath_;
}

@property(nonatomic,strong) NSMutableArray             *mynewMsgArray_;
@property(nonatomic,strong) NSArray                    *adArray_;
@property(nonatomic,weak)   IBOutlet UISearchBar       *searchBar_;

@property(nonatomic,strong) NSString                   *getExpertFlag;

@property(nonatomic,assign) id<SameTradeListCtlDelegate> delegate_;

@property(nonatomic,assign) BOOL fromMessageList;

-(void)reloadTableView;

@end
