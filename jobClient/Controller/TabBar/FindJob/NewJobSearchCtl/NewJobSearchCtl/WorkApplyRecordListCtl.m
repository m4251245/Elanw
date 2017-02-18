//
//  WorkApplyRecordListCtl.m
//  Association
//
//  Created by 一览iOS on 14-6-23.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "WorkApplyRecordListCtl.h"
#import "WorkApplyRecordCell.h"
#import "WorkApplyDataModel.h"
#import "PositionDetailCtl.h"
#import "WorkApplyDetailCtl.h"

#import "NewApplyRecordDataModel.h"

@interface WorkApplyRecordListCtl ()

@end

@implementation WorkApplyRecordListCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
//    self.navigationItem.title = @"申请记录";
    [self setNavTitle:@"申请记录"];
    //初始化
    recordDataArray_ = [[NSMutableArray alloc]init];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc]init];
    tableView_.tableFooterView = view;
    
    tableView_.backgroundColor = UIColorFromRGB(0xf0f0f0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
//    self.navigationItem.title = @"申请记录";
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:nil];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getWorkApplyList:[Manager getUserInfo].userId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_GetWorkApplyList:
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
    static NSString *CellIdentifier = @"WorkApplyRecordCell";
    
    WorkApplyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkApplyRecordCell" owner:self options:nil] lastObject];
    }
    NewApplyRecordDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [cell initCellWith:model];
    if (model.showMessageView) {
        cell.gwMessageBtn.tag = indexPath.row + 200;
        [cell.gwMessageBtn addTarget:self action:@selector(btnMessageList:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)btnMessageList:(UIButton *)sender
{
    NewApplyRecordDataModel *model = [requestCon_.dataArr_ objectAtIndex:sender.tag - 200];
    
    if (model.bsp_id.length == 0) {
        return;
    }
    
    MessageContact_DataModel * dataModal = [[MessageContact_DataModel alloc] init];
    dataModal.userId = model.bsp_id;
    dataModal.userIname = model.bsp_iname;
    
    MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
    ctl.isHr = NO;
    [self.navigationController pushViewController:ctl animated:YES];
    [ctl beginLoad:dataModal exParam:nil];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewApplyRecordDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];

    if(model.showMessageView)
    {
        return 140;
    }
    return 98;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    WorkApplyDetailCtl *workApplyDetailCtl = [[WorkApplyDetailCtl alloc] init];
    NewApplyRecordDataModel *applyModal = selectData;
    [workApplyDetailCtl beginLoad:applyModal exParam:nil];
    [self.navigationController pushViewController:workApplyDetailCtl animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
