//
//  InterviewMessageDetailCtl.m
//  Association
//
//  Created by 一览iOS on 14-6-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "InterviewMessageDetailCtl.h"
#import "PositionDetailCtl.h"
#import "NewResumeNotifyDataModel.h"
@interface InterviewMessageDetailCtl (){
    NewResumeNotifyDataModel *NewResumeNotifyDeatilVO;
    NewResumeNotifyDataModel *interviewMsgDetail_;
}

@end

@implementation InterviewMessageDetailCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"面试通知详情";
    [self setNavTitle:@"面试通知详情"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    webView_.backgroundColor = [UIColor orangeColor];
}

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationItem.title = @"面试通知详情";
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    NewResumeNotifyDeatilVO = dataModal;
    [super beginLoad:dataModal exParam:nil];
}

-(void)updateCom:(RequestCon *)con
{
    //请求面试详情后刷新界面
    if (NewResumeNotifyDeatilVO) {
        [companyNameLb_ setText:NewResumeNotifyDeatilVO.cname];
        [interviewTimeLb_ setText:NewResumeNotifyDeatilVO.sdate];
        [webView_ loadHTMLString:interviewMsgDetail_.mailtext baseURL:nil];
    }
    [super updateCom:con];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getInterviewMessageDetail:NewResumeNotifyDeatilVO.positionId readStatus:@"1"];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_getInterviewMessageDetail:
        {
            interviewMsgDetail_ = [dataArr objectAtIndex:0];
            if ([NewResumeNotifyDeatilVO.newmail isEqualToString:@"0"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"readInterviewBack" object:nil];
            }
        }
            break;
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == companyInfoBtn_) {
        ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
        dataModel.companyID_ = NewResumeNotifyDeatilVO.uid;
        dataModel.companyName_ = NewResumeNotifyDeatilVO.cname;
        if (NewResumeNotifyDeatilVO.logo != nil && ![NewResumeNotifyDeatilVO.logo isEqualToString:@""] && NewResumeNotifyDeatilVO.logo.length > 0) {
            dataModel.companyLogo_ = NewResumeNotifyDeatilVO.logo;
        }else{
            dataModel.companyLogo_ = interviewMsgDetail_.logo;
        }
        PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
        positionCtl.type_ = 2;
        [self.navigationController pushViewController:positionCtl animated:YES];
        [positionCtl beginLoad:dataModel exParam:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
