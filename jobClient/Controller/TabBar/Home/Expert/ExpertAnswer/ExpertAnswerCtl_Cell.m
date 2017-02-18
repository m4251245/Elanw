//
//  ExpertAnswerCtl_Cell.m
//  Association
//
//  Created by 一览iOS on 14-3-6.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ExpertAnswerCtl_Cell.h"

@implementation ExpertAnswerCtl_Cell
@synthesize nameLb_,questionLb_,answerLb_,imgView_,bigView_;


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
