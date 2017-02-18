//
//  WorkExperienceCell.m
//  jobClient
//
//  Created by 一览ios on 15/3/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "WorkExperienceCell.h"
#import "MyConfig.h"
#import "WorkResume_DataModal.h"
#import "NSString+Size.h"

@implementation WorkExperienceCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _positionLb = [[UILabel alloc] init];
    _positionLb.frame = CGRectMake(10,60,280,30);
    _positionLb.numberOfLines = 2;
    _positionLb.font = [UIFont systemFontOfSize:15];
    _positionLb.textColor = UIColorFromRGB(0x888888);
    _positionLb.numberOfLines = 2;
    [self.contentView addSubview:_positionLb];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)cellAssignment:(WorkResume_DataModal *)dataModel
{
    NSString *str = [NSString stringWithFormat:@"%@ | %@",dataModel.companyName_,dataModel.zwName_];
    [_companyNameLb setText:str];
   
    NSMutableString *startStr = [[NSMutableString alloc] initWithString:dataModel.startDate_];
    [startStr replaceOccurrencesOfString:@"-" withString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(0,dataModel.startDate_.length)];
    NSMutableString *endStr =[[NSMutableString alloc] initWithString:dataModel.endDate_];
    [endStr replaceOccurrencesOfString:@"-" withString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(0,dataModel.endDate_.length)];
    if (dataModel.bToNow_ && [dataModel.bToNow_ isEqualToString:@"1"]) {
        [_timeLb setText:[NSString stringWithFormat:@"%@-%@",startStr, @"至今"]];
    }else{
        [_timeLb setText:[NSString stringWithFormat:@"%@-%@",startStr,endStr]];
    }
    
    CGRect frame = _positionLb.frame;
    
    if (dataModel.des_.length > 0)
    {
        _positionLb.hidden = NO;
        CGSize size = [dataModel.des_ sizeNewWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280,40)];
        frame.size.width = 280;
        frame.size.height = size.height;
    }
    else
    {
        _positionLb.hidden = YES;
        frame.size.height = 0;
    }
    _positionLb.frame = frame;
    _positionLb.text = dataModel.des_;
    _rightImage.frame = CGRectMake(300,(CGRectGetMaxY(_positionLb.frame)+3)/2,6,10);
    
}

@end
