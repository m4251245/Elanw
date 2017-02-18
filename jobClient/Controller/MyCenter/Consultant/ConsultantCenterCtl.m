//
//  ConsultantCenterCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantCenterCtl.h"
#import "ConsultantCenterCell.h"
#import "ConsultantHRDataModel.h"
#import "ExRequetCon.h"
#import "ConsultantSearchCtl.h"
#import "ConsultantLoadResumeCtl.h"
#import "ConsultantRecomCtl.h"
#import "ConsultantContactCtl.h"
#import "OfferPartyListCtl.h"
#import "ConsultantLoginCtl.h"
//#import "ZBarScanLoginCtl.h"

@interface ConsultantCenterCtl ()
{
    ConsultantHRDataModel *inModel;
    RequestCon     *changbinCon;
    RequestCon     *bindComCon;
}
@end

@implementation ConsultantCenterCtl

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_islogin) {
        self.fd_interactivePopDisabled = YES;
    }
    
    [self setNavTitle:@"我的招聘"];
    bHeaderEgo_ = NO;
    bFooterEgo_ = NO;
    tableView_.delegate = self;
    tableView_.dataSource = self;
    photoImagev.layer.cornerRadius = 23.0;
    photoImagev.layer.masksToBounds = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"解除绑定" forState:UIControlStateNormal];
    [button.titleLabel setFont:THIRTEENFONT_CONTENT];
    [button setFrame:CGRectMake(10, 0, 60, 40)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshCount:) name:@"ConsultantFreshCount" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)freshCount:(NSNotification *)noti
{
    NSLog(@"---------------%@",noti.userInfo);
    if(!bindComCon)
    {
        bindComCon = [self getNewRequestCon:NO];
    }
    [bindComCon refreshbingdingStatusWith:[Manager getUserInfo].userId_];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel = dataModal;
}

