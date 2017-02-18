//
//  SearchResultCtl.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchResultCtl.h"
#import "MyButton.h"

UIImage *selectOnImage;
UIImage *selectOffImage;

@implementation SearchResultCtl


@synthesize delegate_,type_;

-(id) init
{
    self = [self initWithNibName:SearchResultCtl_Xib_Name bundle:nil];
//    self.navigationItem.title = SearchResultCtl_Title;
    [self setNavTitle:SearchResultCtl_Title];
    
    if( !selectOnImage )
    {
        selectOnImage = [UIImage imageNamed:@"ico_select_on.png"];
        selectOffImage = [UIImage imageNamed:@"ico_select_off.png"];
    }
    
    zwPreRequestCon_ = [[PreRequestCon alloc] init];
    zwPreRequestCon_.delegate_ = self;
    
    bOtherZWResult_ = NO;
        
    //初始化批处理信息
    [self initOperateInfo];
    
    return self;
}

//初始化连续申请，收藏信息
-(void) initOperateInfo
{
    //当前选中为
    currentOperateIndex_ = 0;
    successCount_        = 0;
    failCount_           = 0;
    processCount_        = 0;
    bResumeFail_         = NO;
    //[failMsg_ release];
    failMsg_ = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255 green:229.0/255 blue:238.0/255 alpha:1.0];
    tableView_.backgroundColor = [UIColor clearColor];
    
    //设置圆角
    CALayer *layer=[bottomImageView_ layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:0.0];
    [layer setBorderColor:[[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1] CGColor]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//获取搜索时的条件str
-(NSString *) getSearchCondictionStr:(SearchParam_DataModal *)dataModal
{
    NSMutableString *str = [[NSMutableString alloc] init];
    
    BOOL preAdded = NO;
    
    //关键字
    if( dataModal.searchKeywords_ && ![dataModal.searchKeywords_ isEqualToString:@""] )
    {
        if( dataModal.searchType_ == 2 )
        {
            preAdded = YES;
            [str appendString:@"公司名"];
        }
        else if( dataModal.searchType_ == 1 )
        {
            preAdded = YES;
            [str appendString:@"职位名"];
        }
        
        if( preAdded )
        {
            [str appendFormat:@"+%@",dataModal.searchKeywords_];
        }else
            [str appendFormat:@"%@",dataModal.searchKeywords_];
        
        preAdded = YES;
    }
    
    //地区
    if( dataModal.regionStr_ && ![dataModal.regionStr_ isEqualToString:@""] )
    {
        if( preAdded )
        {
            [str appendFormat:@"+%@",dataModal.regionStr_];
        }else
            [str appendFormat:@"%@",dataModal.regionStr_];
        
        preAdded = YES;
    }
    
    //职位分类
    if( dataModal.zwStr_ && ![dataModal.zwStr_ isEqualToString:@""] )
    {
        if( preAdded )
        {
            [str appendFormat:@"+%@",dataModal.zwStr_];
        }else
            [str appendFormat:@"%@",dataModal.zwStr_];
        
        preAdded = YES;
    }
    
    //行业
    if( dataModal.tradeStr_ && ![dataModal.tradeStr_ isEqualToString:@""] )
    {
        if( preAdded ){
            [str appendFormat:@"+%@",dataModal.tradeStr_];
        }else
            [str appendFormat:@"%@",dataModal.tradeStr_];
        
        preAdded = YES;
    }
    
    //定位范围
    if( dataModal.rangStr_ && ![dataModal.rangStr_ isEqualToString:@""] )
    {
        if( preAdded )
        {
            [str appendFormat:@"+%@",dataModal.rangStr_];
        }else
            [str appendFormat:@"%@",dataModal.rangStr_];
        
        preAdded = YES;
    }
    
    //专业
    if( dataModal.majorStr_ && ![dataModal.majorStr_ isEqualToString:@""] )
    {
        if( preAdded )
        {
            [str appendFormat:@"+%@",dataModal.majorStr_];
        }else
            [str appendFormat:@"%@",dataModal.majorStr_];
        
        preAdded = YES;
    }
    
    //时间
    if( dataModal.dateId_ && ![dataModal.dateId_ isEqualToString:@""] )
    {
        if( preAdded )
        {
            [str appendFormat:@"+%@",dataModal.dateStr_];
        }else
            [str appendFormat:@"%@",dataModal.dateStr_];
        
        preAdded = YES;
    }
    
    //如果没有组装出str,则加上搜索类型
    if( !preAdded )
    {
        if( dataModal.searchType_ == 3 )
        {
            [str appendString:@"全文"];
        }else if( dataModal.searchType_ == 2 )
            [str appendString:@"公司名"];
        else if( dataModal.searchType_ == 1 )
            [str appendString:@"职位名"];
        
        preAdded = YES;
    }
    
//    if( !dataModal.bCampusSearch_ ){
//        [str appendString:@"+社招"];
//    }
    
    if( [str isEqualToString:@""] )
    {
        [str appendString:@"搜索结果"];
    }
    
    return str;
}

-(void) donePop
{
    [super donePop];
    
    bLoadByHistory_ = NO;
}

-(void) backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    if ([type_ isEqualToString:@"1"]) {
        [delegate_ searchBack];
    }
    bLoadByHistory_ = NO;
}

