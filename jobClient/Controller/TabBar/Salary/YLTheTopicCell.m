//
//  YLTheTopicCell.m
//  jobClient
//
//  Created by 一览iOS on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLTheTopicCell.h"
#import "YLTheTopicContentView.h"
#import "ELSalaryModel.h"

@implementation YLTheTopicCell
{
    ELSalaryModel *inModal;
}
- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)giveDateModal:(ELSalaryModel *)modal
{
    inModal = modal;
    if (!self.arrListData || self.arrListData.count == 0) {
         self.arrListData = [[NSMutableArray alloc] init];
        [self creatContentBtn];
    }
    else
    {
        for (YLTheTopicContentView *viewTwo in self.arrListData) {
            [viewTwo removeFromSuperview];
        }
    }
    
    self.commentBtn.userInteractionEnabled = NO;
    
    self.joinCountLb.text = [NSString stringWithFormat:@"已有%@人参与过",modal.allVote];
    
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)modal.like_cnt] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",(long)modal.c_cnt] forState:UIControlStateNormal];
    if (modal.isLike_) {
        [self.likeBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"addLikeSeleted.png"] forState:UIControlStateNormal];
    }
    CGSize size = [modal.content sizeNewWithFont:[UIFont systemFontOfSize:15]];
    CGRect frameLb = self.joinTitleLb.frame;
    
    if (size.width > frameLb.size.width) {
        frameLb.size.height = 40;
        _titleLableHeight.constant = 40;
        self.joinTitleLb.numberOfLines = 2;
    }
    else
    {
        frameLb.size.height = 20;
        _titleLableHeight.constant = 20;
        self.joinTitleLb.numberOfLines = 1;
    }
    self.joinTitleLb.text = [MyCommon translateHTML:modal.content];
    
    for (NSInteger i = 0; i < modal.resultDataArr.count; i++)
    {
        YLTheTopicContentView *viewOne = self.arrListData[i];
        YLVoteDataModal *modalOne = modal.resultDataArr[i];
        if ([modalOne.isBest isEqualToString:@"1"])
        {
            viewOne.backView.backgroundColor = UIColorFromRGB(0xffebaf);
        }
        else
        {
            viewOne.backView.backgroundColor = UIColorFromRGB(0xe6e6e6);
        }
        viewOne.frame = CGRectMake(10,frameLb.origin.y + frameLb.size.height + 10 + 45*i,ScreenWidth-20,40);
        viewOne.contentLb.text = [MyCommon translateHTML:modalOne.gaapName];
        [self.contentView addSubview:viewOne];
        [viewOne hideView];
        if ([modal.isVote isEqualToString:@"1"])
        {
            [viewOne showView:[modalOne.result floatValue]];
            viewOne.userInteractionEnabled = NO;
        }
        else
        {
            viewOne.userInteractionEnabled = YES;
        }
    }
    
}
-(void)creatContentBtn
{
    for (NSInteger i = 0; i < 10; i++)
    {
        YLTheTopicContentView *view = [[YLTheTopicContentView alloc] init];
        view.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:tap];
        [self.arrListData addObject:view];
    }
}
-(void)tapGesture:(UITapGestureRecognizer *)sender
{
    if ([inModal.isVote isEqualToString:@"1"]) {
        return;
    }
    else
    {
        for (NSInteger i = 0; i < inModal.resultDataArr.count; i++)
        {
            YLTheTopicContentView *viewOne = self.arrListData[i];
            YLVoteDataModal *modalOne = inModal.resultDataArr[i];
            if ([modalOne.isBest isEqualToString:@"1"])
            {
                viewOne.backView.backgroundColor = UIColorFromRGB(0xffebaf);
            }
            else
            {
                viewOne.backView.backgroundColor = UIColorFromRGB(0xe6e6e6);
            }
            [viewOne showView:[modalOne.result floatValue]];
            viewOne.userInteractionEnabled = NO;
        }
    }
    [self.cellDelegate changeBtnModal:inModal.resultDataArr[sender.view.tag] indexPath:inModal.indexpath];
}

@end
