//
//  SalaryListCtl.m
//  jobClient
//
//  Created by YL1001 on 14/11/20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//看前景
#define kJobTagOffSet 200
#define kFootViewTag 101

#import "SalaryFutureListCtl.h"
#import "SalaryCtl_Cell.h"
#import "NoLoginPromptCtl.h"
#import "HotJob_DataModel.h"
#import "MoreMajorListCtl.h"
#import "SalaryFutureSearchListCtl.h"
#import "UIButton+WebCache.h"
#import "SalaryGuideCtl.h"

@interface SalaryFutureListCtl () <UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource, NoLoginDelegate>
{
    NSString             *keyword_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    SqlitData            *regionModel_;
    BOOL _shouldRefresh ;
    
    NSArray *_yearArray;
    NSMutableArray *_hotMajorArr;//热门专业
    RequestCon *_hotMajorCon;
}

@end

@implementation SalaryFutureListCtl

-(id)init
{
    self = [super init];
    bFooterEgo_ = YES;
    validateSeconds_ = 600;
    //增加键盘事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    regionModel_ = [[SqlitData alloc]init];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"看钱景";
    [self setNavTitle:@"看钱景"];
    _yearArray = @[@"毕业年限", @"1年内", @"1-2年", @"3-5年", @"6-10年", @"10年以上"];
    
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_yearBtn.titleLabel setFont:FOURTEENFONT_CONTENT];
    [_yearBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    [_majorTF setFont:FOURTEENFONT_CONTENT];
    [_majorTF setTextColor:BLACKCOLOR];
    regionModel_.provinceName = @"毕业后";
    [_yearBtn setTitle:_yearArray[0] forState:UIControlStateNormal];
    
    _queryInfo = [NSMutableDictionary dictionary];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        _shouldRefresh = YES;
    }
    if (_hotMajorCon) {
        [_hotMajorCon stopConnWhenBack];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([requestCon_.dataArr_ count] == 0 || _shouldRefresh ) {
        [self refreshLoad:requestCon_];
    }
//    self.navigationItem.title = @"看钱景";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)updateCom:(RequestCon *)con
{
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!_hotMajorCon) {//热门专业
        _hotMajorCon = [self getNewRequestCon:NO];
        [_hotMajorCon getSalaryHotJobList:1];
    }
    
    regionModel_.provinceld = [CondictionListCtl getRegionId:regionModel_.provinceName];
    
    if (!regionModel_.provinceld) {
        regionModel_.provinceld = @"";
    }
    if (!_majorTF.text) {
        _majorTF.text = @"";
    }
    
    keyword_ = [_majorTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([keyword_ isEqualToString:@""])
    {
        _majorTF.text = @"";
    }
    //请求应届生薪指列表
    [con getFreshSalaryList:_majorTF.text minWorkAge:@"0"  maxWorkAge:@"100" regionId:regionModel_.provinceld page:requestCon_.pageInfo_.currentPage_ pageSize:20];

}



-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        
        case Request_FreshSalaryList://薪指预测列表
        {
            _shouldRefresh = NO;
            if (dataArr.count <= 0) {
                self.imgTopSpace = 90;
            }
        }
            break;
        case Request_SalaryHotJobList://热门专业
        {
            _hotMajorArr = [NSMutableArray arrayWithArray:dataArr];
            HotJob_DataModel *moreModel = [[HotJob_DataModel alloc]init];
            moreModel.jobName = @"更多专业";
            [_hotMajorArr addObject:moreModel];
            [self layoutHotMajor];
        }
            break;
        default:
            break;
    }
}


