//
//  ResumeVisitorListCtl.m
//  Association
//
//  Created by 一览iOS on 14-6-25.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ResumeVisitorListCtl.h"
#import "ResumeVistorListCell.h"
#import "ExRequetCon.h"
#import "NewResumeNotifyDataModel.h"

@interface ResumeVisitorListCtl ()

@end

@implementation ResumeVisitorListCtl

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
//    self.navigationItem.title = @"谁看过我的简历";
    [self setNavTitle:@"谁看过我的简历"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
//    self.navigationItem.title = @"谁看过我的简历";
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
    [con getResumeVisitList:[Manager getUserInfo].userId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetResumeVisitList:
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
    static NSString *CellIdentifier = @"ResumeVistorListCell";
    
    ResumeVistorListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ResumeVistorListCell" owner:self options:nil] lastObject];
    }
    NewResumeNotifyDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [cell.companyNameLb_ setText:model.cname];
    [cell.companyNatureLb_ setText:model.cxz];
    [cell.readCountLb_ setText:[NSString stringWithFormat:@"阅读次数 %@",model.readNumber]];
    [cell.readTimeLb_ setText:[model.readDate substringToIndex:10]];
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
    NewResumeNotifyDataModel *applayModel = selectData;
    ZWDetail_DataModal *model = [[ZWDetail_DataModal alloc]init];
    model.companyLogo_ = applayModel.logo;
    model.companyID_ = applayModel.uid;
    model.companyName_ = applayModel.cname;
    positionCtl.type_ = 2;
    [self.navigationController pushViewController:positionCtl animated:YES];
    [positionCtl beginLoad:model exParam:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
