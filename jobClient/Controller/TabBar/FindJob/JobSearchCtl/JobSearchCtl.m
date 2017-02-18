//
//  JobSearchCtl.m
//  jobClient
//
//  Created by 一览ios on 15-1-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "JobSearchCtl.h"
#import "JobSearchTableViewCell.h"
#import "MyJobSearchCtlCell.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "NewJobPositionDataModel.h"
#import "ZWDetail_DataModal.h"
#import "ELJobSearchChangeListCtl.h"
#import "New_HeaderBtn.h"
#import "FBRegionCtl.h"

#define kBTN_TAG 10000
#define kSelBtnTag 98760

@interface JobSearchCtl () <CondictionChooseDelegate,ConditionItemCtlDelegate,changeJobSearchCondictionDelegate,New_HeaderDelegate,ELSearchChangeDeleagte>
{
    IBOutlet UIButton *cancelBtn;
    UIView *tapView;
    CondictionList_DataModal        *regionDataModal_;
    CondictionList_DataModal        *tradeDataModal_;
    ELJobSearchCondictionChangeCtl *condictionCtl;
    
    NSArray *titleArr;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
    UIView *bgView;
    ELJobSearchChangeListCtl *searchChangeList;
    
    NSArray *leftButtonRegion;
    NSArray *leftButtonBack;
    UILabel *rightRegionLb;
    NSString *rightRegionName;
    NSString *rightRegionId;
    BOOL selectHot;
    
    BOOL isAlreadySearch;
}

@end

@implementation JobSearchCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (tableView_.hidden) {
        [self changeRightButtonStatusWithType:1];
    }else{
        [self changeRightButtonStatusWithType:2];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    searchBar_.hidden = YES;
    bgView.hidden = YES;
    [super viewWillDisappear:animated];
    [searchBar_ resignFirstResponder];
    if (condictionCtl) {
        [condictionCtl hideView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    searchBar_.hidden = NO;
    [super viewDidAppear:animated];
}

#pragma mark--初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
//注册通知
    [self addObserVer];
//配置searchBar
    [self configSearchBar];
//配置条件筛选按钮
    [self configUI];
//初始化搜索条件
    [self loadBeginData];
}

-(void)configSearchBar{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    searchBar_.hidden = YES;
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    [searchBar_ setBackgroundImage:[UIImage imageNamed:@""]];
    [searchBar_ setBackgroundColor:PINGLUNHONG];
    self.navigationItem.titleView = searchBar_;

    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
    
    tableView_.hidden = YES;
    tapView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,568)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tapView addGestureRecognizer:tap];
    [searchBar_ becomeFirstResponder];
    searchBar_.delegate = self;
    
    searchChangeList = [[ELJobSearchChangeListCtl alloc] init];
    searchChangeList.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
    if (_searchParam) {
        searchChangeList.tradeId = _searchParam.tradeId_;
    }
    searchChangeList.searchDelegate = self;
    [self.view addSubview:searchChangeList];
    [self.view sendSubviewToBack:searchChangeList];
}
#pragma mark - ELSearchChangeDeleagte

-(void)searchHideKeyBoard{
    [searchBar_ resignFirstResponder];
}
-(void)selectCellRefreshKeyWord:(NSString *)keyWord{
    searchBar_.text = keyWord;
    tableView_.hidden = NO;
    [self changeRightButtonStatusWithType:2];
    [self beginLoad:nil exParam:nil];
}
-(void)selectCellRefreshWithModel:(SearchParam_DataModal *)dataModal{
    New_HeaderBtn *regionBtn = [self.view viewWithTag:kSelBtnTag];
    New_HeaderBtn *tradeBtn = [self.view viewWithTag:kSelBtnTag + 1];
    _searchParam.searchKeywords_ = dataModal.searchKeywords_;
    _searchParam.regionId_ = dataModal.regionId_;
    _searchParam.regionStr_ = dataModal.regionStr_;
    _searchParam.tradeId_ = dataModal.tradeId_;
    _searchParam.tradeStr_ = dataModal.tradeStr_;
    
    tradeDataModal_.id_ = _searchParam.tradeId_;
    tradeDataModal_.str_ = _searchParam.tradeStr_;
    
    tableView_.hidden = NO;
    [self changeRightButtonStatusWithType:2];
    searchBar_.text = dataModal.searchKeywords_;
    regionBtn.titleLb.text = dataModal.regionStr_;
    if (!dataModal.tradeStr_ || dataModal.tradeStr_.length <= 0 || [dataModal.tradeStr_ isEqualToString:@"(null)"] || [dataModal.tradeStr_ isEqualToString:@""]) {
        tradeBtn.titleLb.text = @"所有行业";
    }
    else{
        tradeBtn.titleLb.text = dataModal.tradeStr_;
    }
    [self beginLoad:nil exParam:nil];
}

