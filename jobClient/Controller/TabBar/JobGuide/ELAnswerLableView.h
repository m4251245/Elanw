//
//  ELAnswerLableView.h
//  jobClient
//
//  Created by 一览iOS on 16/9/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELAnswerLableView : UIView

@property (nonatomic,assign) BOOL noClick;
@property (nonatomic,assign) NSInteger oneLineMaxCount;

-(void)giveDataModalWithArr:(NSArray *)arr;
-(CGFloat)getViewHeightWithModel:(NSArray *)arr;
-(instancetype)initWithMaxCount:(NSInteger)count;

@end
