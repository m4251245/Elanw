//
//  BaseList2.m
//  jobClient
//
//  Created by 一览ios on 15/8/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"


@interface ELBaseListCtl ()<UIGestureRecognizerDelegate>
{
    UIView  *noDataView;
    UIView  *tipsNoDataView;
    
    BOOL isMoveArr;
}
@end

@implementation ELBaseListCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _headerRefreshFlag = YES;
        _footerRefreshFlag = YES;
        _showNoDataViewFlag = YES;
        _showNoMoreDataViewFlag = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tabBarController.tabBar.hidden = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    if (_headerRefreshFlag) {
        [self createHeaderView];
    }
    
    if (!_pageInfo) {
        _pageInfo = [[PageInfo alloc] init];
    }
    
    
    if (!_noRefershLoadData)
    {
        [self showRefreshHeader:YES];
    }
    
    NSLog(@"\n当前页面：%@",[NSString stringWithUTF8String:object_getClassName(self)]);
}

-(void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

-(void)getSubclass
{
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL,0);
    
    if (numClasses >0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            if (class_getSuperclass(classes[i]) == [ELBaseListCtl class]){
                NSLog(@"%@===%@",classes[i], NSStringFromClass(classes[i]));
            }
        }
        free(classes);
    }
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    if (tipsNoDataView) {
        [tipsNoDataView removeFromSuperview];
        tipsNoDataView = nil;
    }
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    if (!_pageInfo) {
        _pageInfo = [[PageInfo alloc] init];
    }
}

- (void)refreshLoad
{
    [self refreshDataSource];
    [self showRefreshHeader:YES];
}

//解析分页信息
-(void)parserPageInfo:(NSDictionary *)dic
{
    if (isMoveArr) {
        [_dataArray removeAllObjects];
        isMoveArr = NO;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *subDic = [dic objectForKey:@"pageparam"];
    ELPageInfo *pageInfo = [[ELPageInfo alloc] initWithDic:subDic];
    _pageInfo.pageCnt_ = [pageInfo.pages intValue];
    _pageInfo.totalCnt_ = [pageInfo.sums intValue];
    
    if([pageInfo.pages isKindOfClass:[NSString class]])
    {
        if([pageInfo.pages isEqualToString:@""]){
            _pageInfo.pageCnt_ = 0;
        }
    }
    if(!pageInfo.pages){
        _pageInfo.pageCnt_ = 0;
    }
    
    if (_pageInfo.totalCnt_ == 0)
    {//没有任何数据
        _pageInfo.lastPageFlag = YES;
        [self showRefreshNoDateView:YES];
    }
    else
    {
        [self showRefreshNoDateView:NO];
        //currentPage_ 从0开始
        BOOL lastPage = NO;
        if ([pageInfo.pages intValue] == [pageInfo.page intValue]) {
            lastPage = YES;
        }
        if (self.pageInfo.currentPage_ >= self.pageInfo.pageCnt_ || lastPage || self.pageInfo.pageCnt_ == 0) {//最后一页
            _pageInfo.lastPageFlag = YES;
            _refreshFooterView.hidden = YES;
            //显示没有更多数据
            [self showNoMoreDataView:YES];
        }
        else{
            _pageInfo.lastPageFlag = NO;
        }
        self.pageInfo.currentPage_ += 1;
    }
    //    [self finishReloadingData];
}

-(void)showRefreshNoDateView:(BOOL) flag
{
    if (flag) {
        if (!tipsNoDataView && _showNoDataViewFlag) {
            CGRect headerViewRect = _tableView.tableHeaderView.frame;
            tipsNoDataView = [[UIView alloc] init];
            tipsNoDataView.frame = CGRectMake(0, headerViewRect.size.height, _tableView.frame.size.width, _tableView.frame.size.height - headerViewRect.size.height);
            [tipsNoDataView setBackgroundColor:UIColorFromRGB(0xffffff)];
            
            if (!_noDataTopSpace) {
                _noDataTopSpace = 80;
            }
            UIImageView *imagevv = [[UIImageView alloc] initWithFrame:CGRectMake((tipsNoDataView.frame.size.width - 213)/2, _noDataTopSpace, 213, 179)];
            if (_noDataImgStr) {
                [imagevv setImage:[UIImage imageNamed:_noDataImgStr]];
            }
            else
            {
                [imagevv setImage:[UIImage imageNamed:@"img_noData.png"]];
            }
            
            UILabel *tipsLb = [[UILabel alloc] initWithFrame:CGRectMake(10, imagevv.frame.size.height + imagevv.frame.origin.y + 10, _tableView.frame.size.width - 20, 21)];
            if (_noDataString) {
                [tipsLb setText:_noDataString];
            }else{
                [tipsLb setText:@"没有请求到数据哦!请下拉试试!"];
            }
            tipsLb.textAlignment = NSTextAlignmentCenter;
            tipsLb.font = [UIFont fontWithName:@"Helvetica-Regular" size:14];
            tipsLb.textColor = UIColorFromRGB(0xbbbbbb);
            [tipsNoDataView addSubview:tipsLb];
            [tipsNoDataView addSubview:imagevv];
            [_tableView addSubview:tipsNoDataView];
        }
    }
    else{
        if (tipsNoDataView) {
            [tipsNoDataView removeFromSuperview];
            tipsNoDataView = nil;
        }
    }
}

- (IBAction)btnResponse:(id)sender {
}

#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     ScreenWidth, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
    [_tableView bringSubviewToFront:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}


-(void)setFooterView{
    CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
    if (_refreshFooterView) {
        _refreshFooterView.hidden = NO;
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              ScreenWidth,
                                              self.view.bounds.size.height);
    }else {
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         ScreenWidth, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_tableView addSubview:_refreshFooterView];
        [_tableView bringSubviewToFront:_refreshFooterView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}


#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(ELEGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    // overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    }
    if (_footerRefreshFlag && !_pageInfo.lastPageFlag) {
        [self setFooterView];
    }
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_refreshHeaderView.state == ELEGOOPullRefreshLoading || _refreshFooterView.state == ELEGOOPullRefreshLoading) {
        return;
    }
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView && !_pageInfo.lastPageFlag) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_refreshHeaderView.state == ELEGOOPullRefreshLoading || _refreshFooterView.state == ELEGOOPullRefreshLoading) {
        return;
    }
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (_refreshFooterView && !_pageInfo.lastPageFlag) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(ELEGORefreshPos)aRefreshPos{
//    [self beginToReloadData:aRefreshPos];
    if (aRefreshPos == ELEGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshDataSource) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == ELEGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:0.1];
    }
}

