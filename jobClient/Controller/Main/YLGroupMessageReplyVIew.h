//
//  YLGroupMessageReplyVIew.h
//  jobClient
//
//  Created by 一览iOS on 15/7/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupMessageReplyDelegete <NSObject>

@optional
-(void)pushArticleDetailCtl;
-(void)pushReplyViewCtl;

@end

@interface YLGroupMessageReplyVIew : UIViewController

@property (nonatomic,weak) id <GroupMessageReplyDelegete> messageReplyDelegate;

-(void)showMessageViewCtl;
-(void)hideMessageViewCtl;

@end
