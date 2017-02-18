//
//  NoLoginCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoLoginCtl;
@protocol ShowLoginDelegate <NSObject>

-(void)showLoginCtl:(NoLoginCtl*) ctl;

@end

@interface NoLoginCtl : UIViewController


@property(nonatomic,weak) IBOutlet  UIButton * loginBtn_;
@property(nonatomic,assign) id<ShowLoginDelegate> delegate_;

@end
