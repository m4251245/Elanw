//
//  ELGroupSearchCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/10/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELGroupSearchCtl.h"
#import "RecommendGroups_Cell.h"
#import "ELTodaySearchModal.h"
#import "ELGroupListDetailModel.h"
#import "PrivateGroupView.h"
#import "MyGroups_Cell.h"
#import "ELGroupDetailCtl.h"


@interface ELGroupSearchCtl () <UISearchBarDelegate,ELGroupDetailCtlDelegate>
{
    __weak IBOutlet UISearchBar *searchBar_;
    __weak IBOutlet UIButton *cancelBtn;
    
    UIView *tapView;
    RequestCon       * joinCon_;
    NSString *groupID;
    PrivateGroupView *privateView;
}
@end

@implementation ELGroupSearchCtl
#pragma mark - LifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchBar_.delegate = self;
    searchBar_.hidden = YES;
    [searchBar_ setBackgroundImage:[UIImage imageNamed:@""]];
    [searchBar_ setBackgroundColor:PINGLUNHONG];
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    self.navigationItem.titleView = searchBar_;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    tableView_.hidden = YES;
    tapView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,568)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tapView addGestureRecognizer:tap];
    [searchBar_ becomeFirstResponder];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"LOGINSUCCESS" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    searchBar_.hidden = NO;
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    searchBar_.hidden = YES;
    [super viewWillDisappear:animated];
    [searchBar_ resignFirstResponder];
    [tapView removeFromSuperview];
}


-(void)tap:(UITapGestureRecognizer *)sender
{
    [searchBar_ resignFirstResponder];
    [tapView removeFromSuperview];
}

