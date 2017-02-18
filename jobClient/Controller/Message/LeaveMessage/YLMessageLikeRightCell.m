//
//  YLMessageLikeRightCell.m
//  jobClient
//
//  Created by 一览iOS on 15/5/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLMessageLikeRightCell.h"

@implementation YLMessageLikeRightCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    UIImage *bgImage = [UIImage imageNamed:@"icon_message_right.png"];
    [self.backBtn setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.4 topCapHeight:bgImage.size.height*0.8] forState:UIControlStateNormal];
    [self sendSubviewToBack:self.backBtn];
    CALayer *layer = _titleImageBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    layer = _cotentImageBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)giveDataModal:(LeaveMessage_DataModel *)modal
{
    Article_DataModal *dataModal = modal.otherModel;
    if (!modal.date) {
        _timeLable.hidden = YES;
    }else{
        _timeLable.text = modal.date;
    }
    
    CGSize pSize = [modal.date sizeNewWithFont:[UIFont systemFontOfSize:9]];
    _timeLable.frame = CGRectMake((ScreenWidth - pSize.width)/2,10,pSize.width+5,11);
    _timeLable.clipsToBounds = YES;
    _timeLable.layer.cornerRadius = 4.0;

    [_titleEmoji removeFromSuperview];
    [_contentEmoji removeFromSuperview];
    
    _titleEmoji = [self emojiLabel:dataModal.title_ numberOfLines:1 textColor:[UIColor blackColor] textFont:THIRTEENFONT_CONTENT];
    _titleEmoji.frame = CGRectMake(70,72,ScreenWidth-130,20);
    //[_titleEmoji sizeToFit];
    [self.contentView addSubview:_titleEmoji];
    
    if (modal.messageType == MessageTypeLikeArticle || modal.messageType == MessageTypeGroupArticle)
    {
        if (modal.messageType == MessageTypeGroupArticle) {
            _titleLable.text = @"文章";
        }
        else
        {
           _titleLable.text = @"赞了你的话题";
        }
        _cotentImageBtn.hidden = NO;
        [_cotentImageBtn sd_setImageWithURL:[NSURL URLWithString:dataModal.thum_] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen2-1"]];
        
//        dataModal.summary_ = [NSString stringWithFormat:@"&#161;&#165;&yen;%@",dataModal.summary_];
        dataModal.summary_ = [MyCommon translateHTML:dataModal.summary_];
        _contentEmoji = [self emojiLabel:dataModal.summary_ numberOfLines:2 textColor:[UIColor lightGrayColor] textFont:THIRTEENFONT_CONTENT];
        _contentEmoji.frame = CGRectMake(115,98,ScreenWidth-180,0);
        [_contentEmoji sizeToFit];
             
        [self.contentView addSubview:_contentEmoji];
    }
    else if(modal.messageType == MessageTypeLikeComment)
    {
            _titleLable.text = @"赞了你的评论";
        _cotentImageBtn.hidden = YES;
        dataModal.content_ = [MyCommon translateHTML:dataModal.content_];
        _contentEmoji = [self emojiLabel:[NSString stringWithFormat:@"你的评论:%@",dataModal.content_] numberOfLines:2 textColor:[UIColor lightGrayColor] textFont:THIRTEENFONT_CONTENT];
        _contentEmoji.frame = CGRectMake(70,98,ScreenWidth-130,0);
        [_contentEmoji sizeToFit];
        [self.contentView addSubview:_contentEmoji];
    }
    
    [_titleImageBtn sd_setImageWithURL:[NSURL URLWithString:modal.personPic] forState:UIControlStateNormal placeholderImage:nil];
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

@end