-(void) bePoped:(UIViewController *)ctl
{
    [super bePoped:ctl];
    
    [tableView_ reloadData];
}

//搜索职位
-(void) search:(NSString *)searchURL title:(NSString *)title
{
    historyURL_ = searchURL;
    bLoadByHistory_ = YES;
    
    if( !bOtherZWResult_ )
    {
        titleStr_ = title;
    }
    
    [self beginLoad:nil exParam:nil];
}

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    if( searchParam_ != dataModal )
    {
        searchParam_ = dataModal;
    }
    
    if (!searchParam_.searchKeywords_) {
        searchParam_.searchKeywords_ = @"";
    }
    
    //保存搜索条件到数据库
    if (searchParam_.searchKeywords_&&![searchParam_.searchKeywords_ isEqual:[NSNull null]]&&![[searchParam_.searchKeywords_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        if (!db_) {
            db_ = [[DBTools alloc]init];
        }
        [db_ createTableForSearch];
        [db_ deleteData:[Manager getUserInfo].userId_ searchKeyWords:searchParam_.searchKeywords_ regionStr:searchParam_.regionStr_ tradeStr:searchParam_.tradeStr_];
        [db_ insertTableForSearch:[Manager getUserInfo].userId_ searchKeyWords:searchParam_.searchKeywords_ regionId:searchParam_.regionId_ regionStr:searchParam_.regionStr_ tradeId:searchParam_.tradeId_ tradeStr:searchParam_.tradeStr_ searchTime:[PreCommon getCurrentDateTime] searchType:[NSString stringWithFormat:@"%ld",(long)searchParam_.searchType_]];
        
    }
    [super beginLoad:dataModal exParam:exParam];
}

-(void) updateComInfo:(PreRequestCon *)con
{
    [super updateComInfo:con];
    
    if( !bOtherZWResult_ ){
        [self setMyTitle];
    }
}

-(void) getDataFunction
{
    if( !bLoadByHistory_ )
    {
        currentSearchURL_ = [PreRequestCon_ searchJob:searchParam_.searchKeywords_ regionId:searchParam_.regionId_ zwId:searchParam_.zwId_ zwStr:nil tradeId:searchParam_.tradeId_ bParent:searchParam_.bParent_ dateId:searchParam_.dateId_ majorId:searchParam_.majorId_ jobtypeId:searchParam_.jobType_ keyType:searchParam_.searchType_ bCampusSearch:searchParam_.bCampusSearch_ uid:searchParam_.uid_ showMode:@"showwap" pageIndex:pageInfo_.currentPage_];
    }else
    {
        [PreRequestCon_ searchByHitory:historyURL_ pageIndex:pageInfo_.currentPage_];
    }
}

-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
//    if( !zwDetailCtl_ ){
//        zwDetailCtl_ = [[ZWDetailCtl alloc] init];
//        zwDetailCtl_.delegate_ = self;
//    }
//    
//    [self.navigationController pushViewController:zwDetailCtl_ animated:YES];
//    [zwDetailCtl_ beginLoad:selectData exParam:nil];
}

//#pragma ZWDetailDelegate
//-(void) zwDetailFinish:(BaseZWDetailCtl *)ctl
//{
//    [tableView_ reloadData];
//}

