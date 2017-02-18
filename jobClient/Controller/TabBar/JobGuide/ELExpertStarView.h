//
//  ELExpertStarView.h
//  jobClient
//
//  Created by 一览iOS on 15/8/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELExpertStarView : UIView

@property (nonatomic,assign) BOOL selectedBtn;

-(void)giveDataWithStar:(CGFloat)star;

@property (nonatomic,copy) NSString *currentStar;

@end
