//
//  SameTradeListCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-10-23.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SameTradeListCtl.h"
#import "SameTradeTipsCell.h"
#import "NewCommentMsgModel.h"
#import "ArticleCommentCtl.h"
#import "MyAudienceListCtl.h"
#import "SameTradeCell.h"
#import "SameTradeSection_DataModal.h"
#import "SalaryHeaderView.h"
#import "SalaryFooterView.h"
#import "Expert_DataModal.h"
#import "NoLoginPromptCtl.h"
#import "ELSameTradeSearchCtl.h"
#import "ELPersonCenterCtl.h"
#import "ELSameTradePeopleFrameModel.h"
#import "ExpertPublishCtl.h"
//#import "SalaryIrrigationDetailCtl.h"

@interface SameTradeListCtl () <SalaryIrrigationDetailDelegate,PersonCenterCtlDelegate>
{
    BOOL shouldRefresh_;
    BOOL bshowAD_;
}

@end

@implementation SameTradeListCtl
@synthesize mynewMsgArray_,searchBar_,delegate_,adArray_,getExpertFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
        validateSeconds_ = 600;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"同行";
    
    searchBar_.delegate = self;
    searchBar_.backgroundColor = [UIColor whiteColor];
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    UITextField *searchField = [searchBar_ valueForKey:@"_searchField"];
    [searchField setValue:UIColorFromRGB(0xd8d8d8) forKeyPath:@"_placeholderLabel.textColor"];
    mynewMsgArray_ = [[NSMutableArray alloc] init];
    adArray_       = [[NSArray alloc] init];
    [tableView_ setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];

    [self.view bringSubviewToFront:tableView_];
   
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.separatorInset = UIEdgeInsetsZero;
    if (IOS8) {
        tableView_.layoutMargins = UIEdgeInsetsZero;
    }
    UIView *view = [[UIView alloc]init];
    tableView_.tableFooterView = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (requestCon_ && ([requestCon_.dataArr_  count] == 0 || shouldRefresh_) ) {
        [self refreshLoad:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{
    if (![Manager shareMgr].isFromMessage_) {
        [requestCon_ stopConnWhenBack];
    }
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    [tableView_ reloadData];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:nil];
    if (dataModal != nil && ![dataModal isEqualToString:@""]) {
        getExpertFlag = dataModal;

        [self setNavTitle:@"行家"];
    }
    else
    {  [self setNavTitle:@"同行"];
        getExpertFlag = @"";
    }
    
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager getUserInfo].userId_) {
        userId = @"";
    }
    [con getNewSameTradePerson:userId expertFlag:getExpertFlag pageIndex:requestCon_.pageInfo_.currentPage_];
}

-(void)reloadTableView
{
    [tableView_ reloadData];
    [self adjustFooterViewFrame];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetTraderPeson:
        {
            shouldRefresh_ = NO;
            [delegate_ finishGetMyData];
        }
            break;
        case Request_getSameTradePerson:
        {
            shouldRefresh_ = NO;
            [delegate_ finishGetMyData];
        }
            break;
        case Request_TopAD:
        {
            adArray_ = [NSArray arrayWithArray:dataArr];
        }
            break;
        case Request_getNewSameTradePerson:
        {
            shouldRefresh_ = NO;
            [delegate_ finishGetMyData];
        }
            break;
        default:
            break;
    }
}

#pragma mark 跳转到发表文章的列表
- (void)goPublishArticleCtl:(UIButton *)sender
{
    NSInteger section = sender.tag;
    SameTradeSection_DataModal *dataModel = requestCon_.dataArr_[section -1];
    Article_DataModal *articleModel = dataModel.dataArray[0];
    Expert_DataModal *expertModel = articleModel.expert_;
    ExpertPublishCtl *publishCtl = [[ExpertPublishCtl alloc]init];
    publishCtl.isMyCenter = NO;
    [publishCtl beginLoad:expertModel exParam:nil];
    [self.navigationController pushViewController:publishCtl animated:NO];
}