#pragma mark - NetWork
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:nil];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId || [userId isEqualToString:@""]) {
        userId = @"";
    }
    //    [con getGroupsBySearch:userId keyword:searchBar_.text page:requestCon_.pageInfo_.currentPage_ pageSize:10];
    [con getTodayMoreGroupSearchWithKeyword:[MyCommon removeAllSpace:searchBar_.text] page:requestCon_.pageInfo_.currentPage_ pageSize:20 searchFrom:_searchFrom useId:_userId];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type)
    {
        case Request_SearchMoreGroupList:
        {
            for (ELTodaySearchModal *model in dataArr) {
                if (!model.attStringTitle){
                    model.attStringTitle = [[NSMutableAttributedString alloc] initWithString:model.group_name];
                    [model.attStringTitle setChangeKeyWord:searchBar_.text color:[UIColor redColor]];
                }
            }
            if (dataArr.count == 0) {
                if (privateView) {
                    [privateView removeFromSuperview];
                    privateView = nil;
                }
                return;
            }
            ELTodaySearchModal *model = dataArr[0];
            if ([model.openstatus isEqualToString:@"3"] && (![model.group_user_rel isEqualToString:@"30"] || ![Manager shareMgr].haveLogin)) {
                [self showTableFootView:model.group_user_rel];
            }else{
                if (privateView) {
                    [privateView removeFromSuperview];
                    privateView  = nil;
                }
            }
            groupID = model.group_id;
            
            [tableView_ reloadData];
        }
            break;
        case Request_JoinGroup:
        {
            if (code == Success) {
                [privateView.operationBtn setTitle:@"等待审核" forState:UIControlStateNormal];
                privateView.operationBtn.enabled = NO;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyGroupsCtlCell";
    MyGroups_Cell *cell = (MyGroups_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyGroups_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (requestCon_.dataArr_.count > 0) {
        ELTodaySearchModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        
        [dataModal.attStringTitle addAttribute:NSFontAttributeName value:cell.nameLb_.font range:NSMakeRange(0, dataModal.attStringTitle.string.length)];
        cell.nameLb_.attributedText = dataModal.attStringTitle;
        cell.msgCnt_.alpha = 0.0;
        
        if (dataModal.articleListContent.length > 0)
        {
            [cell.contentLb_ setText:dataModal.articleListContent];
            cell.contentLb_.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        else
        {
            cell.contentLb_.text = @"暂无新动态";
        }
        if ([dataModal.openstatus isEqualToString:@"3"]){
            cell.privacyImage.hidden = NO;
        }else{
            cell.privacyImage.hidden = YES;
        }
        
        [cell.imgView_ sd_setImageWithURL:[NSURL URLWithString:dataModal.group_pic] placeholderImage:[UIImage imageNamed:@"icon_zhiysq"]];
        
        NSDate * date = [MyCommon getDate:dataModal.group_updatetime_last];
        cell.timeLb.text = [MyCommon compareCurrentTime:date];
    }
    cell.lineImageLeft.constant = -10;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELTodaySearchModal *modal = requestCon_.dataArr_[indexPath.row];
    if ([modal.openstatus isEqualToString:@"3"] && (![modal.group_user_rel isEqualToString:@"30"] || ![Manager shareMgr].haveLogin)) {
        return;
    }
    ELGroupListDetailModel *dataModal = [[ELGroupListDetailModel alloc] init];
    dataModal.group_name = modal.group_name;
    dataModal.group_id = modal.group_id;
    dataModal.group_person_cnt = modal.group_person_cnt;
    dataModal.group_article_cnt = modal.group_article_cnt;
    dataModal.group_pic = modal.group_pic;
    if (_fromMessageDailog)
    {
        [searchBar_ resignFirstResponder];
        if (_block) {
            _block(dataModal);
        }
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
        return;
    }
    
    if ([dataModal._dynamic_cnt integerValue] >0)
    {
        [Manager shareMgr].messageCountDataModal.toolBarGroupCnt = [Manager shareMgr].messageCountDataModal.toolBarGroupCnt - [dataModal._dynamic_cnt integerValue] ;
        dataModal._dynamic_cnt = @"";
        if ([Manager shareMgr].messageCountDataModal.toolBarGroupCnt < 0) {
            [Manager shareMgr].messageCountDataModal.toolBarGroupCnt = 0;
        }
//        [[Manager shareMgr].tabView_ setTabBarNewMessage];
    }
    [tableView_ reloadData];
    ELGroupDetailCtl *detailCtl_ = [[ELGroupDetailCtl alloc] init];
    [detailCtl_ beginLoad:modal.group_id exParam:nil];
    detailCtl_.delegate = self;
    [self.navigationController pushViewController:detailCtl_ animated:YES];
    detailCtl_.isMine = YES;
//    detailCtl_.pushFromMe_ = YES;
}

- (void)showTableFootView:(NSString *)rel
{
    if (!privateView) {
        privateView = [[[NSBundle mainBundle] loadNibNamed:@"PrivateGroupView" owner:self options:nil] lastObject];
        privateView.height = MAX(400, ScreenHeight-150);
        [privateView.operationBtn addTarget:self action:@selector(operationAction) forControlEvents:UIControlEventTouchUpInside];
        tableView_.tableFooterView.height = privateView.height;
        
    }
    tableView_.tableFooterView = privateView;
    [privateView showPrivateGroupEntrance:[Manager shareMgr].haveLogin?rel:@"10"];
    
}


- (void)operationAction
{
    if ([Manager shareMgr].haveLogin) {
        if (!joinCon_) {
            joinCon_ = [self getNewRequestCon:NO];
        }
        [joinCon_ joinGroup:[Manager getUserInfo].userId_ group:groupID content:@" "];
    }else{
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        
    }
}

-(void)refresh
{
    [self refreshLoad:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UISearchBarDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar_ resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    tableView_.hidden = NO;
    [self beginLoad:nil exParam:nil];
    [searchBar_ resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    /*
     if ([MyCommon removeAllSpace:searchBar.text].length > 0) {
     [cancelBtn setTitle:@"搜索" forState:UIControlStateNormal];
     }
     else
     {
     [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
     }
     
     if ([MyCommon removeAllSpace:searchBar_.text].length > 0)
     {
     tableView_.hidden = NO;
     [self showHeaderView:NO];
     [self refreshLoad:nil];
     }
     else
     {
     tableView_.hidden = YES;
     }
     */
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [tableView_ addSubview:tapView];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [tapView removeFromSuperview];
    return YES;
}

- (IBAction)cancelBtnRespone:(UIButton *)sender
{
    //    if ([MyCommon removeAllSpace:searchBar_.text].length > 0)
    //    {
    //        tableView_.hidden = NO;
    //        [self beginLoad:nil exParam:nil];
    //    }
    [searchBar_ resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar_ resignFirstResponder];
}

- (void)refreshData
{
    [self refreshLoad:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