- (void)backBarBtnResponse:(id)sender
{
    NSArray *ctlArray = [self.navigationController viewControllers];
    UIViewController *pushCtl = nil;
    for (UIViewController *ctl in ctlArray) {
        if ([ctl isKindOfClass:[Manager shareMgr].myCenterCtl.class]) {
            pushCtl = ctl;
        }
    }
    if (pushCtl != nil) {
        [self.navigationController popToViewController:pushCtl animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否解除绑定？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //解绑
        if (!changbinCon) {
            changbinCon = [self getNewRequestCon:NO];
        }
        [changbinCon gunwenJieBang:inModel.salerId personId:[Manager getUserInfo].userId_];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case requestBingdingStatusWith:
        {
            if ([dataArr count] != 0) {
                if ([dataArr[0] isKindOfClass:[ConsultantHRDataModel class]]){
                    ConsultantHRDataModel *model = dataArr[0];
                    inModel = model;
                    [Manager setHrInfo:model];
                    [tableView_ reloadData];
                }
            }
        }
            break;
        case refreshbingdingStatusWith:
        {
            if ([dataArr count] != 0) {
                if ([dataArr[0] isKindOfClass:[ConsultantHRDataModel class]]){
                    ConsultantHRDataModel *model = dataArr[0];
                    inModel = model;
                    [Manager setHrInfo:model];
                    [tableView_ reloadData];
                }
                
            }
        }
            break;
        case gunwenJieBang:
        {
            Status_DataModal *model = dataArr[0];
            //解绑成功
            if ([model.status_ isEqualToString:@"1"]) {
                [BaseUIViewController showAutoDismissSucessView:@"解除绑定成功" msg:@"" seconds:1.0];
                NSArray *ctlArray = [self.navigationController viewControllers];
                UIViewController *pushCtl = nil;
                for (UIViewController *ctl in ctlArray) {
                    if ([ctl isKindOfClass:[Manager shareMgr].myCenterCtl.class]) {
                        pushCtl = ctl;
                    }
                }
                if (pushCtl != nil) {
                    [self.navigationController popToViewController:pushCtl animated:NO];
                    ConsultantLoginCtl *loginCtl = [[ConsultantLoginCtl alloc]init];
                    [pushCtl.navigationController pushViewController:loginCtl animated:YES];
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
                
            }else{
                [BaseUIViewController showAutoDismissFailView:@"解除绑定成功" msg:@"" seconds:1.0];
            }
        }
            break;
    }
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    [titleLb setText:inModel.iname_];
    
    [photoImagev sd_setImageWithURL:[NSURL URLWithString:inModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    if ([inModel.candownCount isEqualToString:@""] || inModel.candownCount == nil) {
        inModel.candownCount = @"0";
    }
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本月可下载简历 %@ 份",inModel.candownCount]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:226.0/255.0 green:62.0/255.0 blue:63.0/255.0 alpha:1.0] range:NSMakeRange(8,inModel.candownCount.length)];
    [resumeCount setAttributedText:attributeStr];
    
    if ([inModel.canContact isEqualToString:@""] || inModel.canContact == nil) {
        inModel.canContact = @"0";
    }
    NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本月可查看联系方式简历 %@ 份",inModel.canContact]];
    [attributeStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:226.0/255.0 green:62.0/255.0 blue:63.0/255.0 alpha:1.0] range:NSMakeRange(12,inModel.canContact.length)];
    [contactCountLb setAttributedText:attributeStr1];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 8)];
    [bgView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ConsultantCenterCell *cell = (ConsultantCenterCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantCenterCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    switch (indexPath.row) {
        case 0:
        {
            [cell.titleLb setText:@"搜索简历"];
            [cell.count setText:@""];
            [cell.markImagev setImage:[UIImage imageNamed:@"guwenshousuo.png"]];
        }
            break;
        case 1:
        {
            [cell.titleLb setText:@"我的人才库"];
            [cell.count setText:[NSString stringWithFormat:@"%@",inModel.all_resume_cnt]];
            [cell.markImagev setImage:[UIImage imageNamed:@"guwenrencai"]];
        }
            break;
        case 2:
        {
            [cell.titleLb setText:@"已推荐简历"];
            [cell.count setText:[NSString stringWithFormat:@"%@",inModel.recomdCount]];
            [cell.markImagev setImage:[UIImage imageNamed:@"guwenyituijian.png"]];
        }
            break;
        case 3:
        {
            [cell.titleLb setText:@"联系记录"];
            if (inModel.visitcnt == nil || [inModel.visitcnt isEqualToString:@""]) {
                inModel.visitcnt = @"0";
            }
            [cell.count setText:[NSString stringWithFormat:@"%@",inModel.visitcnt]];
            [cell.markImagev setImage:[UIImage imageNamed:@"guwenlianxi.png"]];
        }
            break;
        case 4:
        {
            if ([inModel.jobfaircnt isEqualToString:@""]) {
                inModel.jobfaircnt = @"0";
            }
            [cell.titleLb setText:@"览英荟"];
            [cell.count setText:inModel.jobfaircnt];
            [cell.markImagev setImage:[UIImage imageNamed:@"guwenofferpai.png"]];
        }
            break;
        case 5:
        {
            [cell.titleLb setText:@"扫描简历"];
            [cell.count setText:@""];
            [cell.markImagev setImage:[UIImage imageNamed:@"guwenshaomiao.png"]];
        }
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    switch (indexPath.row) {
        case 0://搜索简历
        {
            ConsultantSearchCtl *searchCtl = [[ConsultantSearchCtl alloc] init];
            searchCtl.reloadDateFlag = YES;
            searchCtl.searchFlag = 1000;
            [searchCtl beginLoad:inModel exParam:nil];
            [self.navigationController pushViewController:searchCtl animated:YES];
        }
            break;
        case 1://我的人才库
        {
            ConsultantLoadResumeCtl *consultantLoadResumeCtl = [[ConsultantLoadResumeCtl alloc] init];
            consultantLoadResumeCtl.downloadFlag = 1001;
            consultantLoadResumeCtl.salerId = inModel.salerId;
            [self.navigationController pushViewController:consultantLoadResumeCtl animated:YES];
        }
            break;
        case 2://已推荐
        {
            ConsultantRecomCtl *consultantRecomCtl = [[ConsultantRecomCtl alloc] init];
            consultantRecomCtl.recommendFlag = 1002;
            [consultantRecomCtl beginLoad:inModel exParam:nil];
            [self.navigationController pushViewController:consultantRecomCtl animated:YES];
        }
            break;
        case 3://联系记录
        {
            ConsultantContactCtl *consultantContactCtl = [[ConsultantContactCtl alloc] init];
            [consultantContactCtl beginLoad:inModel exParam:nil];
            [self.navigationController pushViewController:consultantContactCtl animated:YES];
        }
            break;
        case 4://览英荟
        {
            OfferPartyListCtl *offerPartyCtl = [[OfferPartyListCtl alloc] init];
            offerPartyCtl.isGuwen = YES;
            [self.navigationController pushViewController:offerPartyCtl animated:YES];
        }
            break;
        case 5:
        {
//            ZBarScanLoginCtl *ctl = [[ZBarScanLoginCtl alloc] init];
//            ctl.companyId = inModel.salerId;
            ELScanQRCodeCtl *ctl = [[ELScanQRCodeCtl alloc] init];
            ctl.companyId = inModel.salerId;
            [self.navigationController pushViewController:ctl animated:YES];
        }
        default:
            break;
    }
}

- (void)jumpCHROfferPartyDetailCtl
{
    [self freshCount:nil];
    [super beginLoad:nil exParam:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
