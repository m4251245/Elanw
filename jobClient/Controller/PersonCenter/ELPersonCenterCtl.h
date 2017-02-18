//
//  ELPersonCenterCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/10/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "User_DataModal.h"

@protocol PersonCenterCtlDelegate <NSObject>

@optional
- (void)addLikeSuccess;
- (void)leslikeSuccess;
- (void)personCenterUserInfoChang:(User_DataModal *)userModel ;

@end

@protocol AttentionSuccessDelegate <NSObject>

-(void)attentionSuccessRefresh:(BOOL)isSuccess;

@end


@interface ELPersonCenterCtl : BaseUIViewController

@property(nonatomic,assign)id<PersonCenterCtlDelegate> delegate;
@property (nonatomic,weak) id <AttentionSuccessDelegate> attentionDelegate;

@property(strong,nonatomic) UIButton *selectBtn;
@property(strong,nonatomic)UIButton *dongtaiChangeBtn;
@property(strong,nonatomic)UIButton *aboutChangeBtn;
@property (nonatomic,assign) BOOL toLoginFlag;
@property(nonatomic,assign) BOOL isFromJobAnswer;
@property(nonatomic, strong) NSMutableArray *contentDataArr; //动态、关于、评价、约谈、推荐职位数组

@property(nonatomic, assign)BOOL isFromManagerCenterPop;//我推过来是否需要测滑动返回

-(void)loadPersonInformation;

@end
