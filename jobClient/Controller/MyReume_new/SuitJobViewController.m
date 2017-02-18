//
//  SuitJobViewController.m
//  jobClient
//
//  Created by 一览ios on 16/5/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "SuitJobViewController.h"
#import "SuitJobDataModel.h"
#import "SuitJobTableViewCell.h"
#import "PositionDetailCtl.h"
#import "ZWDetail_DataModal.h"
#import "WantJob_ResumeCtl.h"
#import "ELSuitJobTableviewCell.h"

@interface SuitJobViewController ()

@end

@implementation SuitJobViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.title = @"适合您的职位";
    [self setNavTitle:@"适合您的职位"];
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
//    self.navigationItem.title = @"适合您的职位";
}

#pragma mark--配置界面
-(void)configUI{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SuitJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"mySuitJobTableViewCell"];
    
    UIView *view = [[UIView alloc]init];
    self.tableView.tableFooterView = view;
//    self.tableView.contentInset = UIEdgeInsetsMake(-20.0f, 0.0f, 0.0f, 0.0f);
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark--加载数据
-(void)beginLoad:(id)param exParam:(id)exParam{
    [super beginLoad:param exParam:exParam];
    [self loadData];
}

-(void)loadData{
    //设置请求参数
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:@"10" forKey:@"page_size"];
    [condictionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page_index"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@",[Manager getUserInfo].userId_,condictionStr];
    NSString * function = @"get_suitable_jobs";
    NSString * op = @"person_sub_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        [self parserPageInfo:result];
        id dataArr = result[@"data"];
        if ([dataArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in dataArr) {
                SuitJobDataModel *suitVO = [SuitJobDataModel new];
                [suitVO setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:suitVO];
            }
            [self.tableView reloadData];
            [self finishReloadingData];
            [self refreshEGORefreshView];
        }
        else{
            return;
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self finishReloadingData];
        [self refreshEGORefreshView];
        NSLog(@"%@",error);
    }];

}
#pragma mark--table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ELSuitJobTableviewCell *suitCell = (ELSuitJobTableviewCell *)cell;
//    SuitJobDataModel *suitVO = _dataArray[indexPath.row];
//    [suitCell.companyLogo sd_setImageWithURL:[NSURL URLWithString:suitVO.logopath] placeholderImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
//    suitCell.companyLabel.text = suitVO.cname;
//    
////    if ([suitVO.salaryType isEqualToString:@"年薪"]) {
////        suitCell.salaryLabel.text = [NSString stringWithFormat:@"%@万 %@",[self minSalary:suitVO.minsalary maxSalary:suitVO.maxsalary],suitVO.salaryType];
////    }else{
//        suitCell.salaryLabel.text = [NSString stringWithFormat:@"%@ %@",[self minSalary:suitVO.minsalary maxSalary:suitVO.maxsalary],suitVO.salaryType];
////    }
//    
//    suitCell.jobLabel.text = suitVO.jtzw;
//    
//    NSString *workAge;
//    NSInteger gznum1 = [suitVO.gznum1 integerValue];
//    NSInteger gznum2 = [suitVO.gznum2 integerValue];
//    if (gznum1 <= 0 && gznum2 <= 0) {
//        workAge = @"经验不限";
//    }else if (gznum1 > 0 && gznum2 <= 0){
//        workAge = [NSString stringWithFormat:@"%d年以上",gznum1];
//    }else if (gznum2 > 0 && gznum1 <= 0){
//        workAge = [NSString stringWithFormat:@"%d年以下",gznum2];
//    }else{
//        workAge = [NSString stringWithFormat:@"%d-%d年",gznum1,gznum2];
//    }
//   
//    
//    suitCell.JobRequireLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[CondictionPlaceCtl getRegionDetailAddressExcept:suitVO.regionid],workAge,[self getEdu:suitVO.eduId]];
//   
//    id flobj = suitVO.fldy;
//    if ([flobj isKindOfClass:[NSArray class]]) {
//        if ([flobj count] == 0) {
//            return;
//        }
//        double __block originX = 16;
//        [flobj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            CGSize size = [obj sizeNewWithFont:[UIFont systemFontOfSize:12]];
//            double width = size.width+12;
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, 101, width+12, 20)];
//            originX = label.right+10;
//            label.backgroundColor = UIColorFromRGB(0xecf4f8);
//            label.text = flobj[idx];
//            label.font = [UIFont systemFontOfSize:12];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.textColor = UIColorFromRGB(0x4570aa);
//            [suitCell addSubview:label];
//            
//        }];
//    }
//    
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SuitJobDataModel *suitVO = _dataArray[indexPath.row];
    SuitJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySuitJobTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = bgView;
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:suitVO.logopath] placeholderImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
    cell.companyLb.text = suitVO.cname;
    cell.areaLb.text = [CondictionPlaceCtl getRegionDetailAddressExcept:suitVO.regionid];
    cell.salaryLb.text = [self minSalary:suitVO.minsalary maxSalary:suitVO.maxsalary];
    cell.salaryLb.textColor = UIColorFromRGB(0xe13e3e);
    id flObj = suitVO.fldy;
    if ([flObj isKindOfClass:[NSArray class]]) {
        cell.conditionLb.hidden = NO;
        cell.companyTopTo.constant = 28;
        if ([flObj count] == 1) {
            cell.conditionLb.text = flObj[0];
        }
        else if([flObj count] == 2){
            cell.conditionLb.text = [NSString stringWithFormat:@"%@  %@",flObj[0],flObj[1]];
        }
        else if ([flObj count] >= 3){
            cell.conditionLb.text = [NSString stringWithFormat:@"%@  %@  %@",flObj[0],flObj[1],flObj[2]];
        }
    }
    else{
        cell.conditionLb.hidden = YES;
        cell.companyTopTo.constant = 5;
    }
    cell.jobLb.text = suitVO.jtzw;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuitJobDataModel *suitVO = _dataArray[indexPath.row];
    id flObj = suitVO.fldy;
    if ([flObj isKindOfClass:[NSArray class]]){
        if ([flObj count] > 0) {
            return 120;
        }
    }
    return 92;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SuitJobDataModel *suitVO = _dataArray[indexPath.row];
