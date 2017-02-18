//
//  TransparencyView.h
//  jobClient
//
//  Created by 一览iOS on 14-8-5.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransparencyViewDelegate <NSObject>

@optional
-(void)removeView;

@end

@interface TransparencyView : UIView

@property(nonatomic,assign) BOOL    flag_;

@property(nonatomic,assign) id<TransparencyViewDelegate> delegate_;

@end
