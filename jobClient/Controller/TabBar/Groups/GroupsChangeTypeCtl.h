//
//  GroupsChangeTypeCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-3-24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface GroupsChangeTypeCtl : BaseListCtl
{

    IBOutlet UISearchBar *searchBar_;
    RequestCon              * searchCon_;
    RequestCon              *joinCon_;
    RequestCon              *normalCon_;
}
@property (nonatomic,assign) NSInteger groupType;
@property (nonatomic,assign) BOOL isHaveTradeChange;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property(nonatomic,strong) NSString *tradeId;
@property (nonatomic,strong) NSString *totalId;
@property(nonatomic,assign) BOOL hideSearchBar;
@property (nonatomic,assign) NSString *groupCode;
@property(nonatomic,assign) BOOL finishRefresh;
@property(nonatomic,assign) BOOL finishBeginLoad; 
@property (nonatomic,assign) BOOL showTypeChangeList;
@property (nonatomic,assign) BOOL showAdView;

-(void)pushViewCtl:(NSString *)tradeId;
-(void)tableViewContentSizeZero;
@end
