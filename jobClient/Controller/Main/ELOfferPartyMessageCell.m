//
//  ELOfferPartyMessageCell.m
//  jobClient
//
//  Created by YL1001 on 16/4/19.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOfferPartyMessageCell.h"

@implementation ELOfferPartyMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _timeBgView.layer.cornerRadius = 8.0;
    _timeBgView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
