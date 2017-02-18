//
//  IndexNavView.h
//  jobClient
//
//  Created by 一览ios on 15/7/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexNavView : UIView

@property (weak, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) NSArray *indexNavArray;//首页导航

@property(nonatomic, copy) void (^clickBlock)(NSString *type );

@property (strong,nonatomic) UILabel *countLb;

-(void)reloadFriendMessageCountLb:(NSInteger)count withFriendCount:(NSInteger)friendCount;

@end
