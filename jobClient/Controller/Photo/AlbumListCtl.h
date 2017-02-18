//
//  AlbumListCtl.h
//  jobClient
//
//  Created by 一览ios on 15/10/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoSelectCtl.h"
#import "New_PhotoSelectionViewController.h"

@interface AlbumListCtl : BaseListCtl

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;


@property (assign, nonatomic) NSInteger maxCount;
@property (assign,nonatomic) BOOL fromTodayList;
@property (assign, nonatomic) id<PhotoSelectCtlDelegate> delegate;
@property (assign, nonatomic) id<LogoPhotoSelectCtlDelegate> logoDelegate;
@property (assign,nonatomic) ChangeSizeType sizeType;
@property (assign,nonatomic) BOOL isOnlyOneSel;

@property (nonatomic,assign) int imageType;

@end