-(void)configUI{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [_searchContentView_ addSubview:headerView];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 108, ScreenWidth, ScreenHeight - 64 - 44)];
    bgView.backgroundColor = UIColorFromRGB(0x000000);
    bgView.alpha = 0.4;
    bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    NSString *region = _searchParam.regionStr_?_searchParam.regionStr_:@"地区";
    NSString *trade = _searchParam.tradeStr_?_searchParam.tradeStr_:@"所有行业";
    titleArr = @[region,trade,@"月薪",@"更多"];
    for (int i = 0; i < titleArr.count; i++) {
        New_HeaderBtn *selBtn = [[New_HeaderBtn alloc]initWithFrame:CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44) withTitle:titleArr[i]arrCount:titleArr.count];
        selBtn.delegate = self;
        selBtn.frame = CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44);
        selBtn.tag = kSelBtnTag + i;
        [headerView addSubview:selBtn];
    }
    [self.view bringSubviewToFront:headerView];
}

-(void)loadBeginData{
    [searchBar_ setText:_searchParam.searchKeywords_];
    [searchBar_ becomeFirstResponder];
    
    _searchParam.eduId_ = @"";
    _searchParam.payMentValue_ = @"";
    _searchParam.workAgeValue_ = @"";
    _searchParam.workTypeValue_ = @"";
    _searchParam.workTypeName_ = @"";
    _searchParam.eduName_ = @"";
    _searchParam.payMentName_ = @"";
    _searchParam.timeName_ = @"";
    _searchParam.workAgeName_ = @"";
    
    tableView_.tableHeaderView = self.searchContentView_;
    
    New_HeaderBtn *regionbtn = [self.view viewWithTag:kSelBtnTag];
    regionbtn.titleLb.text = _oldSearchParam.regionStr_;
    New_HeaderBtn *tradeBtn = [self.view viewWithTag:(kSelBtnTag+1)];
    tradeBtn.titleLb.text = _oldSearchParam.tradeStr_?_oldSearchParam.tradeStr_:@"所有行业";
    _searchParam.tradeStr_ = tradeBtn.titleLb.text;
    tradeDataModal_ = [[CondictionList_DataModal alloc]init];
}

#pragma mark--加载数据
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)updateCom:(RequestCon *)con
{
    //[super updateCom:con];
}

#pragma mark--数据请求
- (void)getDataFunction:(RequestCon *)con
{
    New_HeaderBtn *regionBtn = [self.view viewWithTag:kSelBtnTag];
    NSString *keyWord = [searchBar_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _searchParam.searchKeywords_ = keyWord;
    if ([[Manager shareMgr] haveLogin])
    {
        [searchChangeList saveKeyWord:keyWord searchModel:_searchParam];
    }
    
    if (rightRegionName && ![rightRegionName isEqualToString:@""]) {
        if (![rightRegionName isEqualToString:_searchParam.regionStr_]) {
            _searchParam.regionStr_ = rightRegionName;
            _searchParam.regionId_ = rightRegionId;
            _searchParam.isSelected = selectHot;
            New_HeaderBtn *regionbtn = [self.view viewWithTag:kSelBtnTag];
            regionbtn.titleLb.text = _searchParam.regionStr_;
        }
    }
    
    if ([_searchParam.regionId_ isEqualToString:@""] || _searchParam.regionId_ == nil)
    {
        regionBtn.titleLb.text = @"不限";
        _searchParam.regionId_ = @"100000";
        _searchParam.regionStr_ = @"不限";
    }
    [con getFindJobList:_searchParam.tradeId_ regionId:_searchParam.regionId_ kw:_searchParam.searchKeywords_ time:_searchParam.timeStr_ eduId:_searchParam.eduId_ workAge:_searchParam.workAgeValue_ workAge1:nil payMent:_searchParam.payMentValue_  workType:_searchParam.workTypeValue_ page:requestCon_.pageInfo_.currentPage_ pageSize:18 highlight:@"1"];
    isAlreadySearch = YES;
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_FindJobList:
        {
            for (int i = 0; i < [dataArr count]; i++)
            {
                NewJobPositionDataModel *dataModal = [dataArr objectAtIndex:i];
                dataModal.tagColor = [_colorArr objectAtIndex:(i%_colorArr.count)];
                
                dataModal.positionAttstring = [[NSMutableAttributedString alloc] initWithString:dataModal.jtzw];
                [self changeColor:dataModal.positionAttstring withSearchKeyWord:searchBar_.text];

                NSString *companyname;
                if (dataModal.cname.length > 0)
                {
                    companyname = dataModal.cname;
                }else
                {
                    companyname = dataModal.cname_all;
                }
                dataModal.companyAttString = [[NSMutableAttributedString alloc] initWithString:companyname];
                [self changeColor:dataModal.companyAttString withSearchKeyWord:searchBar_.text];
            }
        }
            break;

        default:
            break;
    }
    
}

