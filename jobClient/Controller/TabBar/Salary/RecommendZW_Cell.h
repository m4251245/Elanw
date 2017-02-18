//
//  RecommendZW_Cell.h
//  jobClient
//
//  Created by YL1001 on 14-9-29.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RecommendZW_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIView   * contentView_;
@property(nonatomic,weak) IBOutlet UIImageView  * CLogo_;
@property(nonatomic,weak) IBOutlet UILabel      * zwNameLb_;
@property(nonatomic,weak) IBOutlet UILabel      * salaryLb_;
@property(nonatomic,weak) IBOutlet UILabel      * tag1Lb_;
@property(nonatomic,weak) IBOutlet UILabel      * tag2Lb_;
@property(nonatomic,weak) IBOutlet UILabel      * tag3Lb_;
@property(nonatomic,weak) IBOutlet UILabel      * regionTimeLb_;


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
                   region:(NSString *)region_;


-(UIColor*)getColor:(NSString*)str;

@end
