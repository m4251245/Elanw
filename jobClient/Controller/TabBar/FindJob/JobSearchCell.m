//
//  JobSearchCell.m
//  jobClient
//
//  Created by 一览ios on 14-12-21.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "JobSearchCell.h"
#import "MyConfig.h"
#import "ZWDetail_DataModal.h"
@implementation JobSearchCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell:(NSMutableArray *)jobSubArray
{
    [titleLb_ setFont:FOURTEENFONT_CONTENT];
    [titleLb_ setTextColor:BLACKCOLOR];
    [contentLb_ setFont:FOURTEENFONT_CONTENT];
    [contentLb_ setTextColor:GRAYCOLOR];
    
    if ([jobSubArray count] ==0) {
        [titleLb_ setText:@"搜索记录"];
    }else{
        NSString *jobSubStr = @"";
        for (ZWDetail_DataModal *model in jobSubArray) {
            NSString *temp = @"";
            if (model.keyword_ !=nil && ![model.keyword_ isEqualToString:@""] && ![model.keyword_ isKindOfClass:[NSNull class]]) {
                temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%@",model.keyword_]];
            }
            if (model.regionName_ !=nil && ![model.regionName_ isEqualToString:@""] && ![model.regionName_ isKindOfClass:[NSNull class]]) {
                temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%@",model.regionName_]];
            }
            
            if (![temp isEqualToString:@""]) {
                jobSubStr = [jobSubStr stringByAppendingString:[NSString stringWithFormat:@"#%@",temp]];
            }
            
        }
        [titleLb_ setText:@"已订阅"];
        [contentLb_ setText:jobSubStr];
    }
    
    bgView_.layer.borderWidth=0.5;
    bgView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
}

@end
