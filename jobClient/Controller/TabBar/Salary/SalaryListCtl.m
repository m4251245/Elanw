//
//  SalaryListCtl.m
//  jobClient
//
//  Created by YL1001 on 14/11/20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//
#define kJobTagOffSet 200
#define kFootViewTag 101

#import "SalaryListCtl.h"
#import "SalaryCtl_Cell.h"
#import "ChangeRegionViewController.h"
#import "BuySalaryServiceCtl.h"
#import "HotJob_DataModel.h"
#import "ProfessionView.h"
#import "ProfesssionListCtl.h"
#import "SalarySearchListCtl2.h"
#import "ExposureSalaryCtl2.h"

@interface SalaryListCtl ()<NoLoginDelegate>
{
    NSString * locationCity_;
    NSArray  * colorArr_;
    NSString * sum_;
    BOOL shouldRefresh_ ;
    RequestCon *_querySalaryCountCon;//曝工资人数
    RequestCon *_salaryHotJobCon;//热门职业
    CGPoint scrollSet;
    NSMutableArray *_hotJobArr;
    BOOL _isOpen;
    UIView *exposureSalaryView;
}

@end

@implementation SalaryListCtl

-(id)init
{
    self = [super init];
    bFooterEgo_ = YES;
    validateSeconds_ = 600;
    //增加键盘事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    regionModel_ = [[SqlitData alloc]init];
    rightNavBarStr_ = @"比薪资";
    return self;
}

