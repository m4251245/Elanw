//
//  CHRResumeCell.h
//  jobClient
//
//  Created by 一览iOS on 15-1-27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User_DataModal.h"

@interface CHRResumeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *summaryLb;
@property (weak, nonatomic) IBOutlet UILabel *jobLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIImageView *isDownImgv;

@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;

@property(strong,nonatomic) User_DataModal *userModel;
@property(nonatomic,assign) BOOL offerListFlag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statuLbWidth;
@property (weak, nonatomic) IBOutlet UIButton *recomendReporterBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBtn;

@end
