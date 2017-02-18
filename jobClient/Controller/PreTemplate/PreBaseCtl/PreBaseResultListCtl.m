//
//  PreBaseResultListCtl.m
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PreBaseResultListCtl.h"


@implementation PreBaseResultListCtl

@synthesize tableView_,noDataOkView_,noDataOkLb_,resultArr_,pageInfo_;

-(id) init
{
    self = [super init];
    
	return self;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    bHeaderEgo_ = YES;
	bFooterEgo_ = YES;
	
    resultArr_ = [[NSMutableArray alloc] init];
    pageInfo_ = [[PageInfo alloc] init];
    prePageInfo_ = [[PageInfo alloc] init];
    
    return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    //如果存在编辑模式
    if( bHaveEditMode_ ){
        bEditMode_ = NO;
        
        rightBarItemStr_ = @"编辑";
    }
    
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//set delegate
	tableView_.delegate = self;
	tableView_.dataSource = self;
    
	//set ego refresh att
	if( bHeaderEgo_ ){
		CGRect rect = CGRectMake(0.0f, -tableView_.bounds.origin.y - tableView_.bounds.size.height, tableView_.frame.size.width, tableView_.bounds.size.height);
		//CGRect rect = CGRectMake(0.0f, -tableView_.bounds.origin.y + tableView_.bounds.size.height, tableView_.frame.size.width, tableView_.bounds.size.height);
        if( !refreshHeaderView_ ){
            refreshHeaderView_ = [[EGORefreshTableView alloc] initWithFrame:rect pos:EGORefreshHeader];
            refreshHeaderView_.delegate = self;
        }
        
        [tableView_ addSubview:refreshHeaderView_];
		[refreshHeaderView_ refreshLastUpdatedDate];
	}

    //change the no data view's rect
    if( noDataOkView_ ){
        [tableView_ addSubview:noDataOkView_];
    }
    
    CGRect rect = noDataOkView_.frame;
    rect.origin.x = (int)((tableView_.frame.size.width - noDataOkView_.frame.size.width)/2.0);
    rect.origin.y = (int)((tableView_.frame.size.height - 100 - noDataOkView_.frame.size.height)/2.0);
    [noDataOkView_ setFrame:rect];
    
    //[self beginLoad:nil exParam:nil];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	[super viewDidUnload];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [resultArr_ count];
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
    
    @try {
        [self loadDetail:[resultArr_ objectAtIndex:[indexPath row]] exParam:nil indexPath:indexPath];
    }
    @catch (NSException *exception) {
        NSLog(@"[%@] : load detail error!",[self class]);
    }
    @finally {
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return bEditMode_;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        @try {
            //删除
            selectIndexPath_ = indexPath;
            [self deleteCell:[resultArr_ objectAtIndex:[indexPath row]] exParam:nil indexPath:indexPath];
            [tableView_ endUpdates];
        }
        @catch (NSException *exception) {
            [PreBaseUIViewController showAlertView:nil msg:@"未知异常,请刷新列表数据" btnTitle:@"关闭"];
        }
        @finally {
            
        }
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//show/hide have more page
-(void) showFooterRefreshView:(BOOL)flag
{
	[refreshFooterView_ removeFromSuperview];
	refreshFooterView_ = nil;
	
	if( flag && bFooterEgo_ ){
		float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
		CGRect rect = CGRectMake(0.0f, height, tableView_.frame.size.width, tableView_.bounds.size.height);
		refreshFooterView_ = [[EGORefreshTableView alloc] initWithFrame:rect pos:EGORefreshFooter];
		refreshFooterView_.delegate = self;
		[tableView_ addSubview:refreshFooterView_];
		
		[refreshFooterView_ refreshLastUpdatedDate];
	}
}

//show/hide no more data
-(void) showNoMoreDataView:(BOOL)flag
{    
	if( flag && bFooterEgo_ ){
		UIView *superView = tableView_;
		
		if( superView ){
			if( !noMoreDataCtl_ ){
				noMoreDataCtl_ = [[NoMoreDataCtl alloc] init];
			}
			
			[noMoreDataCtl_.view removeFromSuperview];
			[superView addSubview:noMoreDataCtl_.view];
			
			//set the rect
            float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
            CGRect rect = CGRectMake(0.0f, height, tableView_.frame.size.width, tableView_.bounds.size.height);
			[noMoreDataCtl_.view setFrame:rect];
		}else{
			NSLog(@"[%@] : Couldn't Set NoMoreDataCtl's View,tableView_ is null",[self class]);
		}
	}else
	{
		[noMoreDataCtl_.view removeFromSuperview];
		noMoreDataCtl_ = nil;
	}
}

//show/hide error load
-(void) showErrorLoadView:(BOOL)flag
{    
    int seconds = 3.0;
    if( flag ){
        //不需要显示,视图被release了
        if( !self.view ){
            return;
        }
        
        if( !errorLoadCtl_ ){
            errorLoadCtl_ = [[ErrorLoadCtl alloc] init];
        }
        
        [self.view addSubview:errorLoadCtl_.view];
        errorLoadCtl_.view.alpha = 1.0;
        errorLoadCtl_.textLb_.text = [ErrorInfo getErrorMsg:errorCode_];
        
        CGRect rect = errorLoadCtl_.view.frame;
        rect.origin.x = (int)((tableView_.frame.size.width - rect.size.width)/2.0);
        rect.origin.y = (int)((tableView_.frame.size.height - rect.size.height)/2.0);
        [errorLoadCtl_.view setFrame:rect];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:seconds];
        errorLoadCtl_.view.alpha = 0.0;
        [UIView commitAnimations];
        
        //已经显示
        bHaveShowErrorLoad_ = YES;
    }else
    {
        [errorLoadCtl_.view removeFromSuperview];
        errorLoadCtl_ = nil;
    }
}

-(UIView *) getNoDataErrorSuperView
{
	return tableView_;
}

-(UIView *) getInReloadSuperView
{
    if( !bHeaderEgo_ ){
        return tableView_;
    }else
        return nil;
}

//update com info
-(void) updateComInfo:(PreRequestCon *)con
{
	[super updateComInfo:con];
	
    if( !con ){
        tableView_.delegate = self;
        tableView_.dataSource = self;
        [tableView_ reloadData];
    }
    
    if( !con || con == PreRequestCon_ ){
        noDataOkView_.alpha = 0.0;
        tableView_.alpha = 1.0;
        [self showFooterRefreshView:NO];
        [self showNoMoreDataView:NO];
        
        if( loadStats_ == FinishLoad ){
            if( [resultArr_ count] == 0 ){
                noDataOkView_.alpha = 1.0;
                if( noDataOkText_ ){
                    noDataOkLb_.text = noDataOkText_;
                }
                tableView_.alpha = 1.0;
            }else {
                //no more page
                if( pageInfo_.currentPage_ > pageInfo_.pageCnt_ || pageInfo_.pageCnt_ == 0 ){
                    [self showNoMoreDataView:YES];
                }
                //have more page
                else{
                    [self showFooterRefreshView:YES];
                }
            }
        }else if( loadStats_ == InReload ){
            //set ego refresh att
            if( bHeaderEgo_ && tableView_ ){
                CGRect rect = CGRectMake(0.0f, -tableView_.bounds.origin.y - tableView_.bounds.size.height, tableView_.frame.size.width, tableView_.bounds.size.height);
                //CGRect rect = CGRectMake(0.0f, -tableView_.bounds.origin.y + tableView_.bounds.size.height, tableView_.frame.size.width, tableView_.bounds.size.height);
                if( !refreshHeaderView_ ){
                    refreshHeaderView_ = [[EGORefreshTableView alloc] initWithFrame:rect pos:EGORefreshHeader];
                    refreshHeaderView_.delegate = self;
                    
                    [tableView_ addSubview:refreshHeaderView_];
                    [refreshHeaderView_ refreshLastUpdatedDate];
                }
            }
            
            [refreshHeaderView_ showHeaderLoading:tableView_];
        }else if( loadStats_ == InLoadMore ){
            //show footer loading view
            [self showFooterRefreshView:YES];
            [refreshFooterView_ showFooterLoading:tableView_];
        }else if( loadStats_ == ErrorLoad ){
            //have data
            if( [resultArr_ count] > 0 ){
                //don't show no data error view
                [self showNoDataErrorView:NO];
                
                //no more page
                if( pageInfo_.currentPage_ > pageInfo_.pageCnt_ || pageInfo_.pageCnt_ == 0 ){
                    [self showNoMoreDataView:YES];
                }
                //have more page
                else{
                    [self showFooterRefreshView:YES];
                }
                
                //...
                if( !bHaveShowErrorLoad_ ){
                    [self showErrorLoadView:YES];
                }
            }else{
                //super class have process it
            }
        }
    }
}

//can get data
-(BOOL) canGetData
{
    BOOL bCan = NO;
    
    //判断有效期
    if( (lasterLoadDate_ && [[NSDate date] timeIntervalSinceDate:lasterLoadDate_] > validateSeconds_ && ( loadStats_ == FinishLoad || loadStats_ == ErrorLoad )) ){
        bCan = YES;
    }
    //加载状态(加载分页出错不算)
    else if( (!lasterLoadDate_ && loadStats_ == FinishLoad) || ((loadStats_ == ErrorLoad || loadStats_ == FinishLoad) && [resultArr_ count] == 0) ){
		bCan = YES;
	}
    //一定要刷新
    else if( bFresh_ ){
        bCan = YES;
    }
	
	return bCan;
}

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    if( [self canGetData] ){
        //重置分页
        pageInfo_.currentPage_ = 0;
        pageInfo_.pageCnt_ = 0;
        pageInfo_.totalCnt_ = 0;
    }
    
    if( bHaveEditMode_ ){
        bEditMode_ = NO;
        [tableView_ setEditing:NO animated:NO];
        [rightBarBtn_ setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
	[super beginLoad:dataModal exParam:exParam];
}

//load more
-(void) loadMoreData
{
    loadStats_ = InLoadMore;
    [self willLoadData];
    [self getDataFunction];
}

//error get data
-(void) errorGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type
{
    [super errorGetData:preRequestCon code:code type:type];
    
    //if have data
    if( preRequestCon == PreRequestCon_ && [resultArr_ count] > 0 ){
        //set show error load view flag
        bHaveShowErrorLoad_ = NO;
    }
}

-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
	[super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
}

///load detail
-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
	NSLog(@"[%@][Index->%ld] : load detail",[self class],(long)[indexPath row]);
}

//delete cell
-(void) deleteCell:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] : delete cell=>%ld",[self class],(long)[indexPath row]);
}

