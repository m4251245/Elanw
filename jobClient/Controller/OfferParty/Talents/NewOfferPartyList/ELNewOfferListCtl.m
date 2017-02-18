//
//  ELNewOfferListCtl.m
//  jobClient
//
//  Created by YL1001 on 16/10/27.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewOfferListCtl.h"
#import "ELNewOfferListCell.h"
#import "ELOfferMainTable.h"
#import "New_HeaderBtn.h"
#import "ResumeCompleteModel.h"
#import "ELJobSearchCondictionChangeCtl.h"

@interface ELNewOfferListCtl ()<New_HeaderDelegate,UISearchBarDelegate,changeJobSearchCondictionDelegate>
{
    New_HeaderBtn *_regionBtn;
    UISearchBar *_searBar;
    UIView *_headerView;
    
    UIView *_bgView;
    CAGradientLayer *_gradientLayer;
    
    ELOfferMainTable *mainTableview;
    ELJobSearchCondictionChangeCtl *condictionCtl;
    CondictionList_DataModal *regionModal;
    
    BOOL pullDownRefresh;  //下拉刷新
    BOOL resumeComplete;   //简历是否完善
}
@end

@implementation ELNewOfferListCtl

- (void)viewDidLoad {
    
    self.headerRefreshFlag = NO;
    self.footerRefreshFlag = YES;
    self.showNoDataViewFlag = YES;
    self.showNoMoreDataViewFlag = YES;
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addNotify];
    
}

- (void)configUI
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    _headerView.backgroundColor = [UIColor clearColor];
    
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(10, 7, ScreenWidth-20, 38)];
    backgroudView.backgroundColor = [UIColor whiteColor];
    backgroudView.layer.cornerRadius = 4.0f;
    backgroudView.layer.borderWidth = 1.0f;
    backgroudView.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    backgroudView.layer.masksToBounds = YES;
    [_headerView addSubview:backgroudView];
    
    _regionBtn = [[New_HeaderBtn alloc] initWithFrame:CGRectMake(0, 0, 70, 38) withTitle:@"所有" arrCount:0];
    _regionBtn.frame = CGRectMake(0, 0, 70, 38);
    _regionBtn.titleLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _regionBtn.titleImg.image = [UIImage imageNamed:@"img_offer_pulldown.png"];
    _regionBtn.markImg.hidden = YES;
    _regionBtn.delegate = self;
    [backgroudView addSubview:_regionBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(70, 3, 0, 32)];
    lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [backgroudView addSubview:lineView];
    
    _searBar = [[UISearchBar alloc] initWithFrame:CGRectMake(71, 0, backgroudView.frame.size.width-70, 38)];
    _searBar.searchBarStyle = UISearchBarStyleDefault;
    _searBar.backgroundImage = [UIImage new];
    _searBar.barTintColor = [UIColor whiteColor];
    _searBar.placeholder = @"搜索职位或其他关键词";
    _searBar.contentMode = UIViewContentModeLeft;
    _searBar.delegate = self;
    [backgroudView addSubview:_searBar];
    
    self.tableView.tableHeaderView = _headerView;
    
    if (!condictionCtl) {
        condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0, mainTableview.tableHeaderView.frame.size.height, ScreenWidth, self.view.frame.size.height - mainTableview.tableHeaderView.frame.size.height)];
        condictionCtl.delegate_ = self;
    }
    
    
    if (_selectTableTag == 0) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"newOfferRegion"];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        regionModal = array.firstObject;
    }
    else
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldOfferRegion"];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        regionModal = array.firstObject;
    }

    if (!regionModal)
    {
        _regionBtn.titleLb.text = @"全国";
    }
    else
    {
        _regionBtn.titleLb.text = regionModal.str_;
    }
    
}

- (void)configBgView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _bgView.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    // 设置渐变效果
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.bounds = _bgView.bounds;
    _gradientLayer.borderWidth = 0;
    
    _gradientLayer.frame = _bgView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor], nil];
    _gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    
    [_bgView.layer insertSublayer:_gradientLayer atIndex:0];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveBgView)];
    [_bgView addGestureRecognizer:singleTap];
}

