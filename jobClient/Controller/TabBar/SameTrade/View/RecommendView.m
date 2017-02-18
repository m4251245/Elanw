//
//  RecommendView.m
//  jobClient
//
//  Created by 一览ios on 15/8/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RecommendView.h"
#import "MyConfig.h"

@interface RecommendView()
{
    __weak IBOutlet UIImageView *imageV;
    
    __weak IBOutlet UILabel *titleLb;
    
    __weak IBOutlet UILabel *detailLb;
    
    __weak IBOutlet UIImageView *isNewImgv;

    __weak IBOutlet NSLayoutConstraint *titleRightWidth;
    __weak IBOutlet UIView *backView;
}
@end

@implementation RecommendView


-(instancetype)init{
    self = [[NSBundle mainBundle]loadNibNamed:@"RecommendView" owner:self options:nil][0];
    if (self) {
         [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recommendViewTap:)]];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3.0;
    }
    return self;
}

-(void)recommendViewTap:(UITapGestureRecognizer *)sender{
    if (_btnBlick) {
        _btnBlick(_type);
    }
}

-(void)setType:(NSString *)type{
    _type = type;
    isNewImgv.hidden = YES;
     titleRightWidth.constant = 5;
    if ([type isEqualToString:@"offer"]) {
        imageV.image = [UIImage imageNamed:@"index_offer.png"];
        titleLb.text = @"Offer 派";
        detailLb.text = @"现场拿Offer 只需4小时";
        isNewImgv.hidden = NO;
        titleRightWidth.constant = 30;
    }else if ([type isEqualToString:@"fujzw"]) {
        imageV.image = [UIImage imageNamed:@"index_near.png"];
        titleLb.text = @"附近职位";
        detailLb.text = @"下一份工作 离家近点";
    }else if ([type isEqualToString:@"jianlzz"]) {
        imageV.image = [UIImage imageNamed:@"index_resume.png"];
        titleLb.text = @"简历制作";
        detailLb.text = @"一份好简历 一份好工作";
    }else if ([type isEqualToString:@"gongsbg"]) {
        imageV.image = [UIImage imageNamed:@"index_company_msg.png"];
        titleLb.text = @"公司内幕";
        detailLb.text = @"深度八卦，尽收眼底";
    }
    else if ([type isEqualToString:@"yilzt"]) {
        imageV.image = [UIImage imageNamed:@"index_resume_recommend.png"];
        titleLb.text = @"一览直推";
        detailLb.text = @"精准推荐 让你任性求职";
    }else if ([type isEqualToString:@"hangjzz"]) {
        imageV.image = [UIImage imageNamed:@"index_job_guide.png"];
        titleLb.text = @"行家支招";
        detailLb.text = @"有梦想 就要努力";
    }else if ([type isEqualToString:@"jingjr"]) {
        imageV.image = [UIImage imageNamed:@"index_job_advisor.png"];
        titleLb.text = @"职业经纪人";
        detailLb.text = @"专属你的职场管家";
    }else if ([type isEqualToString:@"wgz"]) {
        imageV.image = [UIImage imageNamed:@"index_weiguzhu.png"];
        titleLb.text = @"微雇主";
        detailLb.text = @"您专属的移动招聘平台";
    }else if ([type isEqualToString:@"zhiyeghs"]) {
        imageV.image = [UIImage imageNamed:@"index_zhiyeghs.png"];
        titleLb.text = @"职业发展导师";
        detailLb.text = @"行家约谈 助力职场";
    }else if ([type isEqualToString:@"shyg"]) {
        imageV.image = [UIImage imageNamed:@"ios_icon_good.png"];
        titleLb.text = @"三好一改";
        detailLb.text = @"每日三省吾身 发现和改变";
    }
}

@end
