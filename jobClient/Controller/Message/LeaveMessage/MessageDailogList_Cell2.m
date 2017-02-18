//
//  MessageDailogList_Cell2.m
//  jobClient
//
//  Created by 一览ios on 14/12/10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
// 自己对话

#import "MessageDailogList_Cell2.h"
#import "ELGroupChatCellFrame.h"
#import "MyConfig.h"
#import "NSString+Size.h"
#import "UIImageView+WebCache.h"
#import "LeaveMessage_DataModel.h"

#define LINE_WIDTH 240
#define LEFT_INSERT 28
#define RIGHT_INSERT 10
#define TOP_INSERT 10
#define BOTTOM_INSERT 7

@interface MessageDailogList_Cell2 ()
{
    LeaveMessage_DataModel *leaveMsgModel;
}
@end

@implementation MessageDailogList_Cell2

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *bgImage = [UIImage imageNamed:@"icon_dailog1.png"];
    _contentBgImg = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.4 topCapHeight:bgImage.size.height*0.8];
    CALayer *layer = _dateLb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setAttr
{
    //设置头像圆角
    CALayer *layer = _fromUserImgv.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4.0];
    self.backgroundColor = [UIColor clearColor];
    _contentBtn.titleLabel.font = TWEELVEFONT_COMMENT;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) setLeaveMessage:(ELGroupChatCellFrame *)cellFrame
{
    leaveMsgModel = cellFrame.leaveMessage;
    [self.fromUserImgv sd_setImageWithURL:[NSURL URLWithString:leaveMsgModel.personPic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    self.fromUserImgv.userInteractionEnabled = YES;
    [self.fromUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
    self.nameLb.text = leaveMsgModel.personIName;
    self.nameLb.textAlignment = NSTextAlignmentRight;
    if ([leaveMsgModel.qi_id_isdefault isEqualToString:@"2"]) {
        [self.contentBtn addTarget:self action:@selector(goArticledetail:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *contentLb;
    contentLb = (UILabel *)[self.contentBtn viewWithTag:3000];
    if (contentLb) {
        contentLb.attributedText = leaveMsgModel.attString;
    }else{
        contentLb = [self labelWithAttriText:leaveMsgModel.attString];
        [self.contentBtn addSubview:contentLb];
    }
    contentLb.frame = cellFrame.emojiLabelFrame;
    
    self.contentBtn.frame = cellFrame.contentBtnFrame;
    self.fromUserImgv.frame = cellFrame.userImgvFrame;
    self.dateLb.frame = cellFrame.timeLbFrame;
    self.activity.frame = cellFrame.activityFrame;
    self.retryBtn.center = _activity.center;
    [self.contentBtn setBackgroundImage:_contentBgImg forState:UIControlStateNormal];
    
    [self.retryBtn setHidden:YES];
    switch (leaveMsgModel.msgUploadStatus) {
        case MsgUploadStatusInit:
        case MsgUploadStatusUpLoading:
        {
            [self.activity startAnimating];
        }
            break;
        case MsgUploadStatusOk:
        {
            [self.activity stopAnimating];
        }
            break;
        case MsgUploadStatusFailed:
        {
            [self.activity stopAnimating];
            [self.retryBtn setHidden:NO];
        }
            break;
        default:
            break;
    }
    
    if (!leaveMsgModel.date) {
        _dateLb.hidden = YES;
    }else{
        _dateLb.hidden = NO;
        _dateLb.text = leaveMsgModel.date;
    }
}

- (UILabel *)labelWithAttriText:(NSMutableAttributedString *)attributeStr
{
    UILabel *contentLb = [[UILabel alloc]init];
    contentLb.tag = 3000;
    contentLb.numberOfLines = 0;
    contentLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    contentLb.backgroundColor = [UIColor clearColor];
    contentLb.lineBreakMode = NSLineBreakByCharWrapping;
    contentLb.attributedText = attributeStr;
    return contentLb;
}

#pragma mark 跳转个人中心
- (void)goPersonalCenter:(UITapGestureRecognizer *)sender
{
    NSString *userId = @"";
    if ([leaveMsgModel.isSend isEqualToString:@"1"]) {
        userId = [Manager getUserInfo].userId_;
    }else{
        userId = leaveMsgModel.toUserId;
    }
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    personCenterCtl.hidesBottomBarWhenPushed = YES;
    [[MyCommon viewController:self.superview].navigationController pushViewController:personCenterCtl animated:NO];
    [personCenterCtl beginLoad:userId exParam:nil];
}

- (void)goArticledetail:(UIButton *)sender
{
    if (leaveMsgModel.article_id.length > 2) {
        ArticleDetailCtl *articleDetailCtl_ = [[ArticleDetailCtl alloc] init];
        articleDetailCtl_.isFromGroup_ = YES;
        articleDetailCtl_.isEnablePop = YES;
        articleDetailCtl_.isFromCompanyGroup = YES;
        [[MyCommon viewController:self.superview].navigationController pushViewController:articleDetailCtl_ animated:YES];
        [articleDetailCtl_ beginLoad:leaveMsgModel.article_id exParam:nil];
    }
}


@end
