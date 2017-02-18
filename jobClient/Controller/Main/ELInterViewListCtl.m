//
//  ELInterViewListCtl.m
//  jobClient
//
//  Created by YL1001 on 15/9/21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELInterViewListCtl.h"
#import "ELInterviewListCell.h"
#import "ELAspectantDiscussCell.h"
#import "ELMyAspectantDetailCtl.h"

@interface ELInterViewListCtl ()
{
    ELRequest *interViewRequest;
}

@end

@implementation ELInterViewListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    [self setNavTitle:@"约谈信息"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.noDataString = @"暂无相关信息";
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSString * function = @"getMyRecordList";
    NSString * op = @"yuetan_record_busi";
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"" forKey:@"othercond"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionDicStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        [self parserPageInfo:result];
        NSDictionary *dic = result;
        NSArray *dataArray = dic[@"data"];
        if ([dataArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDic in dataArray) {
                ELAspectantDiscuss_Modal *AspDiscussModal = [[ELAspectantDiscuss_Modal alloc] init];
                
                AspDiscussModal.recordId = dataDic[@"record_id"];
                AspDiscussModal.YTZ_id = dataDic[@"person_id"];
                AspDiscussModal.BYTZ_Id = dataDic[@"yuetan_person_id"];
                AspDiscussModal.status = dataDic[@"yuetan_status"];
                AspDiscussModal.dataTime = dataDic[@"idatetime"];
                AspDiscussModal.user_confirm = dataDic[@"confirm_person"];
                AspDiscussModal.isComment = dataDic[@"_is_comment"];
                AspDiscussModal.yuetan_status_desc = dataDic[@"_desc"];
                
                if ([AspDiscussModal.user_confirm isEqualToString:@""]) {
                    AspDiscussModal.user_confirm = @"0";
                }
                AspDiscussModal.dis_confirm = dataDic[@"confirm_yuetan_person"];
                if ([AspDiscussModal.dis_confirm isEqualToString:@""]) {
                    AspDiscussModal.dis_confirm = @"0";
                }
                
                if ([[Manager getUserInfo].userId_ isEqualToString:AspDiscussModal.YTZ_id]) {
                    AspDiscussModal.user_personId = [Manager getUserInfo].userId_;
                    AspDiscussModal.user_name = [Manager getUserInfo].name_;
                    AspDiscussModal.user_nickName = [Manager getUserInfo].nickname_;
                    AspDiscussModal.user_pic = [Manager getUserInfo].img_;
                    AspDiscussModal.user_zw = [Manager getUserInfo].job_;
                    
                    
                    AspDiscussModal.dis_personId = dataDic[@"_yuetan_person_detail"][@"personId"];
                    AspDiscussModal.dis_personName = dataDic[@"_yuetan_person_detail"][@"person_iname"];
                    AspDiscussModal.dis_nickname = dataDic[@"_yuetan_person_detail"][@"person_nickname"];
                    AspDiscussModal.dis_pic = dataDic[@"_yuetan_person_detail"][@"person_pic"];
                    AspDiscussModal.dis_zw = dataDic[@"_yuetan_person_detail"][@"person_zw"];
                    AspDiscussModal.isInCome = dataDic[@"is_income"];
                }
                else
                {
                    AspDiscussModal.user_personId = dataDic[@"_person_detail"][@"personId"];
                    AspDiscussModal.user_name = dataDic[@"_person_detail"][@"person_iname"];
                    AspDiscussModal.user_nickName = dataDic[@"_person_detail"][@"person_nickname"];
                    AspDiscussModal.user_pic = dataDic[@"_person_detail"][@"person_pic"];
                    AspDiscussModal.user_zw = dataDic[@"_person_detail"][@"person_zw"];
                    AspDiscussModal.isInCome = dataDic[@"is_income"];
                    
                    
                    AspDiscussModal.dis_personId = [Manager getUserInfo].userId_;
                    AspDiscussModal.dis_personName = [Manager getUserInfo].name_;
                    AspDiscussModal.dis_nickname = [Manager getUserInfo].nickname_;
                    AspDiscussModal.dis_pic = [Manager getUserInfo].img_;
                    AspDiscussModal.dis_zw = [Manager getUserInfo].job_;
                }
                
                AspDiscussModal.course_id = dataDic[@"course_info"][@"course_id"];
                AspDiscussModal.course_title = dataDic[@"course_info"][@"course_title"];
                AspDiscussModal.course_price = dataDic[@"course_info"][@"course_price"];
                
                [_dataArray addObject:AspDiscussModal];
            }
        }
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        [self finishReloadingData];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ELInterviewListCell";
    
    ELInterviewListCell *cell = (ELInterviewListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELInterviewListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ELAspectantDiscuss_Modal *dataModal = [_dataArray objectAtIndex:indexPath.row];
    [cell giveDataModel:dataModal];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self goToAspDetailCtl:indexPath.row];
}

- (void)goToAspDetailCtl:(NSInteger)index
{
    ELAspectantDiscuss_Modal *dataModal = [_dataArray objectAtIndex:index];
    
    ELMyAspectantDetailCtl *aspDetailCtl = [[ELMyAspectantDetailCtl alloc] init];
    [self.navigationController pushViewController:aspDetailCtl animated:YES];
    [aspDetailCtl beginLoad:dataModal exParam:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
