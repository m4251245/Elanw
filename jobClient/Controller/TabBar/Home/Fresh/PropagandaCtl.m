//
//  PropagandaCtl.m
//  Association
//
//  Created by 一览iOS on 14-3-27.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "PropagandaCtl.h"
#import "CareerTailDetailCtl.h"
#import "XJHSchoolCtl.h"
#import "FreshCtl_Cell.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "NewCareerTalkDataModal.h"

#import "New_HeaderBtn.h"

#define kBTN_TAG 10000
#define kSelBtnTag 98760

#define TODAYCOLOR [UIColor colorWithRed:61.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0]
#define OTHERCOLOR [UIColor colorWithRed:125.0/255.0 green:147.0/255.0 blue:166.0/255.0 alpha:1.0]

@interface PropagandaCtl () <dataChangeDelegate,UISearchBarDelegate,schoolChangeDelegare,changeJobSearchCondictionDelegate,New_HeaderDelegate>
{
    NSString *timeId_;
    NSString *schoolId_;
    
    ELJobSearchCondictionChangeCtl *condictionCtl;
    
    NSArray *titleArr;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
    UIView *bgView;
    CondictionList_DataModal *selectedModal;
    New_HeaderBtn *lastBtn;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayout;

@end

@implementation PropagandaCtl
@synthesize type_;

-(void)dealloc{
    [bgView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)init
{
    self = [super init];
    
    bFooterEgo_ = YES;
    
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bgView.hidden = YES;
    if (condictionCtl)
    {
        [condictionCtl hideView];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark--初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserVer];
    [self setNavTitle:@"宣讲会"];
    tableView_.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    tableView_.backgroundView = nil;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([type_ isEqualToString:@"1"]) {
        _searchBar.hidden = YES;
        [self setNavTitle:@"我的学校"];
        headView_.hidden = YES;
    }
    else
    {
        [self setNavTitle:@"宣讲会"];
         _tableViewTopLayout.constant = 88;
        NSString *str =  [MMLocationManager shareLocation].lastProvince;
        New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
        
        if (!str || [str isEqual:[NSNull null]] || str == nil)
        {
            btn.titleLb.text = @"不限";
        }
        else
        {
            btn.titleLb.text = str;
        }
       [self configUI];
    }
    _searchBar.delegate = self;
    _searchBar.tintColor = UIColorFromRGB(0xe13e3e);
    timeId_ = @"";
    schoolId_ = @"";
    
    selectedModal = [CondictionList_DataModal new];
    
    //无数据是ImageView的顶部距离
    self.imgTopSpace = 80;
}

-(void)configUI{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 40)];
    [self.view addSubview:headerView];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 84, ScreenWidth, ScreenHeight - 64 - 84)];
    bgView.backgroundColor = UIColorFromRGB(0x000000);
    bgView.alpha = 0.4;
    bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    NSString *str =  [MMLocationManager shareLocation].lastProvince;
    if (!str || [str isEqual:[NSNull null]] || str == nil || str.length == 0) {
        str = @"不限";
    }
    titleArr = @[str,@"所有学校",@"所有日期"];
    for (int i = 0; i < titleArr.count; i++) {
        New_HeaderBtn *selBtn = [[New_HeaderBtn alloc]initWithFrame:CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44) withTitle:titleArr[i]arrCount:titleArr.count];
        selBtn.delegate = self;
        if (i == titleArr.count - 1) {
            selBtn.rightLineView.hidden = YES;
        }
        selBtn.frame = CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44);
        selBtn.tag = kSelBtnTag + i;
        [headerView addSubview:selBtn];
    }
    [self.view bringSubviewToFront:headerView];
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

#pragma mark--加载数据
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if ([type_ isEqualToString:@"1"]) {
        inModel_ = dataModal;
    }else
    {
 
    }
}

