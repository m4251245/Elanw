//
//  ResumeAccessAuthorityCtl.m
//  Association
//
//  Created by 一览iOS on 14-6-26.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ResumeAccessAuthorityCtl.h"
#import "ResumeStatusDataModel.h"
#import "ResumeStatusCell.h"
#import "ShieldCompanyCell.h"
#import "SearchCell.h"
#import "SheidCompanyListCtl.h"
#import "AddShieldTableViewCell.h"

@interface ResumeAccessAuthorityCtl ()<UIAlertViewDelegate>{
    NSInteger btnTag;
}

@end

@implementation ResumeAccessAuthorityCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bFooterEgo_ = NO;
        bHeaderEgo_ = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"保密设置";
    [self setNavTitle:@"保密设置"];
    resumeAuthorArray_ = [[NSMutableArray alloc]init];
    companyArray = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        ResumeStatusDataModel *model = [[ResumeStatusDataModel alloc]init];
        switch (i) {
            case 1:
                model.statusKey_ = [NSString stringWithFormat:@"%d",i];
                model.statusValue_ = @"公开";
                model.linkStr = @"(所有企业都能看到，屏蔽公司除外)";
                model.selected_ = NO;
                break;
            case 0:
                model.statusKey_ = [NSString stringWithFormat:@"%d",i];
                model.statusValue_ = @"保密";
                model.linkStr = @"(只有您主动投递的企业可以看到)";
                model.selected_ = NO;
                break;
            case 2:
                model.statusKey_ = [NSString stringWithFormat:@"%d",i];
                model.statusValue_ = @"只对一览公开";
                model.linkStr = @"(只有一览招聘顾问可以看到)";
                model.selected_ = NO;
                break;
            default:
                break;
        }
        [resumeAuthorArray_ addObject:model];
    }
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView_ registerNib:[UINib nibWithNibName:@"AddShieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"myAddShieldTableViewCell"];
    tableView_.backgroundColor = UIColorFromRGB(0xf0f0f0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"保密设置";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
        [con getResumeVisible:[Manager getUserInfo].userId_];
        if (!companyCon) {
            companyCon = [self getNewRequestCon:NO];
        }
        [companyCon getSheidCompanyList:[Manager getUserInfo].userId_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_setSheidCompany:
        {
            [tableView_ reloadData];
        }
            break;
        case Request_SheidCompany:
        {
            if ([dataArr count] !=0) {
                Status_DataModal *model = [dataArr objectAtIndex:0];
                companyArray = [model.exObjArr_ mutableCopy];
                [tableView_ reloadData];
            }
        }
            break;
        case Request_GetResumeVisible:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                for (ResumeStatusDataModel *statusModel in resumeAuthorArray_) {
                    if ([statusModel.statusKey_ isEqualToString:model.exObj_]) {
                        statusModel.selected_ = YES;
                    }
                }
                [tableView_ reloadData];
            }
            
        }
            break;
        case Request_UpdateResumeVisible:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                for (ResumeStatusDataModel *model in resumeAuthorArray_) {
                    model.selected_ = NO;
                }
                ResumeStatusDataModel *model = [resumeAuthorArray_ objectAtIndex:tempIndexPath.row];
                if ([model.statusKey_ isEqualToString:resumeAuthorKey_]) {
                    return;
                }
                model.selected_ = YES;
                resumeAuthorKey_ = model.statusKey_;
                [tableView_ reloadData];
                [BaseUIViewController showAutoDismissSucessView:@"" msg:@"设置成功" seconds:1.0];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"设置失败" msg:nil];
            }
            
        }
            break;
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([resumeAuthorArray_ count]!=0) {
            return [resumeAuthorArray_ count];
        }
    }else if (section == 1){
        if (companyArray.count < 3) {
            return companyArray.count + 1;
        }
        return companyArray.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"ResumeStatusCell";
        ResumeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ResumeStatusCell" owner:self options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        ResumeStatusDataModel *model = [resumeAuthorArray_ objectAtIndex:indexPath.row];
        [cell.statusLb_ setText:model.statusValue_];
        cell.linkLb.text = model.linkStr;
        if (model.selected_) {
            [cell.statusMarkBtn_ setHidden:NO];
            resumeAuthorKey_ = model.statusKey_;
        }else{
            [cell.statusMarkBtn_ setHidden:YES];
        }
        return cell;
    }else{
        if (companyArray.count < 3) {
            if (indexPath.row == companyArray.count) {
                AddShieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myAddShieldTableViewCell" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
                cell.selectedBackgroundView = bgView;
                cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xe0e0e0);

                return cell;
            }
        }
        static NSString *CellIdentifier = @"ShieldCompanyCell";
        ShieldCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShieldCompanyCell" owner:self options:nil] lastObject];
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.sheidBtn addTarget:self action:@selector(sheidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sheidBtn setTag:200+indexPath.row];
        NSInteger tempCount = [companyArray count];
        
        if (tempCount > indexPath.row) {
            [cell.companyNameLb setHidden:NO];
            [cell.companyNameLb setText:[companyArray objectAtIndex:indexPath.row]];
            [cell.sheidBtn setHidden:NO];
        }else{
            [cell.companyNameLb setHidden:YES];
            [cell.sheidBtn setHidden:YES];
        }
        return cell;
    }
}

#pragma mark - 解除屏蔽
- (void)sheidBtnClick:(UIButton *)button
{
    if (button.tag - 200 < [companyArray count] ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        btnTag = button.tag - 200;
        [alert show];
    }
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type{
    if (index == 0) {
        [companyArray removeObjectAtIndex:btnTag];
        if (!updateSheidCon) {
            updateSheidCon = [self getNewRequestCon:NO];
        }
        [updateSheidCon setSheidCompanyWithPersonId:[Manager getUserInfo].userId_ companyList:companyArray];
    }
    else{
        return;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        tempIndexPath = indexPath;
        ResumeStatusDataModel *model = [resumeAuthorArray_ objectAtIndex:indexPath.row];
        if (model.statusKey_ == resumeAuthorKey_) {
            return;
        }
        model.selected_ = YES;
        if (!updateCon_) {
            updateCon_ = [self getNewRequestCon:NO];
        }
        [updateCon_ updateResumeVisible:[Manager getUserInfo].userId_ limitsKey:model.statusKey_];
    }else{
        if ([companyArray count] > indexPath.row) {
            return;
        }
        SheidCompanyListCtl *sheidCompanyCtl = [[SheidCompanyListCtl alloc] init];
        sheidCompanyCtl.block = ^(NSString *string){
            [companyArray addObject:string];
            if (!updateSheidCon) {
                updateSheidCon = [self getNewRequestCon:NO];
            }
            [updateSheidCon setSheidCompanyWithPersonId:[Manager getUserInfo].userId_ companyList:companyArray];
        };
        [self.navigationController pushViewController:sheidCompanyCtl animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [titleView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 75, 50)];
    [titleLb setBackgroundColor:[UIColor clearColor]];
    [titleLb setTextColor:UIColorFromRGB(0x999999)];
    [titleLb setFont:FOURTEENFONT_CONTENT];
    if (section == 0) {
        [titleLb setText:@"简历保密设置"];
    }else{
        [titleLb setText:@"屏蔽公司设置（最多可设置3家）"];
    }
    [titleView addSubview:titleLb];
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}

-(void)rightBarBtnResponse:(id)sender
{
    if (!updateCon_) {
        updateCon_ = [self getNewRequestCon:NO];
    }
    [updateCon_ updateResumeVisible:[Manager getUserInfo].userId_ limitsKey:resumeAuthorKey_];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
