//
//  AttendtionOrganizationCtl.m
//  jobClient
//
//  Created by YL1001 on 14/10/31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "AttendtionOrganizationCtl.h"
#import "AttendtionOrganization_Cell.h"
#import "School_DataModal.h"
#import "JobAttentionNoDataView.h"
#import "PropagandaCtl.h"
#import "CareCompanyDataModel.h"

@interface AttendtionOrganizationCtl ()

@end

@implementation AttendtionOrganizationCtl
@synthesize type_;
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    CGRect frame = tableView_.frame;
    frame.size.width = self.view.frame.size.width;
    tableView_.frame = frame;
    [tableView_ setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataFunction:(RequestCon *)con
{
    if (type_ == Organization_Company) {
        [con getAttentionCompanyList:[Manager getUserInfo].userId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
    }
    if (type_ == Organization_School) {
        [con getAttendSchoolListWithUserId:[Manager getUserInfo].userId_ pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_];
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ChangAttendCareerSchool:
        {
            if (type_ == Organization_Company) {
                CareCompanyDataModel *infoModel = [requestCon_.dataArr_ objectAtIndex:indexPath_.row];
                [requestCon_.dataArr_ removeObject:infoModel];
            }
            else
            {
                School_DataModal *infoModel = [requestCon_.dataArr_ objectAtIndex:indexPath_.row];
                [requestCon_.dataArr_ removeObject:infoModel];
            }
            [tableView_ reloadData];
        }
            break;
        case Request_CancelAttentionCompany:
        {
            if (type_ == Organization_Company) {
                CareCompanyDataModel *infoModel = [requestCon_.dataArr_ objectAtIndex:indexPath_.row];
                [requestCon_.dataArr_ removeObject:infoModel];
            }
            else
            {
                School_DataModal *infoModel = [requestCon_.dataArr_ objectAtIndex:indexPath_.row];
                [requestCon_.dataArr_ removeObject:infoModel];
            }
            [tableView_ reloadData];
        }
        default:
            break;
    }
    if (!requestCon_.dataArr_.count) {
        if (!tableView_.tableHeaderView) {
            JobAttentionNoDataView *noDataView = [[NSBundle mainBundle]loadNibNamed:@"JobAttentionNoDataView" owner:nil options:nil][0];
            noDataView.frame = self.view.bounds;
            tableView_.tableHeaderView = noDataView;
            noDataView.type = type_;
        }
    }else{
        if (tableView_.tableHeaderView) {
            tableView_.tableHeaderView = nil;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tableView_ setEditing:NO];
}

#pragma mark - tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AttendtionOrganization_Cell";
    
    AttendtionOrganization_Cell *cell = (AttendtionOrganization_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AttendtionOrganization_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell.cnameLb_ setFont:FOURTEENFONT_CONTENT];
    [cell.cnameLb_ setTextColor:BLACKCOLOR];
    
    [cell.contentLb_ setFont:FOURTEENFONT_CONTENT];
    [cell.contentLb_ setTextColor:GRAYCOLOR];
    
    switch (type_) {
        case Organization_Company:
        {
            CareCompanyDataModel * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            [cell.cnameLb_ setText:dataModal.cname];
            
            [cell.companyLogo_ sd_setImageWithURL:[NSURL URLWithString:dataModal.logopath] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        }
            break;
        case Organization_School:
        {
            School_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            [cell.cnameLb_ setText:dataModal.name_];
            [cell.contentLb_ setText:dataModal.schoolNews_];
            
            [cell.companyLogo_ sd_setImageWithURL:[NSURL URLWithString:dataModal.logoPath_] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        }
            break;
        default:
            break;
    }
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        indexPath_ = indexPath;
        if (type_ == Organization_Company) {
            CareCompanyDataModel *infoModel = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            RequestCon *changCon = [self getNewRequestCon:NO];
            [changCon cancelAttentionCompany:[Manager getUserInfo].userId_ companyId:infoModel.company_id];
        }
        else
        {
            School_DataModal *infoModel = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            RequestCon *changCon = [self getNewRequestCon:NO];
            [changCon changAttendCareerSchoolWithSchoolId:infoModel.id_ userId:[Manager getUserInfo].userId_];
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消关注";
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    switch (type_) {
        case Organization_Company:
        {
            CareCompanyDataModel *infoModel = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
            dataModel.companyID_ = infoModel.company_id;
            dataModel.companyName_ = infoModel.cname;
            dataModel.companyLogo_ = infoModel.logopath;
            PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
            positionCtl.type_ = 2;
            [self.navigationController pushViewController:positionCtl animated:YES];
            [positionCtl beginLoad:dataModel exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"企业详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];

        }
            break;
        case Organization_School:
        {
            School_DataModal *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            PropagandaCtl *ctl = [[PropagandaCtl alloc]init];
            ctl.type_ = @"1";
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:model exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"我的学校",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
            break;
        default:
            break;
    }
}

-(void)handleEdit:(int)type
{
    switch (type) {
        case 0:
        {
            if (type_ == Organization_Company) {
                for (CareCompanyDataModel * dataModal in requestCon_.dataArr_) {
                    dataModal.canEdit_ = YES;
                }
            }
            if (type_ == Organization_School) {
                for (School_DataModal * dataModal in requestCon_.dataArr_) {
                    dataModal.canEdit_ = YES;
                }
            }
            
        }
            break;
        case 1:
        {
            if (type_ == Organization_Company) {
                for (CareCompanyDataModel * dataModal in requestCon_.dataArr_) {
                    dataModal.canEdit_ = NO;
                }
            }
            if (type_ == Organization_School) {
                for (School_DataModal * dataModal in requestCon_.dataArr_) {
                    dataModal.canEdit_ = NO;
                }
            }

        }
            break;
        default:
            break;
    }
    
    [tableView_ reloadData];
}


-(void)attentionChangeClick:(UIButton *)btn
{
    NSInteger index_ = btn.tag-1000;
    if (type_ == Organization_Company) {
        CareCompanyDataModel *infoModel = [requestCon_.dataArr_ objectAtIndex:index_];
        [requestCon_.dataArr_ removeObject:infoModel];
        [tableView_ reloadData];
        RequestCon *changCon = [self getNewRequestCon:NO];
        [changCon cancelAttentionCompany:[Manager getUserInfo].userId_ companyId:infoModel.company_id];
    }
    else
    {
        School_DataModal *infoModel = [requestCon_.dataArr_ objectAtIndex:index_];
        [requestCon_.dataArr_ removeObject:infoModel];
        [tableView_ reloadData];
        RequestCon *changCon = [self getNewRequestCon:NO];
        [changCon changAttendCareerSchoolWithSchoolId:infoModel.id_ userId:[Manager getUserInfo].userId_];
    }
   
}

-(void) showNoDataOkView:(BOOL)flag
{
    [super showNoDataOkView:NO];
    
}

@end
