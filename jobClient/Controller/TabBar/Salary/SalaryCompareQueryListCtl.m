//
//  SalaryCompareQueryListCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryCompareQueryListCtl.h"
#import "SalaryCompareQuery_Cell.h"
#import "SalaryResult_DataModal.h"

@interface SalaryCompareQueryListCtl ()
{
    RequestCon *_querySalaryCountCon;
    __weak IBOutlet UIView *_tipsView;
    __weak IBOutlet NSLayoutConstraint *_tableViewTopSpace;
}
@end

@implementation SalaryCompareQueryListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.navigationItem.title = @"比拼记录";
    [self setNavTitle:@"比拼记录"];
    bFooterEgo_ = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [super getDataFunction:con];
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        [BaseUIViewController showAlertView:nil msg:@"需要登录" btnTitle:@"确定"];
        return;
    }
    //查询的次数
    if (!_querySalaryCountCon) {
        _querySalaryCountCon = [self getNewRequestCon:NO];
    }
    [con getQuerySalaryList:userId pageSize:requestCon_.pageInfo_.pageSize_ pageIndex:requestCon_.pageInfo_.currentPage_];
    [_querySalaryCountCon getSalaryQueryCountWithUserId:userId];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_GetQuerySalaryCount://查询薪指的次数
        {
            NSDictionary *dic = dataArr[0];
            NSString *salaryQueryCount = dic[@"last_select_nums"];
            is_free = dic[@"is_free"];
            
            if ([is_free isEqualToString:@"1"] && [salaryQueryCount isEqualToString:@""])
            {
                _tipsView.hidden = NO;
                _tableViewTopSpace.constant = 33;
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：你还有1次比拼机会"];
                [attString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xe4403a)} range:NSMakeRange(8, 1)] ;
                _countLb.attributedText = attString;
                
                return;
            }
            
            if (salaryQueryCount)
            {
                if ([salaryQueryCount integerValue] > 0) {
                    _tipsView.hidden = NO;
                    _tableViewTopSpace.constant = 33;
                    NSString *countStr = [NSString stringWithFormat:@"温馨提示：你还有%@次比拼机会", salaryQueryCount];
                    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:countStr];
                    [attString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xe4403a)} range:NSMakeRange(8, salaryQueryCount.length)] ;
                    _countLb.attributedText = attString;
                }
                else{
                    _tipsView.hidden = YES;
                    _tableViewTopSpace.constant = 0;
                }
            }
            
        }
        default:break;
    }
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SalaryCompareQuery_Cell";
    SalaryCompareQuery_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SalaryCompareQuery_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    User_DataModal *resultModel = requestCon_.dataArr_[indexPath.row];
    [cell setUserModel:resultModel];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0 + CELL_MARGIN_TOP;
}


#pragma mark 无需点击
- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
}

- (void)btnResponse:(id)sender
{
    if (sender == _goUseBtn) {//比薪资
        NSInteger count = self.navigationController.childViewControllers.count;
        BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-2];
        if ([ctl isKindOfClass: [SalaryCompeteCtl class]]) {
            [self backBarBtnResponse:sender];
            return;
        }
        BaseUIViewController *ctl2  =self.navigationController.childViewControllers[count-3];
        if ([ctl2 isKindOfClass: [SalaryCompeteCtl class]]) {
            [self.navigationController popToViewController:ctl2 animated:YES];
            return;
        }
        SalaryCompeteCtl *salaryCompeteCtl = [[SalaryCompeteCtl alloc]init];
        [self.navigationController pushViewController:salaryCompeteCtl animated:YES];
    }
}



@end
