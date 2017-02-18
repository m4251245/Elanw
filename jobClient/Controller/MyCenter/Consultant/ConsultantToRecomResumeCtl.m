//
//  ConsultantToRecomResumeCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantToRecomResumeCtl.h"
#import "ToRecomResumeCell.h"
#import "ConsultantHRDataModel.h"
#import "ELResumeTradeChangeCtl.h"
#import "ELSearchView.h"
#import "ELRecommendReportDetailCtl.h"

@interface ConsultantToRecomResumeCtl ()<UITextFieldDelegate,ELRecommentSuccessRefreshDelegate>
{
    UITextField  *keyWorkTf;
    NSMutableArray *companyArray;//已选择公司
    NSMutableDictionary *companyDic;//已选择公司
    NSArray  *btnSelArr;
    NSArray  *placehoderArr;
    //    UIView *searchView;
    UIButton *leftBtn;
}
@end

@implementation ConsultantToRecomResumeCtl
#pragma mark - lifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _recomBtn.layer.cornerRadius = 4.0;
    [_recomBtn setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_recomBtn setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
    _recomBtn.enabled = NO;
    
    companyArray = [[NSMutableArray alloc] init];
    companyDic = [[NSMutableDictionary alloc] init];
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-120, 44)];
    UIImageView *bgImgv = [[UIImageView alloc]init];;
    [bgImgv setFrame:CGRectMake(0, 10, ScreenWidth-120, 24)];
    bgImgv.layer.cornerRadius = 12;
    bgImgv.layer.masksToBounds = YES;
    [bgImgv setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [searchView addSubview:bgImgv];
    
    keyWorkTf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-140, 24)];
    keyWorkTf.returnKeyType = UIReturnKeySearch;
    [keyWorkTf setFont:FOURTEENFONT_CONTENT];
    [keyWorkTf setTextColor:BLACKCOLOR];
    keyWorkTf.delegate = self;
    [keyWorkTf setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:keyWorkTf];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_search_def.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.titleView = searchView;
    
    //[keyWorkTf setText:_inModel.job_];
    [self refreshLoad];
}

#pragma mark - netWork
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [self requestListData];
}

