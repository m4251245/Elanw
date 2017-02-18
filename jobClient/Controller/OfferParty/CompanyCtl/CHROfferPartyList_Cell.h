//
//  CHRIndexCtl_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHROfferPartyList_Cell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dataModel;

@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImgv;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *redDotLb;

@end
