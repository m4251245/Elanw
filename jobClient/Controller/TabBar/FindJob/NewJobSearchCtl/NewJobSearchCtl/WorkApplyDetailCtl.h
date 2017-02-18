//
//  WorkApplyDetailCtl.h
//  jobClient
//
//  Created by YL1001 on 15/6/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
//#import "WorkApplyDataModel.h"
#import "MyConfig.h"
@class NewApplyRecordDataModel;

@interface WorkApplyDetailCtl : BaseEditInfoCtl
{
    IBOutlet UIImageView *companyLogo_;   //公司logo
    IBOutlet UILabel *companyName_;       //公司名称
    IBOutlet UILabel *ZWName_;            //职位名称
    IBOutlet UILabel *salary_;            //薪水
    
    IBOutlet UIButton *positionBtn_;
    
    NewApplyRecordDataModel *workApplyModal_;
    
    CGRect frame;
    CGRect timeframe;
    CGRect spotFrame;
}


@property (weak, nonatomic) IBOutlet UILabel *sendLb_;
@property (weak, nonatomic) IBOutlet UILabel *readLb_;
@property (weak, nonatomic) IBOutlet UILabel *collectLb_;
@property (weak, nonatomic) IBOutlet UILabel *mailLb_;
@property (weak, nonatomic) IBOutlet UILabel *waitingLb_;
@property (weak, nonatomic) IBOutlet UILabel *recentlyLb_;


@property (weak, nonatomic) IBOutlet UILabel *sendTime_;
@property (weak, nonatomic) IBOutlet UILabel *readTime_;
@property (weak, nonatomic) IBOutlet UILabel *collectTime_;
@property (weak, nonatomic) IBOutlet UILabel *mailTime_;
@property (weak, nonatomic) IBOutlet UILabel *recentlyTime_;
@property (weak, nonatomic) IBOutlet UILabel *waitingTime_;


@property (weak, nonatomic) IBOutlet UIImageView *spot1_;
@property (weak, nonatomic) IBOutlet UIImageView *spot2_;
@property (weak, nonatomic) IBOutlet UIImageView *spot3_;
@property (weak, nonatomic) IBOutlet UIImageView *spot4_;
@property (weak, nonatomic) IBOutlet UIImageView *spot5_;
@property (weak, nonatomic) IBOutlet UIImageView *spot6_;


@property (weak, nonatomic) IBOutlet UIView *verticalLine1_;
@property (weak, nonatomic) IBOutlet UIView *verticalLine2_;
@property (weak, nonatomic) IBOutlet UIView *verticalLine3_;
@property (weak, nonatomic) IBOutlet UIView *verticalLine4_;
@property (weak, nonatomic) IBOutlet UIView *verticalLine5_;


@end
