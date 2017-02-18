//
//  MyPubilshCtl_Cell.m
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "MyPubilshCtl_Cell.h"

@implementation MyPubilshCtl_Cell
@synthesize viewCntLb_,commengCntLb_,contentView,descLb_,datetimeLb_,titleLb_,contentView_,articleImage_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