//查看数据库中是否存在此条职位
-(BOOL) checkZWIsExistInDB:(NSString *)zwId
{
    //return NO;
    NSString *personId = [Manager getUserInfo].userId_;
    
    if( !personId )
    {
        return NO;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60*ZW_HaveRead_Max_HistoryDay];
    NSString *dateStr = [PreCommon getDateStr:date];
    
    NSString *whereStr = [[NSString alloc] initWithFormat:@"zw_id='%@' and person_id='%@' and create_data >= '%@'",zwId,personId,dateStr];
    sqlite3_stmt *result = [myDB selectSQL:nil fileds:@"id" whereStr:whereStr limit:1 tableName:DB_TableName_PersonZWReadHistory];
    BOOL bFind = NO;
    while ( sqlite3_step(result) == SQLITE_ROW ) 
    {
        bFind = YES;
        break;
    }
    sqlite3_finalize(result);
    
    return bFind;
}

//批处理
//加载完后，告诉用户处理情况
-(void) showProcessMsg:(int)type
{
    [applyJobArr_ removeAllObjects];
    [PreBaseUIViewController showLoadingView:NO title:nil];
    
    NSString *typeStr;
    
    //订阅
    if( type == 1 )
    {
        typeStr = [[NSString alloc] initWithFormat:@"共帮您订阅了[%d]个职位",processCount_];
    }
    
    //申请
    if( type == 2 )
    {
        typeStr = [[NSString alloc] initWithFormat:@"共帮您申请了[%d]个职位",processCount_];
    }
    
    //如果错误数大于0
    if( failCount_ > 0 )
    {
        //处理完毕
        NSString *title = [[NSString alloc] initWithFormat:@"%@",typeStr];
        NSString *msg = [[NSString alloc] initWithFormat:@"成功:[%d] 失败:[%d]\n 失败的原因:%@",successCount_,failCount_,failMsg_];
        [PreBaseUIViewController showAlertView:title msg:msg btnTitle:@"我知道了"];
    }else
    {
        //处理完毕
        NSString *msg = [[NSString alloc] initWithFormat:@"%@,全部成功",typeStr];
        [PreBaseUIViewController showAlertView:nil msg:msg btnTitle:@"确定"];
    }
}

//申请选中职位
-(void) loadApplySelectZW
{    
    //如果是由简历不完整而造成的错误
    if( bResumeFail_ )
    {
        [PreBaseUIViewController showLoadingView:NO title:nil];
        [self showChooseAlertView:3 title:@"申请失败" msg:@"简历不够完善，是否马上完善简历？" okBtnTitle:@"去完善" cancelBtnTitle:@"取消"];
        return;
    }
    
    @try {
        //显示正在加载视图
        //显示正在加载视图
        if( currentOperateIndex_ == 0 )
        {
            [PreBaseUIViewController showLoadingView:YES title:@"正在申请选中职位"];
        }
        
        JobSearch_DataModal *dataModal = [resultArr_ objectAtIndex:currentOperateIndex_];
        ++currentOperateIndex_;
        
        if( dataModal.bChoosed_ )
        {
            if (!zwPreRequestCon_) {
                zwPreRequestCon_ = [[PreRequestCon alloc] init];
                zwPreRequestCon_.delegate_ = self;
            }
            [zwPreRequestCon_ applyZW:dataModal.zwID_ companyId:dataModal.companyID_];
        }else
        {
            [self loadApplySelectZW];
        }
//        for (JobSearch_DataModal * dataModal in  applyJobArr_) {
//            [zwPreRequestCon_ applyZW:dataModal.zwID_ companyId:dataModal.companyID_];
//        }
    }
    @catch (NSException *exception) {
        //处理完毕
        [self showProcessMsg:2];
    }
    @finally {
//        //处理完毕
//        [self showProcessMsg:2];
    }
}


//订阅选中职位
-(void) loadFavSelectZW
{    
    //如果是由简历不完整而造成的错误
    if( bResumeFail_ )
    {
        [PreBaseUIViewController showLoadingView:NO title:nil];
        [self showChooseAlertView:2 title:@"订阅失败" msg:@"简历不够完善，是否马上完善简历？" okBtnTitle:@"去完善" cancelBtnTitle:@"取消"];
        return;
    }
    
    @try {
        //显示正在加载视图
        if( currentOperateIndex_ == 0 )
        {
            [PreBaseUIViewController showLoadingView:YES title:@"正在订阅相关选中职位"];
        }
        
        JobSearch_DataModal *dataModal = [resultArr_ objectAtIndex:currentOperateIndex_];
        ++currentOperateIndex_;
        
        if( dataModal.bChoosed_ )
        {
            //[zwPreRequestCon_ favZW:dataModal.zwID_ companyId:dataModal.companyID_];
            if (!requestCon_) {
                requestCon_ = [self getNewRequestCon:NO];
            }
            [requestCon_ subscribeJob:loginDataModal.personId_ regionId:searchParam_.regionId_ keyword:dataModal.zwName_ tradeId:searchParam_.tradeId_];
        }else
        {
            [self loadFavSelectZW];
        }
    }
    @catch (NSException *exception) {
        //处理完毕
        [self showProcessMsg:1];
    }
    @finally {
        
    }
    
    
}

