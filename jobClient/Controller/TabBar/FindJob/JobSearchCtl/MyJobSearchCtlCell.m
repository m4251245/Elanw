//
//  MyJobSearchCtlCell.m
//  jobClient
//
//  Created by 一览iOS on 14-9-12.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "MyJobSearchCtlCell.h"
#import "JobSearch_DataModal.h"
#import "UIImageView+WebCache.h"

@implementation MyJobSearchCtlCell
@synthesize positionNameLb_,companyNameLb_,loginImgv_,timeLb_,salaryLb_,welfare1Lb_,welfare2Lb_,welfare3Lb_,regionLb_,kyLb_,condition1Lb_,condition2Lb_,condition3Lb_;

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


- (void)cellInitWithImage:(NSString *)image_ positionName:(NSString *)positionName_ time:(NSString *)time_ companyName:(NSString *)companyName_ salary:(NSString *)salary_ welfare:(NSArray *)welfare_ region:(NSString *)region_ gznum:(NSString *)gznum_ edu:(NSString *)edu_ count:(NSString *)count_ tagColor:(UIColor *)tagColor_ isky:(BOOL)isKy
{
   
    //设置视图样式
    loginImgv_.layer.borderColor = UIColorFromRGB(0xecedec).CGColor;
    loginImgv_.layer.borderWidth = 1;
    loginImgv_.layer.masksToBounds = YES;
    
    

    [loginImgv_ sd_setImageWithURL:[NSURL URLWithString:image_] placeholderImage:nil];
   
    [positionNameLb_ setText:[MyCommon translateHTML:positionName_]];
    [companyNameLb_ setText:[MyCommon translateHTML:companyName_]];
    //salary 格式处理
    salary_ = [salary_ stringByReplacingOccurrencesOfString:@"--" withString:@"-"];
    salary_ = [salary_ stringByReplacingOccurrencesOfString:@" 年薪" withString:@""];
    salary_ = [salary_ stringByReplacingOccurrencesOfString:@" 月薪" withString:@""];
    salary_ = [salary_ stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    if ([salary_ isEqualToString:@"面议"]) {
        [salaryLb_ setText:salary_];
    }else{
        [salaryLb_ setText:[NSString stringWithFormat:@"￥%@",salary_]];
    }
    NSArray *regionArray = [region_ componentsSeparatedByString:@"-"];
    if ([regionArray count] == 2) {
        region_ = [regionArray objectAtIndex:1];
    }else{
        region_ = [regionArray objectAtIndex:0];
    }

    [regionLb_ setText:region_];
    
    if (isKy) {
        [kyLb_ setHidden:NO];
    }else{
        [kyLb_ setHidden:YES];
    }
    
    [welfare1Lb_ setHidden:YES];
    [welfare2Lb_ setHidden:YES];
    [welfare3Lb_ setHidden:YES];
    
    if (![welfare_ isKindOfClass:[NSNull class]] && welfare_ != nil && [welfare_ count] != 0){
         _compantTopToSalary.constant = 28;
        for (int i=0; i<[welfare_ count]; i++) {
            switch (i) {
                case 0:
                {
                    NSString *welfareStr = [welfare_ objectAtIndex:i];
                    if (![welfareStr isKindOfClass:[NSString class]]) {
                        welfareStr = @"";
                    }
                    
                    [welfare1Lb_ setText:welfareStr];
                    [welfare1Lb_ setHidden:NO];
                }
                    break;
                case 1:
                {
                    NSString *welfareStr = [welfare_ objectAtIndex:i];
                    if (![welfareStr isKindOfClass:[NSString class]]) {
                        welfareStr = @"";
                    }
                    [welfare2Lb_ setText:welfareStr];
                    [welfare2Lb_ setHidden:NO];
                }
                    break;
                case 2:
                {
                    NSString *welfareStr = [welfare_ objectAtIndex:i];
                    if (![welfareStr isKindOfClass:[NSString class]]) {
                        welfareStr = @"";
                    }

                    [welfare3Lb_ setText:welfareStr];
                    [welfare3Lb_ setHidden:NO];
                }
                    break;
                default:
                    break;
            }
            
        }
    }
    else{
          _compantTopToSalary.constant = 8;
    }
    
    
    //没有企业头像隐藏
    if ([image_ isEqualToString:@"http://img3.job1001.com/uppic/nocypic.gif"]) {
        [loginImgv_ setImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
    }
}

#pragma mark 职位分享到留言
- (void)cellInitWithDataModel:(JobSearch_DataModal *)jobModel
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    _bgView_.backgroundColor = [UIColor clearColor];
    welfare1Lb_.hidden = YES;
    welfare2Lb_.hidden = YES;
    welfare3Lb_.hidden = YES;

    regionLb_.hidden = YES ;
    
    [loginImgv_ sd_setImageWithURL:[NSURL URLWithString:jobModel.companyLogo_] placeholderImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
    positionNameLb_.text = [MyCommon translateHTML:jobModel.zwName_];
    //salary 格式处理
    jobModel.salary_ = [jobModel.salary_ stringByReplacingOccurrencesOfString:@"--" withString:@"-"];
    jobModel.salary_ = [jobModel.salary_ stringByReplacingOccurrencesOfString:@" 年薪" withString:@""];
    jobModel.salary_ = [jobModel.salary_ stringByReplacingOccurrencesOfString:@" 月薪" withString:@""];
    
    if ([jobModel.salary_ isEqualToString:@"面议"]) {
        [salaryLb_ setText:jobModel.salary_];
    }else{
        [salaryLb_ setText:[NSString stringWithFormat:@"￥%@",jobModel.salary_]];
    }
    companyNameLb_.text = [MyCommon translateHTML:jobModel.companyName_];
}

@end
