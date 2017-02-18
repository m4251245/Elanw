//
//  MyOfferPartyListCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyOfferPartyListCtl.h"
#import "YLOfferListCtlCell.h"
#import "OfferPartyDetailIndexCtl.h"
#import "OfferPartyTalentsModel.h"
#import "UIImageView+WebCache.h"

@interface MyOfferPartyListCtl ()

@end

@implementation MyOfferPartyListCtl

- (instancetype)init
{
    if (self = [super init]) {
        bFooterEgo_= YES;
        bHeaderEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的Offer派";
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUp:) name:@"MyOfferPartyDetailCtlSignUpOfferParty" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUp:) name:@"YLOfferApplyUrlCtlSignUpOfferParty" object:nil];

}

- (void)refreshSignUp:(NSNotification *)notification
{
    [self refreshLoad:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

- (void)getDataFunction:(RequestCon *)con
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    [con getUserOfferPartyListByUserId:userId pageIndex:con.pageInfo_.currentPage_ pageSize:10 fromeType:@"offer"];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetUserOfferPartyList://user offer派列表
            if (![Manager getUserInfo].userId_) {
                 super.noDataTips = @"您需要登录以后才能查看您的报名信息";
            }
            break;
        default:
            break;
    }
}

- (void)updateCom:(RequestCon *)con
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return requestCon_.dataArr_.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"YLOfferListCtlCell";
    
    YLOfferListCtlCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:cellStr owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timeBackView.clipsToBounds = YES;
        cell.timeBackView.layer.borderWidth = 1.0f;
        cell.timeBackView.layer.cornerRadius = 4.0f;
        
        CGRect frame = cell.timeBackView.frame;
        frame.origin.x = 10;
        cell.timeBackView.frame = frame;
        
        cell.title.frame = CGRectMake(94,6,ScreenWidth-112,23);
        cell.job.frame = CGRectMake(94,29,ScreenWidth-112,15);
        cell.address.frame = CGRectMake(94,46,ScreenWidth-112,15);
        cell.lineImage.frame = CGRectMake(-10,68,ScreenWidth+10,1);
    }
    
    OfferPartyTalentsModel *dataModel = requestCon_.dataArr_[indexPath.row];
    cell.weekLb.text = [MyCommon getWeekDay:dataModel.jobfair_time];
    cell.dateLb.text = [dataModel.jobfair_time substringToIndex:10];
    cell.startTimeLb.text = [dataModel.jobfair_time substringFromIndex:11];
    cell.title.text = [MyCommon translateHTML:dataModel.jobfair_name];
    cell.job.text = [MyCommon translateHTML:dataModel.jobfair_zhiwei];
    cell.address.text = [MyCommon translateHTML:dataModel.place_name];
    
    if (dataModel.iscome){
        cell.statuImgv.hidden = NO;
        cell.statuImgv.image = [UIImage imageNamed:@"op_sign_in.png"];
        cell.timeBackView.layer.borderColor = UIColorFromRGB(0xe79945).CGColor;
        cell.dateLb.backgroundColor = UIColorFromRGB(0xe79945);
    }
    else{
        cell.statuImgv.hidden = NO;
        cell.statuImgv.image = [UIImage imageNamed:@"op_applyed.png"];
        cell.timeBackView.layer.borderColor = UIColorFromRGB(0xe74845).CGColor;
        cell.dateLb.backgroundColor = UIColorFromRGB(0xe74845);
    }
    
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    OfferPartyDetailIndexCtl *offerPartyDetailCtl = [[OfferPartyDetailIndexCtl alloc]init];
    OfferPartyTalentsModel * offerPartyModel = selectData;
    offerPartyModel.isjoin = YES;
    offerPartyDetailCtl.offerPartyModel = offerPartyModel;
    offerPartyDetailCtl.isSignUp = YES;
    [ self.navigationController pushViewController:offerPartyDetailCtl animated:YES];
    [offerPartyDetailCtl beginLoad:nil exParam:nil];
}
@end
