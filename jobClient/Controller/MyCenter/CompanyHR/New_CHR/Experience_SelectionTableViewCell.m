//
//  Experience_SelectionTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/8/4.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "Experience_SelectionTableViewCell.h"

@interface Experience_SelectionTableViewCell()


@end

@implementation Experience_SelectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lowTxt.layer.cornerRadius = 3;
    _lowTxt.layer.masksToBounds = YES;
    
    _highTxt.layer.cornerRadius = 3;
    _highTxt.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 3;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.borderWidth = 1;
    _sureBtn.layer.borderColor = UIColorFromRGB(0xbbbbbb).CGColor;
    
    _lowTxt.tag = 101010;
    _highTxt.tag = 101011;
}
- (IBAction)sureBtnClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(sureBtnClicked:)]) {
        [_delegate sureBtnClicked:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
