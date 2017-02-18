//
//  ELOfferPartyListCell.h
//  jobClient
//
//  Created by 一览iOS on 16/11/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ELAnswerLableView;
@class OfferPartyTalentsModel;

@interface ELOfferPartyListCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *placeLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UIImageView *placeImg;
@property (nonatomic,strong) UIImageView *timeImg;
@property (nonatomic,strong) UIImageView *offerImg;
@property (nonatomic,strong) ELLineView *centerLine;
@property (nonatomic,strong) ELLineView *bottomLine;
@property (nonatomic,strong) ELAnswerLableView *lableView;
@property (nonatomic,strong) ELOfferListModel *dataModel;

+(instancetype)getCellWithTableView:(UITableView *)tableView;

@end
