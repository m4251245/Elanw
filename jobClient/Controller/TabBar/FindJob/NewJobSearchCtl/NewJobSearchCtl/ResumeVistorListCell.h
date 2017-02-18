//
//  ResumeVistorListCell.h
//  Association
//
//  Created by 一览iOS on 14-6-25.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumeVistorListCell : UITableViewCell

@property(nonatomic,weak)IBOutlet    UILabel     *companyNameLb_;     //公司名称
@property(nonatomic,weak)IBOutlet    UILabel     *companyNatureLb_;   //企业性质
@property(nonatomic,weak)IBOutlet    UILabel     *readCountLb_;       //阅读次数
@property(nonatomic,weak)IBOutlet    UILabel     *readTimeLb_;        //访问简历时间
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@end