-(void)rightBarBtnResponse:(id)sender{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_SalaryRightButton;
        return;
    }
    if (![AFNetworkReachabilityManager sharedManager].isReachable  && [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusUnknown) {
        [BaseUIViewController showAlertViewContent:@"当前网络可能没有连接" toView:nil second:1.0 animated:YES];
    }else{
        SalaryCompeteCtl * salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
        salaryCompeteCtl_.type_ = 2;
        User_DataModal *userModel = [Manager getUserInfo];
        [salaryCompeteCtl_ beginLoad:userModel.zym_ exParam:nil];
        salaryCompeteCtl_.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:salaryCompeteCtl_ animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"查工资";
    [self setNavTitle:@"查工资"];
    
    [locationBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    [locationBtn_ setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    [_jobTF setFont:FOURTEENFONT_CONTENT];
    [_jobTF setTextColor:BLACKCOLOR];
    NSString *locCity = [Manager shareMgr].regionName_;
    if (locCity && ![locCity isEqualToString:@""]) {
        regionModel_.provinceName = locCity;
        [locationBtn_ setTitle:locCity forState:UIControlStateNormal];
    }else{
        regionModel_.provinceName = @"全国";
        [locationBtn_ setTitle:@"全国" forState:UIControlStateNormal];
    }
    
    CALayer *layer = _loadMoreBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    layer = _exposureSalaryBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
    if (_salaryHotJobCon) {
        [_salaryHotJobCon stopConnWhenBack];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if ([requestCon_.dataArr_ count] == 0 || shouldRefresh_ ) {
        [self refreshLoad:requestCon_];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [self showExposureView];
}

#pragma mark 显示曝工资的view
- (void)showExposureView
{
    //显示曝工资
    if (_shouldShowExposureSalary) {
//        self.navigationItem.title = @"我也要曝工资";
        [self setNavTitle:@"我也要曝工资"];
        _shouldShowExposureSalary = NO;
        ExposureSalaryCtl2 *exposureCtl;
        if (self.childViewControllers.count) {
            exposureCtl = self.childViewControllers[0];
        }
        if (!exposureCtl) {
            exposureCtl = [[ExposureSalaryCtl2 alloc]init];
            [exposureCtl beginLoad:nil exParam:nil];
            __weak typeof(self) weakSelf = self;
            exposureCtl.finishBlock = ^(BOOL shouldRefresh){
                weakSelf.title = @"查工资";
                if (shouldRefresh) {
                    [self refreshLoad:requestCon_];
                }
            };
            [self addChildViewController:exposureCtl];
        }
        if (exposureCtl.view.superview) {
            [exposureCtl.view removeFromSuperview];
        }
        exposureCtl.view.frame = CGRectMake(0, 0-self.view.bounds.size.height, ScreenWidth, self.view.bounds.size.height);
        [self.view addSubview:exposureCtl.view];
        [UIView animateWithDuration:0.6 animations:^{
            CGRect frame = exposureCtl.view.frame;
            frame.origin.y = 0;
            exposureCtl.view.frame = frame;
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setBtnTitle:(NSString*)str
{
    [locationBtn_ setTitle:str forState:UIControlStateNormal];
    
}

-(void)updateCom:(RequestCon *)con
{

}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
    if (!_salaryHotJobCon) {//热门职业分类
        _salaryHotJobCon = [self getNewRequestCon:NO];
    }
    [_salaryHotJobCon getSalaryHotJobList:0];
}

-(void)getDataFunction:(RequestCon *)con
{
//    if ([[Manager shareMgr] haveLogin] && [Manager shareMgr].bLRegion_ == NO) {
//        return;
//    }
    
    if (requestCon_.pageInfo_.currentPage_ == 0) {
        if (!_querySalaryCountCon) {
            _querySalaryCountCon = [self getNewRequestCon:NO];
        }
        [_querySalaryCountCon getExposureSalaryNum];
    }

    regionModel_.provinceld = [CondictionListCtl getRegionId:regionModel_.provinceName];
    
    if (!regionModel_.provinceld) {
        regionModel_.provinceld = @"";
    }
    if (!_jobTF.text) {
        _jobTF.text = @"";
    }
    
    keyword_ = [_jobTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([keyword_ isEqualToString:@""])
    {
        _jobTF.text = @"";
    }
    [con getSalaryList:keyword_ keywordFlag:@"0"  region:regionModel_.provinceld page:requestCon_.pageInfo_.currentPage_ pageSize:20 userId:[Manager getUserInfo].userId_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetExposureSalaryNum://曝工资的数量
        {
            if (dataArr.count) {
                NSDictionary *data = [dataArr objectAtIndex:0];
                _userCountLb.text = data[@"user_unique_cnt"];
            }
        }
            break;
        case Request_SalaryList:
        {
            shouldRefresh_ = NO;
        }
            break;
        case Request_SalaryHotJobList://热门职业分类
        {
            _hotJobArr = [NSMutableArray arrayWithArray:dataArr];
            [self layoutHotJob];
        }
            break;
        default:
            break;
    }
}

#pragma mark
- (void)layoutHotJob
{
    CGFloat padding =6.f;
    CGFloat itemW = (ScreenWidth/2.0)-10;
    CGFloat itemH = 60.f;
    CGFloat yStart = 30;
    HotJob_DataModel *moreModel = [[HotJob_DataModel alloc]init];
    moreModel.jobName = @"更多职位";
    [_hotJobArr addObject:moreModel];
    for (int i=0; i<_hotJobArr.count; i++) {
        HotJob_DataModel *jobModel = _hotJobArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + kJobTagOffSet;
        btn.backgroundColor = [UIColor whiteColor];
        int line = i/2;
        int column = i%2;
        btn.frame = CGRectMake(padding +(padding +itemW)*column, yStart+padding +(padding +itemH)*line, itemW, itemH);
        [btn setTitle:jobModel.jobName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 30, 30)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img sd_setImageWithURL:[NSURL URLWithString:jobModel.pic] placeholderImage:nil];
        [btn addSubview:img];
        btn.titleLabel.font = TWEELVEFONT_COMMENT;
        [_headerView addSubview:btn];
        [btn addTarget:self action:@selector(hotJobBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == _hotJobArr.count -1) {
            [btn setImage:[UIImage imageNamed:@"icon_salary_next.png"] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        }else{
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
    }
    CGFloat line = (_hotJobArr.count-1)/2;//line从0开始
    CGFloat height = yStart+padding +(padding +itemH)*line +itemH;
    
    UIView *footView = [_headerView viewWithTag:kFootViewTag];
    CGRect frame = footView.frame;
    frame.origin.y = height;
    footView.frame = frame;
    frame = _headerView.frame;
    frame.size.height = height +30;
    _headerView.frame = frame;
    tableView_.tableHeaderView = _headerView;
}

#pragma mark 选择热门职业
- (void)hotJobBtnClick:(UIButton *)sender
{
    if (_selectedJobBtn.selected) {
        _selectedJobBtn.selected= NO;
    }
    if (_isOpen) {
        [self resetSubView];
        _isOpen = NO;
        return;
    }
    sender.selected = YES;
    _selectedJobBtn = sender;
    CGFloat padding =6.f;
    CGFloat itemH = 60.f;
    CGFloat yStart = 30;
    
    NSInteger index = sender.tag -kJobTagOffSet;
    if (index == _hotJobArr.count-1) {
        //更多职业
        ProfesssionListCtl * ctl = [[ProfesssionListCtl alloc] init];
        [ctl beginLoad:nil exParam:nil];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    HotJob_DataModel *jobModel = _hotJobArr[index];
    NSArray *subJobArr = jobModel.subArray;
    ProfessionView *subJobView = [[ProfessionView alloc]init];
    if (_subJobView) {
        [_subJobView removeFromSuperview];
    }
    _subJobView = subJobView;
    NSMutableArray *mArray = [NSMutableArray array];
    for (HotJob_DataModel *jobModel in subJobArr) {
        personTagModel *tagModel = [[personTagModel alloc]init];
        tagModel.tagName_ = jobModel.jobName;
        [mArray addObject:tagModel];
    }
    
    subJobView.tagArray = mArray;
    __weak SalaryListCtl *weakSelf = self;
    subJobView.professionBtnBlock = ^(personTagModel *tagModel){
        weakSelf.jobTF.text = tagModel.tagName_;
        weakSelf.isBtnHot = YES;
        [weakSelf resetSubView];
        [weakSelf.searchBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    };
    CGFloat line = index/2;
    CGFloat subViewY = yStart+padding +(padding +itemH)*line +itemH;
    CGRect frame = subJobView.frame;
    frame.origin.x = 0;
    frame.origin.y = subViewY;
    subJobView.frame = frame;
    [_headerView addSubview:subJobView];
    
    for (int i=(line +1)*2; i<_hotJobArr.count; i++) {
        UIButton *btn = (UIButton *)[_headerView viewWithTag:i + kJobTagOffSet];
        CGRect frame = btn.frame;
        frame.origin.y += CGRectGetHeight(subJobView.frame);
        btn.frame = frame;
    }
    
    UIView *footView = [_headerView viewWithTag:kFootViewTag];
    frame = footView.frame;
    frame.origin.y = CGRectGetHeight(_headerView.frame) +CGRectGetHeight(subJobView.frame)-30;
    footView.frame = frame;
    
    frame = _headerView.frame;
    frame.size.height = CGRectGetHeight(_headerView.frame) +CGRectGetHeight(subJobView.frame);
    _headerView.frame = frame;
    tableView_.tableHeaderView = _headerView;
    _isOpen = YES;
}

#pragma mark 恢复
- (void)resetSubView
{
    _selectedJobBtn.selected = NO;
    _isOpen = NO;
    CGFloat height = CGRectGetHeight(_subJobView.frame);
    CGFloat subJobViewY = CGRectGetMaxY(_subJobView.frame);
    for (int i=0; i<_hotJobArr.count; i++) {
        UIView *view = [_headerView viewWithTag:kJobTagOffSet +i];
        if (view.frame.origin.y>=subJobViewY) {
            CGRect frame = view.frame;
            frame.origin.y -= height;
            view.frame = frame;
        }
    }
    UIView *footView = [_headerView viewWithTag:kFootViewTag];
    CGRect frame = footView.frame;
    frame.origin.y -= height;
    footView.frame = frame;
    frame = _headerView.frame;
    frame.size.height -= height;
    _headerView.frame = frame;
    tableView_.tableHeaderView = _headerView;
    [_subJobView removeFromSuperview];
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
    {
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (singleTapRecognizer_) {
        [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
        singleTapRecognizer_ = nil;
    }
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    if (singleTapRecognizer_) {
        [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
        singleTapRecognizer_ = nil;
    }
    [_jobTF resignFirstResponder];
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

#pragma CondictionListDelegate
-(void) condictionListCtlChoosed:(CondictionListCtl *)ctl dataModal:(CondictionList_DataModal *)dataModal
{
    if( !dataModal ){
        dataModal = [[CondictionList_DataModal alloc] init];
        dataModal.str_ = @"全国";
    }
    
    switch ( ctl.type_ ) {
        case CondictionType_Region:
        {
            [locationBtn_ setTitle:dataModal.str_ forState:UIControlStateNormal];
            locationCity_ = dataModal.str_;
            
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
    
    [locationBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    [locationBtn_ setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
}


//返回地区进行查询
- (void)chooseCityToSearch:(SqlitData *)regionModel
{
    regionModel_ = regionModel;
    if (regionModel.provinceName.length >= 4) {
        [locationBtn_ setTitle:[regionModel.provinceName substringWithRange:NSMakeRange(0, 4)] forState:UIControlStateNormal];
    }else{
        [locationBtn_ setTitle:regionModel.provinceName forState:UIControlStateNormal];
    }
    [self refreshLoad:nil];
}

#pragma ChooseHotCityDelegate
-(void)chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    [locationBtn_ setTitle:city forState:UIControlStateNormal];
    locationCity_ = city;
    [self refreshLoad:nil];
}
#pragma mark-- UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
    [refreshFooterView_ setFrame:CGRectMake(0.0f, height, tableView_.frame.size.width, tableView_.bounds.size.height)];
    static NSString *CellIdentifier = @"SalaryCtlCell";
    
    SalaryCtl_Cell *cell = (SalaryCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SalaryCtl_Cell" owner:self options:nil] lastObject];
        //cell其他地方有使用
        cell.resumeLookBtn.hidden = NO;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    ELSalaryResultModel * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [cell setDataModal:dataModal];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 125;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_SalaryListCell;
        [NoLoginPromptCtl getNoLoginManager].indexPath = indexPath;
        return;
    }
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    SalaryGuideCtl *salaryGuideCtl = [[SalaryGuideCtl alloc] init];
    salaryGuideCtl.bgColor_ = [colorArr_ objectAtIndex:indexPath.row%4];
    NSString * regionid = [CondictionListCtl getRegionId:locationBtn_.titleLabel.text];
    if (!regionid) {
        regionid = @"";
    }
    salaryGuideCtl.regionId_ = regionid;
    salaryGuideCtl.noFromMessage_ = YES;
    ELSalaryResultModel * dataModal = selectData;
    if ([keyword_ length] > 0) {
        dataModal.zw_typename = keyword_;
        salaryGuideCtl.kwFlag_ = @"0";
    }else{
        salaryGuideCtl.kwFlag_ = @"1";
    }
    [self.navigationController pushViewController:salaryGuideCtl animated:YES];
    [salaryGuideCtl beginLoad:dataModal exParam:exParam];
    
    //记录友盟统计模块使用量
    NSDictionary * dict = @{@"Function":@"薪指"};
    [MobClick event:@"personused" attributes:dict];
}

- (void)getRegionSucess
{
    locationCity_ = [Manager shareMgr].regionName_;
    [locationBtn_ setTitle:locationCity_ forState:UIControlStateNormal];
    if (!locationCity_ || [locationCity_ isEqual:[NSNull null]]) {
        [locationBtn_ setTitle:@"全国" forState:UIControlStateNormal];
    }
    
    [self refreshLoad:nil];
}

-(void)hideKeyboard
{
    [_jobTF resignFirstResponder];
}

-(void)btnResponse:(id)sender
{
    [_jobTF resignFirstResponder];
    if(sender == locationBtn_)
    {//选择城市
        ChangeRegionViewController *vc = [[ChangeRegionViewController alloc] init];
        vc.blockString = ^(SqlitData *regionModel)
        {
            NSLog(@"%@ %@",regionModel.provinceld, regionModel.provinceName);
            [self chooseCityToSearch:regionModel];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender == _searchBtn)
    {//搜索
        SalarySearchListCtl2 *searchCtl = [[SalarySearchListCtl2 alloc]init];
        [self.navigationController pushViewController:searchCtl animated:YES];
 
        searchCtl.provinceId = [CondictionListCtl getRegionId:regionModel_.provinceName];
        searchCtl.provinceName = regionModel_.provinceName;
        
        
        if (!_jobTF.text) {
            _jobTF.text = @"";
        }
        
        keyword_ = [_jobTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([keyword_ isEqualToString:@""])
        {
            _jobTF.text = @"";
        }
        searchCtl.keyWords = _jobTF.text;
        if (self.isBtnHot) {
            searchCtl.kwFlag = @"0";
        }
        [searchCtl beginLoad:nil exParam:nil];
        return;
    }
    else if (sender == _loadMoreBtn)
    {//加载更多
        [refreshFooterView_ showFooterLoading2:tableView_];
        [self loadMoreData:requestCon_];
    }
    else if (sender == _exposureSalaryBtn)
    {//我也要曝工资
        _shouldShowExposureSalary = YES;
        [self showExposureView];
    }
    
}

//show/hide no data but load ok view
-(void) showNoDataOkView:(BOOL)flag
{
    [MyLog Log:[NSString stringWithFormat:@"showNoDataOkView flag=%d",flag] obj:self];
    
    if( flag ){
        [self performSelector:@selector(delayShowNoDataOkView) withObject:nil afterDelay:1.f];
    }else{
        [[self getNoDataView] removeFromSuperview];
    }
}

- (void)delayShowNoDataOkView
{
    UIView *noDataOkSuperView = [self getNoDataSuperView];
    UIView *noDataOkView = [self getNoDataView];
    if( noDataOkSuperView && noDataOkView ){
        [noDataOkSuperView addSubview:noDataOkView];
        
        //set the rect
        CGRect rect = noDataOkView.frame;
        rect.origin.y = tableView_.contentSize.height;
        rect.origin.x = (int)((tableView_.frame.size.width-rect.size.width)/2.0);
        rect.size.height = 266;
        [noDataOkView setFrame:rect];
    }
    else{
        [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
    }
}

#pragma mark scrollviewdelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollSet = scrollView.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [_jobTF resignFirstResponder];
}


-(void)chooseJob:(NSString *)jobName
{
    [_jobTF setText:jobName];
    [_searchBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 跳转到搜索的页面
-(void)pushSearchCtl
{
    [_searchBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_searchBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    return YES;
}


#pragma mark 退出登录
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_SalaryListCell:
        {
            NSIndexPath *index = [NoLoginPromptCtl getNoLoginManager].indexPath;
            if (index.row < requestCon_.dataArr_.count) {
                [self loadDetail:requestCon_.dataArr_[index.row] exParam:nil indexPath:index ];
            }
        }
            break;
        case LoginType_SalaryRightButton:{
            [self rightBarBtnResponse:nil];
        }
            break;
        default:
            break;
    }
}

- (void)backBarBtnResponse:(id)sender
{
    ExposureSalaryCtl2 *exposurCtl;
    if (self.childViewControllers.count) {
        exposurCtl = self.childViewControllers[0];
    }
    if ([exposurCtl.view superview]) {
        [exposurCtl viewTaped:nil];
        return;
    }
    [super backBarBtnResponse:sender];
}

- (void)dealloc
{
    [database close];
}

@end
