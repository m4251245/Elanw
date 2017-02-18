//
//  ResumePKView.m
//  jobClient
//
//  Created by 一览ios on 15/4/1.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ResumePKView.h"
#import "User_DataModal.h"
#import "WorkExperienceView.h"
#import "SalaryListCtl.h"
#import "UIImageView+WebCache.h"

@implementation ResumePKView
{
    CGFloat scrollHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    CALayer *layer = _userImgv1.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 28.f;
    layer = _userImgv2.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 28.f;
    
    leftScrollView.delegate = self;
    rightScrollView.delegate= self;
    
    slider = [[A3VerticalSliderView alloc] initWithFrame:CGRectMake(147, 99, 10, leftScrollView.frame.size.height)];
    slider.delegate = self;
    [self addSubview:slider];
    
    
    UIImage *sliderImage = [UIImage imageNamed:@"bg_03.png"];
    sliderImage = [sliderImage resizableImageWithCapInsets:UIEdgeInsetsMake(12, 8, 15, 8)];
    UIImageView *sliderImageView = [[UIImageView alloc] initWithImage:sliderImage];
    sliderImageView.frame = CGRectMake(-3, 0, 14, 88);
    sliderImageView.layer.cornerRadius = 7;
    slider.positionIndicator = sliderImageView;

    lineView =[[UIView alloc] init];
    lineView.frame = CGRectMake(10, 334, 1, 100);
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.0;
    
    lineView2 =[[UIView alloc] init];
    lineView2.frame = CGRectMake(10, 334, 1, 100);
    lineView2.backgroundColor = [UIColor lightGrayColor];
    lineView2.alpha = 0.0;
}

- (void)setResumeArr:(NSArray *)resumeArr
{
    [leftScrollView setContentSize:CGSizeMake((self.frame.size.width - 5)/2, 400)];
    [rightScrollView setContentSize:CGSizeMake((self.frame.size.width - 5)/2, 400)];
    
    slider.sliderValue = 0;
    
    if (resumeArr.count)
    {
        User_DataModal *myDataModel = resumeArr[1];
        [_userImgv1 setImage:[UIImage imageNamed:myDataModel.img_]];
        _userName1.text = myDataModel.name_;
        _salaryLb1.text = [NSString stringWithFormat:@"¥ %@", myDataModel.salary_];
        _educationLb1.text = myDataModel.eduName_;
        _majorLb1.text = myDataModel.job_;
        _ageLb1.text = [NSString stringWithFormat:@"%@ 岁", myDataModel.age_] ;
        _workAgeLb1.text = [NSString stringWithFormat:@"%d 年", [myDataModel.gzNum_ intValue]];
        
        _professionLb1.text = myDataModel.zym_;
        _percentLb1.text = [NSString stringWithFormat:@"%@%%", myDataModel.percent];
        
        if ([myDataModel.languageLevel_ isEqualToString:@""]) {
            _languageLb1.text = @"语言能力";
            _languageLb1.textColor = [UIColor lightGrayColor];
        }else{
            _languageLb1.text = myDataModel.languageLevel_;
        }
        
        if ([myDataModel.computerLevel_ isEqualToString:@""]) {
            _computeLevelLb1.text = @"计算机能力";
            _computeLevelLb1.textColor = [UIColor lightGrayColor];
        }else{
            _computeLevelLb1.text = myDataModel.computerLevel_;
        }
        
        _addressLb1.text = myDataModel.regiondetail_;
        
        if ([myDataModel.companyNature_ isEqualToString:@""]) {
            _companyLb1.text = @"公司性质";
            _companyLb1.textColor = [UIColor lightGrayColor];
        }else{
            _companyLb1.text = myDataModel.companyNature_;
        }
        
        if ([myDataModel.school_ isEqualToString:@""]) {
            _schoolLb1.text = @"毕业院校";
            _schoolLb1.textColor = [UIColor lightGrayColor];
        }else{
            _schoolLb1.text = myDataModel.school_;
        }
        [self workExperience:myDataModel.jobArr_];
        
        
        myDataModel = resumeArr[0];
        [_userImgv2 sd_setImageWithURL:[NSURL URLWithString:myDataModel.img_] placeholderImage:nil];
        _userName2.text = myDataModel.name_;
        _salaryLb2.text = [NSString stringWithFormat:@"¥ %@", myDataModel.salary_];
        _educationLb2.text = myDataModel.eduName_;
        _majorLb2.text = myDataModel.job_;
        _ageLb2.text = [NSString stringWithFormat:@"%@ 岁", myDataModel.age_] ;
        _workAgeLb2.text = [NSString stringWithFormat:@"%d 年", [myDataModel.gzNum_ intValue]];
        
        _percentLb2.text = [NSString stringWithFormat:@"%@%%", myDataModel.percent];
        _schoolLb2.text = myDataModel.school_;
        _professionLb2.text = myDataModel.zym_;
        
        if ([myDataModel.languageLevel_ isEqualToString:@""]) {
            _languageLb2.text = @"语言能力";
            _languageLb2.textColor = [UIColor lightGrayColor];
        }else{
            _languageLb2.text = myDataModel.languageLevel_;
        }
        if ([myDataModel.computerLevel_ isEqualToString:@""]) {
            _computeLevelLb2.text = @"计算机能力";
            _computeLevelLb2.textColor = [UIColor lightGrayColor];
        }else{
            _computeLevelLb2.text = myDataModel.computerLevel_;
        }
        _addressLb2.text = myDataModel.regiondetail_;
        if ([myDataModel.companyNature_ isEqualToString:@""]) {
            _companyLb2.text = @"公司性质";
            _companyLb2.textColor = [UIColor lightGrayColor];
        }else{
            _companyLb2.text = myDataModel.companyNature_;
        }
        [self rightWorkExperience:myDataModel.jobArr_];
    }
}

