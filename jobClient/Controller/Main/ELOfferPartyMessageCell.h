//
//  ELOfferPartyMessageCell.h
//  jobClient
//
//  Created by YL1001 on 16/4/19.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELOfferPartyMessageCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIView *timeBgView;            /**<时间背景 */
@property (strong, nonatomic) IBOutlet UILabel *timeLb;               /**<时间 */

@property (strong, nonatomic) IBOutlet UIView *contentBgView;         /**<自定义背景 */
@property (strong, nonatomic) IBOutlet UILabel *interviewFeedbacklb;  /**<面试反馈 */
@property (strong, nonatomic) IBOutlet UIImageView *companyImg;       /**<公司图片 */
@property (strong, nonatomic) IBOutlet UILabel *companyNameLb;        /**<公司名称 */
@property (strong, nonatomic) IBOutlet UILabel *positionLb;           /**<职位名称 */
@property (strong, nonatomic) IBOutlet UILabel *salaryLb;             /**<薪水 */
@property (strong, nonatomic) IBOutlet UILabel *educationLb;          /**<学历 */
@property (strong, nonatomic) IBOutlet UILabel *jobAgeLb;             /**<工龄 */
@property (strong, nonatomic) IBOutlet UIImageView *newsImg;           /**<新消息 */
@property (strong, nonatomic) IBOutlet UILabel *interviewLb;          /**<排队 */
@property (strong, nonatomic) IBOutlet UIButton *detailBtn;           /**<查看详情 */
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewTwo;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *interviewLbLeading;


@end
