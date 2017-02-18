//
//  InbiddingJobCtl.m
//  jobClient
//
//  Created by 一览ios on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "InbiddingJobCtl.h"
#import "InbiddingJobCell.h"
#import "ExRequetCon.h"
#import "ZWDetail_DataModal.h"
#import "FBPositionCtl.h"
#import "CompanyResumeCtl.h"
#import "ELNormalJobCtl.h"
#import "ELStopJobCtl.h"

@interface InbiddingJobCtl ()
{
    NSString    *inCompanyId;
    
    __weak IBOutlet UIScrollView *scrollView_;
    ELNormalJobCtl *normalCtl;//在招
    ELStopJobCtl *stopCtl;//停止
    
    __weak IBOutlet UIButton *leftBtn;
    __weak IBOutlet UIButton *rightBtn;
    
    __weak IBOutlet UIView *lineView;
    
    __weak IBOutlet UIView *headerVIew;
    
    RequestCon *zpRoleCon;
    NSString *zpRoleStr;
}

@end

@implementation InbiddingJobCtl

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.title = @"职位管理";
    [self setNavTitle:@"职位管理"];
    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    
    [self.view bringSubviewToFront:fabuBtn];
    
    fabuBtn.clipsToBounds = YES;
    fabuBtn.layer.cornerRadius = 4.0;
    
    NSString *m_isAddZp = [CommonConfig getDBValueByKey:@"m_isAddZp"];
    if (m_isAddZp && [m_isAddZp isEqualToString:@"0"]) {
        fabuBtn.hidden = YES;
        scrollView_.frame = CGRectMake(0,44,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64 - 44);
    }else{
        scrollView_.frame = CGRectMake(0,44,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 64 - 38 - 44);
    }
    
    scrollView_.bounces = NO;
    scrollView_.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2,scrollView_.frame.size.height);
    
    leftBtn.center = CGPointMake((ScreenWidth/7.0)*2,leftBtn.center.y);
    rightBtn.center = CGPointMake((ScreenWidth/7.0)*5,leftBtn.center.y);
    
    normalCtl = [[ELNormalJobCtl alloc] init];
    normalCtl.view.frame = CGRectMake(0,0,scrollView_.frame.size.width,scrollView_.frame.size.height);
    [normalCtl beginLoad:inCompanyId exParam:nil];
    [scrollView_ addSubview:normalCtl.view];
    [self addChildViewController:normalCtl];
    
    stopCtl = [[ELStopJobCtl alloc] init];
    stopCtl.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width,0,scrollView_.frame.size.width,scrollView_.frame.size.height);
    [stopCtl beginLoad:inCompanyId exParam:nil];
    [scrollView_ addSubview:stopCtl.view];
    [self addChildViewController:stopCtl];
    
    __weak InbiddingJobCtl *ctl = self;
    stopCtl.stopBlock = ^(){
        [ctl refreshNormalCtl];
    };
    
    normalCtl.startBlock = ^(){
        [ctl refreshStopCtl];
    };
    
    [self changeListBtnRespone:leftBtn];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"职位管理";
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

-(void)refreshNormalCtl
{
    [normalCtl refreshLoad];
}

-(void)refreshStopCtl
{
    [stopCtl refreshLoad];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inCompanyId = dataModal;
    
    if (!zpRoleCon) {
        zpRoleCon = [self getNewRequestCon:NO];
    }
    [zpRoleCon getZWFBInfoWithCompanyId:inCompanyId];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    [con getZpListWithCompanyId:inCompanyId pageSize:15 pageIndex:requestCon_.pageInfo_.currentPage_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_getZpListWithCompanyId:
        {
            [tableView_ reloadData];
        }
            break;
        case Request_getZWFBInfoWithCompanyId:
        {
            NSDictionary *dic = [dataArr firstObject];
            zpRoleStr = dic[@"zpRole"];
        }
            break;
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"InbiddingJobCell";
    InbiddingJobCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"InbiddingJobCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ZWDetail_DataModal *model = requestCon_.dataArr_[indexPath.row];
    [cell.positionLb setText:model.zwName_];
    [cell.salaryLb setText:model.salary_];
    [cell.regionLb setText:model.regionName_];
    [cell.companyLb setText:[NSString stringWithFormat:@"发布时间:%@",[model.updateTime_ substringToIndex:10]]];
    [cell.jianliBtn setTitle:[NSString stringWithFormat:@"简历 %@ 份",model.count_] forState:UIControlStateNormal];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0f;
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    ZWDetail_DataModal *model = requestCon_.dataArr_[indexPath.row];
    CompanyResumeCtl *companyResumeCtl = [[CompanyResumeCtl alloc] init];
    companyResumeCtl.isZwgl = YES;
    companyResumeCtl.type_ = 0;
    companyResumeCtl.jobId_ = model.zwID_;
    companyResumeCtl.resumeType = ResumeTypePersonDelivery;
    companyResumeCtl.title = @"人才投递";
    [self.navigationController pushViewController:companyResumeCtl animated:YES];
    [companyResumeCtl beginLoad:inCompanyId exParam:nil];
}


- (void)btnResponse:(id)sender
{
    if (sender == fabuBtn) 
    {
        
        if (![zpRoleStr isEqualToString:@"1"])
        {
            [BaseUIViewController showAlertView:@"" msg:@"您没有发布职位的权限哟!" btnTitle:@"关闭"];
            return;
        }
        else if ([zpRoleStr isEqualToString:@"0"])
        {
            [BaseUIViewController showAlertView:@"" msg:@"您可发布的职位数为0" btnTitle:@"关闭"];
            return;
        }
        
        FBPositionCtl *ctl = [[FBPositionCtl alloc] init];
        ctl.companyDetailModal = self.companyDetailModal;
        ctl.block = ^(){
            [self refreshNormalCtl];
        };
        [ctl beginLoad:inCompanyId exParam:nil];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (IBAction)changeListBtnRespone:(UIButton *)sender
{
    CGPoint center = lineView.center;
    center.x = sender.center.x;
    if (sender == leftBtn)
    {
        [leftBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [scrollView_ setContentOffset:CGPointMake(0,0) animated:YES];
    }
    else
    {
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
        [scrollView_ setContentOffset:CGPointMake(scrollView_.frame.size.width,0) animated:YES];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        lineView.center = center;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