- (void)workExperience:(NSMutableArray *)array
{
    NSInteger index = 0;
    scrollHeight = 200;
    
    for (id view in [leftScrollView subviews])
    {
        if ([view isKindOfClass:[WorkExperienceView class]])
        {
            UIView *gzView = (UIView *)view;
            [gzView removeFromSuperview];
        }
        
        if ([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageV = (UIImageView *)view;
            [imageV removeFromSuperview];
        }
    }    
    
    lineView2.alpha = 0.0;
    if (array)
    {
        if (array.count > 1)
        {
            lineView2.alpha = 1.0;
            CGRect lineRect = lineView2.frame;
            lineRect.size.height = 45 * ([array count]-1);
            lineView2.frame = lineRect;
            [leftScrollView addSubview:lineView2];
        }
        
        
        for (NSInteger i = [array count]; i > 0; --i)
        {
            UserJob_DataModal *gzModal = [array objectAtIndex:[array count]-1-(i-1)];
            WorkExperienceView *_jobView = [[[NSBundle mainBundle] loadNibNamed:@"WorkExperienceView" owner:self options:nil] lastObject];
            _jobView.frame = CGRectMake(8, 45 * index + 320, 140, 45);
            if (i == [array count])
            {
                [_jobView.timeLb_ setTextColor:Color_Red];
                [_jobView.numLb_ setTextColor:Color_Red];
                [_jobView.zwLb_ setTextColor:Color_Red];
            }
            
            [leftScrollView addSubview:_jobView];

            if (i == [array count])
            {
                UIImageView *yuanImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, _jobView.frame.origin.y + 8, 10, 10)];
                [yuanImg setImage:[UIImage imageNamed:@"icon_ios_quan1"]];

                [leftScrollView addSubview:yuanImg];
            }
            else
            {
                UIImageView *yuanImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, _jobView.frame.origin.y + 10, 8, 8)];
                [yuanImg setImage:[UIImage imageNamed:@"icon_ios_lvli_def"]];
                [leftScrollView addSubview:yuanImg];
            }
        
//            NSDate *startDate = [formatter dateFromString:gzModal.stratDate_];
            NSDate *endDate = [gzModal.endDate_ dateFormStringFormat:@"yyyy-MM-dd" timeZone:[NSTimeZone localTimeZone]];
            if (!endDate || endDate == nil) {
                endDate = [NSDate date];
            }
            
            _jobView.numLb_.text = [NSString stringWithFormat:@"%@年",gzModal.gznum_];
            
            if (!gzModal.endDate_ || [gzModal.endDate_ isEqualToString:@""] || [gzModal.endDate_ isEqualToString:@"0000-00-00"])
            {
                gzModal.endDate_ = @"至今";
            }
            if (!gzModal.stratDate_ || [gzModal.stratDate_ isEqualToString:@""]||[gzModal.stratDate_ isEqualToString:@"0000-00-00"]) {
                gzModal.stratDate_ = [MyCommon getDateStr:[NSDate date] format:@"yyyy-MM-dd"];
            }
            
            NSString *startdate = gzModal.stratDate_;
            NSString *enddate = gzModal.endDate_;
            
            startdate  = [startdate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            enddate = [enddate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            _jobView.timeLb_.text = [NSString stringWithFormat:@"%@ -- %@",startdate,enddate];
            _jobView.zwLb_.text = [NSString stringWithFormat:@"任 %@",gzModal.zwName_];
            
            ++index;
        }
        
        scrollHeight = 320 + 50 * [array count];
        
        [leftScrollView setContentSize:CGSizeMake((self.frame.size.width - 5)/2, scrollHeight)];
        [rightScrollView setContentSize:CGSizeMake((self.frame.size.width - 5)/2, scrollHeight)];
    }
}


