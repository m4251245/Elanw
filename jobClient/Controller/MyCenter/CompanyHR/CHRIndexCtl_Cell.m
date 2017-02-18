//
//  CHRIndexCtl_Cell.m
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CHRIndexCtl_Cell.h"

@implementation CHRIndexCtl_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    CALayer *layer = _countLb.layer;
//    layer.masksToBounds = YES;
//    layer.cornerRadius = 3.f;
    
    _isNewImgv.layer.cornerRadius = 4;
    _isNewImgv.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//@{@"title":@"简历评价", @"cnt":@"", @"isNew":@(NO) ,@"type":@"jlpj"}
- (void)setDataModel:(NSDictionary *)dataModel
{
    
}

@end
