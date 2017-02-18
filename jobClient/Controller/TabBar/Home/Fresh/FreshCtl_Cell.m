//
//  FreshCtl_Cell.m
//  Association
//
//  Created by 一览iOS on 14-3-13.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "FreshCtl_Cell.h"
#import "MyConfig.h"

@implementation FreshCtl_Cell
@synthesize timeLb_,schoolLb_,titleLb_,dateLb_,weekdayLb_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
    }
    return self;
}

- (void)initCell
{
    [dateLb_ setTextColor:GRAYCOLOR];
    [timeLb_ setTextColor:GRAYCOLOR];
    //[weekdayLb_ setTextColor:BLACKCOLOR];
    [schoolLb_ setTextColor:GRAYCOLOR];
    [titleLb_ setTextColor:BLACKCOLOR];
}

- (void)setDataModel:(NewCareerTalkDataModal *)model
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