//    [BaseUIViewController showAutoDismissFailView:nil msg:@"该职位已经停招"];
    ZWDetail_DataModal *zwVO = [ZWDetail_DataModal new];
    zwVO.companyID_ = suitVO.uid;
    zwVO.zwID_ = suitVO.suitId;
    zwVO.zwName_ = suitVO.jtzw;
    zwVO.companyLogo_ = suitVO.logopath;
    zwVO.companyName_ = suitVO.cname;
    PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
    detailCtl.type_ = 4;
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:zwVO exParam:nil];
   
}

#pragma mark-- 事件
- (IBAction)btnClick:(id)sender {
    //意向职位
    WantJob_ResumeCtl *wantVC = [[WantJob_ResumeCtl alloc]init];
    
    [self.navigationController pushViewController:wantVC animated:YES];
    [wantVC beginLoad:nil exParam:nil];
}

#pragma mark--业务逻辑
-(NSString *)minSalary:(NSString *)minSalary maxSalary:(NSString *)maxSalary{
    
    if (maxSalary.length > 0 && minSalary.length > 0) {
        
        if (maxSalary.length > 4) {
          NSString *max = [maxSalary substringWithRange:NSMakeRange(0, maxSalary.length-4)];
            maxSalary = [NSString stringWithFormat:@"%@.%@万",max,[maxSalary substringWithRange:NSMakeRange(max.length, 1)]];
        }else if(maxSalary.length == 4){
            NSString *max = [maxSalary substringWithRange:NSMakeRange(0, maxSalary.length-3)];
            maxSalary = [NSString stringWithFormat:@"%@.%@千",max,[maxSalary substringWithRange:NSMakeRange(max.length, 1)]];
        }
        
        if (minSalary.length > 4) {
            NSString *min = [minSalary substringWithRange:NSMakeRange(0, minSalary.length-4)];
            minSalary = [NSString stringWithFormat:@"%@.%@万",min,[minSalary substringWithRange:NSMakeRange(min.length, 1)]];
        }else if(minSalary.length == 4){
            NSString *min = [minSalary substringWithRange:NSMakeRange(0, minSalary.length-3)];
            minSalary = [NSString stringWithFormat:@"%@.%@千",min,[minSalary substringWithRange:NSMakeRange(min.length, 1)]];
        }
        
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

- (NSString *)getEdu:(NSString *)eduId
{
    NSInteger type = [eduId integerValue];
    switch (type) {
        case 10:
        {
            return @"初中";
        }
            break;
        case 20:
        {
            return @"高中";
        }
            break;
        case 30:
        {
            return @"中技";
        }
            break;
        case 40:
        {
            return @"中专";
        }
            break;
        case 50:
        {
            return @"大专";
        }
            break;
        case 60:
        {
            return @"本科";
        }
            break;
        case 70:
        {
            return @"硕士";
        }
            break;
        case 75:
        {
            return @"MBA";
        }
            break;
        case 80:
        {
            return @"博士";
        }
            break;
        case 90:
        {
            return @"博士后";
        }
            break;
        default:
            break;
    }
    return @"学历不限";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