-(void)changeColor:(NSMutableAttributedString *)attString withSearchKeyWord:(NSString *)text
{
    NSString *fontLeft = @"<font color=red>";
    NSString *fontRight = @"</font>";
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    if ([attString.string containsString:fontLeft])
    {
        NSInteger startIndex = 10000;
        BOOL saveString = NO;
        
        for (NSInteger i = 0; i<attString.string.length;)
        {
            NSString *string = [attString.string substringFromIndex:i];
            NSString *str = @"";
            if (saveString && [string containsString:fontRight])
            {
                str = [attString.string substringWithRange:NSMakeRange(i,fontRight.length)];
            }
            else if([string containsString:fontLeft])
            {
                str = [attString.string substringWithRange:NSMakeRange(i,fontLeft.length)];
            }
            
            if ([str isEqualToString:fontLeft])
            {
                [arr addObject:[NSValue valueWithRange:NSMakeRange(i,fontLeft.length)]];
                i += (fontLeft.length);
                startIndex = i;
                saveString = YES;
            }
            else if([str isEqualToString:fontRight] && startIndex < i)
            {
                [arr addObject:[NSValue valueWithRange:NSMakeRange(i,fontRight.length)]];
                
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(startIndex,i-startIndex)];
                i += (fontRight.length);
                startIndex = 100000;
                saveString = NO;
            }
            else
            {
                i++;
            }
        }
    }else if ([attString.string rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound){
        for (NSInteger i = 0; i<=(attString.string.length-text.length) ;i++)
        {
            NSString *str = [attString.string substringWithRange:NSMakeRange(i,text.length)];
            if ([str rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i,text.length)];
            }
        }
    }
    
    for (NSInteger i = arr.count-1;i>=0; i--)
    {
        [attString replaceCharactersInRange:[arr[i] rangeValue] withString:@""];
    }
}

- (void)changConditionLbView
{
    NSString *tempString = @"";
    if (_searchParam.workAgeName_ != nil && ![_searchParam.workAgeName_ isEqualToString:@"不限"] && ![_searchParam.workAgeName_ isEqualToString:@""]) {
        tempString = _searchParam.workAgeName_;
    }
    if (_searchParam.timeName_ != nil && ![_searchParam.timeName_ isEqualToString:@"所有日期"] && ![_searchParam.timeName_ isEqualToString:@""]) {
        if (![tempString isEqualToString:@""]) {
            tempString = [NSString stringWithFormat:@"%@-%@",tempString, _searchParam.timeName_];
        }else{
            tempString = _searchParam.timeName_;
        }
    }
    if (_searchParam.eduName_ != nil && ![_searchParam.eduName_ isEqualToString:@"不限"] && ![_searchParam.eduName_ isEqualToString:@""]) {
        if (![tempString isEqualToString:@""]) {
            tempString = [NSString stringWithFormat:@"%@-%@",tempString, _searchParam.eduName_];
        }else {
            tempString = _searchParam.eduName_;
        }
    }
    if (_searchParam.workTypeName_ != nil && ![_searchParam.workTypeName_ isEqualToString:@"不限"] && ![_searchParam.workTypeName_ isEqualToString:@""]) {
        if (![tempString isEqualToString:@""]) {
            tempString = [NSString stringWithFormat:@"%@-%@",tempString, _searchParam.workTypeName_];
        }else{
            tempString = _searchParam.workTypeName_;
        }
    }
}