//重写父类的此方法
-(BOOL) needProcessError:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type
{
    BOOL flag = NO;
    
    switch ( type ) {
        case ZW_Apply_XMLParser:
            //不需要底层处理此异常
            break;
        case ZW_Fav_XMLParser:
            //不需要底层处理此异常
            break;
        default:
            flag = [super needProcessError:preRequestCon code:code type:type];
            break;
    }
    
    return flag;
}

//load data finish
-(void) loadDataComplete:(RequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr requestType:(int)type
{
    //....
    switch ( type ) {
        case Request_SubscibeJob:
        {
            BOOL bSuccess = NO;
            @try {
                Status_DataModal * dataModal = [dataArr objectAtIndex:0];
                
                if( [dataModal.status_ isEqualToString:Success_Status] ){
                    bSuccess = YES;
                }
                
                if( !bSuccess ){
                    ++failCount_;
                    if(!dataModal.des_){
                        dataModal.des_ = @"0x000005";
                    }
                    failMsg_ = dataModal.des_;
                }else{
                    ++successCount_;
                }

            }
            @catch (NSException *exception) {
                ++failCount_;
            }
            @finally {
                [self performSelector:@selector(loadFavSelectZW) withObject:nil afterDelay:0.2];
                //[self loadFavSelectZW];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void) errorGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type
{
    [super errorGetData:preRequestCon code:code type:type];
    
    switch ( type ) {
        case ZW_Apply_XMLParser:
            ++failCount_;
            
            failMsg_ = [[NSString alloc] initWithString:[ErrorInfo getErrorMsg:code]];
            
            [self loadApplySelectZW];
            break;
        case ZW_Fav_XMLParser:
            ++failCount_;
            
            failMsg_ = [[NSString alloc] initWithString:[ErrorInfo getErrorMsg:code]];
            [self loadFavSelectZW];
            break;
        default:
            break;
    }
}

-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case CompanyOther_ZW_XMLParser:
        {
            //检测是否是已看职位
            for ( id tempDataModal in dataArr ) {
                if( [tempDataModal isKindOfClass:[JobSearch_DataModal class]] )
                {
                    JobSearch_DataModal *dataModal = tempDataModal;
                    if( [self checkZWIsExistInDB:dataModal.zwID_] )
                    {
                        dataModal.bRead_ = YES;
                    }
                }
            }
        }
            break;
        case SearchResult_XMLParser:
        {
            //检测是否是已看职位
            for ( id tempDataModal in dataArr ) {
                if( [tempDataModal isKindOfClass:[JobSearch_DataModal class]] )
                {
                    JobSearch_DataModal *dataModal = tempDataModal;
                    if( [self checkZWIsExistInDB:dataModal.zwID_] )
                    {
                        dataModal.bRead_ = YES;
                    }
                }
            }
            
            //存放进数据库中
            //如果返回的是第一页的数据，那我们就保存到历史记录
            if( pageInfo_.currentPage_ == 1 && code < Fail && pageInfo_.totalCnt_ != 0 )
            {
                [self writeSearchParamToHistoryDB];
            }
            
            [delegate_ searchFinished:self];
        }
            break;
        case ZW_Apply_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                
                if( [dataModal.status_ isEqualToString:Request_OK] )
                {
                    //成功了
                    ++successCount_;
                    
                }else
                {
                    ++failCount_;
                    
                    //如果是简历不完整造成的错误，则所有的选中都不用再处理了
                    if( [dataModal.msg_ isEqualToString:Request_Fail_Resume] )
                    {
                        bResumeFail_ = YES;
                        failMsg_ = Request_Fail_Resume;
                    }else
                    {
                        failMsg_ = [[NSString alloc] initWithString:dataModal.msg_];
                    }
                }
            }
            @catch (NSException *exception) {
                ++failCount_;
            }
            @finally {
                [self loadApplySelectZW];
            }
        }
            break;
        case ZW_Fav_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                
                if( [dataModal.status_ isEqualToString:Request_OK] )
                {
                    //成功了
                    ++successCount_;
                }else
                {
                    ++failCount_;
                    
                    //如果是简历不完整造成的错误，则所有的选中都不用再处理了
                    if( [dataModal.status_ isEqualToString:Request_Fail_Resume] )
                    {
                        bResumeFail_ = YES;
                        failMsg_ = Request_Fail_Resume;
                    }else
                    {
                        failMsg_ = [[NSString alloc] initWithString:dataModal.msg_];
                    }
                }
            }
            @catch (NSException *exception) {
                ++failCount_;
            }
            @finally {
                [self loadFavSelectZW];
            }
        }
            break;
        default:
            break;
    }
}

