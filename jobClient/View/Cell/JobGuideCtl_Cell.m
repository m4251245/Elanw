//
//  JobGuideCtl_Cell.m
//  Association
//
//  Created by 一览iOS on 14-2-11.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "JobGuideCtl_Cell.h"

@implementation JobGuideCtl_Cell
@synthesize image_,titleLb_,qikanLb_,dateLb_;

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