#pragma mark 刷新数据
-(void)refreshDataSource{
//    [_dataArray removeAllObjects];
     isMoveArr = YES;
    _pageInfo.currentPage_ = 0;
    [self beginLoad:nil exParam:nil];
    [self showNoMoreDataView:NO];
}

- (void)adjustFooterViewFrame
{
    if (noDataView) {
        float height = _tableView.contentSize.height > _tableView.bounds.size.height ? _tableView.contentSize.height : _tableView.bounds.size.height;
        noDataView.frame = CGRectMake(0, height, [UIScreen mainScreen].bounds.size.width, 40);
    }else if (_refreshFooterView) {
        float height = _tableView.contentSize.height > _tableView.bounds.size.height ? _tableView.contentSize.height : _tableView.bounds.size.height;
        CGRect rect = CGRectMake(0.0f, height,ScreenWidth, _tableView.bounds.size.height);
        _refreshFooterView.frame = rect;
    }
}

#pragma mark 加载更多数据
-(void)loadMoreData{

    if([_dataArray count] > 0){
//        if(self.pageInfo.currentPage_ >= self.pageInfo.pageCnt_){//最后一页
//            [self finishReloadingData];
//            [self showNoMoreDataView:YES];
//        }else{
            [self beginLoad:nil exParam:nil]; // 加载更多数据
            [self showNoMoreDataView:NO];
//        }
    }
    else
    {
        [self finishReloadingData];
    }
}

#pragma mark 显示没有更多数据
-(void)showNoMoreDataView:(BOOL)flag
{
    if (flag && _showNoMoreDataViewFlag) {
        if (noDataView == nil) {
            float height = _tableView.contentSize.height > _tableView.bounds.size.height ? _tableView.contentSize.height : _tableView.bounds.size.height;
            noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, height, [UIScreen mainScreen].bounds.size.width, 40)];
            noDataView.backgroundColor = [UIColor  clearColor];
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 30)];
            [lb setText:@"没有更多数据了哦"];
            [lb setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13]];
            [lb setTextAlignment:NSTextAlignmentCenter];
            [lb setTextColor:[UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0]];
            [lb setBackgroundColor:[UIColor clearColor]];
            [noDataView addSubview:lb];
            noDataView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            [_tableView addSubview:noDataView];
        }
    }else{
        if (noDataView != nil) {
            [noDataView removeFromSuperview];
            noDataView = nil;
        }
    }
}


- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
    if (!_refreshHeaderView) {
        return;
    }
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [self.tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
    }
    else
    {
        self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [self.tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    }
    
    [_refreshHeaderView setState:ELEGOOPullRefreshLoading];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)loadDataScource
{

}

- (NSString *)getPageQueryStr:(NSInteger)pageSize
{
    return [NSString stringWithFormat:@"{\"page\":\"%ld\",\"page_size\":\"%@\"}", (long)_pageInfo.currentPage_, pageParams];
}

-(void)refreshEGORefreshView
{
    if (_dataArray.count <= 0) {//没有任何数据
        self.pageInfo.lastPageFlag = YES;
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
        {//有网络
            [self showRefreshNoDateView:YES];
        }
        else
        {
            [self removeFooterView];
        }
    }
    else
    {
        [self showNoNetworkView:NO];
        [self showRefreshNoDateView:NO];
        [self showNoMoreDataView:NO];
        //currentPage_ 从0开始
        if (self.pageInfo.currentPage_ >= self.pageInfo.pageCnt_ && _pageInfo.lastPageFlag)
        {//最后一页
            self.pageInfo.lastPageFlag = YES;
            _refreshFooterView.hidden = YES;
            [self showNoMoreDataView:YES];
        }
        else{
            self.pageInfo.lastPageFlag = NO;
            [self setFooterView];
        }
    }
}

- (UIView *)getSuperView
{
    return self.tableView;
}

- (void)showNoNetworkView:(BOOL)flag
{
    if (flag) {
        UIView *superView = [self getSuperView];
        UIView *myView = [self getNoNetworkView];
        
        if( superView && myView ){
            [myView removeFromSuperview];
            [superView addSubview:myView];
            
            //set the rect
            CGRect rect = myView.frame;
            rect.origin.x = 0;
            rect.origin.y = 0;
            [myView setFrame:rect];
        }
    }
    else
    {
        [[self getNoNetworkView] removeFromSuperview];
    }
}


@end
