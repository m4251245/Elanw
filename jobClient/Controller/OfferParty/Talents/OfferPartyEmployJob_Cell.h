//
//  OfferPartyEmployJob_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/9/1.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferPartyEmployJob_Cell : UITableViewCell
@property (strong, nonatomic) NSDictionary *dataModel;

@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImgv;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *jobLb;
@property (weak, nonatomic) IBOutlet UILabel *redDotLb;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *summaryLb;

@property (weak, nonatomic) IBOutlet UIImageView *interviewStatusImgv;
@property (weak, nonatomic) IBOutlet UILabel *interviewDetailLb;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *interviewStatusImgvLeading;
@property (weak, nonatomic) IBOutlet UIImageView *guidImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineToBottom;


@end
