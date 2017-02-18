//
//  ExpertListCell.m
//  jobClient
//
//  Created by YL1001 on 15/7/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ExpertListCell.h"

@implementation ExpertListCell

@synthesize expertHonorLb_,expertImg_, expertName_,adeptLb_;
//,dashLine_,professionLb_;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self initLayuot];
}

//初始化控件
-(void)initLayuot{
    
    _regionView.layer.cornerRadius = 2.0;
    _regionView.layer.masksToBounds = YES;
    
    expertImg_.layer.masksToBounds = YES;
    
    [expertName_ setAdjustsImageWhenHighlighted:NO];
}

- (void)setExpertHonorLbFrame:(JobGuideExpertModal *)dataModal
{
    if (dataModal.expertType == 0)
    {
        if ([dataModal.person_type isEqualToString:@"2"]) {
            _typeImg.image = [UIImage imageNamed:@"zhiyejingjiren"];
        }
        else if ([dataModal.person_type isEqualToString:@"1"])
        {
            _typeImg.image = [UIImage imageNamed:@"zhiyefazhandaoshi.png"];
        }
    }
    else if (dataModal.expertType == 1)
    {
        _typeImg.image = [UIImage imageNamed:@"zhiyefazhandaoshi.png"];
    }
    else if (dataModal.expertType == 2)
    {
        _typeImg.image = [UIImage imageNamed:@"zhiyejingjiren"];
    }

    if (![dataModal.person_region isEqualToString:@""]) {
        _regionView.hidden = NO;
        _regionBtn.hidden = NO;
        [_regionBtn setTitle:dataModal.person_region forState:UIControlStateNormal];
    }
    else
    {
        _regionView.hidden = YES;
        _regionBtn.hidden = YES;
    }
    
//    NSString *defaultImgStr;
//    if (dataModal.expertType == 0)
//    {
//        if ([dataModal.person_type isEqualToString:@"2"]) {
//            defaultImgStr = @"img_ProAgent_ avatar.png";
//        }
//        else if ([dataModal.person_type isEqualToString:@"1"])
//        {
//            defaultImgStr = @"expertImg.jpg";
//        }
//    }
//    else if (dataModal.expertType == 1)
//    {
//        defaultImgStr = @"expertImg.jpg";
//    }
//    else if (dataModal.expertType == 2)
//    {
////        defaultImgStr = @"img_ProAgent_avatar.png";
//        expertImg_.backgroundColor = UIColorFromRGB(0xd9d7ce);
//    }
    expertImg_.backgroundColor = UIColorFromRGB(0xd9d7ce);
    [self.mumAtivity startAnimating];
    [self.expertImg_ sd_setImageWithURL:[NSURL URLWithString:dataModal.photo] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.mumAtivity stopAnimating];
    }];
    
    //话题标题
    NSString *courseTitle = [MyCommon translateHTML:dataModal.course_info[@"course_title"]];
    
    if (courseTitle && ![courseTitle isEqualToString:@""]) {
        _courseTitleBgImg.hidden = NO;
        _courseTitle.hidden = NO;
        _courseTitle.text = courseTitle;
        _courseImg.hidden = NO;
    }
    else{
        _courseTitle.hidden = YES;
        _courseTitleBgImg.hidden = YES;
        _courseImg.hidden = YES;
    }
    
    expertHonorLb_.text = [MyCommon translateHTML:dataModal.person_zw];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
