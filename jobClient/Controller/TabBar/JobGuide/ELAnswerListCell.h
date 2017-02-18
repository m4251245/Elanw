//
//  ELAnswerListCell.h
//  jobClient
//
//  Created by 一览iOS on 16/9/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JobGuideQuizModal;
@class ELAnswerLableView;
@class ELButtonView;

@interface ELAnswerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *personImage;

@property (weak, nonatomic) IBOutlet UILabel *personNameLb;

@property (strong, nonatomic) UILabel *answerContentLb;
@property (strong, nonatomic) UILabel *answerDetailLb;

@property (weak, nonatomic) IBOutlet UILabel *seeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;

@property (weak, nonatomic) IBOutlet UIButton *answerBtn;

@property (weak, nonatomic) IBOutlet UIImageView *expertImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLableLeftWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;


@property (nonatomic,strong) UIView *commentView;
@property (nonatomic,strong) UIImageView *commentBackImage;
@property (nonatomic,strong) ELButtonView *commentOne;
@property (nonatomic,strong) ELButtonView *commentTwo;

@property (nonatomic,strong) ELAnswerLableView *lableView;
@property (nonatomic,strong) ELLineView *lineView;
@property (nonatomic,weak) JobGuideQuizModal *modal;

-(void)giveDataWithModal:(JobGuideQuizModal *)dataModal;

@end
