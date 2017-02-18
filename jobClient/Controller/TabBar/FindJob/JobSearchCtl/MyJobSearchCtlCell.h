//
//  MyJobSearchCtlCell.h
//  jobClient
//
//  Created by 一览iOS on 14-9-12.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConfig.h"
#import "Common.h"
#import "NewJobPositionDataModel.h"
@class JobSearch_DataModal;

@interface MyJobSearchCtlCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *lineImgv;

@property(nonatomic,weak)IBOutlet   UIImageView *loginImgv_;
@property(nonatomic,weak)IBOutlet   UILabel     *companyNameLb_;
@property(nonatomic,weak)IBOutlet   UILabel     *timeLb_;
@property(nonatomic,weak)IBOutlet   UILabel     *salaryLb_;
@property(nonatomic,weak)IBOutlet   UILabel     *positionNameLb_;
@property(nonatomic,weak)IBOutlet   UILabel     *welfare1Lb_;
@property(nonatomic,weak)IBOutlet   UILabel     *welfare2Lb_;
@property(nonatomic,weak)IBOutlet   UILabel     *welfare3Lb_;
@property(nonatomic,weak)IBOutlet   UILabel     *regionLb_;
@property(nonatomic,weak)IBOutlet   UILabel     *kyLb_;
@property(nonatomic,weak)IBOutlet   UIView      *bgView_;
@property(nonatomic,weak)IBOutlet   UIView      *tagView_;
@property(nonatomic,weak)IBOutlet   UILabel     *condition1Lb_;
@property(nonatomic,weak)IBOutlet   UILabel     *condition2Lb_;
@property(nonatomic,weak)IBOutlet   UILabel     *condition3Lb_;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *compantTopToSalary;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineImageLeftW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftWidth;
@property (weak, nonatomic) IBOutlet UIImageView *jobMsgImg;

/**
 *  设置CELL
 *
 *  @param image_        企业logo
 *  @param positionName_ 职位名称
 *  @param time_         发布时间
 *  @param companyName_  企业名称
 *  @param salary_       薪资
 *  @param welfare_      福利待遇 数组
 *  @param region_       区域
 */
- (void)cellInitWithImage:(NSString *)image_ positionName:(NSString *)positionName_
                     time:(NSString *)time_
              companyName:(NSString *)companyName_
                   salary:(NSString *)salary_
                  welfare:(NSArray *)welfare_
                   region:(NSString *)region_
                    gznum:(NSString *)gznum_
                      edu:(NSString *)edu_
                    count:(NSString *)count_
                 tagColor:(UIColor *)tagColor_
                     isky:(BOOL)isKy;

#pragma mark 职位分享到留言
- (void) cellInitWithDataModel:(JobSearch_DataModal *)jobModel;

@end
