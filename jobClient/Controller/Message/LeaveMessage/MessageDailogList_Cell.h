//
//  MessageDailogList_Cell.h
//  jobClient
//
//  Created by 一览ios on 14/12/9.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//对方对话

#import <UIKit/UIKit.h>
@class ELGroupChatCellFrame;

@interface MessageDailogList_Cell : UITableViewCell
{
    @public
    UIImage *_contentBgImg;
}
@property (weak, nonatomic) IBOutlet UIImageView *toUserImgv;

@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (nonatomic,strong) UILabel *contentLb;

- (void)setAttr;
- (void) setLeaveMessage:(ELGroupChatCellFrame *)cellFrame;

@end