#pragma mark 显示热门专业
- (void)layoutHotMajor
{
    CGFloat padding =5.f;
    CGFloat itemW = (ScreenWidth-20)/3;
    CGFloat itemH = 35.f;
    CGFloat yStart = 30;
    for (int i=0; i<_hotMajorArr.count; i++) {
        HotJob_DataModel *jobModel = _hotMajorArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + kJobTagOffSet;
        
        btn.backgroundColor = [UIColor whiteColor];
        int line = i/3;
        int column = i%3;
        btn.frame = CGRectMake(padding +(padding +itemW)*column, yStart+padding +(padding +itemH)*line, itemW, itemH);
        [btn setTitle:jobModel.jobName forState:UIControlStateNormal];
        if (i== _hotMajorArr.count-1) {//更多专业
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"iocn_salary_bg.png"] forState:UIControlStateSelected];
        
        btn.titleLabel.font = TWEELVEFONT_COMMENT;
        [_headerView addSubview:btn];
        [btn addTarget:self action:@selector(hotMajorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    CGFloat line = (_hotMajorArr.count-1)/3;//line从0开始
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

- (void)hotMajorBtnClick:(UIButton *)sender
{
    if (_selectedMajorBtn !=sender ) {
        if (_selectedMajorBtn.selected) {
             _selectedMajorBtn.selected= NO;
        }
    }else{
        if (_selectedMajorBtn.selected) {
            _selectedMajorBtn.selected= NO;
            return;
        }
    }
    sender.selected= YES;
    NSInteger index = sender.tag - kJobTagOffSet;
    HotJob_DataModel *model = _hotMajorArr[index];
    NSString *title = model.jobName;
    _selectedMajorBtn = sender;
    if ([title isEqualToString:@"更多专业"]) {
        MoreMajorListCtl *majorCtl = [[MoreMajorListCtl alloc]init];
        [self.navigationController pushViewController:majorCtl animated:YES];
        [majorCtl beginLoad:nil exParam:nil];
        return;
    }
    _majorTF.text = title;
    _queryInfo[@"matchModel"] = @"equal";
    _queryInfo[@"keywords"] = title;
    [_searchBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}



#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
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
    [_majorTF resignFirstResponder];
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

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
    }
    ELSalaryResultModel *model = requestCon_.dataArr_[indexPath.row];
    [cell setDataModalOne:model];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 125;
    
    
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    //记录友盟统计模块使用量
    NSDictionary * dict = @{@"Function":@"薪指"};
    [MobClick event:@"personused" attributes:dict];
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    SalaryGuideCtl *salaryGuideCtl = [[SalaryGuideCtl alloc] init];
    [self.navigationController pushViewController:salaryGuideCtl animated:YES];
    ELSalaryResultModel * dataModal = selectData;
    if ([keyword_ length] > 0) {
        dataModal.zym = keyword_;
        salaryGuideCtl.kwFlag_ = @"0";
    }
    else{
        salaryGuideCtl.kwFlag_ = @"1";
    }
    NSString * regionid = [CondictionListCtl getRegionId:_yearBtn.titleLabel.text];
    if (!regionid) {
        regionid = @"";
    }
    salaryGuideCtl.regionId_ = regionid;
    salaryGuideCtl.noFromMessage_ = YES;
    [salaryGuideCtl beginLoad:dataModal exParam:exParam];

}

-(void)hideKeyboard
{
    [_majorTF resignFirstResponder];
}

-(void)btnResponse:(id)sender
{
    [_majorTF resignFirstResponder];
    if(sender == _yearBtn){//选择时间
        [self showYearView];
    }
    else if (sender == _searchBtn) {//搜索
        SalaryFutureSearchListCtl *searchCtl = [[SalaryFutureSearchListCtl alloc]init];
        searchCtl.queryInfo = _queryInfo;
        [self.navigationController pushViewController:searchCtl animated:YES];
        if (!_majorTF.text) {
            _majorTF.text = @"";
        }
        
        keyword_ = [_majorTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([keyword_ isEqualToString:@""])
        {
            _majorTF.text = @"";
        }
        NSString *yearStr = _yearBtn.titleLabel.text;
        searchCtl.workAge = yearStr;
        searchCtl.majorName = _majorTF.text;
        [searchCtl beginLoad:nil exParam:nil];
        return;
    }
    
}

-(void)pushSearchCtl
{
    SalaryFutureSearchListCtl *searchCtl = [[SalaryFutureSearchListCtl alloc]init];
    
    [self.navigationController pushViewController:searchCtl animated:YES];
    if (!_majorTF.text) {
        _majorTF.text = @"";
    }
    
    keyword_ = [_majorTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([keyword_ isEqualToString:@""])
    {
        _majorTF.text = @"";
    }
    NSString *yearStr = _yearBtn.titleLabel.text;
    searchCtl.workAge = yearStr;
    searchCtl.majorName = _majorTF.text;
    _queryInfo[@"matchModel"] = @"equal";
    _queryInfo[@"keywords"] = _majorTF.text;
    searchCtl.queryInfo = _queryInfo;
    [searchCtl beginLoad:nil exParam:nil];
}

#pragma makr 显示选择时间
- (void)showYearView
{
    UIView *containerView = [[UIView alloc]initWithFrame:self.view.bounds];
    UIView *mask = [[UIView alloc]initWithFrame:containerView.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.5;
    [MyCommon addTapGesture:mask target:self numberOfTap:1 sel:@selector(maskViewClick)];
    [containerView addSubview:mask];
    CGFloat pickY = CGRectGetHeight(containerView.frame) - 160;
    UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, pickY, ScreenWidth, 160)];
    pickView.delegate =self;
    pickView.dataSource = self;
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.showsSelectionIndicator = YES;
    [containerView addSubview:pickView];
    _pickView = pickView;
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    finishBtn.frame = CGRectMake(ScreenWidth-40, pickY, 40, 40);
    [containerView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(selectYearClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:containerView];
    _containerView = containerView;
}

- (void)maskViewClick
{
    [_containerView removeFromSuperview];
}

- (void) selectYearClick
{
    NSInteger row = [_pickView selectedRowInComponent:0];
    [_yearBtn setTitle:[_yearArray objectAtIndex:row] forState:UIControlStateNormal];
    [self maskViewClick];
}

//show/hide no data but load ok view
-(void) showNoDataOkView:(BOOL)flag
{
    [MyLog Log:[NSString stringWithFormat:@"showNoDataOkView flag=%d",flag] obj:self];
    
    if( flag ){
        UIView *noDataOkSuperView = [self getNoDataSuperView];
        UIView *noDataOkView = [self getNoDataView];
        if( noDataOkSuperView && noDataOkView ){
            [noDataOkSuperView addSubview:noDataOkView];
            
            //set the rect
            CGRect rect = noDataOkView.frame;
            float x = (int)((tableView_.frame.size.width - rect.size.width)/2.0);
            float y = tableView_.frame.origin.y + _headerView.frame.size.height - 74;
            CGRect rect1 = CGRectMake(x, y, rect.size.width, rect.size.height);
            [noDataOkView setFrame:rect1];
        }else{
            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
        }
    }else{
        [[self getNoDataView] removeFromSuperview];
    }
}

- (void)reciveNewMesageAction:(NSNotificationCenter *)notifcation
{
    
}

-(void)chooseJob:(NSString *)jobName
{
    [_majorTF setText:jobName];
    [self refreshLoad:nil];
}


#pragma mark ---------pickview delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

 - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _yearArray[row];
}

 - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _yearArray.count;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_searchBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *keywords = _queryInfo[@"keywords"];
    if (![keywords isEqualToString:textField.text ]) {
        _queryInfo[@"matchModel"] = @"like";
    }
}

#pragma mark 退出登录
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

@end