- (void)moveBgView
{
    _bgView.hidden = YES;
    if (condictionCtl) {
        [condictionCtl hideView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    _bgView.hidden = YES;
    if (condictionCtl) {
        [condictionCtl hideView];
    }
}

//处理和侧滑返回冲突的（涛兄如果你的项目没有侧滑返回可不写）
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.tableView.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - New_HeaderDelegate
-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender
{
    if (!_bgView) {
        [self configBgView];
    }
    else {
        _bgView.hidden = NO;
    }
    
    [_searBar resignFirstResponder];
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [_regionBtn convertRect: _regionBtn.bounds toView:window];
    NSLog(@"view1 frame: %@", NSStringFromCGRect(rect));
    
    CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:_regionBtn];
    NSLog(@"convertPoint:toView: %@", NSStringFromCGPoint(originInSuperview));
    
    
    CGRect frame = condictionCtl.view.frame;
    frame.origin.y = rect.origin.y + _regionBtn.frame.size.height;
    frame.size.height = self.view.frame.size.height - frame.origin.y;
    condictionCtl.view.frame = frame;
    
    if (condictionCtl.view.superview)
    {
        _bgView.hidden = YES;
        [condictionCtl hideView];
        return;
    }
    
    CondictionList_DataModal *modal;
    if(regionModal)
    {
        modal = regionModal;
    }
    else
    {
        modal = [[CondictionList_DataModal alloc] init];
        modal.str_ = _regionBtn.titleLb.text;
        if ([modal.str_ isEqualToString:@"全国"])
        {
            modal.id_ = @"";
        }
        else
        {
            modal.id_ = [CondictionListCtl getRegionId:_regionBtn.titleLb.text];
        }
    }
    
    [condictionCtl creatViewWithType:OfferPaiRegionChange selectModal:modal];
    [condictionCtl showView];
    
}

#pragma mark - 代理
#pragma mark--UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ELNewOfferListCell";
    ELNewOfferListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        OfferPartyTalentsModel *model = _dataArray[indexPath.row];
        cell.titleLb.text = model.jobfair_name;
        cell.addressLb.text = model.place_name;
        cell.timeLb.text = [NSString stringWithFormat:@"%@  %@", model.jobfair_time, [MyCommon getWeekDay:model.jobfair_time]];
        cell.positionLb.text = model.jobfair_zhiwei;
        
        
        if (model.iscome){//到场
            cell.tagImg.image = [UIImage imageNamed:@"img_offer_signIn.png"];
        }
        else if (model.isjoin) {//报名
            cell.tagImg.image = [UIImage imageNamed:@"img_offer_signUp.png"];
        }
        else{
            cell.tagImg.hidden = YES;
        }
        
        return cell;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 119;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    OfferPartyTalentsModel *selectModel = _dataArray[indexPath.row];
    
    if (_selectTableTag < 2) {
        if ([_searBar isFirstResponder]) {
            [_searBar resignFirstResponder];
            return;
        }
        
        OfferPartyDetailIndexCtl *offerDetailCtl = [[OfferPartyDetailIndexCtl alloc] init];
        offerDetailCtl.offerPartyModel = selectModel;
        offerDetailCtl.resumeComplete = resumeComplete;
        if (selectModel.iscome) {
            offerDetailCtl.isSignUp = YES;
        }
        else
        {
            offerDetailCtl.isSignUp = NO;
        }
        [self.navigationController pushViewController:offerDetailCtl animated:YES];
        [offerDetailCtl beginLoad:nil exParam:nil];
    }
    else
    {
        OfferPartyDetailIndexCtl *offerPartyDetailCtl = [[OfferPartyDetailIndexCtl alloc]init];
        selectModel.isjoin = YES;
        offerPartyDetailCtl.offerPartyModel = selectModel;
        offerPartyDetailCtl.isSignUp = YES;
        [ self.navigationController pushViewController:offerPartyDetailCtl animated:YES];
        [offerPartyDetailCtl beginLoad:nil exParam:nil];
    }
    
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

#pragma mark--changeJobSearchCondictionDelegate
-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    _bgView.hidden = YES;
    regionModal = (CondictionList_DataModal *)dataModel;
    _regionBtn.titleLb.text = regionModal.str_;
    
    NSArray *array = [[NSArray alloc] initWithObjects:regionModal, nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
//    NSArray *data2arry = [NSKeyedUnarchiver unarchiveObjectWithData:arry2data];
    if (_selectTableTag == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"newOfferRegion"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"oldOfferRegion"];
    }
    
    [self refreshLoad];
}

#pragma mark--UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self refreshLoad];
    [_searBar resignFirstResponder];
}

#pragma mark - 通知
-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"goTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"leaveTop" object:nil];
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

//下拉刷新
- (void)loadData:(NSNotification *)notify
{
    NSString *notificationName = notify.name;
    if([notificationName isEqualToString:@"refreshData"]){//下拉刷新
        pullDownRefresh = YES;
    }
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    if (_selectTableTag < 2 && !_headerView) {
        [self configUI];
        [self requestZone];
    }
    [self refreshData:_selectTableTag];
}

- (void)refreshData:(NSInteger)type
{
    if (type < 2) {
        [self requestOfferList:[NSString stringWithFormat:@"%ld", (long)type]];
        if ([Manager shareMgr].haveLogin) {
            [self getResumeComplete];
        }
    }
    else if (type == 2)
    {//已报名
        [self requestSignInOfferData];
    }
}

