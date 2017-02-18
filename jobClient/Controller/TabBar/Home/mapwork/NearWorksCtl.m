//
//  NearWorksCtl.m
//  jobClient
//
//  Created by YL1001 on 15/6/10.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "NearWorksCtl.h"
#import "MyJobSearchCtlCell.h"
#import "JobSearchCtl.h"
#import "PositionDetailCtl.h"
#import "NearJobSearchCtl.h"
#import "CondictionTradeCtlOld.h"

#import "ELJobSearchCondictionChangeCtl.h"

#import "NearPositionDataModel.h"

#import "New_HeaderBtn.h"

#define kBTN_TAG 10000
#define kSelBtnTag 98760

@interface NearWorksCtl ()<New_HeaderDelegate,changeJobSearchCondictionDelegate>
{
    DBTools *db_;
    JobSearchCtl *searchCtl;   //职位搜索框    
    
    NSArray      *colorArr_;         //颜色数组
    
    RequestCon *nearWords_;
    NSString *userLat;
    NSString *userLng;
    
    NSMutableArray *dataArray;
    
    NSString *tradeId;
    NSString *rangeValue;
    NSString *searchKeyWord;
    CondictionTradeCtlOld *condictionTradeCtl;
    BOOL shouldRefresh_;
    BOOL latFlag;
    
    NSArray *titleArr;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
    UIView *bgView;
    ELJobSearchCondictionChangeCtl * condictionCtl;
    CondictionList_DataModal        *tradeModel_; //用户选中的行业信息
}
@end

@implementation NearWorksCtl

@synthesize messageKw_,messageRegionId_,searchModel_;

- (id)init
{
    self = [super init];
    
    _searchDefaul = YES;
    colorArr_ = [NSArray arrayWithObjects:Color1,Color2,Color3,Color4,Color5,Color6,Color1,Color2,Color3,Color4,Color5,Color6,Color1,Color2,Color3,Color4,Color5,Color6,nil];
    bHaveGetCurrentLocation_ = YES;
    bFooterEgo_ = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserVer];
//    self.navigationItem.title = @"附近职位";
    [self setNavTitle:@"附近职位"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self configUI];
    
    rangeModel_ = [[RangeDataMocel alloc] init];
    rangeModel_.rangeValue_ = @"30公里内";
    rangeModel_.rangeKey_ = @"30";
    
    tradeModel_ = [[CondictionList_DataModal alloc]init];
    tradeModel_.str_ = @"所有行业";
    tradeModel_.id_ = @"1000";
    
//    [_rangeContentLb_ setText:rangeModel_.rangeKey_];
//    [_tradeContentLb_ setText:tradeModel_.str_];
    
    
    [_searchBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
    
    _searchBtn_.layer.cornerRadius = 2.0;
    _searchBtn_.layer.masksToBounds = YES;
    
    searchCtl = [[JobSearchCtl alloc] init];
    searchModel_ = [[SearchParam_DataModal alloc]init];
    
    cllocation_ = [[CLLocationManager alloc]init];
    cllocation_.desiredAccuracy = kCLLocationAccuracyBest;
    cllocation_.distanceFilter = 10;
    if (IOS8) {
        [cllocation_ requestWhenInUseAuthorization];
    }
    cllocation_.delegate = self;
    [cllocation_ startUpdatingLocation];
    
    dataArray = [[NSMutableArray alloc] init];
    
    _topView.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    _topView.layer.borderWidth = 0.5;
    _topView.layer.masksToBounds = YES;
    
    UIView *view = [[UIView alloc]init];
    tableView_.tableFooterView = view;
    
}

-(void)configUI{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.view addSubview:headerView];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 108, ScreenWidth, ScreenHeight - 64 - 44)];
    bgView.backgroundColor = UIColorFromRGB(0x000000);
    bgView.alpha = 0.4;
    bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    titleArr = @[@"30公里内",@"所有行业",@"职位"];
    for (int i = 0; i < titleArr.count; i++) {
        New_HeaderBtn *selBtn = [[New_HeaderBtn alloc]initWithFrame:CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44) withTitle:titleArr[i]arrCount:titleArr.count];
        selBtn.delegate = self;
        selBtn.frame = CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44);
        selBtn.tag = kSelBtnTag + i;
        [headerView addSubview:selBtn];
    }
    [self.view bringSubviewToFront:headerView];
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

