//
//  ELOfferPartyGroupsCtl.m
//  jobClient
//
//  Created by YL1001 on 16/11/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOfferPartyGroupsCtl.h"
#import "MyGroups_Cell.h"
#import "ELGroupDetailCtl.h"

@interface ELOfferPartyGroupsCtl ()<UISearchBarDelegate,ELGroupDetailCtlDelegate>
{
    UISearchBar *_searBar;
    
    BOOL pullDownRefresh;  //下拉刷新
    BOOL resumeComplete;   //简历是否完善
}
@end

@implementation ELOfferPartyGroupsCtl

- (void)viewDidLoad {
    self.headerRefreshFlag = NO;
    self.footerRefreshFlag = YES;
    self.showNoDataViewFlag = YES;
    self.showNoMoreDataViewFlag = YES;
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addNotify];
//    [self configUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)configUI
{
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, ScreenWidth, 45)];
    backgroudView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    backgroudView.layer.cornerRadius = 4.0f;
    
    _searBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 7, backgroudView.frame.size.width-20, 38)];
    _searBar.searchBarStyle = UISearchBarStyleDefault;
    _searBar.backgroundImage = [UIImage new];
    _searBar.barTintColor = [UIColor whiteColor];
    _searBar.placeholder = @"输入感兴趣的公司名称、职位、职业领域";
    _searBar.delegate = self;
    [backgroudView addSubview:_searBar];
    
    self.tableView.tableHeaderView = backgroudView;
}
#pragma mark - 代理
#pragma mark--UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyGroupsCtlCell";
    MyGroups_Cell *cell = (MyGroups_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyGroups_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    ELGroupListDetailModel * dataModal = [_dataArray objectAtIndex:indexPath.row];
    [cell cellGiveDataWithModal:dataModal];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELGroupListDetailModel *dataModal = _dataArray[indexPath.row];
    
    ELGroupDetailCtl *detailCtl = [[ELGroupDetailCtl alloc]init];
    detailCtl.delegate = self;
    detailCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:dataModal.group_id exParam:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {//从顶部离开的一瞬间发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"canScroll":@"1"}];
    }
    self.tableView = (UITableView *)scrollView;
}

#pragma mark - ELGroupDetailCtlDelegate
-(void)refresh
{
    [self refreshLoad];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self refreshLoad];
    [_searBar resignFirstResponder];
}

#pragma mark - 通知
-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"goTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"leaveTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"LoadGroupsData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"refreshData" object:nil];
}

-(void)notify:(NSNotification *)notify
{
    NSString *notificationName = notify.name;
    
    if ([notificationName isEqualToString:@"goTop"]) {
        NSDictionary *userInfo = notify.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;//处理右侧滚动条，自己观察
        }
    }else if([notificationName isEqualToString:@"leaveTop"]){
        self.tableView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
}

- (void)loadData:(NSNotification *)notify
{
    pullDownRefresh = NO;
    NSString *notificationName = notify.name;
    if ([notificationName isEqualToString:@"LoadGroupsData"]) {//第一次加载
        [self refreshLoad];
    }
    else if([notificationName isEqualToString:@"refreshData"]){//下拉刷新
        pullDownRefresh = YES;
        [self refreshLoad];
    }
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    [self requestOfferPartyGroups];
}

#pragma mark - 请求数据
//社群信息
- (void)requestOfferPartyGroups
{
    NSString *op = @"groups_busi";
    NSString *func = @"getofferpaigroups";
    
    NSString *userId;
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }
    else {
        userId = @"";
    }
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"login_person_id"];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page_index"];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    
    
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@", searchStr, conDicStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [self parserPageInfo:result];
        NSDictionary *dic = result;
        NSArray *dataArr = [dic objectForKey:@"data"];
        
        if ([dataArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDic in dataArr) {
                ELGroupListDetailModel *model = [[ELGroupListDetailModel alloc] initWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
        }
        
        if (_dataArray.count > 0) {
            _isCanLoad = YES;
        }
        
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self finishReloadingData];
        [self refreshEGORefreshView];
    }];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