//将搜索条件写入数据库中
-(void) writeSearchParamToHistoryDB
{
    //不是从历史中加载而来
    if( !bLoadByHistory_ && !bOtherZWResult_ )
    {
        NSInteger cnt = pageInfo_.totalCnt_;
        if( pageInfo_.totalCnt_ > 10000 && pageInfo_.totalCnt_ < 50000 )
        {
            cnt += Result_Add_Cnt;
        }
        
        //存入数据库中
        //去更新数据库中的数据
        NSString *columnsName = [[NSString alloc] initWithFormat:@"search_url,search_result,search_name,save_type,updatetime"];
        NSString *columnsValue = [[NSString alloc] initWithFormat:@"'%@','%ld','%@','%d','%@'",currentSearchURL_,(long)cnt,titleStr_,NormalSearchType,[PreCommon getCurrentDateTime]];
        
        //先去除此条件记录
        NSString *whereStr = [NSString stringWithFormat:@" search_name='%@'",titleStr_];
        if( [myDB deleteSQL:whereStr tableName:DB_SearchHistory_TableName] )
        {
            
        }
        
        //插入成功后
        if( [myDB insertSQL:columnsName columnsValue:columnsValue tableName:DB_SearchHistory_TableName] )
        {

        }
    }
}

//获取选中职位数量
-(int) getSelectCnt
{
    int cnt = 0;
    for ( JobSearch_DataModal *dataModal in resultArr_ ) {
        if( dataModal.bChoosed_ )
        {
            ++cnt;
            //[applyJobArr_ addObject:dataModal];
        }
    }
    
    return cnt;
}

//设置标题
-(void) setMyTitle
{
    if( pageInfo_.currentPage_ == 0 )
    {
        if( !bLoadByHistory_ ){
            titleStr_ = [self getSearchCondictionStr:searchParam_];
        }

//        self.navigationItem.title = titleStr_;
        [self setNavTitle:titleStr_];
    }
    else if( pageInfo_.totalCnt_ > 10000 && pageInfo_.totalCnt_ < 50000 )
    {
        //重设标题
//        self.navigationItem.title = [[NSString alloc] initWithFormat:@"[%ld条]:%@",(long)(pageInfo_.totalCnt_+Result_Add_Cnt),titleStr_];
        [self setNavTitle:[[NSString alloc] initWithFormat:@"[%ld条]:%@",(long)(pageInfo_.totalCnt_+Result_Add_Cnt),titleStr_]];
    }else
    {
        //重设标题
//        self.navigationItem.title = [[NSString alloc] initWithFormat:@"[%ld条]:%@",(long)pageInfo_.totalCnt_,titleStr_];
        [self setNavTitle:[[NSString alloc] initWithFormat:@"[%ld条]:%@",(long)pageInfo_.totalCnt_,titleStr_]];
    }

//    self.navigationItem.title = @"搜索结果";
    [self setNavTitle:@"搜索结果"];
}

//判断是否需要中断
-(InterruptType) checkInterrupt:(id)sender
{
//    if( ![manager haveLogin] && ( sender == applyBtn_ || sender == favBtn_ ) ){
//        return LoginInterrupt;
//    }
    
    return NullInterrupt;
}

#pragma (重载)TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return TableHeight_SearchResult;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    SearchResultList_Cell *cell = (SearchResultList_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        //是否选中的按扭
        MyButton *myBtn     = (MyButton *)[cell viewWithTag:110];
        [myBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //职位名
    UILabel *zwLb       = (UILabel *)[cell viewWithTag:100];
    //公司名称
    UILabel *cnameLb    = (UILabel *)[cell viewWithTag:101];
    //地区名称
    UILabel *regionLb   = (UILabel *)[cell viewWithTag:102];
    //发布时间
    UILabel *dateLb     = (UILabel *)[cell viewWithTag:103];
    //是否选中的按扭
    MyButton *myBtn     = (MyButton *)[cell viewWithTag:110];
    //是否已阅图标
    UIImageView *bReadImage = (UIImageView *)[cell viewWithTag:500];
    
    cell.textLabel.text = @"";

    JobSearch_DataModal *dataModal = [resultArr_ objectAtIndex:[indexPath row]];
    zwLb.text       = dataModal.zwName_;
    cnameLb.text    = dataModal.companyName_;
    dateLb.text     = dataModal.updateTime_;
    regionLb.text   = dataModal.regionName_;
    myBtn.index_    = [indexPath row];
    
    if( dataModal.bChoosed_ )
    {
        [myBtn setImage:selectOnImage forState:UIControlStateNormal];
    }else
        [myBtn setImage:selectOffImage forState:UIControlStateNormal];
    
    if( dataModal.bRead_ )
    {
        bReadImage.alpha = 1.0;
    }else
        bReadImage.alpha = 0.0;
    
    return cell;
}

