//
//  AttentionCompanyListCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-7-11.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "AttentionCompanyListCtl.h"
#import "ExRequetCon.h"
#import "AttentionCompanyCell.h"
#import "SuitJobTableViewCell.h"
#import "CareCompanyDataModel.h"
#import "UIImageView+WebCache.h"

@interface AttentionCompanyListCtl ()

@end

@implementation AttentionCompanyListCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bFooterEgo_ = YES;
        bHeaderEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"关注的企业";
    [self setNavTitle:@"关注的企业"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    dataArray_ = [[NSMutableArray alloc]init];
    [tableView_ registerNib:[UINib nibWithNibName:@"SuitJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"mySuitJobTableViewCell"];
    UIView *view = [[UIView alloc]init];
    tableView_.tableFooterView = view;
    
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"关注的企业";
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
    [con getAttentionCompanyList:[Manager getUserInfo].userId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetAttentionCompanyList:
        {
            if (requestCon_.pageInfo_.currentPage_ == 1) {
                [dataArray_ removeAllObjects];
            }
            for (CareCompanyDataModel *model in dataArr) {
                [dataArray_ addObject:model];
            }
        }
            break;
        case Request_CancelAttentionCompany:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                CareCompanyDataModel *infoModel = [dataArray_ objectAtIndex:index_];
                [dataArray_ removeObject:infoModel];
                [tableView_ reloadData];
                [BaseUIViewController showAutoDismissSucessView:@"取消关注成功" msg:nil];
            }else{
                [BaseUIViewController showAutoDismissSucessView:@"取消关注失败" msg:nil];
            }
        }
            break;
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataArray_ count] !=0) {
        return [dataArray_ count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SuitJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySuitJobTableViewCell" forIndexPath:indexPath];
    CareCompanyDataModel *model = [dataArray_ objectAtIndex:indexPath.row];
    cell.jobLb.text = model.cname;
    
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:model.logopath] placeholderImage:[UIImage imageNamed:@"bg__xinwen2-1.png"] options:SDWebImageAllowInvalidSSLCertificates];
    cell.salaryLb.textColor = UIColorFromRGB(0x888888);
    cell.salaryLb.text = model.cxz;
    cell.salaryLb.font = [UIFont systemFontOfSize:13];
    cell.conditionLb.text = model.yuangong;
    cell.conditionLb.font = [UIFont systemFontOfSize:13];
    cell.conditionLb.textColor = UIColorFromRGB(0x888888);
    cell.companyLb.hidden = YES;
    cell.areaLb.hidden = YES;
    return cell;
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    CareCompanyDataModel *infoModel = [dataArray_ objectAtIndex:indexPath.row];
    ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
    dataModel.companyID_ = infoModel.company_id;
    dataModel.companyName_ = infoModel.cname;
    dataModel.companyLogo_ = infoModel.logopath;
    
    PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
    positionCtl.type_ = 2;
    [self.navigationController pushViewController:positionCtl animated:YES];
    [positionCtl beginLoad:dataModel exParam:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(void)attentionChangeClick:(UIButton *)btn
{
    index_ = btn.tag-1000;
    CareCompanyDataModel *infoModel = [dataArray_ objectAtIndex:index_];
    RequestCon *changCon = [self getNewRequestCon:NO];
    [changCon cancelAttentionCompany:[Manager getUserInfo].userId_ companyId:infoModel.company_id];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
