//
//  CHRIndexCtl_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOfferPartyCompanyList_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImgv;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *jobLb;
@property (weak, nonatomic) IBOutlet UILabel *redDotLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *separateLine;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgv;

@end
