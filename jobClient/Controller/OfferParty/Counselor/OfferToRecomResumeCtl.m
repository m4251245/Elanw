//
//  ConsultantToRecomResumeCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OfferToRecomResumeCtl.h"
#import "ToRecomResumeCell.h"
#import "ConsultantHRDataModel.h"

@interface OfferToRecomResumeCtl ()<UITextFieldDelegate>
{
    User_DataModal *inModel;
    UITextField  *keyWorkTf;
    NSMutableArray *companyArray;
    RequestCon   *recomCon;
    SearchParam_DataModal           *searchParam_;
    NSArray *workAgeArray_;
    NSArray  *workAgeValueArray_;
}
@end

@implementation OfferToRecomResumeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    self.navigationItem.title = @"推荐简历";
    if (_recommendLineUpFlag) {
        self.navigationItem.title = @"推荐排队";
        [self.recomBtn setTitle:@"推荐排队" forState:UIControlStateNormal];
    }
    _recomBtn.layer.cornerRadius = 4.0;
    [_recomBtn setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_recomBtn setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
    _recomBtn.enabled = NO;
    companyArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    searchParam_ = [[SearchParam_DataModal alloc] init];
    inModel = dataModal;
}

- (void)getDataFunction:(RequestCon *)con
{
    [super getDataFunction:con];
    
    if (!searchParam_) {
        searchParam_ = [[SearchParam_DataModal alloc] init];
    }
    
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    
    if (requestCon_.pageInfo_.currentPage_ == 0) {
        [companyArray removeAllObjects];
        [_recomBtn setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_recomBtn setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
        _recomBtn.enabled = NO;
        
    }
    [con getJobFairCompany:self.jobfair_id personId:inModel.userId_ pageSize:15 pageIndex:requestCon_.pageInfo_.currentPage_];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_RecommendPersonToCompany:
        {
            Status_DataModal *model = dataArr[0];
            if ([model.status_ isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"" msg:model.des_ seconds:1.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OFFERPAICOUNREFRESH" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OfferRecomRefresh" object:nil];
                [self backBarBtnResponse:nil];
            }else{
                [BaseUIViewController showAutoDismissSucessView:@"" msg:@"推荐失败" seconds:1.0];
            }
        }
            break;
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ToRecomResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ToRecomResumeCell" owner:self options:nil] lastObject];
        cell.markLb.layer.cornerRadius = 2.0;
        cell.markLb.layer.masksToBounds = YES;
    }
    
    cell.detailBtn.tag = indexPath.row+ 1000;
    [cell.detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CompanyInfo_DataModal *model = requestCon_.dataArr_[indexPath.row];
    if (model.seleted) {
        cell.selectLabel.backgroundColor = [UIColor redColor];
        cell.selectLabel.textColor = [UIColor whiteColor];
    }else{
        cell.selectLabel.backgroundColor = [UIColor clearColor];
        cell.selectLabel.textColor = [UIColor redColor];

    }
    if ([model.isRecommend isEqualToString:@"1"]) {
        [cell.markLb setHidden:NO];
        [cell.markLb setText:@"已推荐"];
        [cell.zwLb setFrame:CGRectMake(cell.zwLb.frame.origin.x, cell.zwLb.frame.origin.y, 220, cell.zwLb.frame.size.height)];
        [cell.nameLb setFrame:CGRectMake(cell.nameLb.frame.origin.x, cell.nameLb.frame.origin.y, 220, cell.nameLb.frame.size.height)];
    }else if([model.isRecommend isEqualToString:@"4"]){
        [cell.markLb setHidden:NO];
        [cell.markLb setText:@"主动申请"];
        [cell.zwLb setFrame:CGRectMake(cell.zwLb.frame.origin.x, cell.zwLb.frame.origin.y, 220, cell.zwLb.frame.size.height)];
        [cell.nameLb setFrame:CGRectMake(cell.nameLb.frame.origin.x, cell.nameLb.frame.origin.y, 220, cell.nameLb.frame.size.height)];
    }else if([model.isRecommend isEqualToString:@"5"]){
        [cell.markLb setHidden:NO];
        [cell.markLb setText:@"顾问推荐"];
        [cell.zwLb setFrame:CGRectMake(cell.zwLb.frame.origin.x, cell.zwLb.frame.origin.y, 220, cell.zwLb.frame.size.height)];
        [cell.nameLb setFrame:CGRectMake(cell.nameLb.frame.origin.x, cell.nameLb.frame.origin.y, 220, cell.nameLb.frame.size.height)];
    }else{
        [cell.markLb setHidden:YES];
        [cell.zwLb setFrame:CGRectMake(cell.zwLb.frame.origin.x, cell.zwLb.frame.origin.y, 259, cell.zwLb.frame.size.height)];
        [cell.nameLb setFrame:CGRectMake(cell.nameLb.frame.origin.x, cell.nameLb.frame.origin.y, 259, cell.nameLb.frame.size.height)];
    }
    [cell.zwLb setText:model.job];
    [cell.nameLb setText:model.cname_];
    cell.offerNameLb.hidden = YES;
    return cell;
}

- (void)detailBtnClick:(UIButton *)button
{
    CompanyInfo_DataModal *dataModal= [requestCon_.dataArr_ objectAtIndex:button.tag - 1000];
    PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
    positionDetailCtl.isConsultantFlag = YES;
    ZWDetail_DataModal *zwModal = [[ZWDetail_DataModal alloc] init];
    zwModal.zwID_ = dataModal.jobId;
    zwModal.companyName_ = dataModal.cname_;
    zwModal.companyID_ = dataModal.uid;
    [self.navigationController pushViewController:positionDetailCtl animated:YES];
    [positionDetailCtl beginLoad:zwModal exParam:nil];
}

- (void)btnResponse:(id)sender
{
    if (sender == _recomBtn) {
        if (!recomCon) {
            recomCon = [self getNewRequestCon:NO];
        }
        if (_recommendLineUpFlag) {//推荐排队
            [recomCon recommendPersonToCompany:self.jobfair_id companyID:companyArray personID:inModel.userId_ salerId:[Manager getHrInfo].salerId isLineUPFlag:YES];
        }else{
            [recomCon recommendPersonToCompany:self.jobfair_id companyID:companyArray personID:inModel.userId_ salerId:[Manager getHrInfo].salerId isLineUPFlag:NO];
        }
    }
}



-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    CompanyInfo_DataModal *model = selectData;
    if ([model.isRecommend isEqualToString:@"1"]) {
        [BaseUIViewController showAlertView:@"" msg:@"已经推荐过了" btnTitle:@"知道了"];
        return;
    }
    ToRecomResumeCell *cell = (ToRecomResumeCell *)[tableView_ cellForRowAtIndexPath:indexPath];
    if (model.seleted) {
        model.seleted = NO;
        [companyArray removeObject:model];
        cell.selectLabel.backgroundColor = [UIColor clearColor];
        cell.selectLabel.textColor = [UIColor redColor];

    }else{
        model.seleted = YES;
        [companyArray addObject:model];
        cell.selectLabel.backgroundColor = [UIColor redColor];
        cell.selectLabel.textColor = [UIColor whiteColor];

    }
    if ([companyArray count] == 0) {
        [_recomBtn setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_recomBtn setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
        _recomBtn.enabled = NO;
    }else{
        [_recomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recomBtn setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:62.0/255.0 blue:63.0/255.0 alpha:1.0]];
        _recomBtn.enabled = YES;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
