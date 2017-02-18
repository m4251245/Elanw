//
//  CompanyResumeCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "CHRIndexCtl.h"
#import "jobChoiceViewController.h"


//jobChoiceDelegate,OtherResumePreviewCtlDelegate
@protocol CompanyResumeReadDelegate <NSObject>

-(void)resumeBeRead;

@optional
- (void)recommendResumeBeRead;

@end

@interface CompanyResumeCtl : BaseListCtl
{
    RequestCon  * setCon_;
}

@property (assign, nonatomic) ResumeType resumeType;
@property(nonatomic,strong) NSString * jobId_;
@property(nonatomic,strong) NSString * jobName;
@property(nonatomic,assign) id<CompanyResumeReadDelegate> delegate_;
@property(nonatomic,assign) int        type_;   //0可进行筛选，1不可以进行筛选，2推荐给企业的简历
@property (nonatomic,assign) BOOL shouldRefresh;
@property (nonatomic, assign) BOOL isRctd;
@property (nonatomic, assign) BOOL isZwgl;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)jobChoiceClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *jobChoiceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (nonatomic, assign) ENTRANCE entrance;//入口

@end
