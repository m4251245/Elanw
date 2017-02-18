//
//  MyFavoriteCenterCtl.h
//  jobClient
//
//  Created by 一览ios on 15/8/14.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@protocol FavoriteMessageDelegate <NSObject>

-(void)favoriteMessageDelegateModal:(id)modal;

@end

@interface MyFavoriteCenterCtl : BaseEditInfoCtl
{
    
}

@property(nonatomic,assign) BOOL fromMessageList;

@property(nonatomic,weak) id <FavoriteMessageDelegate> favoriteDelegate;

@end
