//
//  TxtSearchView.h
//  jobClient
//
//  Created by 一览ios on 16/8/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchViewDelegate <NSObject>

/**
 *  清除
 *
 *  @param btn btn description
 */
-(void)searchViewClearBtnClick:(UIButton *)btn;


/**
 *  取消
 *
 *  @param btn btn description
 */
-(void)cancelBtnClick:(UIButton *)btn;

@end

@interface TxtSearchView : UIView

@property(nonatomic,assign)id<searchViewDelegate>delegate;

@property(nonatomic,retain)UITextField * txt;

@end