- (void)chooseCityToSearch:(SqlitData *)regionModel
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = regionModel.provinceName;
    dataModal.id_ = regionModel.provinceld;
    dataModal.bSelected_ = regionModel.selected;
    
    regionDataModal_ = dataModal;
    
    //地区参数添加道搜索参数
    _searchParam.regionStr_ = dataModal.str_;
    _searchParam.regionId_ = dataModal.id_;
    _searchParam.isSelected = dataModal.bSelected_;
    New_HeaderBtn *regionbtn = [self.view viewWithTag:kSelBtnTag];
    regionbtn.titleLb.text = _searchParam.regionStr_;
//    [self setBtnTitle:_searchParam.regionStr_];
    //地区参数改变后自动请求
    rightRegionName = dataModal.str_;
    rightRegionId = dataModal.id_;
    selectHot = dataModal.bSelected_;
    if ([rightRegionName isEqualToString:@"不限"]) {
        rightRegionLb.text = @"地区";
    }else{
        rightRegionLb.text = rightRegionName;
    }
    [self refreshLoad:nil];
}

#pragma mark--代理
//条件筛选代理
-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType)
    {
        case RegionChange:
        {
            SqlitData *modal = (SqlitData *)dataModel;
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            [self chooseCityToSearch:modal];
        }
            break;
        case TradeChange:
        {
            
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            tradeDataModal_ = (CondictionList_DataModal *)dataModel;
            if( !tradeDataModal_ || tradeDataModal_.id_ == nil ){
                //                [_tradeBtn setTitle:@"所有行业" forState:UIControlStateNormal];
                selectedBtn.titleLb.text = @"所有行业";
                _searchParam.tradeId_ = @"1000";
                _searchParam.tradeStr_ = @"所有行业";
            }else{
                //                [_tradeBtn setTitle:tradeDataModal_.str_ forState:UIControlStateNormal];
                selectedBtn.titleLb.text = tradeDataModal_.str_;
                _searchParam.tradeId_ = tradeDataModal_.id_;
                _searchParam.tradeStr_ = tradeDataModal_.str_;
            }
            [self refreshLoad:nil];
        }
            break;
        case SalaryMonthChange:
        {
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            
            CondictionList_DataModal *modal = (CondictionList_DataModal *)dataModel;
            _searchParam.payMentValue_ = modal.id_;
            _searchParam.payMentName_ = modal.str_;
            if ([modal.id_ isEqualToString:@"lt||3000"]) {
                //                [_salaryBtn setTitle:@"3000以下" forState:UIControlStateNormal];
                selectedBtn.titleLb.text = @"3000以下";
            }else if ([modal.id_ isEqualToString:@"gte||3000"]) {
                //                [_salaryBtn setTitle:@"3000以上" forState:UIControlStateNormal];
                selectedBtn.titleLb.text = @"3000以上";
            }else if ([modal.id_ isEqualToString:@"gte||5000"]) {
                //                [_salaryBtn setTitle:@"5000以上" forState:UIControlStateNormal];
                selectedBtn.titleLb.text = @"5000以上";
            }else if ([modal.id_ isEqualToString:@"gte||7000"]){
                //                [_salaryBtn setTitle:@"7000以上" forState:UIControlStateNormal];
                selectedBtn.titleLb.text = @"7000以上";
            }else if ([modal.id_ isEqualToString:@"gte||10000"]){
                //                [_salaryBtn setTitle:@"10000" forState:UIControlStateNormal];
                selectedBtn.titleLb.text = @"10000";
            }else{
                //                [_salaryBtn setTitle:searchParam_.payMentName_ forState:UIControlStateNormal];
                selectedBtn.titleLb.text = _searchParam.payMentName_;
            }
            [self refreshLoad:nil];
        }
            break;
        case MoreChange:
        {
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

- (void)conditionSelectedOK:(SearchParam_DataModal *)searchParam
{
    _searchParam = searchParam;
    [self refreshLoad:nil];
    [self changConditionLbView];
}

#pragma mark -UISearchBar 代理
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self changeRightButtonStatusWithType:1];
    searchChangeList.iskeyboardShow = YES;
    tableView_.hidden = YES;
    if (searchBar_.text.length > 0) {
        NSString *regionId = _searchParam.regionId_;
        if (rightRegionId) {
            regionId = rightRegionId;
        }
        [searchChangeList searchBarDidChange:searchBar_.text tradeId:_searchParam.tradeId_ regionId:regionId];
    }
    _searchParam.searchKeywords_ = searchBar_.text;
    [tableView_ addSubview:tapView];
    if (condictionCtl) {
        [condictionCtl hideView];
    }
    if (nowBtn.isSelected) {
        [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
        nowBtn.isSelected = !nowBtn.isSelected;
        bgView.hidden = YES;
    }
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar_ resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _searchParam.searchKeywords_ = searchBar_.text;
    tableView_.hidden = NO;
    [self changeRightButtonStatusWithType:2];
    [self beginLoad:nil exParam:nil];
    [searchBar_ resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar == searchBar_){
        tableView_.hidden = YES;
        NSString *regionId = _searchParam.regionId_;
        if (rightRegionId) {
            regionId = rightRegionId;
        }
        [searchChangeList searchBarDidChange:searchBar_.text tradeId:_searchParam.tradeId_ regionId:regionId];
    }
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [tapView removeFromSuperview];
    searchChangeList.iskeyboardShow = NO;
    return YES;
}
#pragma mark - UITableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyJobSearchCtlCell";
    MyJobSearchCtlCell *cell = (MyJobSearchCtlCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobSearchCtlCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if(indexPath.row >= requestCon_.dataArr_.count){
        return cell;
    }
    NewJobPositionDataModel *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    NSString *companyname = @"";
    if (dataModal.cname.length > 0) {
        companyname = dataModal.cname;
    }else
    {
        companyname = dataModal.cname_all;
    }
    BOOL isky = NO;
    if ([dataModal.is_ky isEqualToString:@"2"]) {
        isky = YES;
    }
    else{
        isky = NO;
    }
    [cell cellInitWithImage:dataModal.logo positionName:dataModal.jtzw time:dataModal.updatetime companyName:companyname salary:dataModal.xzdy welfare:dataModal.fldy region:dataModal.regionname gznum:dataModal.gznum edu:dataModal.edus count:nil  tagColor:dataModal.tagColor isky:isky];
    cell.positionNameLb_.attributedText = dataModal.positionAttstring;
    cell.companyNameLb_.attributedText = dataModal.companyAttString;
    
    //cell.positionNameLb_.frame = CGRectMake(88,12,215-cell.regionLb_.frame.size.width,14);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NewJobPositionDataModel *dataModal = requestCon_.dataArr_[indexPath.row];
        if (![dataModal.zptype isEqualToString:@"1"]) {
            [BaseUIViewController showAlertView:@"" msg:@"该职位已停招" btnTitle:@"关闭"];
            return;
        }
        if (_fromMessageList)
        {
            JobSearch_DataModal *modal = [[JobSearch_DataModal alloc] init];
            modal.zwID_ = dataModal.positionId;
            modal.zwName_ = dataModal.jtzw;
            modal.jtzw_ = dataModal.jtzw;
            modal.companyLogo_ = dataModal.logo;
            modal.companyName_ = dataModal.cname;
            modal.companyID_ = dataModal.uid;
            modal.salary_ = dataModal.xzdy;
            [self.myJobSearchCtl.messageDelegate jobSearchMessageDelegateModal:modal];
            for (id ctl in self.navigationController.viewControllers)
            {
                if ([ctl isKindOfClass:[MessageDailogListCtl class]])
                {
                    [self.navigationController popToViewController:ctl animated:YES];
                    break;
                }
            }
            return;
        }
        ZWDetail_DataModal *zwVO = [ZWDetail_DataModal new];
        zwVO.zwID_ = dataModal.positionId;
        zwVO.zwName_ = dataModal.jtzw;
        zwVO.companyID_ = dataModal.uid;
        PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:zwVO exParam:nil];
        return;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView_)
    {
        if (indexPath.row >= requestCon_.dataArr_.count) {
            return 0;
        }
        NewJobPositionDataModel *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        if ([dataModal.fldy isKindOfClass:[NSNull class]] || dataModal.fldy.count == 0) {
            return 95;
        }else{
            return 118;
        }
    }
    return 44;
}
#pragma mark--scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == tableView_)
    {
        [super scrollViewDidScroll:scrollView];
    }
    if ([searchBar_ isFirstResponder]) {
        [searchBar_ resignFirstResponder];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == tableView_) {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark-- New_HeaderDelegate 条件选择按钮点击事件
-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender{
    New_HeaderBtn *btn = (New_HeaderBtn *)sender.view;
    NSInteger idx = btn.tag - kSelBtnTag;
    nowBtn = btn;
    if (![btn isEqual:selectedBtn]) {
        bgView.hidden = NO;
        btn.titleImg.image = [UIImage imageNamed:@"小筛选下拉more-sel"];
        btn.markImg.hidden = NO;
        btn.titleLb.textColor = UIColorFromRGB(0xe13e3e);
        selectedBtn.markImg.hidden = YES;
        selectedBtn.titleImg.image = [UIImage imageNamed:@"小筛选下拉more"];
        selectedBtn.titleLb.textColor = UIColorFromRGB(0x333333);
        
        selectedBtn = btn;
        selectedBtn.isSelected = YES;
    }
    else{
        [self btnSetting:btn];
    }
    
    if (idx == 0) {
        SqlitData *data = [[SqlitData alloc] init];
        data.provinceld = _searchParam.regionId_;
        data.selected = _searchParam.isSelected;
        [self selectedType:RegionChange Model:data nowSelBtn:btn];
    }
    else if(idx == 1){
        [self selectedType:TradeChange Model:tradeDataModal_ nowSelBtn:btn];
    }
    else if(idx == 2){
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        modal.id_ = _searchParam.payMentValue_;
        modal.str_ = _searchParam.payMentName_;
        [self selectedType:SalaryMonthChange Model:modal nowSelBtn:btn];
    }
    else{
        [self selectedType:MoreChange Model:_searchParam nowSelBtn:btn];
    }
}

#pragma mark--通知
-(void)addObserVer{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moreCacel:) name:@"moreCacel" object:nil];
}

