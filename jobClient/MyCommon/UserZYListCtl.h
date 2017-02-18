//
//  UserZYListCtl.h
//  jobClient
//
//  Created by YL1001 on 14-8-13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@protocol ChooseZyDelegate <NSObject>

-(void)chooseZy:(NSString *)zyeStr;

@end

@interface UserZYListCtl : BaseListCtl<ChooseZyDelegate>

@property(nonatomic,assign)id<ChooseZyDelegate> delegate_;
@property(nonatomic,assign) NSInteger                 index_;
@property(nonatomic,assign) NSInteger                 index2_;

@property(nonatomic,assign) NSInteger                 type_;



@end
