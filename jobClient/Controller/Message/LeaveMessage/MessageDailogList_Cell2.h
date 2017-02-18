//
//  MessageDailogList_Cell2.h
//  jobClient
//
//  Created by 一览ios on 14/12/10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//自己对话

#import <UIKit/UIKit.h>
@class ELGroupChatCellFrame;

@interface MessageDailogList_Cell2 : UITableViewCell
{
    @public
    UIImage *_contentBgImg;
}
@property (weak, nonatomic) IBOutlet UIImageView *fromUserImgv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIButton *retryBtn;

- (void)setAttr;

- (void) setLeaveMessage:(ELGroupChatCellFrame *)leaveMessage;

@end
