//
//  RecommendJobCtl.m
//  jobClient
//
//  Created by 一览ios on 15/11/19.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "RecommendJobCtl.h"
#import "RecommendJob_Cell.h"


@interface RecommendJobCtl ()

@end

@implementation RecommendJobCtl

- (void)dealloc
{

}

- (void)viewDidLoad {
    self.headerRefreshFlag = NO;
    self.footerRefreshFlag = NO;
    self.showNoDataViewFlag = NO;
    self.noRefershLoadData = YES;
    self.showNoMoreDataViewFlag = NO;
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionaryWithCapacity:2];
    searchDic[@"login_person_id"] = [Manager getUserInfo].userId_;
    searchDic[@"user_id"] = _otherUserId;
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@&", searchDicStr, [self getPageQueryStr:15]];
    [ELRequest postbodyMsg:bodyMsg op:@"salarycheck_all_new_busi" func:@"getUserzoneJobs" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSArray *arr = result[@"data"];
        @try {
            if (![arr isKindOfClass:[NSNull class]]) {
                for ( NSDictionary *subDic in arr ) {
                    JobSearch_DataModal *dataModal = [[JobSearch_DataModal alloc] init];
                    dataModal.zwID_ = [subDic objectForKey:@"zwid"];
                    dataModal.zwName_ = [subDic objectForKey:@"jtzw"];
                    dataModal.companyID_ = [subDic objectForKey:@"uid"];
                    dataModal.companyName_ =[subDic objectForKey:@"cname"];
                    dataModal.regionName_ = [subDic objectForKey:@"regionid"];
                    dataModal.updateTime_ = [subDic objectForKey:@"updatetime"];
                    dataModal.minSalary = [subDic objectForKey:@"minsalary"];
                    dataModal.maxSalary = [subDic objectForKey:@"maxsalary"];
                    dataModal.salaryType = [subDic objectForKey:@"salaryType"];
                    dataModal.minGzNum = [subDic objectForKey:@"gznum1"];
                    dataModal.maxGzNum = [subDic objectForKey:@"gznum2"];
                    dataModal.gznum_ = [MyCommon removeAllSpace:[subDic objectForKey:@"gznum1"]];
                    dataModal.edu_ = [subDic objectForKey:@"edus"];
                    dataModal.count_ = [subDic objectForKey:@"totalid"];
                    dataModal.welfareArray_ = [subDic objectForKey:@"cm_tags"];//福利
                    
#pragma mark 下面的字段暂时没有用到
                    dataModal.companyLogo_ = [subDic objectForKey:@"logo"];
                    dataModal.cnameAll_ = [subDic objectForKey:@"cname_all"];
                    
                    NSString * str = [subDic objectForKey:@"is_ky"];
                    if ([str isEqualToString:@"2"]) {
                        dataModal.isKy_ = YES;
                    }
                    else
                        dataModal.isKy_ = NO;
                    [_dataArray addObject:dataModal];
                }
            }
            [self.tableView reloadData];
            [self parserPageInfo:result];
            [self finishReloadingData];
            if (_finishBlock) {
                CGRect bounds = self.view.bounds;
                bounds.size = self.tableView.contentSize;
                self.tableView.bounds = bounds;
                self.view.bounds = bounds;
                _finishBlock(self.tableView.contentSize.height, self.pageInfo.lastPageFlag);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobSearch_DataModal *model = _dataArray[indexPath.row];
    NSArray *welfare_ = model.welfareArray_;
    if ([welfare_ isKindOfClass:[NSArray class]] &&  welfare_.count) {
        return 88;
    }
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseIdentifier = @"RecommendJob_Cell";
    RecommendJob_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"RecommendJob_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    JobSearch_DataModal *model = _dataArray[indexPath.row];
    cell.titleLb.text = model.zwName_;
    NSMutableString *summaryStr = [[NSMutableString alloc]init];
    if (model.edu_) {
        [summaryStr appendFormat:@"学历%@ | ", model.edu_];
    }
    
    if ([model.minGzNum isEqualToString:@"0"] && [model.maxGzNum isEqualToString:@"0"]){
        [summaryStr appendFormat:@"经验不限 | "];
    }else if (![model.minGzNum isEqualToString:@"0"] && ![model.maxGzNum isEqualToString:@"0"]){
        [summaryStr appendFormat:@"%@－%@年经验 | ", model.minGzNum, model.maxGzNum];
    }else{
        [summaryStr appendFormat:@"%@年经验 | ", model.minGzNum?model.minGzNum:model.maxGzNum];
    }
    if(model.regionName_){
        [summaryStr appendFormat:@"%@ | ", model.regionName_];
    }
    [summaryStr replaceOccurrencesOfString:@" | " withString:@"" options:NSBackwardsSearch range:NSMakeRange(summaryStr.length-3, 3)];
    cell.summaryLb.text = summaryStr;
    
    NSString *salaryStr;
    if ([model.minSalary isEqualToString:@"0"] && [model.maxSalary isEqualToString:@"0"]){
        salaryStr = @"薪资面议";
    }else if (![model.minSalary isEqualToString:@"0"] && ![model.maxSalary isEqualToString:@"0"]){
        salaryStr = [NSString stringWithFormat:@"¥%@－%@%@", model.minSalary, model.maxSalary, model.salaryType];
    }else{
        salaryStr = [NSString stringWithFormat:@"¥%@ %@", model.minSalary?model.minSalary:model.maxSalary , model.salaryType];
    }
    cell.salaryLb.text = salaryStr;
    
    //福利
    cell.conditionLb1.hidden = YES;
    cell.conditionLb2.hidden = YES;
    cell.conditionLb3.hidden = YES;
    
    NSArray *welfare_ = model.welfareArray_;
    if (![welfare_ isKindOfClass:[NSNull class]] && welfare_ != nil && [welfare_ count] != 0){
        for (int i=0; i<[welfare_ count]; i++) {
            switch (i) {
                case 0:
                {
                    NSString *welfareStr = [welfare_ objectAtIndex:i][@"ylt_name"];
                    if (![welfareStr isKindOfClass:[NSString class]]) {
                        welfareStr = @"";
                    }
                    CGSize size = [welfareStr sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10] constrainedToSize:CGSizeMake(72, 14)];
                    CGRect rect = cell.conditionLb1.frame;
                    rect.size.width = size.width + 5;
                    [cell.conditionLb1 setFrame:rect];
                    [cell.conditionLb1 setText:welfareStr];
                    [cell.conditionLb1 setHidden:NO];
                }
                    break;
                case 1:
                {
                    NSString *welfareStr = [welfare_ objectAtIndex:i][@"ylt_name"];
                    if (![welfareStr isKindOfClass:[NSString class]]) {
                        welfareStr = @"";
                    }
                    CGSize size = [welfareStr sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10] constrainedToSize:CGSizeMake(72, 14)];
                    CGRect rect = cell.conditionLb2.frame;
                    rect.size.width = size.width + 5;
                    rect.origin.x = cell.conditionLb1.frame.origin.x + cell.conditionLb1.frame.size.width + 5;
                    [cell.conditionLb2 setFrame:rect];
                    [cell.conditionLb2 setText:welfareStr];
                    [cell.conditionLb2 setHidden:NO];
                }
                    break;
                case 2:
                {
                    NSString *welfareStr = [welfare_ objectAtIndex:i][@"ylt_name"];
                    if (![welfareStr isKindOfClass:[NSString class]]) {
                        welfareStr = @"";
                    }
                    CGSize size = [welfareStr sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10] constrainedToSize:CGSizeMake(72, 14)];
                    CGRect rect = cell.conditionLb3.frame;
                    rect.size.width = size.width + 5;
                    rect.origin.x = cell.conditionLb2.frame.origin.x + cell.conditionLb2.frame.size.width + 5;
                    [cell.conditionLb3 setFrame:rect];
                    [cell.conditionLb3 setText:welfareStr];
                    [cell.conditionLb3 setHidden:NO];
                }
                    break;
                default:
                    break;
            }
            
        }
        cell.conditionTitleLb.hidden = NO;
    }else{
        cell.conditionTitleLb.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
    [self.navigationController pushViewController:detailCtl animated:YES];
    JobSearch_DataModal *model = _dataArray[indexPath.row];
    [detailCtl beginLoad:model exParam:nil];
}


@end
