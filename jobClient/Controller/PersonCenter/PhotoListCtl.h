//
//  PhotoListCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-10-30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PersonCenterDataModel.h"
#import "MJPhotoBrowser.h"
#import "RequestViewCtl.h"
#import "ELLoadDataView.h"

@protocol PhotoListCtlDelegate <NSObject>

@optional
-(void)showPicker:(id)picker;

//上传图片成功刷新代理
- (void)changImageSuccess;

#pragma mark - 邀请上传图片成功代理
- (void)inviteUpdateImageSuccess;

-(void)photoCancelRefresh;

-(void)addNologinNotification;

@end

@interface PhotoListCtl : ELLoadDataView

@property(nonatomic,assign) CGRect  subRect;
@property(nonatomic,assign) BOOL   isMyCenter;
@property(nonatomic,assign) id<PhotoListCtlDelegate> delegate_;

- (void)beginLoad:(id)dataModal exParam:(id)exParam;
@end
