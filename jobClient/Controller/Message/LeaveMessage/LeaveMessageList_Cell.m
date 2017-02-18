//
//  LeaveMessageList_Cell.m
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "LeaveMessageList_Cell.h"
#import "MessageContact_DataModel.h"
#import "MyConfig.h"
#import "MLEmojiLabel.h"
#import "NSString+Size.h"
#import "UIImageView+WebCache.h"

#import "ELNewNewsListVO.h"
#import "ELNewNewsInfoVO.h"

#import "ELNewsListDAO.h"

//#define CELL_MARGIN 10

@interface LeaveMessageList_Cell(){
    NSDictionary *iconDic;
    NSArray *iconArr;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeft;

@end

@implementation LeaveMessageList_Cell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setAttr];
    
    iconDic = @{@"sys_msg":@"ios_icon_xiaoxi_xitong@2x",@"comment_msg":@"ios_icon_xiaoxi_pinglun@2x",@"article_msg":@"ios_icon_xiaoxi_fabiao@2x",@"follow_msg":@"ios_icon_xiaoxi_guanzhu@2x",@"praise_msg":@"ios_icon_xiaoxi_dianzan@2x",@"yuetan_msg":@"ios_icon_xiaoxi_yuetan@2x",@"dashang_msg":@"ios_icon_reward@2x",@"oa_msg":@"ios_icon_xiaoxi_OA@2x",@"spec_private_msg":@"ios_icon_xiaoxi_zhedie@2x",@"group_msg":@"ios_icon_xiaoxi_shequn@2x"};
    iconArr = @[@"sys_msg",@"comment_msg",@"article_msg",@"follow_msg",@"praise_msg",@"yuetan_msg",@"dashang_msg",@"oa_msg",@"spec_private_msg",@"group_msg"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setAttr
{
    /*
    UIView *backgroundView = [[UIView alloc]init];
    CALayer *bgLayer = backgroundView.layer;
    bgLayer.borderWidth = 0.5;
    bgLayer.borderColor = [UIColor colorWithRed:200.0/225 green:200.0/225 blue:200.0/225 alpha:1.0].CGColor;
    bgLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.backgroundView = backgroundView;
     */

    CALayer *layer = _picImg.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4.0];
}
/*
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = CELL_MARGIN;
    frame.size.width -= CELL_MARGIN*2;
    frame.origin.y += CELL_MARGIN;
    frame.size.height -= CELL_MARGIN;
    [super setFrame:frame];
}
*/

//处理‘\n’
-(NSString *)dealRerunStr:(NSString *)detailStr{
    if ([detailStr containsString:@"\n"]) {
        NSArray *arr = [detailStr componentsSeparatedByString:@"\n"];
        NSString *str = [arr componentsJoinedByString:@""];
        return str;
    }
    return detailStr;
}
 
