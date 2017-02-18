//
//  ResumeStatusStepCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-12-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ResumeStatusStepCtl.h"
#import "MyConfig.h"

@interface ResumeStatusStepCtl ()

@end

@implementation ResumeStatusStepCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (UIView *)returnStepView:(WorkApplyDataModel *)workDataModel
{
    int status = [workDataModel.resumeStatus intValue];
    if (status >=3 && workDataModel.collectTime_ == nil) {
        [self.view setFrame:CGRectMake(0, 0, 280, 50*status+20)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, 280, 50*(status+1)+20)];
    }

    for (int i=status; i>=0; i--) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10+50*(status-i), 280, 50)];
        view.tag = i+1000;
        UIImageView *cricleImgv = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 6, 6)];
        UIImageView *lineImgv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 13, 2, 37)];
        UILabel *timeLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 3, 225, 9)];
        UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, 125, 41)];
        [contentLb setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLb setNumberOfLines:2];
        if (status == i && status !=0) {
            [lineImgv setImage:[UIImage imageNamed:@"applayRedLine.png"]];
            [cricleImgv setImage:[UIImage imageNamed:@"applayRedCircle.png"]];
        }else{
            [lineImgv setImage:[UIImage imageNamed:@"applayGrayLine.png"]];
            [cricleImgv setImage:[UIImage imageNamed:@"applayGrayCircle.png"]];
        }
        [timeLb setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:8]];
        [timeLb setTextColor:GRAYCOLOR];
        [contentLb setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:11]];
        [contentLb setTextColor:GRAYCOLOR];
        [view addSubview:cricleImgv];
        [view addSubview:lineImgv];
        [view addSubview:timeLb];
        [view addSubview:contentLb];
        [self.view addSubview:view];
        switch (i) {
            case 0:
            {
                UIImageView *lineimgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, 280, 1)];
                [lineimgv setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0]];
                [self.view addSubview:lineimgv];
                if(workDataModel.sendTime_ != nil) {
                    [timeLb setText:workDataModel.sendTime_];
                }
                [contentLb setText:@"简历投递成功"];
            }
                break;
            case 1:
            {
                if(workDataModel.readTime_ != nil) {
                    [timeLb setText:workDataModel.readTime_];
                }
                [contentLb setText:@"简历被HR查看"];
            }
                break;
            case 2:
            {
                if(workDataModel.collectTime_ != nil) {
                    [timeLb setText:workDataModel.collectTime_];
                }
                [contentLb setText:@"HR对您的简历很感兴趣将仔细考虑是否通知面试"];
            }
                break;
            case 3:
            {
                if(workDataModel.mailTime_ != nil) {
                    [timeLb setText:workDataModel.mailTime_];
                }
                [contentLb setText:@"通知面试"];
            }
                break;
            case 4:
            {
                if(workDataModel.unqualTime_ != nil) {
                    [timeLb setText:workDataModel.unqualTime_];
                }
                [contentLb setText:@"很遗憾，HR认为您暂不适合该岗位"];
            }
                break;
            default:
                break;
        }
    }
    
    if (status >=3 && workDataModel.collectTime_ == nil) {
        UIView *view0 = [self.view viewWithTag:1000];
        UIView *view1 = [self.view viewWithTag:1001];
        UIView *view2 = [self.view viewWithTag:1002];
        
        [view2 setHidden:YES];
        
        [view0 setFrame:CGRectMake(0, 10+50*(status-1), 280, 50)];
        [view1 setFrame:CGRectMake(0, 10+50*(status-2), 280, 50)];
    }
    return self.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
