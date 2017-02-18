//
//  MessageDailogList_Cell.m
//  jobClient
//
//  Created by 一览ios on 14/12/9.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//对方对话

#import "MessageDailogList_Cell.h"
#import "MyConfig.h"
#import "LeaveMessage_DataModel.h"
#import "NSString+Size.h"
#import "ELGroupChatCellFrame.h"

//#define LINE_WIDTH 240
//#define LEFT_INSERT 28
//#define RIGHT_INSERT 10
//#define TOP_INSERT 10
//#define BOTTOM_INSERT 7

@interface MessageDailogList_Cell ()
{
    LeaveMessage_DataModel *leaveMessage;
}
@end

@implementation MessageDailogList_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *bgImage = [UIImage imageNamed:@"icon_dailog2.png"];
    _contentBgImg = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.6 topCapHeight:bgImage.size.height*0.8];
    CALayer *layer = _dateLb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAttr
{
    //设置头像圆角
    CALayer *layer = _toUserImgv.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4.0];
    self.backgroundColor = [UIColor clearColor];
    _contentBtn.titleLabel.font = TWEELVEFONT_COMMENT;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) setLeaveMessage:(ELGroupChatCellFrame *)cellFrame
{
    leaveMessage = cellFrame.leaveMessage;
    _contentLb = (UILabel *)[self.contentBtn viewWithTag:3000];
    if (_contentLb) {
        _contentLb.attributedText = leaveMessage.attString;
    }else{
        _contentLb = [self labelWithAttriText:leaveMessage.attString];
        [self.contentBtn addSubview:_contentLb];
    }
    _contentLb.frame = cellFrame.emojiLabelFrame;
    
    [self.toUserImgv sd_setImageWithURL:[NSURL URLWithString:leaveMessage.personPic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    self.toUserImgv.userInteractionEnabled = YES;
    [self.toUserImgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalCenter:)]];
    if ([leaveMessage.qi_id_isdefault isEqualToString:@"2"]) {
        [self.contentBtn addTarget:self action:@selector(goArticledetail:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.nameLb.text = leaveMessage.personIName;
    self.contentBtn.frame = cellFrame.contentBtnFrame;
    self.toUserImgv.frame = cellFrame.userImgvFrame;
    self.dateLb.frame = cellFrame.timeLbFrame;
    
    [self.contentBtn setBackgroundImage:_contentBgImg forState:UIControlStateNormal];
   
    if (!leaveMessage.date) {
        self.dateLb.hidden = YES;
    }else{
        self.dateLb.hidden = NO;
        self.dateLb.text = leaveMessage.date;
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
    if ([leaveMessage.isSend isEqualToString:@"1"]) {
        userId = [Manager getUserInfo].userId_;
    }else{
        userId = leaveMessage.toUserId;
    }
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    personCenterCtl.hidesBottomBarWhenPushed = YES;
    [[MyCommon viewController:self.superview].navigationController pushViewController:personCenterCtl animated:NO];
    [personCenterCtl beginLoad:userId exParam:nil];
}

- (void)goArticledetail:(UIButton *)sender
{
    if (leaveMessage.article_id.length > 2) {
        ArticleDetailCtl *articleDetailCtl_ = [[ArticleDetailCtl alloc] init];
        articleDetailCtl_.isFromGroup_ = YES;
        articleDetailCtl_.isEnablePop = YES;
        articleDetailCtl_.isFromCompanyGroup = YES;
        [[MyCommon viewController:self.superview].navigationController pushViewController:articleDetailCtl_ animated:YES];
        [articleDetailCtl_ beginLoad:leaveMessage.article_id exParam:nil];
    }
}

@end