#pragma mark - 请求数据
//最新 往期
- (void)requestOfferList:(NSString *)type
{
    NSString *op = @"offerpai_busi";
    NSString *func = @"getLatelyJobfairListNew";
    
    NSString *userId;
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }
    else {
        userId = @"";
    }
    
    NSString * regionId = @"";//地区
    if (regionModal) {
        regionId = regionModal.id_;
    }
    else
    {
//        NSString *str = [Manager shareMgr].regionName_;
//        if (!str || [str isEqual:[NSNull null]] || str == nil)
//        {
//            str = @"全国";
//        }
//
//        regionId = [CondictionListCtl getRegionId:str];
        regionId = [CondictionListCtl getRegionId:@"全国"];
    }
    
    NSString *kword = @"";//搜索关键词
    if ([MyCommon removeAllSpace:_searBar.text].length > 0) {
        kword = [MyCommon removeAllSpace:_searBar.text];
    }
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setValue:regionId forKey:@"region"];
    [conditionDic setValue:kword forKey:@"keyword"];
    [conditionDic setObject:userId forKey:@"person_id"];
    [conditionDic setObject:@"offer" forKey:@"fromType"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    
    SBJsonWriter *json = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [json stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"type=%@&conditionArr=%@", type, conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [self parserPageInfo:result];
        
        NSDictionary *data = result;
        NSArray *dataArr = data[@"data"];
        if ([dataArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDic in dataArr) {
                OfferPartyTalentsModel *model = [[OfferPartyTalentsModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
        }
        
        if (_dataArray.count > 0) {
            _isCanLoad = YES;
        }
        
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
        if (pullDownRefresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPullDownRefresh" object:nil userInfo:nil];
            pullDownRefresh = NO;
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
        if (pullDownRefresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPullDownRefresh" object:nil userInfo:nil];
        }
    }];
}

//请求地区
-(void)requestZone{
    
    NSMutableArray * offerRegionArr = [[NSMutableArray alloc] init];
    CondictionList_DataModal *dataModalOne = [[CondictionList_DataModal alloc] init];
    dataModalOne.id_ = @"";
    dataModalOne.str_ = @"全国";
    [offerRegionArr addObject:dataModalOne];
    
    [ELRequest postbodyMsg:@"" op:@"offerpai_busi" func:@"getAllRegionNameArr" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dicOne = result[@"data"];
         for (NSString *key in dicOne)
         {
             NSDictionary *dicTwo = dicOne[key];
             NSString *str = dicTwo[@"regionName"];
             if ([str containsString:@"上海"] || [str containsString:@"北京"] ||[str containsString:@"天津"]  || [str containsString:@"重庆"]) {
                 CondictionList_DataModal *modalOne = [[CondictionList_DataModal alloc] init];
                 modalOne.str_ = dicTwo[@"regionName"];
                 modalOne.id_ = dicTwo[@"regionid"];
                 [offerRegionArr addObject:modalOne];
             }
             else{
                 NSArray *arr = dicOne[key][@"shi"];
                 if ([arr isKindOfClass:[NSArray class]])
                 {
                     for (NSDictionary *subDic in arr)
                     {
                         CondictionList_DataModal *modalOne = [[CondictionList_DataModal alloc] init];
                         modalOne.str_ = subDic[@"regionName"];
                         modalOne.id_ = subDic[@"regionid"];
                         [offerRegionArr addObject:modalOne];
                     }
                 }
             }
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"offerPaiZoneSel" object:@(1) userInfo:@{@"offerPaiZone" : offerRegionArr}];
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

//已报名
- (void)requestSignInOfferData
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    
    NSString * function = @"getJobfairListByPersonId";
    NSString * op = @"offerpai_busi";
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"offer" forKey:@"offer"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page_index"];
    
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"personid=%@&conditionArr=%@&", userId, conDicStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [self parserPageInfo:result];
        
        NSDictionary *dic = result;
        NSArray *dataArr = dic[@"data"];
        if ([dataArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDic in dataArr) {
                OfferPartyTalentsModel *model = [[OfferPartyTalentsModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
        }
        
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
        if (pullDownRefresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPullDownRefresh" object:nil userInfo:nil];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
        if (pullDownRefresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPullDownRefresh" object:nil userInfo:nil];
        }
    }];
    
}

//检测简历是否完善
- (void)getResumeComplete
{
    NSString * function = @"getResumeCompleteInfo";
    NSString * op = @"person_info_busi";
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@", [Manager getUserInfo].userId_];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        ResumeCompleteModel *model = [[ResumeCompleteModel alloc]init];
        model.basic_ = [dic objectForKey:@"basic"]; //基本资料 2完善 1不完善
        model.edu_ = [dic objectForKey:@"edus"];   //教育背景 2完善 1不完善
        model.work_ = [dic objectForKey:@"work"];  //工作经历 2完善 1不完善
        
        if ([model.basic_ isEqualToString:@"2"] && [model.edu_ isEqualToString:@"2"] && [model.work_ isEqualToString:@"2"])
        {
            resumeComplete = YES;
        }
        else
        {
            resumeComplete = NO;
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        
    }];
}

-(void)dealloc{
    [_bgView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
