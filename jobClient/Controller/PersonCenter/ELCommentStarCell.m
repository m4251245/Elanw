//
//  ELCommentStarCell.m
//  jobClient
//
//  Created by 一览iOS on 15/11/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELCommentStarCell.h"


@implementation ELCommentStarCell

- (void)awakeFromNib
{
    self.titleImage.clipsToBounds = YES;
    self.titleImage.layer.cornerRadius = 3.0;
    
    for (NSInteger i= 0; i<5; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.frame = CGRectMake(20*i,0,20,20);
        btn.tag = 100+i;
        [btn setImage:[UIImage imageNamed:@"jobstarthree"] forState:UIControlStateNormal];
        [self.starView addSubview:btn];
    }
    [super awakeFromNib];
}

-(void)giveDataModal:(Expert_DataModal *)model
{
//    dataModal.commentList.zpcId = dataDic[@"zpc_id"];
//    dataModal.commentList.zpcPersonId = dataDic[@"zpc_person_id"];
//    dataModal.commentList.zpcExpertId = dataDic[@"zpc_expert_id"];
//    dataModal.commentList.content_ = dataDic[@"zpc_content"];
//    dataModal.commentList.zpcType = dataDic[@"zpc_type"];
//    dataModal.commentList.zpcTypeId = dataDic[@"zpc_type_id"];
//    dataModal.commentList.datetime_ = dataDic[@"idatetime"];
//    dataModal.commentList.zpcStar = dataDic[@"zpc_star"];
//    
//    dataModal.appraiser.id_ = dataDic[@"_person_detail"][@"personId"];
//    dataModal.appraiser.iname_ = dataDic[@"_person_detail"][@"person_iname"];
//    dataModal.appraiser.nickname_ = dataDic[@"_person_detail"][@"person_nickname"];
//    dataModal.appraiser.img_ = dataDic[@"_person_detail"][@"person_pic"];
//    dataModal.appraiser.zw_ = dataDic[@"_person_detail"][@"person_zw"];
    
    CGSize size = [model.appraiser.iname_ sizeNewWithFont:self.titleLb.font];
    self.titleLb.text = model.appraiser.iname_;
    
    CGRect frame = self.titleLb.frame;
    frame.size.width = size.width <= (ScreenWidth-170) ? size.width:(ScreenWidth-170);
    self.titleLb.frame = frame;
    
    self.timeLb.text = model.commentList.datetime_;
    frame = self.timeLb.frame;
    frame.origin.x = CGRectGetMaxX(self.titleLb.frame) + 3;
    self.timeLb.frame = frame;
    
    [self giveDataWithStar:[model.commentList.zpcStar floatValue]];
    
    size = [model.commentList.content_ sizeNewWithFont:self.contentLb.font constrainedToSize:CGSizeMake(ScreenWidth-60,100000)];
    self.contentLb.frame = CGRectMake(50,47,ScreenWidth-55,size.height+5);
    self.contentLb.text = model.commentList.content_;
    
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:model.appraiser.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    
    
     //"type": 1表示个人评价 没有_product_info为空 10表示为问答评论 20表示为约谈评论
    if ([model.commentList.zpcType isEqualToString:@"20"]) {
        self.sourceLb.text = [NSString stringWithFormat:@"来自约谈：%@",model.commentList.zpcTitle];
    }
    else if ([model.commentList.zpcType isEqualToString:@"10"])
    {
        self.sourceLb.text = [NSString stringWithFormat:@"来自问答：%@",model.commentList.zpcTitle];
    }
    
    self.sourceLb.frame = CGRectMake(50, CGRectGetMaxY(self.contentLb.frame), ScreenWidth-55, 21);
    
    
    if ([model.commentList.zpcTitle isEqualToString:@""] || [model.commentList.zpcType isEqualToString:@"1"]) {
        self.sourceLb.hidden = YES;
        self.lineImage.frame = CGRectMake(0,CGRectGetMaxY(self.contentLb.frame)+7,ScreenWidth,1);
    }
    else
    {
        self.sourceLb.hidden = NO;
        self.lineImage.frame = CGRectMake(0,CGRectGetMaxY(self.sourceLb.frame)+7,ScreenWidth,1);
    }
}

-(void)giveDataWithStar:(CGFloat)star
{
    for (NSInteger i = 1; i<=5; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:99+i];
        if (i <= star) {
            [btn setImage:[UIImage imageNamed:@"icon_zhuye_redstar"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"icon_zhuye_graystar"] forState:UIControlStateNormal];
        }
        
//        if (star > i-1 && star < i)
//        {
//            [btn setImage:[UIImage imageNamed:@"jobstartwo"] forState:UIControlStateNormal];
//        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