#pragma mark 跳转到灌薪水列表
- (void)goSalaryListCtl
{
//    [[Manager shareMgr] tabViewModalChanged:[Manager shareMgr].tabView_ type:Tab_First];
    [self performSelector:@selector(changeType) withObject:nil afterDelay:.1f];
}

- (void)changeType
{
    //[[Manager shareMgr].salaryCtl_ changeModel:1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){//显示新的消息
        return [mynewMsgArray_ count];
    }else{
        return requestCon_.dataArr_.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 93 + CELL_MARGIN_TOP;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SameTradeTipsCell";
    if (indexPath.section == 0) {
        SameTradeTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SameTradeTipsCell" owner:self options:nil] lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell setDataModel:[mynewMsgArray_ objectAtIndex:indexPath.row]];
        return cell;
    }else{
        ELSameTradePeopleFrameModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        static NSString *identifier = @"cell";
        SameTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[SameTradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (_fromMessageList) {
            cell.showAttentionButton = NO;
        }else{
            cell.showAttentionButton = YES;
        }
        cell.peopleModel = model;
        return cell;
    }
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    if (indexPath.section == 0) {
        Status_DataModal *model = [mynewMsgArray_ objectAtIndex:indexPath.row];
        model.exObj_ = @"0";
        MyAudienceListCtl *audienceCtl = [[MyAudienceListCtl alloc]init];
        NSString *type = [NSString stringWithFormat:@"2"];
        [audienceCtl beginLoad:type exParam:nil];
        [mynewMsgArray_ removeObject:model];
        [self.navigationController pushViewController:audienceCtl animated:YES];
        [tableView_ reloadData];
    }else{
        ELSameTradePeopleFrameModel *dataModel = requestCon_.dataArr_[indexPath.row];
        if (_fromMessageList){
            ShareMessageModal *shareModal = [[ShareMessageModal alloc] init];
            shareModal.personId = dataModel.peopleModel.personId;
            shareModal.personName = dataModel.peopleModel.person_iname;
            shareModal.person_pic = dataModel.peopleModel.person_pic;
            shareModal.person_zw = dataModel.peopleModel.person_job_now;
            if (shareModal.person_zw.length == 0) {
                shareModal.person_zw = dataModel.peopleModel.person_zw;
            }
            shareModal.shareType = @"1";
            shareModal.shareContent = @"名片";
            
            if (!shareModal.personName) {
                shareModal.personName = @"";
            }
            if (!shareModal.person_pic) {
                shareModal.person_pic = @"";
            }
            if (!shareModal.person_zw) {
                shareModal.person_zw = @"";
            }
            [delegate_ sameTradeMessageModal:shareModal];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
        personCenterCtl.delegate = self;
        [self.navigationController pushViewController:personCenterCtl animated:NO];
        selectedIndexpath_ = indexPath;
        [personCenterCtl beginLoad:dataModel.peopleModel.personId exParam:nil];
    }
}

#pragma mark - 个人中心加关注回调
- (void)addLikeSuccess{
    ELSameTradePeopleFrameModel *model = requestCon_.dataArr_[selectedIndexpath_.row];
    model.peopleModel.rel = @"1";
    [tableView_ reloadData];
}

#pragma mark - 个人中心取消关注回调
- (void)leslikeSuccess{
    ELSameTradePeopleFrameModel *model = requestCon_.dataArr_[selectedIndexpath_.row];
    model.peopleModel.rel = @"";
    [tableView_ reloadData];
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    ELSameTradeSearchCtl *ctl = [[ELSameTradeSearchCtl alloc] init];
    ctl.getExpertFlag = getExpertFlag;
    ctl.fromMessageList = self.fromMessageList;
    ctl.sameTradeCtl = self;
    [self.navigationController pushViewController:ctl animated:YES];
    return NO;
}

- (void)reciveNewMesageAction:(NSNotificationCenter *)notifcation
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
