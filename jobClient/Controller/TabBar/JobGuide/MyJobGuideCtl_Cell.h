//
//  MyJobGuideCtl_Cell.h
//  jobClient
//
//  Created by 一览iOS on 15-1-20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobGuideQuizModal.h"

@interface MyJobGuideCtl_Cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *questLable;

@property (strong, nonatomic) IBOutlet UIImageView *typeImg;
@property (weak, nonatomic) IBOutlet UILabel *typeLableOne;
@property (weak, nonatomic) IBOutlet UILabel *typeLableTwo;
@property (weak, nonatomic) IBOutlet UILabel *typeLableThree;

@property (weak, nonatomic) IBOutlet UIImageView *expertImage;
@property (strong, nonatomic) IBOutlet UILabel *replysCount;
@property (strong, nonatomic) IBOutlet UIButton *answerBtn;
@property (strong, nonatomic) IBOutlet UIButton *viewCountBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleNameLayout;


-(void)giveDataWithModal:(JobGuideQuizModal *)dataModal;

@end