- (void)rightWorkExperience:(NSMutableArray *)array
{
    NSInteger index = 0;
    CGFloat height = 200;
    
    for (id view in [rightScrollView subviews])
    {
        if ([view isKindOfClass:[WorkExperienceView class]])
        {
            UIView *gzView = (UIView *)view;
            [gzView removeFromSuperview];
        }
        
        if ([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageV = (UIImageView *)view;
            [imageV removeFromSuperview];
        }
    }    
    
    lineView.alpha = 0.0;
    if (array)
    {
        if (array.count > 1)
        {            
            lineView.alpha = 1.0;
            CGRect lineRect = lineView.frame;
            lineRect.size.height = 45 * ([array count]-1);
            lineView.frame = lineRect;
            [rightScrollView addSubview:lineView];
        }
        
        for (NSInteger i = [array count]; i > 0; --i)
        {
            UserJob_DataModal *gzModal = [array objectAtIndex:[array count]-1-(i-1)];
            WorkExperienceView *jobView = [[[NSBundle mainBundle] loadNibNamed:@"WorkExperienceView" owner:self options:nil] lastObject];
            jobView.frame = CGRectMake(8, 45 * index + 320, 140, 45);
            if (i == [array count])
            {
                [jobView.timeLb_ setTextColor:[UIColor colorWithRed:121/255.0 green:186/255.0 blue:222/255.0 alpha:1.0]];
                [jobView.numLb_ setTextColor:[UIColor colorWithRed:121/255.0 green:186/255.0 blue:222/255.0 alpha:1.0]];
                [jobView.zwLb_ setTextColor:[UIColor colorWithRed:121/255.0 green:186/255.0 blue:222/255.0 alpha:1.0]];
            }
            
            [rightScrollView addSubview:jobView];
            
            if (i == [array count])
            {
                UIImageView *yuanImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, jobView.frame.origin.y + 8, 10, 10)];
                [yuanImg setImage:[UIImage imageNamed:@"icon_ios_quan1"]];
                [rightScrollView addSubview:yuanImg];
            }
            else
            {
                UIImageView *yuanImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, jobView.frame.origin.y + 10, 8, 8)];
                [yuanImg setImage:[UIImage imageNamed:@"icon_ios_lvli_def"]];
                [rightScrollView addSubview:yuanImg];
            }
            
//            NSDate *startDate = [formatter dateFromString:gzModal.stratDate_];
            NSDate *endDate = [gzModal.endDate_ dateFormStringFormat:@"yyyy-MM-dd" timeZone:[NSTimeZone localTimeZone]];
            if (!endDate || endDate == nil) {
                endDate = [NSDate date];
            }
            
            jobView.numLb_.text = [NSString stringWithFormat:@"%@年",gzModal.gznum_];
            
            if (!gzModal.endDate_ || [gzModal.endDate_ isEqualToString:@""] || [gzModal.endDate_ isEqualToString:@"0000-00-00"])
            {
                gzModal.endDate_ = @"至今";
            }
            if (!gzModal.stratDate_ || [gzModal.stratDate_ isEqualToString:@""]||[gzModal.stratDate_ isEqualToString:@"0000-00-00"]) {
                gzModal.stratDate_ = [MyCommon getDateStr:[NSDate date] format:@"yyyy-MM-dd"];
            }
            
            NSString *startdate = gzModal.stratDate_;
            NSString *enddate = gzModal.endDate_;
            
            startdate  = [startdate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            enddate = [enddate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            jobView.timeLb_.text = [NSString stringWithFormat:@"%@ -- %@",startdate,enddate];
            jobView.zwLb_.text = [NSString stringWithFormat:@"%@",gzModal.zwName_];
            
            ++index;
        }
        
        height = 320 + 50 * [array count];
        
        if (height > scrollHeight) {
            [leftScrollView setContentSize:CGSizeMake((self.frame.size.width - 5)/2, height)];
            [rightScrollView setContentSize:CGSizeMake((self.frame.size.width - 5)/2, height)];

        }
        
    }
}

#pragma mark - A3VerticalSliderViewDelegate
- (void)A3VerticalSliderViewDidChangeValue:(A3VerticalSliderView *)sliderView
{
    CGFloat contentH = leftScrollView.contentSize.height;
    CGFloat maxContentOffset = contentH - leftScrollView.frame.size.height;
    
    CGFloat nowContentOffset = maxContentOffset * sliderView.sliderValue;
    
    leftScrollView.contentOffset = CGPointMake(0, nowContentOffset);
    rightScrollView.contentOffset = CGPointMake(0, nowContentOffset);
}


@end
