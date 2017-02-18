//
//  ConsultantRecommendationViewController.m
//  jobClient
//
//  Created by 一览ios on 16/5/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ConsultantRecommendationViewController.h"
#import "ConsultantRecommendDataModel.h"
#import "ZPinfoDataModel.h"
#import "CounsultRecTableViewCell.h"
#import "RecJobTableViewCell.h"
#import "SuitJobTableViewCell.h"
#import "ConsltRecHeaderCollectionViewCell.h"
#import "RecJobCollectionViewCell.h"
#import "PositionDetailCtl.h"
#import "LineSpaceHelper.h"

static int kSCROLL_TAG = 1234560;
static int kICON_TAG = 1237890;
static int kCELL_TAG = 90909090;
static double kFIRSTCELL_HEIGHT = 100;
static double kOTHERCELL_HEIGHT = 120;

@interface ConsultantRecommendationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation ConsultantRecommendationViewController
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noDataString = @"没有请求到数据哦！";
    self.noDataImgStr = @"img_noJob.png";
    [self configUI];
    
}

#pragma mark--配置界面
-(void)configUI{
//    self.navigationItem.title = @"顾问推荐职位";
    [self setNavTitle:@"顾问推荐职位"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"CounsultRecTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCounsultRecTableViewCell"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tableView.contentInset = UIEdgeInsetsMake(-20.0f, 0.0f, 0.0f, 0.0f);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"顾问推荐职位";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark--加载数据
-(void)beginLoad:(id)param exParam:(id)exParam{
    [super beginLoad:param exParam:exParam];
    [self loadData];
}

-(void)loadData{
    //设置请求参数
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:pageParams forKey:@"page_size"];
    [condictionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@",[Manager getUserInfo].userId_,condictionStr];
    NSString * function = @"getSalerRecomendZwlistByPerson";
    NSString * op = @"person_info_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        [self parserPageInfo:result];
        id dataArr = result[@"data"];
        if ([dataArr isKindOfClass:[NSNull class]]) {
            [self finishReloadingData];
            [self refreshEGORefreshView];
            return ;
        }
        for (NSDictionary *dataDic in dataArr) {
            ConsultantRecommendDataModel *consultRecVO = [[ConsultantRecommendDataModel alloc]initWithDict:dataDic];
            [_dataArray addObject:consultRecVO];
        }
        
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self finishReloadingData];
        [self refreshEGORefreshView];
    }];

}

