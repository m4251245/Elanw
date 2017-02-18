//
//  TodayFocusListCtl.h
//  jobClient
//
//  Created by 彭永 on 15-4-6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"
@class ELRecommendView;

@protocol TodayFocusListDelegate <NSObject>

@optional
-(void)finishGetMyData;
@end

@interface TodayFocusListCtl : ELBaseListCtl
{
    
}

@property(nonatomic,strong) NSMutableArray             *mynewMsgArray_;
@property(nonatomic,assign) id<TodayFocusListDelegate> delegate_;

@property (strong, nonatomic) UIView *navView;//导航
@property (strong, nonatomic) UIView *adView;//广告
@property (strong, nonatomic) ELRecommendView *recommendView;//小编推荐

@property (weak, nonatomic) IBOutlet UIButton *moreBtn_;

@property (assign, nonatomic) int selectType;//当前操作项

-(void)reloadTableView;
-(void)reloadFriendMessageCount;

//点击底部导航按钮回到顶部刷新列表
-(void)refreshBtnList;

//- (void)statusBarTouchedAction;

//显示offer派引导页
- (void)checkForOfferPartys;

@end