-(void)moreCacel:(NSNotification *)notyfi{
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    nowBtn.isSelected = !nowBtn.isSelected;
    bgView.hidden = YES;
}

-(void)dealloc{
    [bgView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark-- 事件
-(void)tap:(UITapGestureRecognizer *)sender
{
    [searchBar_ resignFirstResponder];
    [tapView removeFromSuperview];
}

#pragma mark--业务逻辑
-(void)btnSetting:(New_HeaderBtn *)btn{
    if (!btn.isSelected) {
        [self dealBtn:btn withColor:UIColorFromRGB(0xe13e3e) bgStatus:NO imageName:@"小筛选下拉more-sel"];
    }
    else{
        [self dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    }
    btn.isSelected = !btn.isSelected;
}

-(void)dealBtn:(New_HeaderBtn *)btn withColor:(UIColor *)color bgStatus:(BOOL)bgState imageName:(NSString *)imgName{
    bgView.hidden = bgState;
    btn.titleImg.image = [UIImage imageNamed:imgName];
    btn.titleLb.textColor = color;
    btn.markImg.hidden = bgState;
}

-(void)selectedType:(CondictionChangeType)conditionType Model:(id)model nowSelBtn:(New_HeaderBtn *)selBtn{
    if (!condictionCtl)
    {
        condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,108,ScreenWidth,ScreenHeight - 108)];
        condictionCtl.delegate_ = self;
    }
    if (condictionCtl.currentType == conditionType)
    {
        [condictionCtl hideView];
        return;
    }
    [condictionCtl hideView];
    [condictionCtl creatViewWithType:conditionType selectModal:model];
    [condictionCtl showView];
}

- (IBAction)cancelBtnRespone:(UIButton *)sender
{
    if (isAlreadySearch && tableView_.hidden) {
        [searchBar_ resignFirstResponder];
        tableView_.hidden = NO;
        [self changeRightButtonStatusWithType:2];  
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 修改右上角按钮 type1为地区选择 2为返回
-(void)changeRightButtonStatusWithType:(NSInteger)type{
    if (type == 1) {
        if (!leftButtonRegion) {
            UIView *backBtnView = [[UIView alloc] initWithFrame:CGRectMake(0,0,70,40)];
            rightRegionLb = [[UILabel alloc] initWithFrame:CGRectMake(0,0,55,40)];
            rightRegionLb.textColor = [UIColor whiteColor];
            rightRegionLb.font = [UIFont systemFontOfSize:15];
            rightRegionLb.textAlignment = NSTextAlignmentCenter;
            rightRegionLb.numberOfLines = 1;
            if (_searchParam.regionStr_){
                rightRegionLb.text = _searchParam.regionStr_;
            }else{
               rightRegionLb.text = @"地区"; 
            }
            [backBtnView addSubview:rightRegionLb];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(55,15,15,9)];
            image.image = [UIImage imageNamed:@"jobsearch_bottom"];
            [backBtnView addSubview:image];
            backBtnView.userInteractionEnabled = YES;
            [backBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightRegionBtnRespone)]];
            
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = -15;
            leftButtonRegion = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
        }
        self.navigationItem.leftBarButtonItems = leftButtonRegion;
        
    }else if (type == 2){
        if (!leftButtonBack) {
            UIView *backBtnView = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,40)];
            [backBtnView addSubview:backBarBtn_];
            backBarBtn_.origin = CGPointMake(0, backBtnView.center.y - backBarBtn_.frame.size.height/2);
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = -15;
            leftButtonBack = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
        }
        self.navigationItem.leftBarButtonItems = leftButtonBack;
    }
}

