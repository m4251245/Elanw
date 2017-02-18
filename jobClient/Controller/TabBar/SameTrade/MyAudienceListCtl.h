//
//  MyAudienceListCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-10-27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "PersonCenterDataModel.h"

@protocol MyAudienceListCtlDelegate <NSObject>

- (void)reduceLikePersonSuccess;

- (void)addLikePersonSuccess;

@end

@interface MyAudienceListCtl : BaseListCtl
{
    NSInteger  index_;
    RequestCon      *attentionCon_;
    NSString            *type_;
    NSIndexPath         *selectedIndexpath_;
}

@property(nonatomic,assign) id<MyAudienceListCtlDelegate>  delegate;
@property(nonatomic,assign)  BOOL     isOthercenterFlag;
@property(nonatomic,strong)  PersonCenterDataModel *personModel;
@property(nonatomic,assign)  BOOL     isMyCenter;

@property(nonatomic,assign) BOOL hideDynamic;

@property(nonatomic,assign) BOOL isPop;

@end
