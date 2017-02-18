//
//  ResumePKView.h
//  jobClient
//
//  Created by 一览ios on 15/4/1.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A3VerticalSliderView.h"
#import "WorkExperienceView.h"

@interface ResumePKView : UIView<UIScrollViewDelegate,A3VerticalSliderViewDelegate>
{
    IBOutlet UIScrollView *leftScrollView;
    
    IBOutlet UIScrollView *rightScrollView;
    
    
    UIView *lineView;
    UIView *lineView2;
    A3VerticalSliderView *slider;
}

//@property(weak, nonatomic) WorkExperienceView *jobView;


@property (weak, nonatomic) IBOutlet UIImageView *userImgv1;
@property (weak, nonatomic) IBOutlet UILabel *userName1;
@property (weak, nonatomic) IBOutlet UILabel *salaryLb1;
@property (strong, nonatomic) IBOutlet UILabel *percentLb1;

@property (weak, nonatomic) IBOutlet UILabel *educationLb1;
@property (weak, nonatomic) IBOutlet UILabel *majorLb1;
@property (weak, nonatomic) IBOutlet UILabel *ageLb1;
@property (weak, nonatomic) IBOutlet UILabel *workAgeLb1;
@property (weak, nonatomic) IBOutlet UILabel *languageLb1;
@property (weak, nonatomic) IBOutlet UILabel *computeLevelLb1;
@property (weak, nonatomic) IBOutlet UILabel *addressLb1;
@property (weak, nonatomic) IBOutlet UILabel *companyLb1;
@property (strong, nonatomic) IBOutlet UILabel *schoolLb1;
@property (strong, nonatomic) IBOutlet UILabel *professionLb1;



@property (weak, nonatomic) IBOutlet UIImageView *userImgv2;
@property (weak, nonatomic) IBOutlet UILabel *userName2;
@property (weak, nonatomic) IBOutlet UILabel *salaryLb2;
@property (strong, nonatomic) IBOutlet UILabel *percentLb2;
@property (weak, nonatomic) IBOutlet UILabel *educationLb2;
@property (weak, nonatomic) IBOutlet UILabel *majorLb2;
@property (weak, nonatomic) IBOutlet UILabel *ageLb2;
@property (weak, nonatomic) IBOutlet UILabel *workAgeLb2;
@property (weak, nonatomic) IBOutlet UILabel *languageLb2;
@property (weak, nonatomic) IBOutlet UILabel *computeLevelLb2;
@property (weak, nonatomic) IBOutlet UILabel *addressLb2;
@property (weak, nonatomic) IBOutlet UILabel *companyLb2;
@property (strong, nonatomic) IBOutlet UILabel *schoolLb2;
@property (strong, nonatomic) IBOutlet UILabel *professionLb2;





@property (strong, nonatomic) NSArray *resumeArr;

@end