- (void)setMessageContact:(ELNewNewsListVO *)contact
{
    NSString *numKey = nil;
    if (contact.infoId.length > 0) {
        numKey = [NSString stringWithFormat:@"%@_%@",contact.infoId,[Manager getUserInfo].userId_];
    }
    else{
        numKey = [NSString stringWithFormat:@"%@_%@",contact.type,[Manager getUserInfo].userId_];
    }
    
    ELNewNewsInfoVO *infoVo = contact.info;
    if ([infoVo isKindOfClass:[NSObject class]]) {
        if ([iconArr containsObject:contact.type]) {
            [_picImg sd_setImageWithURL:[NSURL URLWithString:infoVo.pic] placeholderImage:[UIImage imageNamed:iconDic[contact.type]]];
        }
        else{
            [_picImg sd_setImageWithURL:[NSURL URLWithString:infoVo.pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        }
    }
    else{
        if ([iconArr containsObject:contact.type]) {
            [_picImg sd_setImageWithURL:[NSURL URLWithString:infoVo.pic] placeholderImage:[UIImage imageNamed:iconDic[contact.type]]];
        }
        else{
            [_picImg setImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        }
    }
    _picImg.frame = CGRectMake(10, 13, 40, 40);
    
    NSNumber *isNew = contact.cnt;
    NSNumber *isExpert = infoVo.is_expert;
    _numRedIcon.hidden = NO;
    if ([isNew integerValue] > 99) {
        [_numRedIcon setBackgroundImage:[UIImage imageNamed:@"message_new_double@2x.png"] forState:UIControlStateNormal];
        [_numRedIcon setTitle:@"99+" forState:UIControlStateNormal];
        _iconLeft.constant = 32;
    }else if([isNew integerValue] > 10){
        [_numRedIcon setBackgroundImage:[UIImage imageNamed:@"message_new_double@2x.png"] forState:UIControlStateNormal];
        [_numRedIcon setTitle:[NSString stringWithFormat:@"%@",isNew] forState:UIControlStateNormal];
        _iconLeft.constant = 32;
    }
    else if([isNew integerValue] > 0){
        [_numRedIcon setBackgroundImage:[UIImage imageNamed:@"message_new@2x.png"] forState:UIControlStateNormal];
        [_numRedIcon setTitle:[NSString stringWithFormat:@"%@",isNew] forState:UIControlStateNormal];
        _iconLeft.constant = 37;
    }
    else{
        _numRedIcon.hidden = YES;
    }
//    CGRect frame = _userName.frame;
    
    if ([isExpert integerValue] != 1) {
        _isExpertImg.hidden = YES;
        _userNameLeftToImg.constant = 8;
    }else{
        _isExpertImg.hidden = NO;
        _userNameLeftToImg.constant = 25;
    }
//    _userName.frame = frame;
//    _userName.font = FOURTEENFONT_CONTENT;
    _userName.text = contact.title;
    
    CGSize size = CGSizeZero;
//
    size = [contact.title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"STHeitiSC-Light" size:16],NSFontAttributeName, nil]];
//
    CGRect rect = _userName.frame;
    rect.size.width = size.width;
//    [_userName setFrame:rect];
//    [_userName sizeToFit];
    //需要判断一下是否是Hr  gw
    if ([infoVo.is_zp  isEqual: @(1)]) {
        CGRect hrMarkImageRect = _hrMarkImagev.frame;
        hrMarkImageRect.origin.x = rect.size.width + rect.origin.x + 2;
        [_hrMarkImagev setFrame:hrMarkImageRect];
        _hrMarkImagev.layer.cornerRadius = 2.0;
        _hrMarkImagev.layer.masksToBounds = YES;
        [_hrMarkImagev setHidden:NO];
        [_hrMarkImagev setText:@"顾问"];
    } else if ([infoVo.is_hr isEqual:@(2)]){
        _hrMarkImagev.layer.cornerRadius = 2.0;
        _hrMarkImagev.layer.masksToBounds = YES;
        CGRect hrMarkImageRect = _hrMarkImagev.frame;
        hrMarkImageRect.origin.x = rect.size.width + rect.origin.x + 2;
        [_hrMarkImagev setFrame:hrMarkImageRect];
        [_hrMarkImagev setHidden:NO];
        [_hrMarkImagev setText:@"企业"];
    }else{
        [_hrMarkImagev setHidden:YES];
    }
    
    
    _dateTime.font = TWEELVEFONT_COMMENT;
    _dateTime.text = [contact.time substringWithRange:NSMakeRange(5,11)];
    UIView *view = [self.contentView viewWithTag:222];
    if (view) {
        [view removeFromSuperview];
        
    }
    NSString *tempStr = [[contact.content componentsSeparatedByString:@"#"] firstObject];
    if ([tempStr hasPrefix:@"http://"] && [tempStr hasSuffix:@".aac"]) {
        tempStr = @"[语音消息]"; 
    }else{
        tempStr = [self dealRerunStr:contact.content];
        tempStr = [MyCommon translateHTML:tempStr];
        tempStr = [MyCommon MyfilterHTML:tempStr];
    }
    
//    _msgLb.text = tempStr;
    MLEmojiLabel *emojiLabel = [self emojiLabel:tempStr numberOfLines:1 textColor:[UIColor colorWithRed:160.0/255 green:160.0/255 blue:160.0/255 alpha:1.0]];
    emojiLabel.frame = CGRectMake(0, 0,ScreenWidth - 90 , 0);
    [emojiLabel sizeToFit];
    emojiLabel.frame = CGRectMake(65,34,ScreenWidth - 90,emojiLabel.frame.size.height+4);
    emojiLabel.tag = 222;
    [self.contentView addSubview: emojiLabel];
    _msgLb.hidden = YES;
}

- (MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num textColor:(UIColor *)color
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = FOURTEENFONT_CONTENT;
    emojiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor whiteColor];
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    if (_inEditing) {
        for (UIView *view in self.contentView.subviews) {
            CGRect frame = view.frame;
            frame.origin.x += 70;
            view.frame = frame;
        }
    }
    _inEditing = NO;
}

@end
