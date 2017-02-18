//
//  SalaryIrrigationCtl_Cell.h
//  jobClient
//
//  Created by YL1001 on 14/11/21.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import "Article_DataModal.h"
@class ELSalaryModel;
@interface SalaryIrrigationCtl_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel * contentLb_;
@property(nonatomic,weak) IBOutlet UIButton * likeBtn_;
@property(nonatomic,weak) IBOutlet UIButton * commentCntBtn_;
@property(nonatomic,weak) IBOutlet UIButton * shareBtn_;
@property(nonatomic,weak) IBOutlet UILabel  * sourceLb_;
@property(nonatomic,weak) IBOutlet UILabel  * isJingLb_;   //精华帖
@property(nonatomic,weak) IBOutlet UIImageView * huoImage_;
@property (weak, nonatomic) IBOutlet UIImageView *backGroupImg;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property(nonatomic,strong) MLEmojiLabel *emojiLb;

@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;

@property (weak, nonatomic) IBOutlet UIView *backGroudView;

@property (weak, nonatomic) IBOutlet UIImageView *imageLine;


-(void)giveDataCellWithModal:(ELSalaryModel *)dataModal;

-(void)giveDataCellWithModal:(ELSalaryModel *)dataModal type:(NSInteger)type;

@end
