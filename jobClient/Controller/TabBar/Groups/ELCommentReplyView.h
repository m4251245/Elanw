//
//  ELCommentReplyView.h
//  jobClient
//
//  Created by 一览iOS on 16/8/5.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReplyButtonResponeDelegate <NSObject>

-(void)btnResponeWithTitle:(NSString *)buttoName;

@end

@interface ELCommentReplyView : UIView

@property (nonatomic,weak) id<ReplyButtonResponeDelegate>replyDelegate;

-(void)showView;

@end
