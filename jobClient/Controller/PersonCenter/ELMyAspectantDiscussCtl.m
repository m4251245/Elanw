//
//  ELMyAspectantDiscussCtl.m
//  jobClient
//
//  Created by YL1001 on 15/9/6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELMyAspectantDiscussCtl.h"
#import "ELAspectantDiscussCell.h"
#import "JobGuideCtl2.h"
#import "Manager.h"
#import "Status_DataModal.h"
#import "ELMyInterViewDetailCtl.h"
#import "Order.h"
#import "PayCtl.h"
#import "ELAddInterviewRegionCtl.h"
#import "AspectantDiscussSuccessCtl.h"

@interface ELMyAspectantDiscussCtl ()
{
    RequestCon *aspDisRequestCon;
    BOOL refreshList;
}
@end

@implementation ELMyAspectantDiscussCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bFooterEgo_ = YES;
        bHeaderEgo_ = YES;
        validateSeconds_ = 60000;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的约谈";
    proceedBtn.tag = 0;
    endBtn.tag = 1;
    goToLookBtn.layer.cornerRadius = 5;
    productType = 0;
    
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    redLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_title"]];
    redLine.frame = CGRectMake(0,32,ScreenWidth/2,2);
    [btnBgView addSubview:redLine];
}


- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)getDataFunction:(RequestCon *)con
{
    [con getAspectantDisListWithUserId:[Manager getUserInfo].userId_ status:productType page:con.pageInfo_.currentPage_ pageSize:15 otherCond:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (refreshList) {
        [self refreshLoad:nil];
        refreshList = NO;
    }
    self.navigationItem.title = @"我的约谈";
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationItem.title = @"";
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_AspectantDisList:
        {
            if (requestCon_.dataArr_.count < 1) {
                noDataView.hidden = NO;
            }
            else
            {
                noDataView.hidden = YES;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ELAspectantDiscussCell";
    ELAspectantDiscussCell *cell = (ELAspectantDiscussCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELAspectantDiscussCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ELAspectantDiscuss_Modal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    [cell giveDataModel:dataModal];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 162;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    refreshList = YES;
    ELAspectantDiscuss_Modal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    ELMyInterViewDetailCtl *detailCtl = [[ELMyInterViewDetailCtl alloc] init];
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:dataModal exParam:nil];
}

- (void)btnResponse:(UIButton *)sender
{
    CGPoint center = redLine.center;
    
    if (sender == proceedBtn) {
        center.x = proceedBtn.center.x;
        [UIView animateWithDuration:0.3 animations:^{
            redLine.center = center;
        }];
        
        [proceedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [endBtn setTitleColor:UIColorFromRGB(0x686868) forState:UIControlStateNormal];
        productType = 0;
        [self refreshLoad:nil];
    }
    else if (sender == endBtn)
    {
        center.x = endBtn.center.x;
        [UIView animateWithDuration:0.3 animations:^{
            redLine.center = center;
        }];
        
        [endBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [proceedBtn setTitleColor:UIColorFromRGB(0x686868) forState:UIControlStateNormal];
        productType = 1;
        [self refreshLoad:nil];
    }
    else if (sender == goToLookBtn)
    {
        JobGuideCtl2 *expertCtl = [[JobGuideCtl2 alloc] init];
        expertCtl.selectedTab = @"职业发展导师";
        [self.navigationController pushViewController:expertCtl animated:YES];
        [expertCtl beginLoad:nil exParam:nil];
    }
}

- (void)backBarBtnResponse:(id)sender
{
//    if ([[Manager shareMgr].yuetanListBackCtl isKindOfClass:[MyManagermentCenterCtl class]]) {
//        [self.navigationController popToViewController:[Manager shareMgr].yuetanListBackCtl animated:YES];
//    }
//    else
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