#pragma mark-- New_HeaderDelegate 事件

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
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        modal.id_ = rangeModel_.rangeKey_;
        modal.str_ = rangeModel_.rangeValue_;
        [self selectedType:Range_ChooseChange Model:modal nowSelBtn:btn];
    }
    else if(idx == 1){
        [self selectedType:TradeChange Model:tradeModel_ nowSelBtn:btn];
    }
    else if(idx == 2){
        bgView.hidden = YES;
        [condictionCtl hideView];
        [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
        nowBtn.isSelected = !nowBtn.isSelected;
        
        searchModel_.tradeId_ = tradeModel_.id_;
        if ([btn.titleLb.text isEqualToString:@"职位"])
        {
            searchModel_.searchKeywords_ = @"";
        }
        else
        {
            searchModel_.searchKeywords_ = btn.titleLb.text;
        }
        
        NearJobSearchCtl *histrySearchCtl = [[NearJobSearchCtl alloc] init];
        [histrySearchCtl beginLoad:searchModel_ exParam:nil];
        
        __weak typeof (NearWorksCtl) * wearkSelf = self;
        histrySearchCtl.nearsearchBlock = ^(SearchParam_DataModal *searchParamModal, BOOL freshflag){
            wearkSelf.searchModel_ = searchParamModal;
            if (wearkSelf.searchModel_.searchKeywords_ !=nil && ![wearkSelf.searchModel_.searchKeywords_ isEqualToString:@""]) {
                btn.titleLb.text = wearkSelf.searchModel_.searchKeywords_;
            }
            else
            {
                btn.titleLb.text = @"职位";
            }
            
            wearkSelf.searchDefaul = NO;
            if (freshflag)
            {
                [wearkSelf refreshLoad:nil];
            }
        };
        [self.navigationController pushViewController:histrySearchCtl animated:YES];
    }
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
#pragma mark-- 条件选择代理
-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType)
    {
        case Range_ChooseChange:
        {
            rangeModel_.rangeValue_ = [dataModel str_];
            rangeModel_.rangeKey_ = [dataModel id_];
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            selectedBtn.titleLb.text = rangeModel_.rangeValue_;
            searchModel_.rangId_ = rangeModel_.rangeKey_;
            searchModel_.rangStr_ = rangeModel_.rangeValue_;
            [self refreshLoad:nil];
        }
            break;
        case TradeChange:
        {
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            tradeModel_ = (CondictionList_DataModal *)dataModel;
            if( !tradeModel_ || tradeModel_.id_ == nil ){
                //                [_tradeBtn setTitle:@"所有行业" forState:UIControlStateNormal];
                selectedBtn.titleLb.text = @"所有行业";
                searchModel_.tradeId_ = @"1000";
                searchModel_.tradeStr_ = @"所有行业";
            }else{
                //                [_tradeBtn setTitle:tradeDataModal_.str_ forState:UIControlStateNormal];
                selectedBtn.titleLb.text = tradeModel_.str_;
                searchModel_.tradeId_ = tradeModel_.id_;
                searchModel_.tradeStr_ = tradeModel_.str_;
            }
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

- (void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [_positionLb_ resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"附近职位";
    if (requestCon_ && ([requestCon_.dataArr_  count] == 0 || shouldRefresh_) ) {
        [self refreshLoad:nil];
        shouldRefresh_ = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bgView.hidden = YES;
    [condictionCtl hideView];
    [cllocation_ stopUpdatingLocation];
    rangeValue = @"3";
    tradeId = @"1000";
    
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation_ = [locations lastObject];
    currentRegion_.center = currentLocation_.coordinate;
    currentRegion_.span = currentSpan_;
    
    if (IOS8)
    {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentRegion_.center, currentRegion_.span.latitudeDelta, currentRegion_.span.longitudeDelta);
        MKCoordinateRegion adjustedRegion = [mapView_ regionThatFits:viewRegion];
        [mapView_ setRegion:adjustedRegion animated:NO];
    }
    else
    {
        CLLocationCoordinate2D coords = mapView_.userLocation.location.coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coords, currentRegion_.span.latitudeDelta, currentRegion_.span.longitudeDelta);
        MKCoordinateRegion adjustedRregion = [mapView_ regionThatFits:viewRegion];
        [mapView_ setRegion:adjustedRregion animated:NO];
    }
    
    if (bHaveGetCurrentLocation_ == YES) {
        [self getMapData:currentLocation_];
    }
    
    [cllocation_ stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        if (IOS8)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在 “设置-隐私-定位服务” 中进行设置" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"去设置", nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在 “设置-隐私-定位服务” 中进行设置" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alertView show];
        }
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        NSLog(@"error= %ld",(long)[error code]);
        [BaseUIViewController showAlertView:@"网络请求失败" msg:@"无法获取位置信息" btnTitle:@"确定"];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (searchModel_.searchKeywords_ !=nil && ![searchModel_.searchKeywords_ isEqualToString:@""]) {
        _positionLb_.text = searchModel_.searchKeywords_;
    }
    else {
        _positionLb_.text = @"职位";
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    searchModel_.searchKeywords_ = @"";
    searchKeyWord = searchModel_.searchKeywords_;
}

- (void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    
    if (userLat != nil && userLng != nil && ![userLat isEqualToString:@""] && ![userLng isEqualToString:@""])
    {
        New_HeaderBtn *btn= [self.view viewWithTag:kSelBtnTag + 2];
        NSString *keyWord = btn.titleLb.text;
        if ([keyWord isEqualToString:@"职位"])
        {
            keyWord = @"";
        }
        
        if(!(searchModel_.tradeId_.length > 0)){
            searchModel_.tradeId_ = @"";
        }
        
        if ([searchModel_.tradeStr_ isEqualToString:@"所有行业"]) {
            searchModel_.tradeId_ = @"1000";
        }
        
        if ([[Manager shareMgr] haveLogin])
        {
            if (![keyWord isEqualToString:@""] && ![keyWord isKindOfClass:[NSNull class]] && keyWord != nil)
            {
                if (!db_) {
                    db_ = [[DBTools alloc]init];
                }
                [db_ createNearJobForSearch];
                [db_ deleteData:[Manager getUserInfo].userId_ searchKeyWords:keyWord tradeStr:nil];
                [db_ insertNearJobForSearch:[Manager getUserInfo].userId_ searchKeyWords:keyWord tradeId:nil tradeStr:nil];
            }
        
        }
        NSInteger range = [rangeModel_.rangeValue_ integerValue];
        [con nearWorksWithLng:userLng Lat:userLat Range:range keWord:keyWord tradeId:searchModel_.tradeId_ page:con.pageInfo_.currentPage_ pageSize:15 geo_diff:1];
    }
}

- (void)getMapData:(CLLocation *)userLocation
{
    userLat = [NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
    userLng = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
    
    if (!isFromMessage_)
    {
//        if ([[Manager shareMgr] haveLogin] && [Manager shareMgr].bLRegion_ == NO) {
//            return;
//        }
        NSString *keyWord = [_positionLb_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![keyWord isEqualToString:@""] &&![keyWord isKindOfClass:[NSNull class]]&&keyWord != nil)
        {
            if (searchModel_.tradeStr_ == nil || [searchModel_.tradeStr_ isEqualToString:@""] || [searchModel_.tradeStr_ isEqualToString:@"所有行业"])
            {
                searchModel_.tradeStr_ = @"所有行业";
                searchModel_.tradeId_ = @"1000";
            }
        }

    }
    else{
        searchModel_.regionId_ = messageRegionId_;
        searchModel_.searchKeywords_ = messageKw_;
        [_positionLb_ setText:messageKw_];
        isFromMessage_ = NO;
    }
    [self getDataFunction:nil];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_nearWords:
        {
            searchModel_.jobNum = [requestCon_.dataArr_ count];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearPositionDataModel *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if ([dataModal.com_tag isKindOfClass:[NSNull class]] || dataModal.com_tag == nil || [dataModal.com_tag count] == 0){
            return 95;
    }else{
        return 118;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([requestCon_.dataArr_ count] !=0) {
        
        return [requestCon_.dataArr_ count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyJobSearchCtlCell";
    MyJobSearchCtlCell *cell = (MyJobSearchCtlCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NearPositionDataModel *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobSearchCtlCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = cellBgView;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    
    CGFloat kilometers = [dataModal.geo_diff floatValue]/1000;
    NSString *distance = [NSString stringWithFormat:@"%.2f",kilometers];
    
    if (kilometers > 1)
    {
        distance = [NSString stringWithFormat:@"%@km",distance];
    }
    else
    {
        kilometers = kilometers *1000;
        distance = [NSString stringWithFormat:@"%.0f",kilometers];
        distance = [NSString stringWithFormat:@"%@m",distance];
    }
    if ([dataModal.gznum isEqualToString:@""] || [dataModal.gznum isEqualToString:@"不限"] || dataModal.gznum == nil) {
        dataModal.gznum =@"工作经验不限";
    }
    NSMutableArray *fldyArr = [NSMutableArray array];
    if (dataModal.com_tag != nil) {
        for (NSDictionary *dic in dataModal.com_tag) {
            [fldyArr addObject:dic[@"tag_name"]];
        }
    }
    [cell cellInitWithImage:dataModal.logopath positionName:dataModal.jtzw time:nil companyName:dataModal.cname salary:dataModal.salary welfare:fldyArr region:distance gznum:dataModal.gznum edu:nil count:nil  tagColor:nil isky:NO];
    
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    bHaveGetCurrentLocation_ = NO;
    NearPositionDataModel *nearVO = selectData;
    JobSearch_DataModal *dataModal = [JobSearch_DataModal new];
    
    dataModal.companyID_ = nearVO.uid;
    dataModal.zwID_ = nearVO.positionId;
    dataModal.companyName_ = nearVO.cname;
    dataModal.nearByWords = @"nearWords";
    
    PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:dataModal exParam:nil];
}

#if 0
#pragma mark-   行业选择回调
-(void)condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetTradeType:
        {
            tradeModel_ = dataModal;
            if(!tradeModel_ || tradeModel_.id_ == nil)
            {
                [_tradeContentLb_ setText:@"所有行业" ];
                searchModel_.tradeId_ = @"1000";
                searchModel_.tradeStr_ = @"所有行业";
            }else{
                [_tradeContentLb_ setText:tradeModel_.str_ ];
                searchModel_.tradeId_ = tradeModel_.id_;
                searchModel_.tradeStr_ = tradeModel_.str_;
            }
            [self refreshLoad:nil];
            
        }
            break;
        default:
            break;
    }
}
#endif

#pragma mark - 按钮响应事件
-(void)btnResponse:(id)sender
{
    if (sender == _searchBtn_)
    {
        New_HeaderBtn *positionBtn = [self.view viewWithTag:kSelBtnTag + 2];
        MapWorkCtl *mapWorkCtl = [[MapWorkCtl alloc]init];
        mapWorkCtl.moveFlag = YES;
       
        NSString *keyWord = positionBtn.titleLb.text;
        if ([keyWord isEqualToString:@"职位"])
        {
            keyWord = @"";
        }
        
        if ([tradeModel_.str_ isEqualToString:@"所有行业"] || tradeModel_.id_ == nil)
        {
            tradeModel_.id_ = @"1000";
        }
        
        //组装搜索参数
        searchModel_.rangStr_ = rangeModel_.rangeValue_;
        searchModel_.tradeId_ = tradeModel_.id_;
        searchModel_.searchKeywords_ = keyWord;
        searchModel_.latNum = userLat;
        searchModel_.longnum = userLng;
        
        [mapWorkCtl beginLoad:searchModel_ exParam:nil];
        [self.navigationController pushViewController:mapWorkCtl animated:YES];   
    }
}
#if 0
- (void)rangeChoose:(RangeDataMocel *)range_
{
    rangeModel_ = range_;
    [_rangeContentLb_ setText:rangeModel_.rangeKey_];
    [self refreshLoad:nil];
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