-(void) donePop
{
	[super donePop];
	
	if( [self canGetData] ){
        //reset page info
        pageInfo_.currentPage_      = 0;
        pageInfo_.pageCnt_          = 0;
        prePageInfo_.currentPage_   = 0;
        prePageInfo_.pageCnt_       = 0;
        
        [self clearData:PreRequestCon_];
        [tableView_ reloadData];
	}
}

#pragma EGO
#pragma mark – 
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource:(EGORefreshTableView *)egoView
{     
	if( egoView == refreshHeaderView_ ){
		NSLog(@"[%@] : ego header refresh",[self class]);
		
        //refresh data
        [self refreshData:myParam_ exParam:exParam_];
        
	}else if( egoView == refreshFooterView_ ){
		NSLog(@"[%@] : ego footer refresh",[self class]);
		
        //load more
        [self loadMoreData];
	}else{
		NSLog(@"[%@] : null ego refresh",[self class]);
	}
}

- (void)doneLoadingTableViewData:(EGORefreshTableView *)egoView
{ 
	NSLog(@"[%@] : ego done",[self class]);
	
	[egoView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
}


#pragma mark – 
#pragma mark UIScrollViewDelegate Methods 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    [refreshHeaderView_ egoRefreshScrollViewDidScroll:scrollView]; 
	[refreshFooterView_ egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[refreshHeaderView_ egoRefreshScrollViewDidEndDragging:scrollView];
	[refreshFooterView_ egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark – 
#pragma mark EGORefreshTableDelegate Methods 
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshTableView*)view
{
    //[self reloadTableViewDataSource:view];
    [self performSelector:@selector(reloadTableViewDataSource:) withObject:view afterDelay:0.1];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(EGORefreshTableView*)view
{
    //return (loadState_ == InReload); 
	if( loadStats_ == InReload && view == refreshHeaderView_ ){
		return YES;
	}
    else if( loadStats_ == InLoadMore && view == refreshFooterView_ ){
		return YES;
	}
    
    return NO;
} 

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(EGORefreshTableView*)view
{
    return [NSDate date];     
}

//add obj from dataArr
-(void) addDataModal:(PreRequestCon *)con dataArr:(NSArray *)dataArr type:(XMLParserType)type
{
    [resultArr_ addObjectsFromArray:dataArr];
}

//sub class rewrite it
-(void) beginClearData:(PreRequestCon *)con
{

}

//clear data
-(void) clearData:(PreRequestCon *)con
{
    [self beginClearData:con];
    
    [resultArr_ removeAllObjects];
}

#pragma mark LoadDataDelegate
-(void) loadDataComplete:(PreRequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr parserType:(XMLParserType)type
{
    if( con == PreRequestCon_ )
    {        
        //处理分页
        if( code <= Success ){
            @try {
                if( [dataArr count] > 0 ){
                    id obj = [dataArr objectAtIndex:0];
                    
                    if( [obj isKindOfClass:[PageInfo class]] ){
                        PageInfo *pageInfo = obj;
                        
                        pageInfo_.totalCnt_ = pageInfo.totalCnt_;
                        pageInfo_.pageCnt_ = pageInfo.pageCnt_;
                    }else
                        [self clearData:con];
                }
                
                if( pageInfo_.currentPage_ == 0 ){
                    [self clearData:con];
                }
                
                [self addDataModal:con dataArr:dataArr type:type];
                
                [tableView_ reloadData];
            }
            @catch (NSException * e) {
                NSLog(@"[%@] : PageInfo Error!",[self class]);
            }
            @finally {
                ++pageInfo_.currentPage_;
                
                //记下分页信息
                prePageInfo_.currentPage_ = pageInfo_.currentPage_;
                prePageInfo_.pageCnt_ = pageInfo_.pageCnt_;
            }
        }else{
            //error load
            //recover page info
            pageInfo_.currentPage_ = prePageInfo_.currentPage_;
            pageInfo_.pageCnt_ = prePageInfo_.pageCnt_;
        }
        
        if( loadStats_ == InReload ){
            [self doneLoadingTableViewData:refreshHeaderView_];
        }else if( loadStats_ == InLoadMore ){
            [self doneLoadingTableViewData:refreshFooterView_];
        }else{
            [self doneLoadingTableViewData:nil];
        }
    }
    
    [super loadDataComplete:con code:code dataArr:dataArr parserType:type];

    //set edit mode
    if( bHaveEditMode_ ){
        if( [resultArr_ count] == 0 && bEditMode_ ){
            [rightBarBtn_ setTitle:@"编辑" forState:UIControlStateNormal];
            
            bEditMode_ = NO;
            [tableView_ setEditing:NO animated:YES];
            [tableView_ reloadData];
        }
        
        [tableView_ endUpdates];
    }
}


-(void) rightBarBtnResponse:(id)sender
{
    //存在编辑模式时
    if( bHaveEditMode_ ){
        bEditMode_ = !bEditMode_;
        
        if( bEditMode_ ){
            //如果没有数据
            if( [resultArr_ count] == 0 ){
                bEditMode_ = NO;
                [PreBaseUIViewController showAlertView:nil msg:@"无数据,暂无法进入编辑模式" btnTitle:@"我知道了"];
                return;
            }
            
            [rightBarBtn_ setTitle:@"完成" forState:UIControlStateNormal];
            
            [tableView_ setEditing:YES animated:YES];
        }else{
            [rightBarBtn_ setTitle:@"编辑" forState:UIControlStateNormal];
            
            [tableView_ setEditing:NO animated:YES];
            [tableView_ endUpdates];
        }
    }
}

@end