#pragma mark--代理
#pragma mark--tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CounsultRecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCounsultRecTableViewCell" forIndexPath:indexPath];
    [cell.recBgCollectionView registerNib:[UINib nibWithNibName:@"ConsltRecHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"myConsltRecHeaderCollectionViewCell"];
    [cell.recBgCollectionView registerNib:[UINib nibWithNibName:@"RecJobCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"myRecJobCollectionViewCell"];
    cell.recBgCollectionView.delegate = self;
    cell.recBgCollectionView.dataSource = self;
    cell.recBgCollectionView.scrollEnabled = NO;
    cell.recBgCollectionView.tag = indexPath.row + kSCROLL_TAG;
    [cell.recBgCollectionView reloadData];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConsultantRecommendDataModel *consultRecVO = _dataArray[indexPath.row];
    NSArray * arr = consultRecVO.zpinfo;
    CGFloat otherHeight = 0;
    if (arr.count == 0) {
        return kFIRSTCELL_HEIGHT;
    }
    if (arr.count > 0) {
        for (ZPinfoDataModel *zpModel in arr) {
            id tagArr = zpModel.company_tags;
            if (![tagArr isKindOfClass:[NSArray class]]){
                otherHeight += kOTHERCELL_HEIGHT - 21;
            }
            else{
                otherHeight += kOTHERCELL_HEIGHT;
            }
        }
    }
    return kFIRSTCELL_HEIGHT + otherHeight + 6;
}
#pragma mark--collectionDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger collectTag = collectionView.tag - kSCROLL_TAG;
    ConsultantRecommendDataModel *consultRecVO = _dataArray[collectTag];
    NSArray *arr = consultRecVO.zpinfo;
    if (arr.count == 0) {
        return 1;
    }
    return arr.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger collectTag = collectionView.tag - kSCROLL_TAG;
    ConsultantRecommendDataModel *consultRecVO = _dataArray[collectTag];
    if (indexPath.row == 0) {
        ConsltRecHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myConsltRecHeaderCollectionViewCell" forIndexPath:indexPath];
        if (consultRecVO.salerperson) {
            NSDictionary *dic = consultRecVO.salerperson;
            
            [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage new]];
            cell.nameLb.text = dic[@"iname"];
            NSString *role = dic[@"role"];
            if (role.length == 0) {
               cell.typeJobLb.text = [NSString stringWithFormat:@"/%@",@""];
            }
            else{
               cell.typeJobLb.text = [NSString stringWithFormat:@"/%@",role];
            }
            
            NSString *titleStr = @"";
            if(consultRecVO.idate){
                titleStr = consultRecVO.idate;
            }
            cell.timeLb.attributedText = [LineSpaceHelper dealTitleColor:[NSString stringWithFormat:@"推荐时间：%@",consultRecVO.idate]];
           
            cell.reseonLb.attributedText = [LineSpaceHelper dealTitleColor:[NSString stringWithFormat:@"推荐理由：%@",@"以下推荐岗位非常符合您的意向岗位需求！"]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
            cell.iconImg.userInteractionEnabled = YES;
            [cell.iconImg addGestureRecognizer:tap];
            cell.iconImg.tag = collectTag + kICON_TAG;
        }
        return cell;
    }
    else{
        RecJobCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myRecJobCollectionViewCell" forIndexPath:indexPath];
        cell.tag = kCELL_TAG + indexPath.row;
        NSArray *infoArr = consultRecVO.zpinfo;
        if (infoArr.count > 0) {
            ZPinfoDataModel *zpinfoVO = infoArr[indexPath.row - 1];
            
            [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:zpinfoVO.logopath] placeholderImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
            cell.jobNameLb.text = zpinfoVO.jtzw;
            cell.regionLb.text = zpinfoVO.workplace;
            cell.salaryLb.text = [self minSalary:zpinfoVO.minsalary maxSalary:zpinfoVO.maxsalary];
            cell.companyLb.text = zpinfoVO.company_cname;
            id tagArr = zpinfoVO.company_tags;
            if ([tagArr isKindOfClass:[NSArray class]]) {
                cell.companyTopToSalary.constant = 31;
                if ([tagArr count] == 1) {
                    cell.tagLb.text = tagArr[0][@"ylt_name"];
                }
                else if([tagArr count] == 2){
                    cell.tagLb.text = [NSString stringWithFormat:@"%@  %@",tagArr[0][@"ylt_name"],tagArr[1][@"ylt_name"]];
                }
                else if([tagArr count] > 2){
                    cell.tagLb.text = [NSString stringWithFormat:@"%@  %@  %@",tagArr[0][@"ylt_name"],tagArr[1][@"ylt_name"],tagArr[2][@"ylt_name"]];
                }
            }
            else{
                cell.companyTopToSalary.constant = 10;
                cell.tagLb.text = @" ";
            }
            if (indexPath.row == infoArr.count + 1) {
                cell.lineView.hidden = YES;
            }
            else{
                cell.lineView.hidden = NO;
            }
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger collectTag = collectionView.tag - kSCROLL_TAG;
    ConsultantRecommendDataModel *consultRecVO = _dataArray[collectTag];
    NSArray *infoArr = consultRecVO.zpinfo;
    
    if (indexPath.row == 0) {
        return CGSizeMake(ScreenWidth - 20, kFIRSTCELL_HEIGHT);
    }
    if(infoArr.count > 0){
        ZPinfoDataModel *zpinfoVO = infoArr[indexPath.row - 1];
        id tagArr = zpinfoVO.company_tags;
        if ([tagArr isKindOfClass:[NSArray class]] && [tagArr count] > 0) {
            return CGSizeMake(ScreenWidth - 20, kOTHERCELL_HEIGHT);
        }
        else{
            return CGSizeMake(ScreenWidth - 20, kOTHERCELL_HEIGHT - 21);
        }
    }
    return CGSizeMake(0, 0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return;
    }
    NSInteger collectTag = collectionView.tag - kSCROLL_TAG;
    ConsultantRecommendDataModel *consultRecVO = _dataArray[collectTag];
    NSArray *arr = consultRecVO.zpinfo;
    ZPinfoDataModel *zpinfoVO = arr[indexPath.row - 1];
    if ([zpinfoVO.isdelete isEqualToString:@"1"]) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"该职位已经删除"];
        return;
    }
    if ([zpinfoVO.zptype isEqualToString:@"0"]) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"该职位已经停招"];
        return;
    }
    ZWDetail_DataModal *zwVO = [ZWDetail_DataModal new];
    zwVO.companyID_ = zpinfoVO.company_id;
    zwVO.zwID_ = zpinfoVO.job_id;
    zwVO.zwName_ = zpinfoVO.zptxt;
    PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
    detailCtl.type_ = 4;
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:zwVO exParam:nil];
}
#pragma mark--事件
//头像点击
-(void)iconTap:(UITapGestureRecognizer *)tap{
    ConsultantRecommendDataModel *consultRecVO = _dataArray[tap.view.tag - kICON_TAG];
    NSDictionary *dic = consultRecVO.salerperson;
    ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc]init];
    if (dic[@"person_id"] && [dic[@"person_id"] length] > 0) {
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:dic[@"person_id"] exParam:nil];
    }
    return;
}
#pragma mark--业务逻辑
//薪资
-(NSString *)minSalary:(NSString *)minSalary maxSalary:(NSString *)maxSalary{
    if (maxSalary.length > 0 && minSalary.length > 0) {
        if (([maxSalary isEqualToString:@"0"] && [minSalary isEqualToString:@"0"])) {
            return @"面议";
        }
        if ([maxSalary isEqualToString:@"0"] && ![minSalary isEqualToString:@"0"]) {
            return [NSString stringWithFormat:@"%@以上",minSalary];
        }
        if (![maxSalary isEqualToString:@"0"] && [minSalary isEqualToString:@"0"]) {
            return [NSString stringWithFormat:@"%@以下",maxSalary];
        }
        return [NSString stringWithFormat:@"￥%@-%@",minSalary,maxSalary];
    }
    else if(maxSalary.length == 0 && minSalary.length > 0){
        return [NSString stringWithFormat:@"%@以上",minSalary];
    }
    else if(maxSalary.length > 0 && minSalary.length == 0){
        return [NSString stringWithFormat:@"%@以下",maxSalary];
    }
    else{
        return @"面议";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
