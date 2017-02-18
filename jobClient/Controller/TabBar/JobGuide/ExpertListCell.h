//
//  ExpertListCell.h
//  jobClient
//
//  Created by YL1001 on 15/7/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expert_DataModal.h"
#import "JobGuideExpertModal.h"

@interface ExpertListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *backView_;
@property (strong, nonatomic) IBOutlet UIImageView *expertImg_; /** < 专家图片 */
@property (strong, nonatomic) IBOutlet UIButton *expertName_;   /** < 专家名字 */
@property (strong, nonatomic) IBOutlet UILabel *expertHonorLb_; /** < 专家头衔 */
@property (strong, nonatomic) IBOutlet UILabel *adeptLb_;       /** < 专业 */
@property (strong, nonatomic) IBOutlet UIImageView *typeImg;
@property (strong, nonatomic) IBOutlet UIView *regionView;
@property (strong, nonatomic) IBOutlet UIButton *regionBtn;
@property (strong, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UIImageView *courseTitleBgImg;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mumAtivity;
@property (weak, nonatomic) IBOutlet UIImageView *courseImg;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *expertImgAutoHeight;

- (void)setExpertHonorLbFrame:(JobGuideExpertModal *)dataModal;

@end
