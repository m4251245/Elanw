//
//  RecommendZW_Cell.m
//  jobClient
//
//  Created by YL1001 on 14-9-29.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RecommendZW_Cell.h"
#import "NSString+Size.h"


@implementation RecommendZW_Cell
@synthesize CLogo_,contentView_,zwNameLb_,salaryLb_,tag1Lb_,tag2Lb_,tag3Lb_,regionTimeLb_;

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIColor*)getColor:(NSString*)str
{
    if ([str isEqualToString:@"员工宿舍"]) {
        return [UIColor colorWithRed:82.0/255.0 green:197.0/255.0 blue:172.0/255.0 alpha:1.0];
    }
    if ([str isEqualToString:@"公费旅游"]) {
        return [UIColor colorWithRed:153.0/255.0 green:213.0/255.0 blue:111.0/255.0 alpha:1.0];
    }
    if ([str isEqualToString:@"年终奖"]) {
        return [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:78.0/255.0 alpha:1.0];
    }
    if ([str isEqualToString:@"双休"]) {
        return [UIColor colorWithRed:230.0/255.0 green:151.0/255.0 blue:234.0/255.0 alpha:1.0];
    }
    if ([str isEqualToString:@"公费培训"]) {
        return [UIColor colorWithRed:235.0/255.0 green:191.0/255.0 blue:48.0/255.0 alpha:1.0];
    }
    else
        return [UIColor redColor];
}

- (void)cellInitWithImage:(NSString *)image_ positionName:(NSString *)positionName_
                     time:(NSString *)time_
              companyName:(NSString *)companyName_
                   salary:(NSString *)salary_
                  welfare:(NSArray *)welfare_
                   region:(NSString *)region_
{
    //设置视图样式
    
    
    [CLogo_  sd_setImageWithURL:[NSURL URLWithString:image_] placeholderImage:[UIImage imageNamed:@"280"]];
    [zwNameLb_ setText:positionName_];
    //time 格式处理
    time_ = [time_ stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    regionTimeLb_.text = [NSString stringWithFormat:@"%@     %@",region_,time_];
    //salary 格式处理
    salary_ = [salary_ stringByReplacingOccurrencesOfString:@"--" withString:@"-"];
    salary_ = [salary_ stringByReplacingOccurrencesOfString:@" 年薪" withString:@"/年"];
    salary_ = [salary_ stringByReplacingOccurrencesOfString:@" 月薪" withString:@"/月"];
    [salaryLb_ setText:salary_];
    
    [tag1Lb_ setHidden:YES];
    [tag2Lb_ setHidden:YES];
    [tag3Lb_ setHidden:YES];
    tag1Lb_.layer.cornerRadius = 2.0;
    tag2Lb_.layer.cornerRadius = 2.0;
    tag3Lb_.layer.cornerRadius = 2.0;
    
    if (![welfare_ isKindOfClass:[NSNull class]]){
        for (int i=0; i<[welfare_ count]; i++) {
            switch (i) {
                case 0:
                {
                    NSString *welfareStr = [welfare_ objectAtIndex:i];
                    CGSize size = [welfareStr sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:11] constrainedToSize:CGSizeMake(60, 14)];
                    CGRect rect = tag1Lb_.frame;
                    rect.size.width = size.width + 8;
                    [tag1Lb_ setFrame:rect];
                    [tag1Lb_ setText:welfareStr];
                    [tag1Lb_ setBackgroundColor:[UIColor orangeColor]];
                    [tag1Lb_ setHidden:NO];
                    
                }
                    break;
                case 1:
                {
                    NSString *welfareStr = [welfare_ objectAtIndex:i];
                    CGSize size = [welfareStr sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:11] constrainedToSize:CGSizeMake(60, 14)];
                    CGRect rect = tag2Lb_.frame;
                    rect.size.width = size.width + 8;
                    rect.origin.x = tag1Lb_.frame.origin.x + tag1Lb_.frame.size.width + 3;
                    [tag2Lb_ setFrame:rect];
                    [tag2Lb_ setText:welfareStr];
                    [tag2Lb_ setBackgroundColor:[UIColor orangeColor]];
                    [tag2Lb_ setHidden:NO];
                }
                    break;
                case 2:
                {
                    NSString *welfareStr = [welfare_ objectAtIndex:i];
                    CGSize size = [welfareStr sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:11] constrainedToSize:CGSizeMake(60, 14)];
                    CGRect rect = tag3Lb_.frame;
                    rect.size.width = size.width + 8;
                    rect.origin.x = tag2Lb_.frame.origin.x + tag2Lb_.frame.size.width + 3;
                    [tag3Lb_ setFrame:rect];
                    [tag3Lb_ setText:welfareStr];
                    [tag3Lb_ setBackgroundColor:[UIColor orangeColor]];
                    [tag3Lb_ setHidden:NO];
                }
                    break;
                default:
                    break;
            }
        }
    }
    else
    {
        CGRect rect = regionTimeLb_.frame;
        rect.origin.y = tag1Lb_.frame.origin.y;
        regionTimeLb_.frame  = rect;
    }
}

@end
