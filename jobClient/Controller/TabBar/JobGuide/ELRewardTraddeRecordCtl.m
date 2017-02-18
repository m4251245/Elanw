//
//  ELRewardTraddeRecordCtl.m
//  jobClient
//
//  Created by YL1001 on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELRewardTraddeRecordCtl.h"
#import "ELRewardTradeRecordCell.h"
//#import "OrderType_DataModal.h"
#import "MyTradeRecordModal.h"

@interface ELRewardTraddeRecordCtl ()
{
    UIView *maskView;

    NSString *recordType; //1打赏  3提现  5约谈
    RequestCon *rewardCon;
    
    NSMutableArray *imgArray;
    
    NSString *rewardSum;
    NSString *interviewSum;
    NSString *withdrawSum;
}
@end

@implementation ELRewardTraddeRecordCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        bFooterEgo_ = YES;
        bHeaderEgo_ = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"流水记录";
    [self setNavTitle:@"流水记录"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger width = -6;
    negativeSpacer.width = width;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];

    
    imgArray = [[NSMutableArray alloc] initWithObjects:@"redPacket.png",@"flower.png",@"reward_ pen.png",@"compute.png",@"emblem.png",@"crown.png", nil];
    
    allTypeBtn.layer.cornerRadius = 4.0f;
    allTypeBtn.layer.masksToBounds = YES;
    allTypeBtn.layer.borderColor = [UIColor redColor].CGColor;
    allTypeBtn.layer.borderWidth = 1.0f;
    
    rewardBtn.layer.cornerRadius = 4.0f;
    rewardBtn.layer.masksToBounds = YES;
    rewardBtn.layer.borderColor = [UIColor redColor].CGColor;
    rewardBtn.layer.borderWidth = 1.0f;
    
    interviewBtn.layer.cornerRadius = 4.0f;
    interviewBtn.layer.masksToBounds = YES;
    interviewBtn.layer.borderColor = [UIColor redColor].CGColor;
    interviewBtn.layer.borderWidth = 1.0f;
    
    withdrawBtn.layer.cornerRadius = 4.0f;
    withdrawBtn.layer.masksToBounds = YES;
    withdrawBtn.layer.borderColor = [UIColor redColor].CGColor;
    withdrawBtn.layer.borderWidth = 1.0f;
    
    if (!rewardCon) {
        rewardCon = [self getNewRequestCon:NO];
    }
    recordType = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"流水记录";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [self getTotalMoney];
}

