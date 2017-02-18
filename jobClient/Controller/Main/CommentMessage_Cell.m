//
//  CommentMessage_Cell.m
//  jobClient
//
//  Created by YL1001 on 14/10/28.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CommentMessage_Cell.h"
#import "GroupInvite_DataModal.h"


@implementation CommentMessage_Cell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    self.contentView_.layer.borderWidth = 0.5;
    [self.nameLb_ setFont:FOURTEENFONT_CONTENT];
    [self.titleLb_ setFont:FOURTEENFONT_CONTENT];
    [self.nameLb_ setTextColor:BLACKCOLOR];
    [self.titleLb_ setTextColor:UIColorFromRGB(0xaaaaaa)];
    [self.timeLb_ setFont:NINEFONT_TIME];
    [self.timeLb_ setTextColor:UIColorFromRGB(0xaaaaaa)];
}

-(void)setDataModal:(GroupInvite_DataModal *)dataModal{
    _dataModal = dataModal;
    _nameLb_.hidden = NO;
    _titleLb_.hidden = NO;
    _contentLb_.hidden = YES;
    _titlelableOne.hidden = YES;
    _contentLableOne.hidden = YES;
    if ([dataModal.is_read isEqualToString:@"1"]) {
        [self.markNewImg_ setHidden:YES];
    }else{
        [self.markNewImg_ setHidden:NO];
    }
    
    [self.userImg_ sd_setImageWithURL:[NSURL URLWithString:dataModal.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"] options:SDWebImageAllowInvalidSSLCertificates];
    self.nameLb_.text = dataModal.person_iname;
    
    if (dataModal.parentContent.length > 0){
        self.titleLb_.text = [NSString stringWithFormat:@"回复了:%@",dataModal.parentContent];
    }else{
        self.titleLb_.text = [NSString stringWithFormat:@"评论了:%@",dataModal.article_title];
    }
    NSString * content = [dataModal.comment_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    content = [MyCommon MyfilterHTML:content];
    content = [MyCommon translateHTML:content];
    MLEmojiLabel *emojiLabel = [GroupInvite_DataModal emojiLabel:content numberOfLines:3];
    emojiLabel.tag = 1001;
    emojiLabel.frame = CGRectMake(40, 30, ScreenWidth - 64, 0);
    [emojiLabel sizeToFit];
    UIView *oldView = [self.contentView_ viewWithTag:1001];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    [self.contentView_ addSubview:emojiLabel];
    self.timeLb_.text = dataModal.idatetime;
}

-(void)setDataModalOne:(GroupInvite_DataModal *)dataModalOne{
    _dataModalOne = dataModalOne;
    UIView *oldView = [self.contentView_ viewWithTag:1001];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    _nameLb_.hidden = YES;
    _titleLb_.hidden = YES;
    _contentLb_.hidden = NO;
    _titlelableOne.hidden = YES;
    _contentLableOne.hidden = YES;
    if (dataModalOne.contentAttString) {
        [_contentLb_ setAttributedText:dataModalOne.contentAttString];
    }
    if ([dataModalOne.is_read isEqualToString:@"1"]) {
        [self.markNewImg_ setHidden:YES];
    }else{
        [self.markNewImg_ setHidden:NO];
    }
    
    [self.userImg_ sd_setImageWithURL:[NSURL URLWithString:dataModalOne.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"] options:SDWebImageAllowInvalidSSLCertificates];
    self.timeLb_.text = dataModalOne.idatetime;
}

-(void)setDataModalTwo:(GroupInvite_DataModal *)dataModalTwo{
    _dataModalTwo = dataModalTwo;
    UIView *oldView = [self.contentView_ viewWithTag:1001];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    _nameLb_.hidden = YES;
    _titleLb_.hidden = YES;
    _contentLb_.hidden = YES;
    _titlelableOne.hidden = NO;
    _contentLableOne.hidden = NO;
    
    _titlelableOne.text = dataModalTwo.title;
    _contentLableOne.text = dataModalTwo.content;
    if ([dataModalTwo.is_read isEqualToString:@"1"]) {
        [self.markNewImg_ setHidden:YES];
    }else{
        [self.markNewImg_ setHidden:NO];
    }
    
    [self.userImg_ sd_setImageWithURL:[NSURL URLWithString:dataModalTwo.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"] options:SDWebImageAllowInvalidSSLCertificates];
    self.timeLb_.text = dataModalTwo.idatetime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
