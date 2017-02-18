//
//  ZWDescript_Cell.m
//  jobClient
//
//  Created by job1001 job1001 on 11-12-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ZWDescript_Cell.h"

@implementation ZWDescript_Cell
@synthesize updateTimeLb_,regionNameLb_,peopeleCountLb_,yearCountLb_,eduLb_,moneyCountLb_,majorLb_,zwJianJieLb_;
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