#pragma mark--数据请求
-(void)getDataFunction:(RequestCon *)con
{
    New_HeaderBtn *schoolBtn_new = [self.view viewWithTag:kSelBtnTag + 1];
    New_HeaderBtn *regionBtn_new = [self.view viewWithTag:kSelBtnTag];
    if ([type_ isEqualToString:@"1"]) {
        [con getSchoolXJHListWithSchoolId:inModel_.id_ pageSize:10 pageIndex:requestCon_.pageInfo_.currentPage_];
    }
    else
    {
        NSString *regiontitle = regionBtn_new.titleLb.text;
        if ([regiontitle containsString:@"省"])
        {
            regiontitle = [regiontitle stringByReplacingOccurrencesOfString:@"省" withString:@""];
        }
        if ([regiontitle isEqualToString:@"北京市"] || [regiontitle isEqualToString:@"上海市"] || [regiontitle isEqualToString:@"天津市"] || [regiontitle isEqualToString:@"重庆市"]) {
            regiontitle = [regiontitle substringToIndex:2];
        }
        NSString * idstr = [CondictionListCtl getRegionId:regiontitle];
        NSString *schoolN = @"";
        if (![schoolBtn_new.titleLb.text isEqualToString:@"所有学校"]) {
            schoolN = schoolBtn_new.titleLb.text;
        }
        if ([[Manager shareMgr] haveLogin]) {
            [con getXjhList:idstr pagesize:10 pageindex:requestCon_.pageInfo_.currentPage_ kw:_searchBar.text userId:[Manager getUserInfo].userId_ schoolId:schoolId_ schoolName:schoolN timeType:timeId_ searchDateType:@"40"];
        }else{
            [con getXjhList:idstr pagesize:10 pageindex:requestCon_.pageInfo_.currentPage_ kw:_searchBar.text userId:nil schoolId:schoolId_ schoolName:schoolN timeType:timeId_ searchDateType:@"40"];
        }
    }

}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_XjhList:
        {
            for (NewCareerTalkDataModal *dataModal in dataArr ) {
                dataModal.weekday = [MyCommon getWeekDay:dataModal.sdate];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark--代理
#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FreshCtl_Cell *freshCell = (FreshCtl_Cell *)cell;
    freshCell.dateView_.layer.cornerRadius = 4.0;
    [freshCell.dateView_.layer setMasksToBounds:YES];
    NewCareerTalkDataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    freshCell.titleLb_.text = [MyCommon translateHTML:dataModal.title];
    freshCell.dateLb_.text = [dataModal.sdate substringToIndex:10];
    freshCell.schoolLb_.text = [MyCommon translateHTML:dataModal.sname];
    
    if(!dataModal.sname || [dataModal.sname isEqualToString:@""]){
        freshCell.schoolLb_.text = [MyCommon translateHTML:dataModal.addr];
    }
    if ([type_ isEqualToString:@"1"]) {
//        freshCell.weekdayLb_.text = dataModal.weekday;
        freshCell.weekdayLb_.text = [MyCommon getWeekDay:dataModal.sdate];
        freshCell.timeLb_.text = dataModal.sdate;
    }else{
        freshCell.weekdayLb_.text = dataModal.weekday;
        freshCell.timeLb_.text = [dataModal.sdate substringFromIndex:11];
    }
    
    NSString *todayString = [[MyCommon getNowTime] substringToIndex:10];
    freshCell.dateView_.clipsToBounds = YES;
    freshCell.dateView_.layer.borderWidth = 0.5;
    
    if ([todayString isEqualToString:freshCell.dateLb_.text]) {

        freshCell.bgColor.image = [UIImage createImageWithColor:TODAYCOLOR];
        freshCell.dateView_.layer.borderColor = TODAYCOLOR.CGColor;
    }
    else
    {
        freshCell.bgColor.image = [UIImage createImageWithColor:OTHERCOLOR];
        freshCell.dateView_.layer.borderColor = OTHERCOLOR.CGColor;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    FreshCtl_Cell *cell = (FreshCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Campus_Xjh_Cell" owner:self options:nil] lastObject];

        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = cellBgView;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell initCell];
    }
    
    
   // [cell.timeLb_ setTextColor:[MyCommon getWeekDayColor:dataModal.weekday_]];
    //[cell.colorLb_ setBackgroundColor:[MyCommon getWeekDayColor:dataModal.weekday_]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    NewCareerTalkDataModal * dataModal = selectData;
    
    dataModal.type = 2;
    
    CareerTailDetailCtl *careerCtl = [[CareerTailDetailCtl alloc]init];
    [self.navigationController pushViewController:careerCtl animated:YES];
    [careerCtl beginLoad:dataModal exParam:exParam];
}

#pragma mark--scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [keywordsTF_ resignFirstResponder];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

#pragma mark -- 条件筛选代理
-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType) {
        case XJHRegionChange:
        {
            CondictionList_DataModal *modal = (CondictionList_DataModal *)dataModel;
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            nowBtn.titleLb.text = modal.str_;
            selectedModal.bSelected_ = modal.bSelected_;
            selectedModal.bParent_ = modal.bParent_;
            [self refreshLoad:nil];
        }
            break;
        case XJHSchoolChange:
        {
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            SqlitData *modal = (SqlitData *)dataModel;
            schoolId_ = @"";
            nowBtn.titleLb.text = modal.school;
            [self refreshLoad:nil];
        }
            break;
        case XJHTimeChange:
        {
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            CondictionList_DataModal *modal = (CondictionList_DataModal *)dataModel;
            nowBtn.titleLb.text = modal.str_;
            timeId_ = modal.id_;
            [self refreshLoad:nil];
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
        dataModal.str_ = @"不限";
    }
    
    switch ( ctl.type_ ) {
        case CondictionType_Region:
        {
            New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
            btn.titleLb.text = dataModal.str_;
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

#pragma ChooseHotCityDelegate
-(void)chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
    btn.titleLb.text = city;
    [self refreshLoad:nil];
}


#pragma mark - SearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = [MyCommon removeAllSpace:searchBar.text];
    [self refreshLoad:nil];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    if (condictionCtl)
    {
        [condictionCtl hideView];
    }
    if (nowBtn.isSelected) {
        [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
        nowBtn.isSelected = !nowBtn.isSelected;
        bgView.hidden = YES;
    }
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}
#pragma mark-- New_HeaderDelegate 条件筛选点击事件代理
-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender{
    New_HeaderBtn *reginBtn = [self.view viewWithTag:kSelBtnTag];
    New_HeaderBtn *schoolBtn_new = [self.view viewWithTag:kSelBtnTag + 1];
    
    [_searchBar resignFirstResponder];
    New_HeaderBtn *btn = (New_HeaderBtn *)sender.view;
    NSInteger idx = btn.tag - kSelBtnTag;
    
    if (idx == 0) {
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        NSString *regiontitle = reginBtn.titleLb.text;
        if ([regiontitle containsString:@"省"])
        {
            regiontitle = [regiontitle stringByReplacingOccurrencesOfString:@"省" withString:@""];
        }

        NSString * idstr = [CondictionListCtl getRegionId:regiontitle];
        modal.id_ = idstr;
        modal.str_ = regiontitle;
        modal.bSelected_ = selectedModal.bSelected_;
        modal.bParent_ = selectedModal.bParent_;
        [self selectedType:XJHRegionChange Model:modal nowSelBtn:btn];
    }
    else if(idx == 1){
        if ([reginBtn.titleLb.text isEqualToString:@"不限"]) {
            [self showChooseAlertView:100 title:@"请选择地区" msg:nil okBtnTitle:@"确定" cancelBtnTitle:nil];
            btn.isSelected = NO;
            return;
        }
        
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        NSString *regiontitle = reginBtn.titleLb.text;
        if ([regiontitle containsString:@"省"])
        {
            regiontitle = [regiontitle stringByReplacingOccurrencesOfString:@"省" withString:@""];
        }
        NSString * idstr = [CondictionListCtl getRegionId:regiontitle];
        modal.id_ = idstr;
        modal.str_ = regiontitle;
        modal.pId_ = schoolBtn_new.titleLb.text;
        [self selectedType:XJHSchoolChange Model:modal nowSelBtn:btn];
    }
    else if(idx == 2){
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        modal.str_ = btn.titleLb.text;
        [self selectedType:XJHTimeChange Model:modal nowSelBtn:btn];
    }
    
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

#pragma mark--事件
-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [keywordsTF_ resignFirstResponder];
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
        condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,64 + 84,ScreenWidth,ScreenHeight - 64 - 84)];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideKeyboard
{
    [_searchBar resignFirstResponder];
}


-(void)changeCurrentTimeType:(NSString *)timeName timeId:(NSString *)timeId
{
    [dateBtn setTitle:timeName forState:UIControlStateNormal];
    timeId_ = timeId;
    [self refreshLoad:nil];
}

-(void)schoolId:(NSString *)schoolId andName:(NSString *)schoolName
{
    New_HeaderBtn *schoolBtn_new = [self.view viewWithTag:kSelBtnTag + 1];
    schoolId_ = schoolId;
//    [schoolBtn setTitle:schoolName forState:UIControlStateNormal];
    schoolBtn_new.titleLb.text = schoolName;
    [self refreshLoad:nil];
}


#if 0
-(void)btnResponse:(id)sender
{
    [_searchBar resignFirstResponder];
    if (sender == regionBtn_)
    {
        if (!condictionCtl)
        {
            condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,148,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 148)];
            condictionCtl.delegate_ = self;
        }
        if(condictionCtl.currentType == XJHRegionChange)
        {
            [condictionCtl hideView];
            return;
        }
        [condictionCtl hideView];
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        NSString *regiontitle = regionBtn_.titleLabel.text;
        if ([regiontitle containsString:@"省"])
        {
            regiontitle = [regiontitle stringByReplacingOccurrencesOfString:@"省" withString:@""];
        }
        NSString * idstr = [CondictionListCtl getRegionId:regiontitle];
        modal.id_ = idstr;
        modal.str_ = regiontitle;
        [condictionCtl creatViewWithType:XJHRegionChange selectModal:modal];
        [condictionCtl showView];
        
        //        if (![Manager shareMgr].regionListCtl_) {
        //            [Manager shareMgr].regionListCtl_ = [[RegionCtl alloc] init];
        //        }
        //        [self.navigationController pushViewController:[Manager shareMgr].regionListCtl_ animated:YES];
        //        [[Manager shareMgr].regionListCtl_ beginLoad:nil exParam:nil];
        //        [Manager shareMgr].regionListCtl_.delegate_ = self;
    }
    else if (sender == searchBtn_)
    {
        [keywordsTF_ resignFirstResponder];
        [self refreshLoad:nil];
    }
    else if (sender == schoolBtn)
    {
        if ([regionBtn_.titleLabel.text isEqualToString:@"全国"]) {
            [self showChooseAlertView:100 title:@"请选择地区" msg:nil okBtnTitle:@"确定" cancelBtnTitle:nil];
        }
        else
        {
            if (!condictionCtl)
            {
                condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,148,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 148)];
                condictionCtl.delegate_ = self;
            }
            if(condictionCtl.currentType == XJHSchoolChange)
            {
                [condictionCtl hideView];
                return;
            }
            [condictionCtl hideView];
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            NSString *regiontitle = regionBtn_.titleLabel.text;
            if ([regiontitle containsString:@"省"])
            {
                regiontitle = [regiontitle stringByReplacingOccurrencesOfString:@"省" withString:@""];
            }
            NSString * idstr = [CondictionListCtl getRegionId:regiontitle];
            modal.id_ = idstr;
            modal.str_ = regiontitle;
            modal.pId_ = schoolBtn.titleLabel.text;
            [condictionCtl creatViewWithType:XJHSchoolChange selectModal:modal];
            [condictionCtl showView];
            //            NSString *regiontitle = regionBtn_.titleLabel.text;
            //            if ([regiontitle containsString:@"省"])
            //            {
            //                regiontitle = [regiontitle stringByReplacingOccurrencesOfString:@"省" withString:@""];
            //            }
            //            NSString * regionId = [CondictionListCtl getRegionId:regiontitle];
            //            XJHSchoolCtl *ctl = [[XJHSchoolCtl alloc] init];
            //            ctl.regionId = regionId;
            //            ctl.schoolChangeDelegate = self;
            //            ctl.currentSchool = schoolBtn.titleLabel.text;
            //            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
    else if (sender == dateBtn)
    {
        if (!condictionCtl)
        {
            condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,148,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 148)];
            condictionCtl.delegate_ = self;
        }
        if(condictionCtl.currentType == XJHTimeChange)
        {
            [condictionCtl hideView];
            return;
        }
        [condictionCtl hideView];
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        modal.str_ = dateBtn.titleLabel.text;
        [condictionCtl creatViewWithType:XJHTimeChange selectModal:modal];
        [condictionCtl showView];
        
        //        XJHDateChangeCtl *ctl = [[XJHDateChangeCtl alloc] init];
        //        ctl.currentTime = dateBtn.titleLabel.text;
        //        ctl.timeDelegate = self;
        //        [self.navigationController pushViewController:ctl animated:YES];
    }
}

#endif

@end
