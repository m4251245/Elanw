//
//  InterviewMessageListCtl.m
//  Association
//
//  Created by 一览iOS on 14-6-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "InterviewMessageListCtl.h"
#import "WorkApplyDataModel.h"
#import "InterviewMessageCell.h"

#import "NewResumeNotifyDataModel.h"

@interface InterviewMessageListCtl ()

@end

@implementation InterviewMessageListCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFooterEgo_ = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readInterviewBack:) name:@"readInterviewBack" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
//    self.navigationItem.title = @"面试通知";
    [self setNavTitle:@"面试通知"];
//    interviewMsgArray_ = [[NSMutableArray alloc]init];
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UIView *view = [[UIView alloc]init];
    tableView_.tableFooterView = view;
    tableView_.backgroundColor = UIColorFromRGB(0xf0f0f0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"面试通知";
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    
    [super beginLoad:dataModal exParam:nil];
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)getDataFunction:(RequestCon *)con
{
    User_DataModal *userDataModel = [Manager getUserInfo];
    [con getInterviewMessageList:userDataModel.userId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetInterviewMessageList:
        {
            [tableView_ reloadData];
        }
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InterviewMessageCell";

    InterviewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InterviewMessageCell" owner:self options:nil] lastObject];
    }
    NewResumeNotifyDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [cell.companyNameLb_ setText:model.cname];
    [cell.interviewTimeLb_ setText:model.sdate];
    if ([model.newmail isEqualToString:@"0"]) {
        cell.isReadImg.image = [UIImage imageNamed:@"read_no"];
    }else{
        cell.isReadImg.image = [UIImage imageNamed:@"read_yes"];
    }
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    InterviewMessageDetailCtl *interviewDetailCtl_ = [[InterviewMessageDetailCtl alloc]init];
    [self.navigationController pushViewController:interviewDetailCtl_ animated:YES];
    [interviewDetailCtl_ beginLoad:selectData exParam:nil];
    
    NewResumeNotifyDataModel *model = selectData;
    if ([model.newmail isEqualToString:@"0"]) {
        model.newmail = @"1";
        [tableView_ reloadData];
        if ([Manager shareMgr].haveLogin) {
           [[Manager shareMgr].messageRefreshCtl requestCount];
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}

-(void)readInterviewBack:(NSNotification *)notification
{
    [self refreshLoad:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
