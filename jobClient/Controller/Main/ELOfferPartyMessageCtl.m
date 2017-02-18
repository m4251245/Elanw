//
//  ELOfferPartyMessageCtl.m
//  jobClient
//
//  Created by YL1001 on 16/4/19.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOfferPartyMessageCtl.h"
#import "ELOfferPartyMessageCell.h"
#import "MyOfferPartyApplyDetail.h"
#import "CompanyInfo_DataModal.h"
#import "SBJson.h"


@interface ELOfferPartyMessageCtl ()

@end

@implementation ELOfferPartyMessageCtl

- (void)viewDidLoad {
    
    self.showNoDataViewFlag = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationItem.title = @"职位推荐信息";
    [self setNavTitle:@"职位推荐信息"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    
    [self getOfferPartyMessageList];
}

//获取列表数据
- (void)getOfferPartyMessageList
{
    NSString *op = @"offerpai_busi";
    NSString *func = @"getOperationListByPersonid";
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setValue:pageParams forKey:@"page_size"];

    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@", [Manager getUserInfo].userId_, conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [self parserPageInfo:result];
        
        NSArray *dataArray = result[@"data"];
        if ([dataArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in dataArray) {
                CompanyInfo_DataModal *model = [[CompanyInfo_DataModal alloc]init];
                @try {
                    model.cname_ = dic[@"cname"];
                    model.companyID_ = dic[@"uId"];
                    model.logoPath_ = dic[@"logopath"];
                    model.jobStatus = [dic[@"tj_state"] integerValue];
                    model.jobId = dic[@"job_id"];
                    model.time = dic[@"idate"];
                    model.companyNews_ = dic[@"remark"];
                    model.address_ = dic[@"address"];
                    model.positionName = dic[@"job_name"];
                    model.readStatus = dic[@"read_status"];
                    
                    
                    User_DataModal *userModal = [[User_DataModal alloc]init];
                    userModal.recommendId = dic[@"tuijian_id"];
                    userModal.salary_ = dic[@"salary"];
                    userModal.eduName_ = dic[@"edus"];
                    userModal.gzNum_ = dic[@"gznum"];
                    userModal.waiteNum = dic[@"paiduihao"];
                    if ([userModal.waiteNum isEqualToString:@""]) {
                        userModal.waiteNum = @"999";
                    }
                    
                    userModal.deliverState = dic[@"toudi_state"];
                    userModal.interviewState = dic[@"mianshi_state"];
                    userModal.joinstate = [dic[@"leave_state"] integerValue];
                    //1 通过初选  2 不通过初选  3 待确定
                    userModal.resumeType = [dic[@"company_state"] integerValue];
                    model.userModal = userModal;
                    
                    [_dataArray addObject:model];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        }
        
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self finishReloadingData];
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ELOfferPartyMessageCell";
    
    CompanyInfo_DataModal *model = [_dataArray objectAtIndex:indexPath.row];
    ELOfferPartyMessageCell *cell = (ELOfferPartyMessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELOfferPartyMessageCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.interviewFeedbacklb.text = model.companyNews_;
    
    [cell.companyImg sd_setImageWithURL:[NSURL URLWithString:model.logoPath_] placeholderImage:nil];
    cell.companyNameLb.text = model.cname_;
    cell.positionLb.text = model.positionName;
    
    cell.salaryLb.text = [NSString stringWithFormat:@"￥%@", model.userModal.salary_];
    cell.educationLb.text = model.userModal.eduName_;
    if ([model.userModal.eduName_ isEqualToString:@""]) {
        cell.imageViewOne.hidden = YES;
    }
    else
    {
        cell.imageViewOne.hidden = NO;
    }
    
    cell.jobAgeLb.text = model.userModal.gzNum_;
    if ([model.userModal.gzNum_ isEqualToString:@""]) {
        cell.imageViewTwo.hidden = YES;
    }
    else
    {
        cell.imageViewTwo.hidden = NO;
    }
    
    if ([model.readStatus isEqualToString:@"1"]) {//已阅
        cell.newsImg.hidden = YES;
        cell.interviewLbLeading.constant = 8;
    }
    else if ([model.readStatus isEqualToString:@"0"])
    {//未阅
        cell.newsImg.hidden = NO;
        cell.interviewLbLeading.constant = 37;
    }
    
    if (model.jobStatus == 7) {//等候面试状态下
        NSInteger waiteNum = model.userModal.waiteNum.integerValue;
        
        if (model.userModal.joinstate == 1)
        {//已离场
            cell.interviewLb.text = @"你已离场";
        }
        else if (waiteNum == 999)
        {
            cell.interviewLb.text = @"";
        }
        else if (waiteNum > 0 ) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.lineSpacing = 4;
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
            NSDictionary *textAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor], NSParagraphStyleAttributeName:paragraphStyle};
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"还有" attributes:textAttr]];
            NSDictionary *numberAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor colorWithRed:240.f/255 green:95.f/255 blue:95.f/255 alpha:1.f], NSParagraphStyleAttributeName:paragraphStyle};
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)waiteNum] attributes:numberAttr]];
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"个人排在您前面" attributes:textAttr]];
            cell.interviewLb.attributedText = attrString;
        }
        else if (waiteNum == 0){
            cell.interviewLb.text = @"将轮到你面试，请耐心等候通知!";
        }
        else if (waiteNum < 0){
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
            NSDictionary *textAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor]};
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"过号了" attributes:textAttr]];
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"还有" attributes:textAttr]];
            NSDictionary *numberAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor colorWithRed:240.f/255 green:95.f/255 blue:95.f/255 alpha:1.f]};
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",  labs(waiteNum)] attributes:numberAttr]];
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"人排在你前面" attributes:textAttr]];
            cell.interviewLb.attributedText = attrString;
        }
    }
    else
    {
        cell.interviewLb.text = @"";
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyInfo_DataModal *selectModel = [_dataArray objectAtIndex:indexPath.row];
    
    [self updateReadState:selectModel.userModal.recommendId];
    
    MyOfferPartyApplyDetail *applyDetailCtl = [[MyOfferPartyApplyDetail alloc]init];
    applyDetailCtl.companyModel = selectModel;
    [self.navigationController pushViewController:applyDetailCtl animated:YES];
    [applyDetailCtl beginLoad:nil exParam:nil];
    
}

- (void)updateReadState:(NSString *)tuijianId
{
    NSString *op = @"offerpai_busi";
    NSString *func = @"updateReadStatus";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"tuijian_id=%@&conditionArr=", tuijianId];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        Status_DataModal *model = [[Status_DataModal alloc] init];
        
        model.code_ = result[@"code"];
        model.status_ = result[@"status"];
        model.des_ = result[@"status_desc"];
        
        if ([model.code_ isEqualToString:@"200"]) {
            [self refreshLoad];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
