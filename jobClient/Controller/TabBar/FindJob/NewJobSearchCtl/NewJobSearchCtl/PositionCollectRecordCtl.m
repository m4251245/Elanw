//
//  PositionCollectRecordCtl.m
//  Association
//
//  Created by 一览iOS on 14-6-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "PositionCollectRecordCtl.h"
#import "PositionCollectRecordCell.h"
#import "WorkApplyDataModel.h"
#import "PositionDetailCtl.h"
#import "SuitJobTableViewCell.h"
#import "NewPositionCollectDataModel.h"

@interface PositionCollectRecordCtl ()

@end

@implementation PositionCollectRecordCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFooterEgo_ = YES;
        bHeaderEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.title = @"职位收藏记录";
    [self setNavTitle:@"职位收藏记录"];
//    positionArray_ = [[NSMutableArray alloc]init];
    seletedArray_ = [[NSMutableArray alloc]init];
    
    CALayer *layer=[bottomView_ layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:0.0];
    [layer setBorderColor:[[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1] CGColor]];
    
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView_.backgroundColor = UIColorFromRGB(0xf0f0f0);
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"职位收藏记录";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
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
    [con getPositionApplyCollectList:[Manager getUserInfo].userId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetPositionApplyCollectList:
        {
            [tableView_ reloadData];
        }
            break;
        case Request_DeleteCollectPosition:
        {
            Status_DataModal *statusModel = [dataArr objectAtIndex:0];
            if ([statusModel.status_ isEqualToString:@"OK"]) {
                NewPositionCollectDataModel *model = (NewPositionCollectDataModel *)[requestCon_.dataArr_ objectAtIndex:indexPath_.row];
                //移除数据源
                [requestCon_.dataArr_ removeObjectAtIndex:indexPath_.row];
                if ([seletedArray_ containsObject:model]) {
                    [seletedArray_ removeObject:model];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FRESHCOLLECTIONCOUNT" object:@"-"];
                [tableView_ reloadData];
                [BaseUIViewController showAutoDismissSucessView:@"删除职位成功" msg:nil];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"删除职位失败" msg:nil];
            }
        }
            break;
        default:
            break;
    }
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if ([positionArray_ count] !=0) {
//        return [positionArray_ count];
//    }
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mySuitJobTableViewCell";
    
    SuitJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SuitJobTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = bgView;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
//    WorkApplyDataModel
    NewPositionCollectDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
    cell.jobLb.text = model.jtzw;
    cell.areaLb.text = model.region;
    cell.salaryLb.text = model.xzdy;
    cell.salaryLb.textColor = UIColorFromRGB(0xe13e3e);
    if ([model.fldy isKindOfClass:[NSArray class]] && model.fldy.count > 0) {
        if (model.fldy.count == 1) {
            cell.conditionLb.text = model.fldy[0];
        }
        else if(model.fldy.count == 2){
            cell.conditionLb.text = [NSString stringWithFormat:@"%@ %@",model.fldy[0],model.fldy[1]];
        }
        else if(model.fldy.count > 2){
            cell.conditionLb.text = [NSString stringWithFormat:@"%@ %@ %@",model.fldy[0],model.fldy[1],model.fldy[2]];
        }
        cell.companyTopTo.constant = 28;
        cell.conditionLb.hidden = NO;
    }
    else{
        cell.companyTopTo.constant = 5;
        cell.conditionLb.hidden = YES;
    }
    cell.companyLb.text = model.cname;
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    NewPositionCollectDataModel *applayModel = selectData;
    if ([applayModel.zptype isEqualToString:@"0"]) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"该职位已经停招"];
        return;
    }
    ZWDetail_DataModal *model = [[ZWDetail_DataModal alloc]init];
    model.companyID_ = applayModel.uid;
    model.companyName_ = applayModel.cname;
    model.zwID_ = applayModel.positionId;
    model.zwName_ = applayModel.jtzw;
    model.companyLogo_ = applayModel.logo;
    PositionDetailCtl *positionDetailCtl_ = [[PositionDetailCtl alloc] init];
    positionDetailCtl_.type_ = 4;
    [self.navigationController pushViewController:positionDetailCtl_ animated:YES];
    [positionDetailCtl_ beginLoad:model exParam:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewPositionCollectDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if ([model.fldy isKindOfClass:[NSArray class]] && model.fldy.count > 0) {
        return 118;
    }
    return 95;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        indexPath_ = indexPath;
        NewPositionCollectDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        if (!deleteCon_) {
            deleteCon_ = [self getNewRequestCon:NO];
        }
        [deleteCon_ deleteCollectPosition:[Manager getUserInfo].userId_ positionId:model.pf_id];
    }
}

-(void)selectedBtnClick:(UIButton *)button
{
    NewPositionCollectDataModel *model = [requestCon_.dataArr_ objectAtIndex:button.tag - 1000];
    UIButton *changPicBtn = (UIButton *)[tableView_ viewWithTag:button.tag + 1000];
    if (model.isSeleted_) {
        [seletedArray_ removeObject:model];
        model.isSeleted_ = !model.isSeleted_;
        [changPicBtn setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    }else{
        [seletedArray_ addObject:model];
        model.isSeleted_ = !model.isSeleted_;
        [changPicBtn setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    }
    [tableView_ reloadData];
}

-(void)btnResponse:(id)sender
{
    if (sender == applayBtn_) {
        if (!applyCon_) {
            applyCon_ = [self getNewRequestCon:NO];
        }
        //等申请接口
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
