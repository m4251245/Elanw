//
//  ELNewOfferListCell.h
//  jobClient
//
//  Created by YL1001 on 16/10/27.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OfferPartyTalentsModel;

@interface ELNewOfferListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIImageView *tagImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *positionLb;

@property (nonatomic, strong) OfferPartyTalentsModel *talentModel;

@end
