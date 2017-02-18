//
//  SameTradeTipsCell.m
//  jobClient
//
//  Created by 一览iOS on 14-10-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SameTradeTipsCell.h"
#import "NewCommentMsgModel.h"
#import "Status_DataModal.h"

@implementation SameTradeTipsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundView_.layer.borderWidth = 0.5;
    self.backgroundView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    //样式
    [self.titleLb_ setFont:FIFTEENFONT_TITLE];
    [self.titleLb_ setTextColor:BLACKCOLOR];
    [self.contentLb_ setFont:FOURTEENFONT_CONTENT];
    [self.contentLb_ setTextColor:LIGHTGRAYCOLOR];
    [self.tipsCountLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:9]];
    self.tipsCountLb_.layer.cornerRadius = 10.0;
    self.tipsCountLb_.layer.masksToBounds = YES;
}

-(void)setDataModel:(id)dataModel
{
    if ([dataModel isKindOfClass:[NewCommentMsgModel class]]) {
        NewCommentMsgModel *commentModel = dataModel;
        [self.markImgv_ setImage:[UIImage imageNamed:@"newcomments.png"]];
        [self.titleLb_ setText:@"谁评论了我的文章"];
        [self.contentLb_ setText:[NSString stringWithFormat:@"%@:%@",commentModel.name_,commentModel.commentcontent_]];
        [self.tipsCountLb_ setText:commentModel.totalCount_];
        
        [self.voiceImgv_ setHidden:NO];
        [self.contentLb_ setHidden:NO];
        [self.friendView_ setHidden:YES];
        
        if ([commentModel.totalCount_ isEqualToString:@"0"]) {
            [self.tipsCountLb_ setHidden:YES];
        }else{
            [self.tipsCountLb_ setHidden:NO];
        }
    }else if ([dataModel isKindOfClass:[Status_DataModal class]]){
        Status_DataModal *newFirendModel = dataModel;
        [self.voiceImgv_ setHidden:YES];
        [self.contentLb_ setHidden:YES];
        [self.friendView_ setHidden:NO];
        [self.markImgv_ setImage:[UIImage imageNamed:@"newfriends.png"]];
        [self.titleLb_ setText:@"新的朋友"];
        [self.tipsCountLb_ setText:newFirendModel.exObj_];
        if ([newFirendModel.exObj_ isEqualToString:@"0"]){
            [self.tipsCountLb_ setHidden:YES];
        }else{
            [self.tipsCountLb_ setHidden:NO];
        }
        for (int i=0;i<[newFirendModel.exObjArr_ count]; i++) {
            NSString *imgUrl = [newFirendModel.exObjArr_ objectAtIndex:i];
            UIImageView *imageView = (UIImageView *)[self.friendView_ viewWithTag:301+i];
            imageView.layer.cornerRadius = 2.0;
            imageView.layer.masksToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
