//
//  SalaryIrrigationCtl_Cell.m
//  jobClient
//
//  Created by YL1001 on 14/11/21.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SalaryIrrigationCtl_Cell.h"
#import "ELSalaryModel.h"

@interface SalaryIrrigationCtl_Cell()

@end

@implementation SalaryIrrigationCtl_Cell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)giveDataCellWithModal:(ELSalaryModel *)dataModal type:(NSInteger)type
{
    
    [self.commentCntBtn_ setImage:[UIImage imageNamed:@"groupArticleCommentNormal.png"] forState:UIControlStateNormal];
    [self.shareBtn_ setImage:[UIImage imageNamed:@"groupShareNormal.png"] forState:UIControlStateNormal];
    
    [self.commentCntBtn_ setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    [self.shareBtn_ setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    [self.commentCntBtn_ setTitle:[NSString stringWithFormat:@"%ld",(long)dataModal.c_cnt] forState:UIControlStateNormal];
    
    if (dataModal.isLike_) {
        [self.likeBtn_ setSelected:YES];
        self.likeBtn_.userInteractionEnabled = NO;
        [self.likeBtn_ setImage:[UIImage imageNamed:@"addLikeSeleted.png"] forState:UIControlStateNormal];
        [self.likeBtn_ setTitleColor:UIColorFromRGB(0xF32913) forState:UIControlStateNormal];
        [self.likeBtn_ setTitle:[NSString stringWithFormat:@"%ld",(long)dataModal.like_cnt] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeBtn_ setSelected:NO];
        self.likeBtn_.userInteractionEnabled = YES;
        [self.likeBtn_ setImage:[UIImage imageNamed:@"addLikeNormal.png"] forState:UIControlStateNormal];
        [self.likeBtn_ setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        [self.likeBtn_ setTitle:[NSString stringWithFormat:@"%ld",(long)dataModal.like_cnt] forState:UIControlStateNormal];
    }
    
    
    CGFloat heightLabel = 25;
    
    [self.sourceLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
    [self.isJingLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
    
    if (dataModal.is_jing && ![dataModal.is_jing isEqualToString:@""]) {
        [self.isJingLb_ setText:dataModal.is_jing];
        self.isJingLb_.layer.masksToBounds = YES;
        [self.isJingLb_.layer setCornerRadius:2.0];
        CGSize size = [dataModal.is_jing sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
        CGRect rect = self.isJingLb_.frame;
        rect.size.width = size.width + 6;
        self.isJingLb_.frame = rect;
        self.isJingLb_.alpha = 1.0;
        self.huoImage_.alpha = 1.0;
        heightLabel = self.isJingLb_.frame.size.height + self.isJingLb_.frame.origin.y + 15;
    }
    else
    {
        self.isJingLb_.alpha = 0.0;
        self.huoImage_.alpha = 0.0;
    }
    
    
    if (dataModal.is_system && ![dataModal.is_system isEqualToString:@""]) {
        [self.sourceLb_ setText:[MyCommon translateHTML:dataModal.is_system]];
        self.sourceLb_.layer.masksToBounds = YES;
        [self.sourceLb_.layer setCornerRadius:2.0];
        CGSize size = [dataModal.is_system sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
        CGRect rect = self.sourceLb_.frame;
        if (size.width < ScreenWidth-40) {
            rect.size.width = size.width + 6;
        }
        else
        {
            rect.size.width = ScreenWidth-40;
        }
        rect.origin.y = heightLabel;
        self.sourceLb_.frame = rect;
        self.sourceLb_.alpha = 1.0;
        heightLabel += self.sourceLb_.frame.size.height + 15;
    }
    else
    {
        self.sourceLb_.alpha = 0.0;
    }
    
    [self.emojiLb removeFromSuperview];
    
    UIColor *color = UIColorFromRGB(0x333333);
    
    if (type == 2) {
        color = [UIColor whiteColor];
        
        self.emojiLb = [self emojiLabel:dataModal.content numberOfLines:5 textColor:color];
        self.emojiLb.frame = CGRectMake(30,50,ScreenWidth-40,140);
        
        [self.shareBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.commentCntBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.likeBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.shareBtn_ setImage:[UIImage imageNamed:@"ios_icon_list_fenxiang"] forState:UIControlStateNormal];
        [self.commentCntBtn_ setImage:[UIImage imageNamed:@"ios_icon_list_pinglun"] forState:UIControlStateNormal];
        [self.likeBtn_ setImage:[UIImage imageNamed:@"ios_icon_list_dianzan"] forState:UIControlStateNormal];
        
        self.shareImage.image = [UIImage imageNamed:@"ios_icon_list_xiankuang2"];
        self.commentImage.image = [UIImage imageNamed:@"ios_icon_list_xiankuang2"];
        self.likeImage.image = [UIImage imageNamed:@"ios_icon_list_xiankuang2"];
        
        CGRect shareFrame = self.shareBtn_.frame;
        shareFrame.origin.y = 199;
        self.shareBtn_.frame = shareFrame;
        
        shareFrame = self.commentCntBtn_.frame;
        shareFrame.origin.y = 199;
        shareFrame.origin.x = (ScreenWidth-shareFrame.size.width)/2;
        self.commentCntBtn_.frame = shareFrame;
        
        shareFrame = self.likeBtn_.frame;
        shareFrame.origin.y = 199;
        shareFrame.origin.x = ScreenWidth-(shareFrame.size.width+20);
        self.likeBtn_.frame = shareFrame;
        
        shareFrame = self.shareImage.frame;
        shareFrame.origin.y = 202;
        self.shareImage.frame = shareFrame;
        
        shareFrame = self.commentImage.frame;
        shareFrame.origin.y = 202;
        shareFrame.origin.x = (ScreenWidth-shareFrame.size.width)/2;
        self.commentImage.frame = shareFrame;
        
        shareFrame = self.likeImage.frame;
        shareFrame.origin.y = 202;
        shareFrame.origin.x = ScreenWidth-(shareFrame.size.width+20);
        self.likeImage.frame = shareFrame;
        
        self.backGroudView.frame = CGRectMake(0,0,ScreenWidth,246);
        
        [self.contentView addSubview:self.emojiLb];
    }
    else
    {
        NSInteger line = 5;
        if (dataModal.isSalaryDetail) {
            line = 0;
        }
        self.emojiLb = [self emojiLabel:dataModal.content numberOfLines:line textColor:color];
        self.emojiLb.frame = CGRectMake(30,heightLabel,ScreenWidth-60,0);
        [self.emojiLb sizeToFit];
        
        CGRect frame = self.emojiLb.frame;
        if (frame.size.width < ScreenWidth-60) {
            frame.origin.x = 30 + (ScreenWidth-60 - frame.size.width)/2;
        }
        self.emojiLb.frame = frame;
        [self.contentView addSubview:self.emojiLb];
        
        
        
        CGRect shareFrame = self.shareBtn_.frame;
        shareFrame.origin.y = self.emojiLb.frame.size.height + self.emojiLb.frame.origin.y + 20;
        self.shareBtn_.frame = shareFrame;
        
        shareFrame = self.commentCntBtn_.frame;
        shareFrame.origin.y = self.emojiLb.frame.size.height + self.emojiLb.frame.origin.y + 20;
        shareFrame.origin.x = ScreenWidth/2-25;
        self.commentCntBtn_.frame = shareFrame;
        
        shareFrame = self.likeBtn_.frame;
        shareFrame.origin.y = self.emojiLb.frame.size.height + self.emojiLb.frame.origin.y + 20;
        shareFrame.origin.x = ScreenWidth-90;
        self.likeBtn_.frame = shareFrame;
        
        shareFrame = self.shareImage.frame;
        shareFrame.origin.y = self.emojiLb.frame.size.height + self.emojiLb.frame.origin.y + 22;
        self.shareImage.frame = shareFrame;
        
        shareFrame = self.commentImage.frame;
        shareFrame.origin.y = self.emojiLb.frame.size.height + self.emojiLb.frame.origin.y + 22;
        shareFrame.origin.x = ScreenWidth/2-25;
        self.commentImage.frame = shareFrame;
        
        shareFrame = self.likeImage.frame;
        shareFrame.origin.y = self.emojiLb.frame.size.height + self.emojiLb.frame.origin.y + 22;
        shareFrame.origin.x = ScreenWidth-90;
        self.likeImage.frame = shareFrame;
        
        shareFrame = self.backGroudView.frame;
        shareFrame.size.height = self.emojiLb.frame.size.height + 60 + heightLabel;
        self.backGroudView.frame = CGRectMake(0, 0, ScreenWidth, shareFrame.size.height);
    }
}

-(void)giveDataCellWithModal:(ELSalaryModel *)dataModal
{
    [self giveDataCellWithModal:dataModal type:1];
}

-(MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(NSInteger)num textColor:(UIColor *)color
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = FIFTEENFONT_TITLE;
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    emojiLabel.lineSpacing = 10.0;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

@end
