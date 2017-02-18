//
//  BaseListCtl.m
//  Template
//
//  Created by sysweal on 13-9-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "BaseListCtl.h"
#import "MessageCenterList.h"
#import "MyJobSearchCtl.h"
#import "TodayFocusListCtl.h"
#import "MyManagermentCenterCtl.h"
#import "ELMyGroupCenterCtl.h"
@interface BaseListCtl ()<UIGestureRecognizerDelegate>

@end

@implementation BaseListCtl
@synthesize noMoreDataCtl_,isChangeNoMoreData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNewMesageAction:) name:@"TIPSNEWMESAGE" object:nil];
        //默认只有上拉刷新
        bHeaderEgo_ = YES;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    isChangeNoMoreData = NO;
    
    baseTipsView_ = [[UIView alloc] initWithFrame:CGRectMake(0, -64, ScreenWidth, 40)];
    baseTipsView_.backgroundColor = [UIColor clearColor];

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [bgView setBackgroundColor:UIColorFromRGB(0xfff0b4)];
    [bgView setAlpha:0.8];
    [baseTipsView_ addSubview:bgView];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:15]];
    [label setText:@"又有新动静～点击查看！"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor redColor]];
    [baseTipsView_ addSubview:label];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    button.backgroundColor = [UIColor clearColor];
    [baseTipsView_ addSubview:button];
    [button addTarget:self action:@selector(tipsMsgClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:baseTipsView_];
    [baseTipsView_ setHidden:YES];
    
    tableView_.delegate = self;
    tableView_.dataSource = self;
    //[self followScrollView:tableView_];
    //set ego refresh att
	if( bHeaderEgo_ ){
		CGRect rect = CGRectMake(0.0f, -tableView_.bounds.origin.y - tableView_.bounds.size.height,ScreenWidth, tableView_.bounds.size.height);
		refreshHeaderView_ = [[EGORefreshTableView alloc] initWithFrame:rect pos:EGORefreshHeader];
		refreshHeaderView_.delegate = self;
		[tableView_ addSubview:refreshHeaderView_];
		
		[refreshHeaderView_ refreshLastUpdatedDate];
	}
}


-(void)showHeaderView:(BOOL)show
{
    if (show && refreshHeaderView_) {
        return;
    }
    [refreshHeaderView_ removeFromSuperview];
    refreshHeaderView_ = nil;
    if (show)
    {
        CGRect rect = CGRectMake(0.0f, -tableView_.bounds.origin.y - tableView_.bounds.size.height, ScreenWidth, tableView_.bounds.size.height);
        refreshHeaderView_ = [[EGORefreshTableView alloc] initWithFrame:rect pos:EGORefreshHeader];
        refreshHeaderView_.delegate = self;
        [tableView_ addSubview:refreshHeaderView_];
        
        [refreshHeaderView_ refreshLastUpdatedDate];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if ([self isKindOfClass:[MessageCenterList class]] || [self isKindOfClass:[MyJobSearchCtl class]] ||[self isKindOfClass:[TodayFocusListCtl class]] ||[self isKindOfClass:[MyManagermentCenterCtl class]] ||[self isKindOfClass:[ELMyGroupCenterCtl class]])
//    {
//        self.tabBarController.tabBar.hidden = NO;
//    }
//    else{
//        self.tabBarController.tabBar.hidden = YES;
//    }
    
    if (requestCon_ && ([requestCon_.dataArr_  count] == 0 || shouldRefresh_) ) {
        [self refreshLoad:nil];
        shouldRefresh_ = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![Manager shareMgr].isFromMessage_) {
        [requestCon_ stopConnWhenBack];
        
    }
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
}

- (void)startLoop
{
    [NSThread detachNewThreadSelector:@selector(loopMethod) toTarget:self withObject:nil];
}


- (void)loopMethod
{
    [NSTimer scheduledTimerWithTimeInterval:8.0f target:self selector:@selector(setTipsViewHidden) userInfo:nil repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}

- (void)setTipsViewHidden
{
    [UIView animateWithDuration:0.5 animations:^{
        [baseTipsView_ setFrame:CGRectMake(0, -64, ScreenWidth, 40)];
    } completion:^(BOOL finished) {
        [baseTipsView_ setHidden:YES];
    }];
    [Manager shareMgr].showTipsViewFlag = NO;
}

-(void)reciveNewMesageAction:(NSNotificationCenter *)notifcation
{
    if (self.view.window) {
        if ([Manager shareMgr].showTipsViewFlag) {
            [baseTipsView_ setHidden:NO];
            [UIView animateWithDuration:0.5 animations:^{
                [baseTipsView_ setFrame:CGRectMake(0, 0, ScreenWidth, 40)];
            }];
        }
        double delayInSeconds = 8.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self delayMethod]; });
    }
}

