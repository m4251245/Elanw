//
//  SalaryCompareQuery_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/3/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryCompareQuery_Cell.h"
#import "User_DataModal.h"


@implementation SalaryCompareQuery_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setFrame:(CGRect)frame
{
//    frame.origin.y += CELL_MARGIN_TOP;
    frame.size.height -= CELL_MARGIN_TOP;
    [super setFrame:frame];
}

- (void)setUserModel:(User_DataModal *)userModel
{
    self.countLb.text = [NSString stringWithFormat:@"%ld", (long)userModel.followCnt_];
    self.detailLb.text = [NSString stringWithFormat:@"%@ + %@(元/月) + %@", userModel.zym_, userModel.salary_, userModel.regiondetail_];
    self.timeLb.text = userModel.sendtime_;
}

@end
