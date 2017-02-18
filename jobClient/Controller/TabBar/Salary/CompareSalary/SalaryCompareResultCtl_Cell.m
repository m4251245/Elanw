//
//  SalaryCompareResultCtl_Cell.m
//  jobClient
//
//  Created by YL1001 on 15/6/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryCompareResultCtl_Cell.h"
#import "User_DataModal.h"
#import "Common.h"
#import "FMDatabase.h"

@interface SalaryCompareResultCtl_Cell ()
{
    FMDatabase    *database;
}

@end

@implementation SalaryCompareResultCtl_Cell

@synthesize SexImg,jobLb,salaryLb;

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
