//
// 
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//  表情

#import <UIKit/UIKit.h>
#import "FaceView.h"

@interface FaceScrollView : UIView <UIScrollViewDelegate> {
    UIScrollView *faceScrollView;
    UIPageControl *pageControl;
    @public
    FaceView *faceView;
}

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isShow;

- (id)initWithBlock:(SelectBlock)block;
@end
