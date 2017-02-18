//
//  OwnGroupListCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OwnGroupListCtl.h"
#import "ExRequetCon.h"
#import "MyGroups_Cell.h"
#import "ELGroupSearchCtl.h"
#import "ELGroupListDetailModel.h"
#import "ELGroupCommentModel.h"
#import "ELGroupArticleModel.h"
#import "ELGroupDetailCtl.h"
#import "GroupsDetailCtl.h"

@interface OwnGroupListCtl ()<UISearchBarDelegate,ELGroupDetailCtlDelegate,QuitGroupDelegate>
{
    NSMutableArray *_myCreateGroupArr;
    NSMutableArray *_myJoinGroupArr;
    
    IBOutlet UISearchBar *_searchBar;
    BOOL _isShowSectionTitle;
    NSIndexPath *_selectIndexPath;
    
    __weak IBOutlet NSLayoutConstraint *tableViewTop;
    
}
@end

@implementation OwnGroupListCtl
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.navigationItem.title){
//        self.navigationItem.title = @"我的社群";
        [self setNavTitle:@"我的社群"];
    }
    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    _myCreateGroupArr = [[NSMutableArray alloc] init];
    _myJoinGroupArr = [[NSMutableArray alloc] init];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchBar.delegate = self;
    
    if (_hideSearchBar) {
        tableViewTop.constant = 0;
        _searchBar.hidden = YES;
    }else{
        _searchBar.hidden = NO;
        tableViewTop.constant = 42;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupName:) name:@"kChangeGroupName" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)getDataFunction:(RequestCon *)con
{
    if (!_userId) {
        _userId = [Manager getUserInfo].userId_;
    }
    [con getMyGroups:_userId page:requestCon_.pageInfo_.currentPage_ pageSize:15 searchArr:[Manager getUserInfo].userId_ type:@"1"];//0全部社群
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_MyGroups:
        {
            [_myCreateGroupArr removeAllObjects];
            [_myJoinGroupArr removeAllObjects];
            if ([_userId isEqualToString:[Manager getUserInfo].userId_]) {
                for (ELGroupListDetailModel *dataModal in requestCon.dataArr_) {
                    if ([dataModal.group_person_id isEqualToString:_userId])
                    {
                        [_myCreateGroupArr addObject:dataModal];
                    }
                    else {
                        [_myJoinGroupArr addObject:dataModal];
                    }
                }
            }else{
                [_myJoinGroupArr addObjectsFromArray:requestCon.dataArr_];
            }
            _isShowSectionTitle = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_myJoinGroupArr.count == 0 || _myCreateGroupArr.count == 0) {
        return 1;
    }
    else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleStr = @"";
    if (_isShowSectionTitle) {
//        if (section == 0) {
//            if (_myCreateGroupArr.count != 0) {
//                if ([self.navigationItem.title isEqualToString:@"我的社群"]) {
//                    titleStr = @"我创建的社群";
//                }
//                else if ([self.navigationItem.title isEqualToString:@"TA的社群"]){
//                    titleStr = @"TA创建的社群";
//                }
//            }
//            else {
//                if ([self.navigationItem.title isEqualToString:@"我的社群"]) {
//                    titleStr = @"我加入的社群";
//                }
//                else if ([self.navigationItem.title isEqualToString:@"TA的社群"]){
//                    titleStr = @"TA加入的社群";
//                }
//            }
//        }
//        else if (section == 1) {
//            if ([self.navigationItem.title isEqualToString:@"我的社群"]) {
//                titleStr = @"我加入的社群";
//            }
//            else if ([self.navigationItem.title isEqualToString:@"TA的社群"]){
//                titleStr = @"TA加入的社群";
//            }
//        }
        titleStr = [self setSectionTitle:section];
    }
    
    return titleStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount;
    if (section == 0) {
        if (_myCreateGroupArr.count != 0) {
            rowCount = _myCreateGroupArr.count;
        }
        else {
            rowCount = _myJoinGroupArr.count;
        }
    }
    else if (section == 1) {
        rowCount = _myJoinGroupArr.count;
    }
    else{
        rowCount = 0;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    static NSString *CellIdentifier = @"MyGroupsCtlCell";
    
    MyGroups_Cell *cell = (MyGroups_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyGroups_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
       
    }
    
    ELGroupListDetailModel *dataModal;
    switch (indexPath.section) {
        case 0:
        {
            if (_myCreateGroupArr.count != 0) {
                dataModal = [_myCreateGroupArr objectAtIndex:indexPath.row];
            }
            else {
                dataModal = [_myJoinGroupArr objectAtIndex:indexPath.row];
            }
        }
            break;
        case 1:
        {
            dataModal = [_myJoinGroupArr objectAtIndex:indexPath.row];
        }
            break;
            
        default:
            break;
    }
    [cell cellGiveDataWithModal:dataModal];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    ELGroupListDetailModel * dataModal;
    if (indexPath.section == 0) {
        if (_myCreateGroupArr.count != 0) {
            dataModal = [_myCreateGroupArr objectAtIndex:indexPath.row];
        }else{
            dataModal = [_myJoinGroupArr objectAtIndex:indexPath.row];
        }
    }else if (indexPath.section == 1){
        dataModal = [_myJoinGroupArr objectAtIndex:indexPath.row];
    }
    if (_fromMessageDailog) {
        if (_block) {
           _block(dataModal); 
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    

    if ([dataModal._dynamic_cnt integerValue] >0) {
        [Manager shareMgr].messageCountDataModal.toolBarGroupCnt = [Manager shareMgr].messageCountDataModal.toolBarGroupCnt - [dataModal._dynamic_cnt integerValue] ;
        dataModal._dynamic_cnt = @"";
        if ([Manager shareMgr].messageCountDataModal.toolBarGroupCnt < 0) {
            [Manager shareMgr].messageCountDataModal.toolBarGroupCnt = 0;
        }
//        [[Manager shareMgr].tabView_ setTabBarNewMessage];
    }
    [tableView_ reloadData];
    ELGroupDetailCtl *detailCtl_ = [[ELGroupDetailCtl alloc] init];
    detailCtl_.delegate = self;
    [detailCtl_ beginLoad:dataModal.group_id exParam:nil];
    _selectIndexPath = indexPath;
    [self.navigationController pushViewController:detailCtl_ animated:YES];
    detailCtl_.isMine = YES;
//    detailCtl_.pushFromMe_ = YES;
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"社群详情",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

#pragma mark - ELGroupDetailCtlDelegate
-(void)refresh{
    [self refreshLoad:nil];
}

#pragma mark - 退出社群成功代理
-(void)quitGroupSuccess{
    if (_selectIndexPath.row < _myJoinGroupArr.count) {
        [_myJoinGroupArr removeObjectAtIndex:_selectIndexPath.row];
        [tableView_ reloadData];
        [self adjustFooterViewFrame];
    }
}
#pragma mark - 修改头像成功代理
-(void)updateGroupImgSuccess:(NSString *)img{
    ELGroupListDetailModel * dataModal;
    if (_selectIndexPath.row < _myCreateGroupArr.count) {
        dataModal = [_myCreateGroupArr objectAtIndex:_selectIndexPath.row];
    }
    if (dataModal && img && ![img isEqualToString:@""]) {
        dataModal.group_pic = img;
        [tableView_ reloadData];
        [self adjustFooterViewFrame];
    }
}

#pragma mark - changeGroupName notification
- (void)updateGroupName:(NSNotification *)noti
{
    [self refreshLoad:nil];
}

//跳转社群详情页
- (void)cellBtnClick:(UIButton *)sender
{
    ELGroupListDetailModel *dataModal = [_myCreateGroupArr objectAtIndex:sender.tag];
    GroupsDetailCtl *detailCtl = [[GroupsDetailCtl alloc] init];
    detailCtl.delegate_ = self;
    _selectIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:dataModal.group_id exParam:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    ELGroupSearchCtl *ctl = [[ELGroupSearchCtl alloc] init];
    ctl.fromMessageDailog = _fromMessageDailog;
    ctl.searchFrom = @"mygroup";
    ctl.userId = _userId;
    ctl.block = ^(ELGroupListDetailModel *dataModal){
        if (_block) {
            _block(dataModal);
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
    return NO;
}

- (NSString *)setSectionTitle:(NSInteger)section
{
    NSString *titleStr;
    switch (section) {
        case 0:
            if (_myCreateGroupArr.count != 0) {
                if ([_userId isEqualToString:[Manager getUserInfo].userId_]) {
                    titleStr = @"我创建的社群";
                }
                else {
                    titleStr = @"TA创建的社群";
                }
            }
            else {
                if ([_userId isEqualToString:[Manager getUserInfo].userId_]) {
                    titleStr = @"我加入的社群";
                }
                else {
                    titleStr = @"TA加入的社群";
                }
            }
            break;
        case 1:
        {
            if ([_userId isEqualToString:[Manager getUserInfo].userId_]) {
                titleStr = @"我加入的社群";
            }
            else {
                titleStr = @"TA加入的社群";
            }
        }
            break;
        default:
            break;
    }
    
    return titleStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
