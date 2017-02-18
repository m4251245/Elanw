//
//  ELAddSelView.h
//  jobClient
//
//  Created by 一览ios on 2016/12/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddselDelegate <NSObject>

-(void)addSelClick:(UIButton *)sender;

@end

@interface ELAddSelView : UIView

@property(nonatomic,assign)id<AddselDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray*)selArr;

@end
