//
//  MessageListCell.m
//  jobClient
//
//  Created by 一览ios on 15/4/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MessageListCell.h"
#import "MessageCenterDataModel.h"

@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)giveDataModal:(WhoLikeMeDataModal *)modal
{
//    [self.emojiContent removeFromSuperview];
//    self.emojiContent = [self emojiLabel:content numberOfLines:1 textColor:UIColorFromRGB(0xAEAEAE) textFont:TWEELVEFONT_COMMENT];
//    self.emojiContent.frame = CGRectMake(60,37,252,0);
//    [self.emojiContent sizeToFit];
//    CGRect frame = self.emojiContent.frame;
//    frame.size.width = 240;
//    self.emojiContent.frame = frame;
//    
//    [self.contentView addSubview:self.emojiContent];
    
    
    [self.contentLb setAttributedText:modal.contentAttString];
    self.contentLb.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.nameLb.text = modal.person_iname;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:modal.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    self.timeLable.text = [MyCommon getWhoLikeMeListCurrentTime:[MyCommon getDate:modal.idatetime] currentTimeString:modal.idatetime];
//    
//    if(modal.isNewMessage)
//    {
//        self.countLb.text = @"";
//        self.countLb.hidden = NO;
//    }
//    else
//    {
//        self.countLb.text = @"";
//        self.countLb.hidden = YES;
//    }
}

- (MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num textColor:(UIColor *)color textFont:(UIFont *)font
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = font;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

- (void)setMessageType:(MessageCenterDataModel *)model
{
    self.markBgImgView.image = [UIImage imageNamed:@"info_01"];
    ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(72,66,ScreenWidth-72,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [self.contentView addSubview:line];
    
    [self.nameLb setText:model.title];
    
    if ([model.content containsString:@"\n"]) {
        model.content = [model.content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    model.content = [MyCommon translateHTML:model.content];
    NSMutableAttributedString *attString = [model.content getHtmlAttString];
    [attString addAttributes:@{
                               NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:14],
                               NSForegroundColorAttributeName:UIColorFromRGB(0x888888)
                               }
                       range:NSMakeRange(0,attString.length)];
    [self.contentLb setAttributedText:attString];
    self.contentLb.lineBreakMode = NSLineBreakByTruncatingTail;
    if ([model.count integerValue] > 0) {
        if ([model.count integerValue]> 99) {
            [self.countLb setText:@"···"];
        }else{
            [self.countLb setText:model.count];
        }
        [self.countLb setHidden:NO];
        [self.markBgImgView setHidden:NO];
    }else{
        [self.countLb setHidden:YES];
        [self.markBgImgView setHidden:YES];
    }
    if ([model.type isEqualToString:@"sys_msg"]) {
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_xiaoxi_xitong.png"]];
        [self.nameLb setTextColor:Color(223, 61, 65, 1)];
    }else if ([model.type isEqualToString:@"aide_msg"]) {
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_xiaoxi_aide.png"]];
        [self.nameLb setTextColor:Color(223, 61, 65, 1)];
    }else if ([model.type isEqualToString:@"group_msg"]) {
        [self.nameLb setTextColor:[UIColor blackColor]];
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_xiaoxi_shequn.png"]];
    }else if ([model.type isEqualToString:@"article_cnt"]) {
        [self.nameLb setTextColor:[UIColor blackColor]];
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_xiaoxi_fabiao.png"]];
    }else if ([model.type isEqualToString:@"comment_msg"]) {
        [self.nameLb setTextColor:[UIColor blackColor]];
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_xiaoxi_pinglun.png"]];
    }else if ([model.type isEqualToString:@"follow_msg"]) {
        [self.nameLb setTextColor:[UIColor blackColor]];
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_xiaoxi_guanzhu.png"]];
    }
    else if ([model.type isEqualToString:@"praise_msg"])
    {
        [self.nameLb setTextColor:[UIColor blackColor]];
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_xiaoxi_dianzan.png"]];
    }else if ([model.type isEqualToString:@"oa_msg"]){
        [self.nameLb setTextColor:[UIColor blackColor]];
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_xiaoxi_OA.png"]];
    }
    else if ([model.type isEqualToString:@"yuetan_msg"])
    {
        [self.nameLb setTextColor:[UIColor blackColor]];
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_xiaoxi_yuetan.png"]];
    }
    else if ([model.type isEqualToString:@"dashang_msg"])
    {
        [self.nameLb setTextColor:[UIColor blackColor]];
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_reward.png"]];
    }
    else if ([model.type isEqualToString:@"offerpai_msg"])
    {//offer派
        [self.nameLb setTextColor:[UIColor blackColor]];
        [self.imagev setImage:[UIImage imageNamed:@"ios_icon_offerpai.png"]];
    }

}

@end
