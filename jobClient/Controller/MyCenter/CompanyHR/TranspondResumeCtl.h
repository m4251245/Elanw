//
//  TranspondResumeCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-12.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "CHRIndexCtl.h"

//#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

typedef enum
{
    TranspondRecommendResume = 1,//推荐的简历
    TranspondAdviserRecommend //offer派中招聘顾问推荐
} TranspondType;

@protocol TranspondResumeCtlDelegate <NSObject>

@optional
-(void)removeView;
-(void)backView;

@end

@interface TranspondResumeCtl : BaseListCtl
{
    IBOutlet  UITextField   *emailTX_;
    IBOutlet  UIView        *_backView;
    IBOutlet  UIButton      *clostBtn_;
    IBOutlet  UIButton      *commitBtn_;
    
    IBOutlet  UIScrollView  *scrollView_;
    IBOutlet  UIButton      *backBtn_;
    
    User_DataModal          *inModal_;
    RequestCon              *transferon_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
}

@property (nonatomic,assign) id<TranspondResumeCtlDelegate> delegate_;
@property (nonatomic,strong) NSString * url_;
@property (nonatomic, assign) TranspondType type;
@property (assign, nonatomic) ResumeType resumeType;
@property (nonatomic, assign) NSInteger isGUWEN;

@property (assign, nonatomic) NSInteger tag;
@property (assign, nonatomic) BOOL isResumeSearch;
@end
