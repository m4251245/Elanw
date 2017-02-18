//
//  ELCreateCourseCell.h
//  jobClient
//
//  Created by YL1001 on 15/10/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELCreateCourseCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *contentBgView;  /**<背景 */
@property (strong, nonatomic) IBOutlet UIButton *status;        /**<审核状态 */
@property (strong, nonatomic) IBOutlet UILabel *titleLb;       /**<课程标题 */
@property (strong, nonatomic) IBOutlet UILabel *contentLb;     /**<课程内容 */
@property (strong, nonatomic) IBOutlet UILabel *courseTime;    /**<课程时长 */
@property (strong, nonatomic) IBOutlet UILabel *coursePrice;   /**<课程价格 */
@property (strong, nonatomic) IBOutlet UILabel *personCount;   /**<已约谈人数 */



@end
