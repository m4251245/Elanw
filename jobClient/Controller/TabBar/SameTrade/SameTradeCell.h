//
//  SameTradeCell.h
//  jobClient
//
//  Created by YL1001 on 15/2/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CELL_MARGIN_TOP 0
#import "ELSameTradePeopleFrameModel.h"

typedef void (^NoLoginBtnClick)(UIButton *button);

@interface SameTradeCell : UITableViewCell

@property(nonatomic,strong) UIImageView      *phototImgv_;//用户头像
@property(nonatomic,strong) UIImageView      *markImgv_;//行家标识
@property(nonatomic,strong) UILabel          *nameLb_; //用户名标签

@property(nonatomic,strong) UILabel          *workAgeLb_;//中间职位工作经验标签
@property(nonatomic,strong) UILabel          *dynamicLb_;//底部动态文本

@property (nonatomic,strong) UIView *rightButtonView; //右侧关注，私信按钮
@property (nonatomic,strong) UIImageView *rightImage;
@property (nonatomic,strong) UILabel *rightLabel;

@property (nonatomic,strong) UIView *ageView; //年龄性别标签
@property (nonatomic,strong) UILabel *ageLb;
@property (nonatomic,strong) UIImageView *ageImage;

@property (nonatomic,strong) UILabel *realNameLabel; //实名标签
@property (nonatomic,strong) UILabel *sameCityLabel; //同城标签
@property (nonatomic,strong) UILabel *sameSchoolLabel; //同校标签

@property (nonatomic,strong) ELLineView *lineView;

@property (nonatomic,copy) NoLoginBtnClick block;

@property(nonatomic,strong) ELSameTradePeopleFrameModel *peopleModel;

@property (nonatomic,assign) BOOL showAttentionButton;
@property (nonatomic,assign) BOOL showMessageButton;
@property (nonatomic,assign) BOOL hideDynamic;

@end