#pragma IBActions
-(void) buttonResponse:(id)sender
{
    //申请职位
    if( sender == applyBtn_ )
    {
        if( ![Manager shareMgr].haveLogin ){
            [BaseUIViewController showAlertView:@"请先登录再操作" msg:nil btnTitle:@"确定"];
            return;
        }
        
        [self initOperateInfo];
        
        processCount_ = [self getSelectCnt];
        
        if( processCount_ )
        {
            [self showChooseAlertView:1 title:@"确定申请选中职位？" msg:nil okBtnTitle:@"确认" cancelBtnTitle:@"取消"];
            
        }else
        {
            [PreBaseUIViewController showAlertView:nil msg:@"您至少要选中一个职位"  btnTitle:@"我知道了"];
        }
    }
    //订阅职位
    else if( sender == favBtn_ )
    {
        if( ![Manager shareMgr].haveLogin ){
            [BaseUIViewController showAlertView:@"请先登录再操作" msg:nil btnTitle:@"确定"];
            return;
        }
        
        [self initOperateInfo];
        
        processCount_ = [self getSelectCnt];
        
        if( processCount_ )
        {
            [self loadFavSelectZW];
        }else
        {
            if (!searchParam_.tradeStr_||[searchParam_.tradeStr_ isEqualToString:@""]||[searchParam_.tradeStr_ isEqualToString:@"所有行业"]) {
                [PreBaseUIViewController showAlertView:@"订阅失败" msg:@"搜索条件中缺少行业信息"  btnTitle:@"我知道了"];
                return;
            }
            else
            {
                [self showChooseAlertView:11 title:@"未选择具体职位" msg:@"是否订阅该类职位？" okBtnTitle:@"订阅" cancelBtnTitle:@"取消"];
                
            }
            
            
        }
    }
    //MyButton Click
    else if( [sender isKindOfClass:[MyButton class]] )
    {
        MyButton *myBtn = sender;
        JobSearch_DataModal *dataModal = [resultArr_ objectAtIndex:myBtn.index_];
        dataModal.bChoosed_ = !dataModal.bChoosed_;
        if( dataModal.bChoosed_ )
        {
            [myBtn setImage:selectOnImage forState:UIControlStateNormal];
        }else
            [myBtn setImage:selectOffImage forState:UIControlStateNormal];
    }
}


-(void)alertViewChoosed:(UIAlertView *)alertView index:(NSInteger)index type:(ChooseAlertViewType)type
{
    switch (type) {
        case 1:
        {
            [self loadApplySelectZW];
        }
            break;
//        case 2:
//        {
//            if (!myResumeCtl_) {
//                myResumeCtl_ =[[ResumeCenterCtl alloc] init];
//            }
//            [self.navigationController pushViewController:myResumeCtl_ animated:YES];
//            [myResumeCtl_ beginLoad:nil exParam:nil];
//        }
//            break;
//        case 3:
//        {
//            if (!myResumeCtl_) {
//                myResumeCtl_ =[[ResumeCenterCtl alloc] init];
//            }
//            [self.navigationController pushViewController:myResumeCtl_ animated:YES];
//            [myResumeCtl_ beginLoad:nil exParam:nil];
//        }
//            break;
        case 11:
        {
            processCount_ = 1;
            if (!requestCon_) {
                requestCon_ = [self getNewRequestCon:NO];
            }
            [requestCon_ subscribeJob:loginDataModal.personId_ regionId:searchParam_.regionId_ keyword:searchParam_.searchKeywords_ tradeId:searchParam_.tradeId_];
            [PreBaseUIViewController showLoadingView:YES title:@"正在订阅该类职位"];
        }
            break;
        default:
            break;
    }
}


@end
