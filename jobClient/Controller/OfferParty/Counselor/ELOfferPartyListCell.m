//
//  ELOfferPartyListCell.m
//  jobClient
//
//  Created by 一览iOS on 16/11/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOfferPartyListCell.h"
#import "ELAnswerLableView.h"

@implementation ELOfferPartyListCell


+(instancetype)getCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"ELOfferPartyListCell";
    ELOfferPartyListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ELOfferPartyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell creatUI];
    }
    return cell;
}

-(void)creatUI{
    self.offerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10,15,66,42)];
    [self.contentView addSubview:self.offerImg];
    
    self.nameLb = [[UILabel alloc] initWithFrame:CGRectMake(86,12,ScreenWidth-96,20)];
    self.nameLb.textColor = UIColorFromRGB(0x212121);
    self.nameLb.font = [UIFont systemFontOfSize:16];
    self.nameLb.numberOfLines = 1;
    [self.contentView addSubview:self.nameLb];
    
    self.placeImg = [[UIImageView alloc] initWithFrame:CGRectMake(86,37,11,12)];
    self.placeImg.image = [UIImage imageNamed:@"offerpai_ort"];
    [self.contentView addSubview:self.placeImg];
    
    self.timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(86,56,11,12)];
    self.timeImg.image = [UIImage imageNamed:@"offerpai_time"];
    [self.contentView addSubview:self.timeImg];
    
    self.placeLb = [[UILabel alloc] initWithFrame:CGRectMake(107,36,ScreenWidth-117,14)];
    self.placeLb.textColor = UIColorFromRGB(0x212121);
    self.placeLb.font = [UIFont systemFontOfSize:12];
    self.placeLb.numberOfLines = 1;
    [self.contentView addSubview:self.placeLb];
    
    self.timeLb = [[UILabel alloc] initWithFrame:CGRectMake(107,55,ScreenWidth-117,14)];
    self.timeLb.textColor = UIColorFromRGB(0x757575);
    self.timeLb.font = [UIFont systemFontOfSize:12];
    self.timeLb.numberOfLines = 1;
    [self.contentView addSubview:self.timeLb];
    
    self.centerLine = [[ELLineView alloc] initWithFrame:CGRectMake(10,80,ScreenWidth-20,0.8) WithColor:UIColorFromRGB(0xe0e0e0)];
    [self.contentView addSubview:self.centerLine];
    
    self.bottomLine = [[ELLineView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,5) WithColor:UIColorFromRGB(0xf5f5f5)];
    [self.contentView addSubview:self.bottomLine];
    
    if (!self.lableView) {
        self.lableView = [[ELAnswerLableView alloc] initWithMaxCount:7];
        [self.contentView addSubview:self.lableView];
        self.lableView.noClick = YES;
    }
}

-(void)setDataModel:(ELOfferListModel *)dataModel{
    _dataModel = dataModel;
    
    self.nameLb.text = dataModel.project_title;
    if (dataModel.project_holdtime.length>10) {
        self.timeLb.text = [dataModel.project_holdtime substringToIndex:10];
    }else{
        self.timeLb.text = dataModel.project_holdtime;
    }
    self.placeLb.text = dataModel.place_name;
    if ([dataModel.fromtype isEqualToString:@"hunter"]) {
        
        [self.offerImg sd_setImageWithURL:[NSURL URLWithString:dataModel.logo_src] placeholderImage:[UIImage imageNamed:@"chr_offerParty_hunter.png"]];
    }
    else
    {
        [self.offerImg sd_setImageWithURL:[NSURL URLWithString:dataModel.logo_src] placeholderImage:[UIImage imageNamed:@"chr_offer_party_bg1.png"]];
    }
    self.lableView.frame = dataModel.lableViewFrame;
    [self.lableView giveDataModalWithArr:dataModel.lableArr];
    self.bottomLine.frame = CGRectMake(0,dataModel.cellHeight-5,ScreenWidth,5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