-(void)requestListData{
    NSString *keywords = @"";
    if (keyWorkTf.text.length > 0 && ![[keyWorkTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]) {
        keywords = keyWorkTf.text;
    }
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = @"";
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionary];
    if (keywords.length > 0){
        [searchDic setObject:keywords forKey:@"job_name"];
    }
    if (searchDic.count > 0) {
        searchStr = [jsonWriter stringWithObject:searchDic];
    }
    SBJsonWriter * jsonWriter1 = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter1 stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"sa_user_id=%@&person_id=%@&conditionArr=%@&searchArray=%@",self.salerId,_inModel.userId_,conDicStr,searchStr];
    NSString * function = @"deliveryJoblist";
    NSString * op = @"app_jjr_api_busi";
    [ELRequest newBodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]){
            [self parserPageInfo:dic];
            NSArray *arr = dic[@"data"];
            if ([arr isKindOfClass:[NSArray class]]){
                for (NSDictionary *subDic in arr) {
                    ELCompanyInfoModel *model = [[ELCompanyInfoModel alloc] initWithDic:subDic];
                    if ([[companyDic objectForKey:model.job_id] isEqualToString:@"1"]) {
                        model.seleted = YES;
                    }
                    [_dataArray addObject:model];
                }
            }
        }
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        [self finishReloadingData];
        [self refreshEGORefreshView];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([keyWorkTf isFirstResponder]) {
        [keyWorkTf resignFirstResponder];
        return;
    }
    ELCompanyInfoModel *model = _dataArray[indexPath.row];
    if ([model.tj_state isEqualToString:@"1"]) {
        [BaseUIViewController showAlertView:@"" msg:@"已经推荐过了" btnTitle:@"知道了"];
        return;
    }
    ToRecomResumeCell *cell = (ToRecomResumeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (model.seleted) {
        model.seleted = NO;
        for (ELCompanyInfoModel *subModel in companyArray) {
            if ([subModel.job_id isEqualToString:model.job_id]) {
                [companyArray removeObject: subModel];
                break;
            }
        }
        [companyDic removeObjectForKey:model.job_id];
        cell.selectLabel.textColor = [UIColor redColor];
        cell.selectLabel.backgroundColor = [UIColor clearColor];
    }else{
        model.seleted = YES;
        [companyArray addObject:model];
        [companyDic setObject:@"1" forKey:model.job_id];
        cell.selectLabel.textColor = [UIColor whiteColor];
        cell.selectLabel.backgroundColor = [UIColor redColor];
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
    
    ELCompanyInfoModel *model = _dataArray[indexPath.row];
    if (model.seleted) {
        cell.selectLabel.textColor = [UIColor whiteColor];
        cell.selectLabel.backgroundColor = [UIColor redColor];
    }else{
        cell.selectLabel.textColor = [UIColor redColor];
        cell.selectLabel.backgroundColor = [UIColor clearColor];
    }
    if ([model.tj_state isEqualToString:@"1"]) {
        [cell.markLb setHidden:NO];
        [cell.markLb setText:@"已推荐"];
        [cell.zwLb setFrame:CGRectMake(cell.zwLb.frame.origin.x, cell.zwLb.frame.origin.y, 220, cell.zwLb.frame.size.height)];
        [cell.nameLb setFrame:CGRectMake(cell.nameLb.frame.origin.x, cell.nameLb.frame.origin.y, 220, cell.nameLb.frame.size.height)];
    }else if([model.tj_state isEqualToString:@"4"]){
        [cell.markLb setHidden:NO];
        [cell.markLb setText:@"主动申请"];
        [cell.zwLb setFrame:CGRectMake(cell.zwLb.frame.origin.x, cell.zwLb.frame.origin.y, 220, cell.zwLb.frame.size.height)];
        [cell.nameLb setFrame:CGRectMake(cell.nameLb.frame.origin.x, cell.nameLb.frame.origin.y, 220, cell.nameLb.frame.size.height)];
    }else if([model.tj_state isEqualToString:@"5"]){
        [cell.markLb setHidden:NO];
        [cell.markLb setText:@"顾问推荐"];
        [cell.zwLb setFrame:CGRectMake(cell.zwLb.frame.origin.x, cell.zwLb.frame.origin.y, 220, cell.zwLb.frame.size.height)];
        [cell.nameLb setFrame:CGRectMake(cell.nameLb.frame.origin.x, cell.nameLb.frame.origin.y, 220, cell.nameLb.frame.size.height)];
    }else{
        [cell.markLb setHidden:YES];
        [cell.zwLb setFrame:CGRectMake(cell.zwLb.frame.origin.x, cell.zwLb.frame.origin.y, 259, cell.zwLb.frame.size.height)];
        [cell.nameLb setFrame:CGRectMake(cell.nameLb.frame.origin.x, cell.nameLb.frame.origin.y, 259, cell.nameLb.frame.size.height)];
    }
    if (!cell.markLb.hidden) {
        cell.titleRightWidth.constant = 55;
    }else{
        cell.titleRightWidth.constant = 8;
    }
    [cell.zwLb setText:model.job_name];
    if (model.project_title && model.cname) {
        [cell.nameLb setText:model.cname];
        cell.offerNameLb.text = model.project_title;
        cell.offerNameLb.hidden = NO;
    }else{
        cell.offerNameLb.hidden = YES;
        if (model.project_title) {
            [cell.nameLb setText:model.project_title];
        }else if(model.job_name){
            [cell.nameLb setText:model.cname];
        }
    }
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELCompanyInfoModel *model = _dataArray[indexPath.row];
    if (model.project_title && model.cname){
        return 80;
    }
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detailBtnClick:(UIButton *)button
{
    if ([keyWorkTf isFirstResponder]) {
        [keyWorkTf resignFirstResponder];
        return;
    }
    ELCompanyInfoModel *dataModal= [_dataArray objectAtIndex:button.tag - 1000];
    PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
    positionDetailCtl.isConsultantFlag = YES;
    ZWDetail_DataModal *zwModal = [[ZWDetail_DataModal alloc] init];
    zwModal.zwID_ = dataModal.job_id;
    zwModal.companyName_ = dataModal.cname;
    zwModal.companyID_ = dataModal.uId;
    [self.navigationController pushViewController:positionDetailCtl animated:YES];
    [positionDetailCtl beginLoad:zwModal exParam:nil];
}


- (void)rightBarBtnResponse:(id)sender
{
    [keyWorkTf resignFirstResponder];
    [self refreshLoad];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == keyWorkTf) {
        [keyWorkTf resignFirstResponder];
        [self refreshLoad];
    }
    return YES;
}

- (void)btnResponse:(id)sender
{
    [keyWorkTf resignFirstResponder];
    if (sender == _recomBtn){
        ELRecommendReportDetailCtl *ctl = [[ELRecommendReportDetailCtl alloc] init];
        ctl.selectArr = [[NSMutableArray alloc] initWithArray:companyArray]; 
        ctl.salerId = _salerId;
        ctl.userId = _inModel.userId_;
        ctl.refreshDelegate = self;
        [self.navigationController pushViewController:ctl animated:YES];
    }    
}

-(void)recommentSuccessRefresh{
    [companyArray removeAllObjects];
    [companyDic removeAllObjects];
    [self refreshLoad];
}

@end