- (void)delayMethod
{
    [UIView animateWithDuration:0.5 animations:^{
         [baseTipsView_ setFrame:CGRectMake(0, -64, ScreenWidth, 40)];
    } completion:^(BOOL finished) {
        [baseTipsView_ setHidden:YES];
        [Manager shareMgr].showTipsViewFlag = NO;
    }];
}

- (void)tipsMsgClick
{
    NSLog(@"点击tipsMsgClick");
    [UIView animateWithDuration:0.5 animations:^{
        [baseTipsView_ setFrame:CGRectMake(0, -64, ScreenWidth, 40)];
    }];
    [baseTipsView_ setHidden:YES];
    [Manager shareMgr].showTipsViewFlag = NO;
    
    if (![Manager shareMgr].sysNotificationCtl_) {
        [Manager shareMgr].sysNotificationCtl_ = [[SystemNotificationCtl alloc] init];
    }
    [self.navigationController pushViewController:[Manager shareMgr].sysNotificationCtl_ animated:NO];
    [[Manager shareMgr].sysNotificationCtl_ beginLoad:nil exParam:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(RequestCon *) getNewRequestCon:(BOOL)bDefault
{
    RequestCon *con = [super getNewRequestCon:bDefault];
    
    //让请求具有存放数据的能力
    if( con && con == requestCon_ ){
        con.storeType_ = TempStoreType;
        [con initPageInfo];
    }
    return con;
}

-(UIView *) getErrorSuperView
{
    return tableView_;
}

-(UIView *) getLoadingSuperView
{
    return tableView_;
}

//获取没有更多数据视图的父视图
-(UIView *) getNoMoreDataSuperView
{
    return tableView_;
}

//show/hide have more page
-(void) showFooterRefreshView:(BOOL)flag
{
    [refreshFooterView_ removeFromSuperview];
	refreshFooterView_ = nil;
	
	if( flag && bFooterEgo_ ){
		float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
		CGRect rect = CGRectMake(0.0f, height,ScreenWidth, tableView_.bounds.size.height);
		refreshFooterView_ = [[EGORefreshTableView alloc] initWithFrame:rect pos:EGORefreshFooter];
		refreshFooterView_.delegate = self;
		[tableView_ addSubview:refreshFooterView_];
		
		[refreshFooterView_ refreshLastUpdatedDate];
	}
}

- (void)adjustFooterViewFrame
{
    if (refreshFooterView_) {
        float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
        CGRect rect = CGRectMake(0.0f, height,ScreenWidth, tableView_.bounds.size.height);
        refreshFooterView_.frame = rect;
    }
    if (noMoreDataCtl_) {
        float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
        float x = (int)((tableView_.frame.size.width-noMoreDataCtl_.view.frame.size.width)/2.0);
        CGRect rect = CGRectMake(x, height, ScreenWidth, tableView_.bounds.size.height);
        [noMoreDataCtl_.view setFrame:rect];
    }
}

//show/hide no more data
-(void) showNoMoreDataView:(BOOL)flag
{
	if( flag && bFooterEgo_ ){
		UIView *superView = [self getNoMoreDataSuperView];
		
		if( superView ){
			if( !noMoreDataCtl_ ){
				noMoreDataCtl_ = [[NoMoreDataCtl alloc] init];
			}
			
			[noMoreDataCtl_.view removeFromSuperview];
			[superView addSubview:noMoreDataCtl_.view];
            noMoreDataCtl_.view.backgroundColor = [UIColor clearColor];
            
            if (isChangeNoMoreData == YES) {
                [noMoreDataCtl_.view removeFromSuperview];
                CGSize frame = tableView_.contentSize;
                frame.height = tableView_.contentSize.height - 60;
                tableView_.contentSize = frame;
                isChangeNoMoreData = NO;
                return;
            }
            
			//set the rect
            float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
            float x = (int)((tableView_.frame.size.width-noMoreDataCtl_.view.frame.size.width)/2.0);
            CGRect rect = CGRectMake(x, height, ScreenWidth, tableView_.bounds.size.height);
			[noMoreDataCtl_.view setFrame:rect];
            noMoreDataCtl_.view.center = CGPointMake(ScreenWidth/2.0,noMoreDataCtl_.view.center.y);
		}else{
            [MyLog Log:@"Couldn't Set NoMoreDataCtl's View,NoMoreDataCtl's super view is null" obj:self];
		}
	}else
	{
		[noMoreDataCtl_.view removeFromSuperview];
		noMoreDataCtl_ = nil;
	}
}

//获取没有数据时的视图所显示的父视图
-(UIView *) getNoDataSuperView
{
    return tableView_;
}

//获取没有数据时的视图
-(UIView *) getNoDataView
{
    if( !noDataOkCtl_ ){
        noDataOkCtl_ = [[NoDataOkCtl alloc] initWithNibName:@"NoDataOkCtl" bundle:nil];
    }
    
    if (_noDataTips) {//提示信息
        noDataOkCtl_.txtLb_.text = _noDataTips;
    }
    
    if (_noDataImgStr) {//提示图片
        noDataOkCtl_.imageView_.image = [UIImage imageNamed:_noDataImgStr];
    }
    
    if (_imgTopSpace) {//提示图片与定部距离
        noDataOkCtl_.imageTopSpace.constant = _imgTopSpace;
    }
    
    return noDataOkCtl_.view;
}

//show/hide no data but load ok view
- (void) showNoDataOkView:(BOOL)flag
{
    [MyLog Log:[NSString stringWithFormat:@"showNoDataOkView flag=%d",flag] obj:self];
    
    if( flag && !_noShowNoDataView){
        UIView *noDataOkSuperView = [self getNoDataSuperView];
        UIView *noDataOkView = [self getNoDataView];
        if(noDataOkSuperView && noDataOkView ){
            [noDataOkSuperView addSubview:noDataOkView];
            
            //set the rect
            CGRect rect = noDataOkView.frame;
            if (_noDataViewStartY >0 && _noDataViewStartY < ScreenHeight) {
                rect.origin.y = _noDataViewStartY;
            }else{
                rect.origin.y = 0;
            }
            rect.origin.x = 0;
            [noDataOkView setFrame:rect];
        }else{
            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
        }
    }else{
        [[self getNoDataView] removeFromSuperview];
    }
}

//重写父类的显示正在加载视图方法
-(void) showLoadingView:(BOOL)flag
{
    //如果没有上拉刷新，则采用父类的显示加载视图方法
    if( !bHeaderEgo_ ){
        [super showLoadingView:flag];
    }else{
        if( flag )
            [refreshHeaderView_ showHeaderLoading:tableView_];
    }
}


//重写父类的显示异常视图
-(void) showErrorView:(BOOL)flag
{
    [super showErrorView:flag];
    
    if( flag ){
        //让异常视图动态的消失
        UIView *myView = [self getErrorView];
        myView.alpha = 1.0;
        
        if( [requestCon_.dataArr_ count] > 0 ){
            //不提供重新加载功能
            [ELRequest sharedELRequest];
            myView.alpha = 0.0;
            [[self getErrorView] removeFromSuperview];
        }else{
            //提供重新加载功能
//            [[self getErrorView] removeFromSuperview];
        }
    }
}


//解析分页信息
-(PageInfo *)parserPageInfo:(NSDictionary *)dic
{
    PageInfo *pageInfo = [[PageInfo alloc] init];
    @try {
        dic = [dic objectForKey:@"pageparam"];
        pageInfo.pageCnt_ = [[dic objectForKey:@"pages"] intValue];
        pageInfo.totalCnt_ = [[dic objectForKey:@"sums"] intValue];
        if(![dic objectForKey:@"pages"])
        {
            pageInfo.pageCnt_ = pageInfo.totalCnt_/10.0 ;
        }
        
    }
    @catch (NSException *exception) {
        [MyLog Log:@"parser pageInfo error!!!" obj:self];
    }
    @finally {
        
    }
    
    return pageInfo;
}

-(void) updateLoadingCom:(RequestCon *)con
{
    [super updateLoadingCom:con];
    
    if( (!con || con == requestCon_) && requestCon_ ){
        [self showFooterRefreshView:NO];
        [self showNoMoreDataView:NO];
        [self showNoDataOkView:NO];
        
        switch ( con.loadStats_ ) {
            case FinishLoad:    //逻辑与ErrorLoad相似，不过还要处理没有数据的情况，所以不用break
                //如果数据为空
                if( [requestCon_.dataArr_ count] == 0 ){
                    //显示没有数据的提示信息
                    [self showNoDataOkView:YES];
                }
                
                if (!_reloadDateFlag) {
                    [tableView_ reloadData];
                }
                //刷新一下列表数据
//                break;
            case ErrorLoad:
                //判断是否需要显示没有更多数据
                if( [requestCon_.dataArr_ count] > 0 ){
                    if( requestCon_.pageInfo_.currentPage_ > requestCon_.pageInfo_.pageCnt_ ){
                        [self showNoMoreDataView:YES];
                    }
                    //还有更多数据
                    else{
                        [self showFooterRefreshView:YES];
                    }
                }
                break;
            case InLoadMore:
                [self showFooterRefreshView:YES];
                //[refreshFooterView_ showFooterLoading:tableView_];
                
//                //刷新一下列表数据
//                [tableView_ reloadData];
                break;
            default:
                break;
        }
    }
}

-(void) startLoad:(RequestCon *)con
{
    if( con && con == requestCon_ && [con canGetData] ){
        [con resetPageInfo];
    }
    
    [super startLoad:con];
}

-(void) refreshLoad:(RequestCon *)con
{
    //将请求的分页初始化一次
    [con resetPageInfo];
    [super refreshLoad:con];
}

//加载更多
-(void) loadMoreData:(RequestCon *)con
{
    con.delegate_ = self;
    [con setFresh:YES];
    [self getDataFunction:con];
    [con setFresh:NO];
}

//load detail
-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [MyLog Log:[NSString stringWithFormat:@"loadDetail section=%ld row=%ld",(long)[indexPath section],(long)[indexPath row]] obj:self];

    //do what you want to do
}

#pragma mark - LoadDataDelegate
-(void) dataChanged:(RequestCon *)con
{
    [super dataChanged:con];
    
    if( con == requestCon_ ){
        //[tableView_ reloadData];
    }
}

-(void) loadDataComplete:(RequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr requestType:(int)type
{
    [super loadDataComplete:con code:code dataArr:dataArr requestType:type];

    if( con != nil ){
        if( !con.bLoadMore_ ){
            [self doneLoadingTableViewData:refreshHeaderView_];
        }else{
            [self doneLoadingTableViewData:refreshFooterView_];
        }
    }
}

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger cnt = 0;
    @try {
        cnt = [requestCon_.dataArr_ count];
    }
    @catch (NSException *exception) {
        cnt = 0;
        
        [MyLog Log:@"tableView get cnt error!!!" obj:self];
    }
    @finally {
        [MyLog Log:[NSString stringWithFormat:@"tableView's data cnt = %ld",(long)cnt] obj:self];
    }
    
    return cnt;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id selectModal = nil;
    @try {
        if (requestCon_.dataArr_.count > indexPath.row) {
            selectModal = [requestCon_.dataArr_ objectAtIndex:[indexPath row]];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    @try {
        [self loadDetail:selectModal exParam:nil indexPath:indexPath];
    }
    @catch (NSException *exception) {
        [MyLog Log:@"loadDetail error!!!" obj:self];
    }
    @finally {
        
    }
    
}

#pragma EGO
#pragma mark –
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource:(EGORefreshTableView *)egoView
{
	if( egoView == refreshHeaderView_ ){
        [MyLog Log:@"header refresh" obj:self];
		
        //refresh data
        [self refreshLoad:requestCon_];
	}else if( egoView == refreshFooterView_ ){
        [MyLog Log:@"foot load" obj:self];
		
        //load more
        [self loadMoreData:requestCon_];
	}else{
        [MyLog Log:@"null refresh" obj:self];
	}
}

- (void)doneLoadingTableViewData:(EGORefreshTableView *)egoView
{
    [MyLog Log:@"ego done" obj:self];
	
	[egoView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (refreshHeaderView_.state == ELEGOOPullRefreshLoading || refreshFooterView_.state == ELEGOOPullRefreshLoading) {
        return;
    }
    [refreshHeaderView_ egoRefreshScrollViewDidScroll:scrollView];
	[refreshFooterView_ egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (refreshHeaderView_.state == ELEGOOPullRefreshLoading || refreshFooterView_.state == ELEGOOPullRefreshLoading) {
        return;
    }
	[refreshHeaderView_ egoRefreshScrollViewDidEndDragging:scrollView];
	[refreshFooterView_ egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark –
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshTableView*)view
{
    [self performSelector:@selector(reloadTableViewDataSource:) withObject:view afterDelay:0.1];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(EGORefreshTableView*)view
{
    return [view isLoading];
    return NO;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(EGORefreshTableView*)view
{
    return [NSDate date];     
}

@end
