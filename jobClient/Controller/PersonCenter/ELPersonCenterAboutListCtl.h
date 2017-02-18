//
//  ELPersonCenterAboutListCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/11/30.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PersonCenterDataModel.h"
#import "ELLoadDataView.h"

@protocol PersonCenterAboutDelegate <NSObject>

@optional

-(void)refreshAllLoad;
-(void)finishLoadWithHeight:(CGFloat)height;
-(void)refreshListCtlFrame;

@end

@interface ELPersonCenterAboutListCtl : ELLoadDataView

@property(nonatomic,weak) id <PersonCenterAboutDelegate> aboutDelegate;

-(void)refreshAboutListView:(PersonCenterDataModel *)personModal isMyCenter:(BOOL)isCenter;
-(void)loadGuanYuTa:(NSString *)userId personModal:(PersonCenterDataModel *)modal isMyCenter:(BOOL)isMyCenter;

 @property(nonatomic,assign) BOOL toLoginFlag;

@end
