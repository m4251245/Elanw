//
//  RecommendGroups_Cell.m
//  Association
//
//  Created by 一览iOS on 14-4-3.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "RecommendGroups_Cell.h"
#import "BaseUIViewController.h"


@implementation RecommendGroups_Cell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellGiveDataWith:(Groups_DataModal *)dataModal
{
    //self.bgView_.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    //self.bgView_.layer.borderWidth = 0.5;
    
    [self.titleLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:15]];
    [self.infoLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13]];
    [self.memberNumLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
    [self.articleNumLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
    [self.memberLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
    [self.articleLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
    
    [self.titleLb_ setTextColor:UIColorFromRGB(0x333333)];
    [self.infoLb_ setTextColor:UIColorFromRGB(0x808080)];
    [self.memberLb_ setTextColor:UIColorFromRGB(0x666666)];
    [self.articleLb_ setTextColor:UIColorFromRGB(0x666666)];
    [self.memberNumLb_ setTextColor:UIColorFromRGB(0xd20000)];
    [self.articleNumLb_ setTextColor:UIColorFromRGB(0xd20000)];
    
    self.titleLb_.text = dataModal.name_;
    if (dataModal.firstArt_ && dataModal.firstArt_.title_ && ![dataModal.firstArt_.title_ isEqualToString:@""]&&![dataModal.firstArt_.title_ isEqualToString:@"(null)"]) {
        self.infoLb_.text = [NSString stringWithFormat:@"%@",dataModal.firstArt_.title_];
    }
    else
    {
        self.infoLb_.text = @"暂无新动态";
    }
    NSString *pCount = [NSString stringWithFormat:@"%ld ",(long)dataModal.personCnt_];
    NSString *aCount = [NSString stringWithFormat:@"%ld ",(long)dataModal.articleCnt_];
    
    [self.articleNumLb_ setText:aCount];
    [self.memberNumLb_ setText:pCount];
    
    CGSize pSize = [pCount sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10] constrainedToSize:CGSizeMake(80, 16)];
    CGSize aSize = [aCount sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10] constrainedToSize:CGSizeMake(80, 16)];
    
    CGRect pRect = self.memberNumLb_.frame;
    pRect.size.width = pSize.width;
    [self.memberNumLb_ setFrame:pRect];
    
    CGRect ppRect = self.memberLb_.frame;
    ppRect.origin.x = pRect.origin.x + pRect.size.width;
    [self.memberLb_ setFrame:ppRect];
    
    CGRect aRect = self.articleNumLb_.frame;
    aRect.size.width = aSize.width;
    aRect.origin.x = ppRect.origin.x + ppRect.size.width + 20;
    [self.articleNumLb_ setFrame:aRect];
    
    CGRect aaRect = self.articleLb_.frame;
    aaRect.origin.x = aRect.origin.x + aRect.size.width;
    [self.articleLb_ setFrame:aaRect];
    
    self.imgView_.layer.cornerRadius = 2.5;
    self.imgView_.layer.masksToBounds = YES;
    [self.imgView_ sd_setImageWithURL:[NSURL URLWithString:dataModal.pic_] placeholderImage:[UIImage imageNamed:@"icon_zhiysq"]];
    if ([dataModal.openstatus_ isEqualToString:@"3"]) {
        self.privacyImage.hidden = NO;
    }else{
        self.privacyImage.hidden = YES;
    }
}

@end
