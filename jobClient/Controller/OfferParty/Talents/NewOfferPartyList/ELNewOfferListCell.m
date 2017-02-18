//
//  ELNewOfferListCell.m
//  jobClient
//
//  Created by YL1001 on 16/10/27.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewOfferListCell.h"

@implementation ELNewOfferListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 4.0f;
    self.bgView.layer.masksToBounds = YES;
}

/*
- (void)setTalentModel:(OfferPartyTalentsModel *)talentModel
{
    _talentModel = talentModel;
    
    self.titleLb.text = talentModel.jobfair_name;
    self.addressLb.text = talentModel.place_name;
    self.timeLb.text = [NSString stringWithFormat:@"%@  %@", talentModel.jobfair_time, [MyCommon getWeekDay:talentModel.jobfair_time]];
    self.positionLb.text = talentModel.jobfair_zhiwei;
    
    
    if (talentModel.iscome){
        self.tagImg.image = [UIImage imageNamed:@"img_offer_signIn.png"];
    }
    else if (talentModel.isjoin) {
        self.tagImg.image = [UIImage imageNamed:@"img_offer_signUp.png"];
    }
    else{
        self.tagImg.hidden = YES;
    }

}
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
