//
//  MyJobGuide_RewardCell.m
//  jobClient
//
//  Created by YL1001 on 16/1/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "MyJobGuide_RewardCell.h"

@implementation MyJobGuide_RewardCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)setCount:(NSString *)count withContent:(NSString *)content
{
//    if (count && ![count isEqualToString:@""]) {
//        _hotCountLb.text = count;
//    }else{
//        _hotCountLb.text = @"0";
//    }
    _contentLb.text = content;
}

+(CGFloat)getCellHeight{
    return (ScreenWidth*316)/750.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
