//
//  YLOfferApplyPromptCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/7/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OfferApplyDelegate <NSObject>

-(void)applyDelegateCtlWithType:(NSInteger)type;

@end

@interface YLOfferApplyPromptCtl : UIViewController

@property (weak,nonatomic) id <OfferApplyDelegate> applyDelegare;

-(void)showApplyCtlViewType:(NSInteger)type;
-(void)hideApplyCtlView;

@end
