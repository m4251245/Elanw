//
//  MyFavoriteArticleList.h
//  jobClient
//
//  Created by 一览ios on 15/8/14.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "Article_DataModal.h"

typedef void(^returnTypeblock)(BOOL flag);

@protocol ShareMessageDelegate <NSObject>

-(void)shareMessageDelegateModal:(Article_DataModal *)modal;

@end


@interface MyFavoriteArticleList : BaseListCtl

- (void)startEditor;
- (void)stopEditro;
@property(nonatomic,copy) returnTypeblock block;

@property (nonatomic,assign) BOOL fromMessageList;

@property (nonatomic,weak) id <ShareMessageDelegate> shareDelegate;

@end
