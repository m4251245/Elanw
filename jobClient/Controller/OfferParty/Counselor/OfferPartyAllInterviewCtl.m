//
//  OfferPartyAllInterviewCtl.m
//  jobClient
//
//  Created by YL1001 on 16/3/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "OfferPartyAllInterviewCtl.h"
#import "ELOfferNotificationCell.h"

@interface OfferPartyAllInterviewCtl ()

@end

@implementation OfferPartyAllInterviewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerRefreshFlag = YES;
    self.footerRefreshFlag = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.navigationItem.title = @"面试详情";
    [self setNavTitle:@"面试详情"];

}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
    //组件条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page_index"];
    
    NSString *condition = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&conditionArr=%@",_jobfair_id,condition];
    
    [ELRequest postbodyMsg:bodyMsg op:@"offerpai_busi" func:@"getOfferSmsList" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         [self parserPageInfo:result];
         if([result[@"data"] isKindOfClass:[NSArray class]])
         {
             for (NSDictionary *subDic in result[@"data"])
             {
                 OfferPartyTalentsModel *modal = [[OfferPartyTalentsModel alloc] init];
                 modal.jobfair_id = subDic[@"id"];
                 modal.personId = subDic[@"reid"];
                 modal.companyId = subDic[@"senduid"];
                 modal.companyName = subDic[@"sendname"];
                 modal.jobfair_time = subDic[@"sdate"];
                 modal.jobfair_name = subDic[@"person_iname"];
                 [_dataArray addObject:modal];
             }
         }
         [self.tableView reloadData];
         [self finishReloadingData];
         [self refreshEGORefreshView];
     } failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [self finishReloadingData];
         [self refreshEGORefreshView];
     }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"ELOfferNotificationCell";
    ELOfferNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ELOfferNotificationCell" owner:self options:nil][0];
        
    }
    if (indexPath.row == 0) 
    {
        cell.lineImage.hidden = YES;
    }
    else
    {
        cell.lineImage.hidden = NO;
    }
    OfferPartyTalentsModel *model = _dataArray[indexPath.row];
    cell.titleLabel.text = model.companyName;
    cell.timeLabel.text = model.jobfair_time;
    cell.nameLabel.text = model.jobfair_name;
    CGSize size = [model.jobfair_name sizeNewWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(ScreenWidth-150,20)];
    CGRect frame = cell.nameLabel.frame;
    frame.size.width = size.width + 5;
    cell.nameLabel.frame = frame;
    
    frame = cell.contentLabel.frame;
    frame.origin.x = CGRectGetMaxX(cell.nameLabel.frame)+15;
    cell.contentLabel.frame = frame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
