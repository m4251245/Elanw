//
//  YLAddListViewCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/8/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayFocusListCtl.h"

@protocol AddBtnDelegate <NSObject>

-(void)hideBtnAndView:(BOOL)hide;
-(void)refreshDelegateCtl;

@end

@interface YLAddListViewCtl : UIViewController

@property (nonatomic,weak) id <AddBtnDelegate> addBtnDelegate;

-(void)showViewCtl;
-(void)giveDataArr:(NSMutableArray *)arrData;

@end
