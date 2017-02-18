//
//  RecentNewsCtl.h
//  jobClient
//
//  Created by YL1001 on 14-8-22.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "ArticleDetailCtl.h"
#import "AD_dataModal.h"
#import "GCPlaceholderTextView.h"

@protocol RecentNewsCtlDelegate <NSObject>

-(void)refreshSelf;

@optional
-(void)setMyBtnTitle:(NSString*)str;
-(void)finishGetData;

@end

@interface RecentNewsCtl : BaseListCtl<UISearchBarDelegate,UITextViewDelegate>
{

    RequestCon     *newCountCon_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    BOOL           isHideMethod_;
}

@property(nonatomic,assign) id<RecentNewsCtlDelegate> delegate_;
@property(nonatomic,strong) NSMutableArray             *mynewMsgArray_;

-(void)removeAllData;
-(void)resetNoSearch;
-(void)reloadTableView;

@end
