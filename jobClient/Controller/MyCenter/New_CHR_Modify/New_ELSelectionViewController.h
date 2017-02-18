//
//  New_ELSelectionViewController.h
//  jobClient
//
//  Created by 一览ios on 16/9/22.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "CHRIndexCtl.h"

//typedef NS_ENUM(NSInteger,ENTRANCE)//入口
//{
//    DEFAULT,
//    POSITION,//通过职位跳转进来
//};
@class TxtSearchView;

//@protocol CompanyResumeReadDelegate <NSObject>
//
//-(void)resumeBeRead;
//
//@optional
//- (void)recommendResumeBeRead;
//
//@end

@interface New_ELSelectionViewController : BaseListCtl

@property (assign, nonatomic) ResumeType resumeType;

//@property(nonatomic,assign) id<CompanyResumeReadDelegate> delegate;
@property (nonatomic,assign) BOOL shouldRefresh;
@property(nonatomic,assign) int type;
@property(nonatomic,copy) NSString *jobId_;

@property(nonatomic,retain)TxtSearchView *seachView;

@property(nonatomic,assign) ENTRANCE entrance;
@property(nonatomic,strong) NSString *positionName;
@property(nonatomic, strong) CompanyInfo_DataModal *companyInfo;//公司信息
@end