- (void)getDataFunction:(RequestCon *)con
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        return;
    }
    [con getRewardList:userId type:recordType page:con.pageInfo_.currentPage_ pageSize:20];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetRewardList://打赏记录
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ELRewardTradeRecordCell";
    
    ELRewardTradeRecordCell *cell = (ELRewardTradeRecordCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELRewardTradeRecordCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.bgView_.layer.cornerRadius = 8;
    MyTradeRecordModal *order = requestCon_.dataArr_[indexPath.row];
    
    cell.titleLb.text = order.bill_type_name;
    cell.detailLb.text = order.bill_desc;

    if ([order.bill_type_name isEqualToString:@"打赏"]) {
        cell.giftImg.hidden = NO;
        cell.giftImg.image = [UIImage imageNamed:[imgArray objectAtIndex:[order.service_detail_id integerValue]-1]];
    }
    else
    {
        cell.giftImg.hidden = YES;
        cell.detailLbAutoLeading.constant = 15;
    }
    
    if ([order.bill_status isEqualToString:@""]) {
        cell.statusLb.text = @"已处理";
        cell.statusLb.textColor = UIColorFromRGB(0x666666);
    }
    else
    {
        cell.statusLb.text = order.bill_status;
    }
    
    if ([order.is_income isEqualToString:@"3"]) {
        cell.statusLb.text = @"已退款";
    }
    
//    cell.statusLb.text = order.bill_status;
    cell.moneyLb.text = order.money;
    cell.timeLb.text = order.idatetime;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

- (void)btnResponse:(id)sender
{
    if (sender == moreBtn) {
        [self showTypeView];
    }
    else if (sender == allTypeBtn)
    {
        recordType = @"";
        tableView_.tableHeaderView = nil;
        
        rewardBtn.backgroundColor = [UIColor whiteColor];
        [rewardBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        interviewBtn.backgroundColor = [UIColor whiteColor];
        [interviewBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        withdrawBtn.backgroundColor = [UIColor whiteColor];
        [withdrawBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        allTypeBtn.backgroundColor = [UIColor redColor];
        [allTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [rewardCon getRewardList:[Manager getUserInfo].userId_ type:recordType page:rewardCon.pageInfo_.currentPage_ pageSize:20];
        [self hiddenTypeView];
        [self refreshLoad:rewardCon];
    }
}

- (IBAction)chooseType:(UIButton *)sender {
    tableView_.tableHeaderView = nil;
    
    if (sender == rewardBtn)
    {//打赏
        recordType = @"1";
        totalLb.text = @"打赏合计";
        moneyTotallb.text = rewardSum;
        [self hiddenTypeView];
        
        rewardBtn.backgroundColor = [UIColor redColor];
        [rewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        interviewBtn.backgroundColor = [UIColor whiteColor];
        [interviewBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        withdrawBtn.backgroundColor = [UIColor whiteColor];
        [withdrawBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        allTypeBtn.backgroundColor = [UIColor whiteColor];
        [allTypeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if (sender == interviewBtn)
    {//约谈
        recordType = @"5";
        totalLb.text = @"约谈合计";
        moneyTotallb.text = interviewSum;
        [self hiddenTypeView];
        
        rewardBtn.backgroundColor = [UIColor whiteColor];
        [rewardBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        interviewBtn.backgroundColor = [UIColor redColor];
        [interviewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        withdrawBtn.backgroundColor = [UIColor whiteColor];
        [withdrawBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        allTypeBtn.backgroundColor = [UIColor whiteColor];
        [allTypeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if (sender == withdrawBtn)
    {//提现
        recordType = @"3";
        totalLb.text = @"提现合计";
        moneyTotallb.text = withdrawSum;
        [self hiddenTypeView];
        
        rewardBtn.backgroundColor = [UIColor whiteColor];
        [rewardBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        interviewBtn.backgroundColor = [UIColor whiteColor];
        [interviewBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        withdrawBtn.backgroundColor = [UIColor redColor];
        [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        allTypeBtn.backgroundColor = [UIColor whiteColor];
        [allTypeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    tableView_.tableHeaderView = headerView;
    [self refreshLoad:rewardCon];
}


- (void)getTotalMoney
{
    /**
     bill_type:账单类型，1打赏 3提现 5约谈  0全部
     */
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&bill_type=%d",[Manager getUserInfo].userId_,0];
    
    NSString *function = @"getPersonBillStat";
    NSString *op = @"yl_bill_record_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        rewardSum = [result objectForKey:@"dashang"];
        interviewSum = [result objectForKey:@"yuetan"];
        withdrawSum = [result objectForKey:@"cash"];
        
        if ([rewardSum isEqualToString:@""]) {
            rewardSum = @"0";
        }
        
        if ([interviewSum isEqualToString:@""]) {
            interviewSum = @"0";
        }
        
        if ([withdrawSum isEqualToString:@""]) {
            withdrawSum = @"0";
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}

- (void)showTypeView
{
    moreBtn.hidden = YES;
    maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.0;
    
    CGRect frame = typeView.frame;
    frame.origin.x = 0;
    frame.origin.y = -80;
    typeView.frame = frame;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTypeView)];
    singleRecognizer.numberOfTapsRequired = 1;
    [maskView addGestureRecognizer:singleRecognizer];
    
    [self.view addSubview:maskView];
    [self.view addSubview:typeView];
    
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0.7;
        typeView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 49);
    }];
}

- (void)hiddenTypeView
{
    moreBtn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0.0;
        typeView.frame = CGRectMake(0, -80, self.view.bounds.size.width, 49);
    }completion:^(BOOL finished){
        [maskView removeFromSuperview];
        [typeView removeFromSuperview];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
