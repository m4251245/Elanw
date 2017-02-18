//
//  OfferPartyCenterCtl.h
//  jobClient
//
//  Created by 一览ios on 15/7/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface OfferPartyCenterCtl : BaseListCtl

@property(nonatomic, copy) NSString *companyId;//企业ID

@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, copy)NSString *jobfair_time;
@property (nonatomic, copy)NSString *jobfair_name;
@property (nonatomic, copy)NSString *place_name;
@property (nonatomic, copy)NSString *logo_src;

@property (strong, nonatomic) UIImageView *logoImgv;
@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) UILabel *addLb;
@property (strong, nonatomic) UILabel *timeLb;

@end
