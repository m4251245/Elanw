//
//  SalaryCtl2_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/4/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article_DataModal;

@interface SalaryCtl2_Cell : UITableViewCell

@property (strong, nonatomic) Article_DataModal *articleModel;
@property (weak, nonatomic) IBOutlet UIView *toolBar;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgv;
@property (weak, nonatomic) IBOutlet UILabel *jingHuaLb;

@end
