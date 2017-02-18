//
//  TodayFocus_Cell.h
//  jobClient
//
//  Created by 彭永 on 15-4-5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#define CELL_MARGIN_TOP 0

#import <UIKit/UIKit.h>
#import "TodayFocusFrame_DataModal.h"
#import "MLLinkLabel.h"
#import "NSString+MLExpression.h"

const static char associationKey;
@class TodayFocusFrame_DataModal;

typedef void(^CellBtnClick)(TodayFocusFrame_DataModal *modal,NSString *type);

@interface TodayFocus_Cell : UITableViewCell<MLLinkLabelDelegate,UIGestureRecognizerDelegate>
{
    UIImage *commentViewbackImage;
}

@property (weak, nonatomic) IBOutlet UILabel *tipsLb;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *artilceTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIView *imgShowView;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentCntBtn;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@property (weak, nonatomic) IBOutlet UIView *sameTradeHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *bExpertImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *jobLb;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgv;

@property (strong, nonatomic) TodayFocusFrame_DataModal *model;
@property (weak, nonatomic) IBOutlet UIImageView *isNewImg;

@property (weak, nonatomic) IBOutlet UILabel *formLeftLb;

@property (weak, nonatomic) IBOutlet UILabel *fromRightLb;

@property (weak, nonatomic) IBOutlet UIImageView *commentBackImage;

@property (strong, nonatomic) IBOutlet UIButton *personNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *shareLable;

@property (nonatomic,copy) CellBtnClick block;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *sharePersonNameLb;

@property (weak, nonatomic) IBOutlet UIImageView *attachmentStatusImage;
@property (nonatomic,assign) BOOL showStatusLable;
@property (nonatomic,assign) BOOL showStatusShot;
@property (weak, nonatomic) IBOutlet UILabel *articleStatusLable;


@end