-(void)rightRegionBtnRespone{
    //PersonDetailInfo_DataModal *dataModal = personDataModal;
    FBRegionCtl *ctl = [[FBRegionCtl alloc] init];
    ctl.isShowLocation = YES;
    ctl.showQuanGuo = YES;
    ctl.selectName = rightRegionName;
    ctl.selectId = rightRegionId;
    ctl.selectHotCity = selectHot;
    ctl.block = ^(NSString *regionName,NSString *regionId,BOOL selectHotCity){
        rightRegionName = regionName;
        rightRegionId = regionId;
        selectHot = selectHotCity;
        if ([regionName isEqualToString:@"不限"]) {
            rightRegionLb.text = @"地区";
        }else{
            rightRegionLb.text = regionName;
        }
        NSString *searchStr = [searchBar_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (searchStr.length > 0) {
            NSString *regionId = _searchParam.regionId_;
            if (rightRegionId) {
                regionId = rightRegionId;
            }
            [searchChangeList searchBarDidChange:searchBar_.text tradeId:_searchParam.tradeId_ regionId:regionId];
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)backBarBtnResponse:(id)sender
{
    self.searchBlock(_searchParam,NO);
    [self.navigationController popViewControllerAnimated:YES];
}

//网络异常提示
- (void)showErrorView:(BOOL)flag
{
    //显示
    if( flag ){
        UIView *superView = [self getErrorSuperView];
        UIView *myView = [self getErrorView];
        
        if( superView && myView ){
            [myView removeFromSuperview];
            [superView addSubview:myView];
            
            //set the rect
            CGRect rect = myView.frame;
            
            rect.origin.x = (int)((superView.frame.size.width - rect.size.width)/2.0);
            rect.origin.y = (int)((superView.frame.size.height - rect.size.height)/2.0+44);
            [myView setFrame:rect];
        }else{
            [MyLog Log:@"error view's super view or error view is null" obj:self];
        }
    }
    //不显示
    else{
        [[self getErrorView] removeFromSuperview];
    }
}

- (void) showNoDataOkView:(BOOL)flag
{
    [MyLog Log:[NSString stringWithFormat:@"showNoDataOkView flag=%d",flag] obj:self];
    
    if( flag){
//        UIView *noDataOkSuperView = [self getNoDataSuperView];
//        UIView *noDataOkView = [self getNoDataView];
//        if(noDataOkSuperView && noDataOkView ){
//            [noDataOkSuperView addSubview:noDataOkView];
//            
//            //set the rect
//            CGRect rect = noDataOkView.frame;
//            rect.origin.x = (int)((noDataOkSuperView.frame.size.width - rect.size.width)/2.0);
//            rect.origin.y = 44;
//            [noDataOkView setFrame:rect];
//        }else{
//            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
//        }
        
        tableView_.tableFooterView = [searchChangeList getNoDataFooterView];
    }else{
        tableView_.tableFooterView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[SDWebImageManager sharedManager] cancelAll];
    
    [[SDImageCache sharedImageCache] cleanDisk];
    
    
    
}

@end
