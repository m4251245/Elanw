//
//  MyGroups_Cell.m
//  Association
//
//  Created by YL1001 on 14-5-9.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "MyGroups_Cell.h"
#import "BaseUIViewController.h"
#import "ELGroupCommentModel.h"
#import "ELGroupArticleModel.h"


@implementation MyGroups_Cell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code

    [self.contentLb_ setFont:THIRTEENFONT_CONTENT];
    [self.contentLb_ setTextColor:UIColorFromRGB(0x666666)];
    [self.msgCnt_ setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"group_message_lable_backimage"]]];
    self.imgView_.layer.cornerRadius = 2.0;
    self.imgView_.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellGiveDataWithModal:(ELGroupListDetailModel *)dataModal
{
    self.nameLb_.text = [MyCommon removeAllSpace:dataModal.group_name];
    
    [self.nameLb_ setTextColor:UIColorFromRGB(0x333333)];
    
    if ([dataModal._dynamic_cnt integerValue] > 0) {
        self.msgCnt_.alpha = 1.0;

        if ([dataModal._dynamic_cnt integerValue] >=99) {
            [self.msgCnt_ setText:@"99"];
        }else{
            [self.msgCnt_ setText:[NSString stringWithFormat:@"%@",dataModal._dynamic_cnt]];
        }
    }else{
        self.msgCnt_.alpha = 0.0;

    }
    
    if (dataModal._article.count > 0) {
        ELGroupArticleModel *articleModel = dataModal._article[0];
        NSString *str = @"";
        if (articleModel._comment.count > 0) {
            ELGroupCommentModel *commentModel = articleModel._comment[0];
            str = [NSString stringWithFormat:@"%@评论了:%@",commentModel.person_iname,articleModel.title];
        }else{
            str = [NSString stringWithFormat:@"%@发表了:%@",articleModel.person_iname,articleModel.title];
        }
        [self.contentLb_ setText:str];
        self.contentLb_.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    else
    {
        self.contentLb_.text = @"暂无最新动态";
    }
    if ([dataModal.group_open_status isEqualToString:@"3"]){
        self.privacyImage.hidden = NO;
    }else{
        self.privacyImage.hidden = YES;
    }
    
//    dataModal.group_pic = [NSString httpToHttps:dataModal.group_pic];
    
    [self.imgView_ sd_setImageWithURL:[NSURL URLWithString:dataModal.group_pic] placeholderImage:[UIImage imageNamed:@"icon_zhiysq"] options:SDWebImageAllowInvalidSSLCertificates];
    
    
    NSDate * date = [MyCommon getDate:dataModal.updatetime_act_last];
//    self.timeLb.text = [MyCommon compareCurrentTime:date];
    self.timeLb.text = [MyCommon compareCurrentTimePrestige:date currentString:dataModal.updatetime_act_last];
}

@end
