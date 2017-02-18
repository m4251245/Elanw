//
//  MyJobSearchCtl.m
//  Association
//
//  Created by sysweal on 14-3-28.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "MyJobSearchCtl.h"
#import "DataSelectedCtl.h"
#import "MyJobSearchCtlCell.h"
#import "MMLocationManager.h"
#import "JobSearchCtl.h"
#import "PropagandaCtl.h"
#import "NoLoginPromptCtl.h"
#import "NearWorksCtl.h"
#import "YLOfferListCtl.h"
#import "RecruitmentCtl.h"
#import "FBRegionCtl.h"
#import "ELPersonCenterCtl.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "SBJson.h"
//#import "PushUrlCtl.h"
#import "AD_dataModal.h"
#import "MyResumeController.h"
//#import "SalaryIrrigationCtl.h"
#import "NewCareerTalkDataModal.h"
#import "NewJobPositionDataModel.h"
#import "ZWDetail_DataModal.h"
#import "CycleScrollView.h"
#import "YLExpertListCtl.h"
#import "New_HeaderBtn.h"
#import "SqlitData.h"
#import "ELMyjobsearchDAO.h"
#import "ELMyjobBrokerDAO.h"
//#import "SalaryIrrigationDetailCtl.h"
#import "SalaryCompeteCtl.h"

#define kBTN_TAG 10000
#define kSelBtnTag 98760

static NSString * kURL = @"http://m.jianke.cc/?qdao_target=yilan";

@interface MyJobSearchCtl () <NoLoginDelegate,changeJobSearchCondictionDelegate,UIActionSheetDelegate,UIScrollViewDelegate,New_HeaderDelegate>
{
    UIButton    *searchBtn;
    BOOL shouldRefresh_;
    UILabel  *keyWorkLb;
    
    NSArray *_adArray;
    RequestCon *_addAdClickCount;
    ELJobSearchCondictionChangeCtl *condictionCtl;
    ELRequest *request;
//    UIPageControl *page;
    
    IBOutlet UIView *_backView;
    IBOutlet UIView *_brokerbackView;
    IBOutlet UIImageView *_brokerImg;    /*<职业经纪人头像 */
    IBOutlet UILabel *_brokerNameLb;     /*<职业经纪人名字 */
    IBOutlet UILabel *_brokerZwLb;       /*<职业经纪人职位 */
    IBOutlet UILabel *_brokerInfoLb;     /*<职业经纪人信息 */
    IBOutlet UIButton *_moreBrokerBtn;   /*<更多选择 */
    BOOL isHaveBroker;
    
    UIScrollView *conScrollView;
    Expert_DataModal *profeAgentModel; /**<经纪人Model */
    
    NSMutableArray *btnArr;
    NSMutableDictionary *btnTitleDic;
    NSMutableArray *btnProperty;
    
    __weak IBOutlet NSLayoutConstraint *tableViewBottom;
    
    NSArray *titleArr;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
    UIView *bgView;
    BOOL isPush;
    BOOL isFirstLocation;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewTopTo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brokerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;


@end

@implementation MyJobSearchCtl
@synthesize type_,isFromMessage_,messageKw_,messageRegionId_;

#pragma mark -LifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [bgView removeFromSuperview];
}

-(id)init
{
    self  = [super init];
    jobSubscribedArray_ = [[NSMutableArray alloc]init];
    bFooterEgo_ = YES;
    bHeaderEgo_ = YES;
    validateSeconds_ = 600;
    searchDefaul_ = YES;
    _index = 0;
    
    colorArr_ = [NSArray arrayWithObjects:Color1,Color2,Color3,Color4,Color5,Color6,Color1,Color2,Color3,Color4,Color5,Color6,Color1,Color2,Color3,Color4,Color5,Color6,nil];
    return  self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    if (nowBtn.isSelected) {
        [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
        nowBtn.isSelected = !nowBtn.isSelected;
        bgView.hidden = YES;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"statusBarTouchedAction" object:nil];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
    if (condictionCtl) {
        [condictionCtl hideView];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_fromMessageList) {
        self.tabBarController.tabBar.hidden = YES;
    }
    else{
        self.tabBarController.tabBar.hidden = NO;
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //status Bar Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchedAction) name:@"statusBarTouchedAction" object:nil];
    
    if ([requestCon_.dataArr_ count] == 0 ||shouldRefresh_) {
        [self refreshLoad:nil];
    }
    
    //定位
    if (!_fromMessageList)
    {
        [self startLocation];
    }
    
}
#pragma mark--
#pragma mark - 配置界面
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
//注册通知
    [self addObserVer];
    [self beginLoad:nil exParam:nil];
//起始约束
    [self configBeginConstain];
//条件筛选按钮配置
    [self configUI];
//搜索框
    [self configSearchBar];
//加载起始条件
    [self loadBeginCondition];
    
    [self updateCom:nil];
}

//搜索框
-(void)configSearchBar{
    //搜索框
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth - 120, 44)];
    UIImageView *bgImgv = [[UIImageView alloc]init];;
    [bgImgv setFrame:CGRectMake(0, 10, ScreenWidth - 120, 24)];
    bgImgv.layer.cornerRadius = 12;
    bgImgv.layer.masksToBounds = YES;
    [bgImgv setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [searchView addSubview:bgImgv];
    
    keyWorkLb = [[UILabel alloc] initWithFrame:CGRectMake(27, 10, ScreenWidth - 130, 24)];
    [keyWorkLb setFont:FOURTEENFONT_CONTENT];
    [keyWorkLb setTextColor:BLACKCOLOR];
    [keyWorkLb setBackgroundColor:[UIColor clearColor]];
    keyWorkLb.tintColor = UIColorFromRGB(0xe13e3e);
    [searchView addSubview:keyWorkLb];
    
    UILabel *tipsLb = [[UILabel alloc] initWithFrame:CGRectMake(27, 10, ScreenWidth - 130, 24)];
    tipsLb.tag = 10000;
    [tipsLb setText:@"请输入职位或公司关键字"];
    [tipsLb setFont:FOURTEENFONT_CONTENT];
    [tipsLb setTextColor:GRAYCOLOR];
    [tipsLb setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:tipsLb];
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setBackgroundColor:[UIColor clearColor]];
    [searchBtn setFrame:CGRectMake(0, 0, ScreenWidth - 120, 44)];
    [searchView addSubview:searchBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_search_def.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger width = -10;
    negativeSpacer.width = width;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
    self.navigationItem.titleView = searchView;
}

//条件筛选按钮配置
-(void)configUI{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [headView addSubview:headerView];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 108, ScreenWidth, ScreenHeight - 64 - 44)];
    bgView.backgroundColor = UIColorFromRGB(0x000000);
    bgView.alpha = 0.4;
    bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    titleArr = @[@"地区",@"所有行业",@"月薪",@"更多"];
    for (int i = 0; i < titleArr.count; i++) {
        New_HeaderBtn *selBtn = [[New_HeaderBtn alloc]initWithFrame:CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44) withTitle:titleArr[i]arrCount:titleArr.count];
        selBtn.delegate = self;
        selBtn.frame = CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44);
        selBtn.tag = kSelBtnTag + i;
        if (i == titleArr.count - 1) {
            selBtn.rightLineView.hidden = YES;
        }
        [headerView addSubview:selBtn];
    }
    [self.view bringSubviewToFront:headerView];
}

//配置起始约束
-(void)configBeginConstain{
    btnProperty = [NSMutableArray array];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [_backView layoutSubviews];
    [adView layoutSubviews];
    [_typeChangeView layoutSubviews];
}

//加载顶部按钮
-(void)configHeaderBtn{
    if (conScrollView){
        return;
    }
    btnTitleDic = [@{@"zhiwei":@[@"附近职位",@"jobsearchtypefjzw"],@"xuanjh":@[@"宣讲会",@"jobsearchtypexjh"],@"jianli":@[@"我的简历",@"jobsearchtypewdjl"],@"zhaoph":@[@"招聘会",@"jobsearchtypezph"]} mutableCopy];
    btnArr = [NSMutableArray array];
    
    UIView *scrollBgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    [_typeChangeView addSubview:scrollBgview];
    
    conScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    conScrollView.contentSize = CGSizeMake(ScreenWidth, 90);
    conScrollView.delegate = self;
    conScrollView.pagingEnabled = YES;
    conScrollView.showsHorizontalScrollIndicator = NO;
    [scrollBgview addSubview:conScrollView];
    
    NSArray *startBtnProArr = @[@[@"附近职位",@"jobsearchtypefjzw"],@[@"宣讲会",@"jobsearchtypexjh"],@[@"我的简历",@"jobsearchtypewdjl"],@[@"招聘会",@"jobsearchtypezph"]];
    for (int i = 0; i < startBtnProArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat min_width = (ScreenWidth / 4 - 80) / 2;
        btn.frame = CGRectMake((2 * i + 1) * min_width + 80 * i, 0, 80, 80);
        [btn setTitleColor:[UIColor colorWithRed:104/255.0 green:105/255.0 blue:106/255.0 alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font = FOURTEENFONT_CONTENT;
        [conScrollView addSubview:btn];
        btn.tag = kBTN_TAG + i;
        [btnArr addObject:btn];
        
        [btn setTitle:startBtnProArr[i][0] forState:UIControlStateNormal];
        btn.titleLabel.font = FOURTEENFONT_CONTENT;
        [btn setImage:[UIImage imageNamed:startBtnProArr[i][1]] forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -34, -45, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-18, 14, 0, 0);
        
        [btn addTarget:self action:@selector(changeTyoeBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    }
//    page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
//    page.center = CGPointMake(scrollBgview.center.x, 80);
//    page.numberOfPages = 2;
//    page.currentPageIndicatorTintColor = [UIColor grayColor];
//    page.pageIndicatorTintColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//    [scrollBgview addSubview:page];
//    [page addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
}

//加载起始条件
-(void)loadBeginCondition{
    NSArray *paymentArray_ = [[NSArray alloc]initWithObjects:@"不限",@"面议",@"3000以下",@"3000及以上",@"5000及以上",@"7000及以上",@"10000及以上",nil];
    NSArray *paymentValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"lt||3000",@"gte||3000",@"gte||5000",@"gte||7000",@"gte||10000",nil];
    payMentArray = [[NSArray alloc]initWithObjects:paymentArray_,paymentValueArray_, nil];
    searchParam_ = [self getSearchDataModal];
    
//    NSUserDefaults *locationCity = [NSUserDefaults standardUserDefaults];
    New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
//    NSString *cityStr = [locationCity objectForKey:@"city"];
    NSString *cityStr = getUserDefaults(kLocationCityName);
    if (cityStr != nil) {
        searchParam_.regionStr_ = cityStr;
        searchParam_.regionId_ = [CondictionListCtl getRegionId:searchParam_.regionStr_];
        btn.titleLb.text = searchParam_.regionStr_;
    }
    else
    {
        btn.titleLb.text = @"不限";
        searchParam_.regionStr_ = @"不限";
        searchParam_.regionId_ = @"100000";
        
    }
    
    if (searchParam_.regionId_.length > 0) {
        
    }
    else
    {
        if ([searchParam_.regionStr_ containsString:@"市"])
        {
            searchParam_.regionStr_ = [searchParam_.regionStr_ substringWithRange:NSMakeRange(0,searchParam_.regionStr_.length-1)];
            searchParam_.regionId_ = [CondictionListCtl getRegionId:searchParam_.regionStr_];
        }
    }
    
    NSString *keyWord = [keyWorkLb.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([[Manager shareMgr] haveLogin]) {
        if (![keyWord isEqualToString:@""] &&![keyWord isKindOfClass:[NSNull class]]&&keyWord != nil) {
            if (!db_) {
                db_ = [[DBTools alloc]init];
            }
            [db_ createTableForSearch];
            [db_ deleteData:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionStr:searchParam_.regionStr_ tradeStr:searchParam_.tradeStr_];
        }
    }
    
    if (_fromMessageList) {
        backBarBtn_.hidden = NO;
    }
    else
    {
        
        if (type_ == 0)
        {
            backBarBtn_.hidden = YES;
            CGRect rect = tableView_.frame;
            rect.size.height = rect.size.height-44;
            tableView_.frame = rect;
        }
        else
        {
            myLeftBarBtnItem_ = nil;
            backBarBtn_.hidden = NO;
            [self.navigationItem setHidesBackButton:NO animated:NO];
        }
    }
    
    keyWorkLb.text = @"";
    keyWorkLb.hidden = YES;
    searchParam_.searchKeywords_ = @"";
}

- (void)changTipsLabel
{
    UILabel *tipsLb = (UILabel *)[self.navigationItem.titleView viewWithTag:10000];
    [tipsLb setHidden:NO];
}

- (void)updateCom:(RequestCon *)con
{
    CGFloat backHeight = 0;
    //职业经纪人
    if (isHaveBroker) {
        _brokerNameLb.text = profeAgentModel.iname_;
        if (profeAgentModel.zw_.length > 0 || profeAgentModel.gznum_.length > 0) {
            _brokerZwLb.text = [NSString stringWithFormat:@"%@ | %@年工作经验", profeAgentModel.zw_, profeAgentModel.gznum_];
        }
        
        _brokerInfoLb.text = profeAgentModel.expertIntroduce_;
        [_brokerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",profeAgentModel.img_]] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goPersonCentertTap)];
        [_brokerbackView addGestureRecognizer:singleTap];
        
        _brokerImg.layer.cornerRadius = 8.0f;
        _brokerImg.layer.masksToBounds = YES;
        
        _brokerbackView.hidden = NO;
        _brokerHeight.constant = 134;
        backHeight = 244;
        _backViewHeight.constant = 244;
    }
    else
    {
        _brokerbackView.hidden = YES;
        _brokerHeight.constant = 0;
        backHeight = 90;
        _backViewHeight.constant = 90;
    }
    
    //广告
    if (_fromMessageList)
    {
        headView.bounds = CGRectMake(0, 0, ScreenWidth, 44);
        headView.clipsToBounds = YES;
        tableView_.tableHeaderView = headView;
        _adHeight.constant = 0;
        adView.hidden = YES;
        _backViewTopTo.constant = 44;
        tableViewBottom.constant = 0;
    }
    else
    {
        if (_adCon && con == _adCon)
        {
            if ([_adArray count] > 0)
            {
                _backViewTopTo.constant = 120 + 44;
                headView.bounds = CGRectMake(0, 0, ScreenWidth, 44 + 130 + backHeight);
                adView.hidden = NO;
                _adHeight.constant = 120;
                
//                [self setAd];
            }
            else
            {
                _backViewTopTo.constant = 44;
                headView.bounds = CGRectMake(0, 0, ScreenWidth, 44 + backHeight);
                adView.hidden = YES;
                _adHeight.constant = 0;
            }
            tableView_.tableHeaderView = headView;
        }
    }
    
//    [self.view layoutSubviews];
    //    [super updateCom:con];
}

#pragma mark -- 获取当前城市
- (void)startLocation
{
    if (!_cllocation) {
        _cllocation = [[CLLocationManager alloc] init];
        _cllocation.desiredAccuracy = kCLLocationAccuracyBest;
        _cllocation.distanceFilter = 10.0f;
    }
    _cllocation.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        if (IOS8) {
            [_cllocation requestWhenInUseAuthorization];
        }
        [_cllocation startUpdatingLocation];
    }
}

#pragma mark--
#pragma mark - 加载数据
-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [self loadData];
}

-(void)loadData{
    profeAgentModel = [[Expert_DataModal alloc] init];
    dataArray_ = [NSMutableArray array];
    //职位列表从数据库获取数据
    ELMyjobsearchDAO *DAO = [[ELMyjobsearchDAO alloc]init];
    id arr = [DAO showAll];
    if ([arr count] > 0) {
        for (NewJobPositionDataModel *vo in arr) {
            if(vo.benefits.length > 0){
                vo.fldy = [vo.benefits componentsSeparatedByString:@","];
            }
        }
        [dataArray_ addObjectsFromArray:arr];
        [tableView_ reloadData];
    }
    //职业经纪人从数据库获取数据
    ELMyjobBrokerDAO *brokerDAO = [[ELMyjobBrokerDAO alloc]init];
    Expert_DataModal *expertVO = [brokerDAO showAll];
    if (expertVO) {
        profeAgentModel = expertVO;
        isHaveBroker = YES;
    }
}

-(void)refreshLoad:(RequestCon *)con
{
    [super refreshLoad:con];
    
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    
#pragma mark--请求顶部四个按钮
    if (!sortCon_) {
        sortCon_ = [self getNewRequestCon:NO];
    }
    [sortCon_ getTableViewHeadButtonList:2];
    
    //请求广告位
    if (!_adCon || !_adView2)
    {
        _adCon = [self getNewRequestCon:NO];
        [_adCon getTopAD:userId Type:@"app_zw"];
    }
}
#pragma mark--
#pragma mark - 请求数据
- (void)getDataFunction:(RequestCon *)con
{
    New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    if (!keyWorkLb) {
        keyWorkLb = [[UILabel alloc] init];
    }
    keyWorkLb.text = @"";
    keyWorkLb.hidden = YES;
    if (!searchParam_) {
        searchParam_ = [[SearchParam_DataModal alloc] init];
    }
    searchParam_.searchKeywords_ = @"";
    
    if (!isFromMessage_)
    {
//        if ([[Manager shareMgr] haveLogin] && [Manager shareMgr].bLRegion_ == NO) {
//            return;
//        }
        NSString *keyWord = [keyWorkLb.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([[Manager shareMgr] haveLogin]) {
            if (![keyWord isEqualToString:@""] &&![keyWord isKindOfClass:[NSNull class]] && keyWord != nil)
            {
                if (searchParam_.tradeStr_ == nil || [searchParam_.tradeStr_ isEqualToString:@""])
                {
                    searchParam_.tradeStr_ = @"所有行业";
                }
                if (!db_) {
                    db_ = [[DBTools alloc]init];
                }
                [db_ createTableForSearch];
                [db_ deleteData:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionStr:searchParam_.regionStr_ tradeStr:searchParam_.tradeStr_];
                [db_ insertTableForSearch:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionId:searchParam_.regionId_ regionStr:searchParam_.regionStr_ tradeId:searchParam_.tradeId_ tradeStr:searchParam_.tradeStr_ searchTime:[PreCommon getCurrentDateTime] searchType:[NSString stringWithFormat:@"%ld",(long)searchParam_.searchType_]];
            }
        }
        
        if ([searchParam_.regionId_ isEqualToString:@""] || searchParam_.regionId_ == nil)
        {
            if(regionDataModal_.id_ != nil && ![regionDataModal_.id_ isKindOfClass:[NSNull class]])
                searchParam_.regionId_ = @"100000";
        }
        
        if (searchDefaul_ == YES)
        {
            NSString *keyWord  = nil;
            if ([Manager getUserInfo].intentionJob && [[Manager getUserInfo].intentionJob isEqualToString:@""]) {
                keyWord = [Manager getUserInfo].intentionJob;
            }
            else
            {
                keyWord = [Manager getUserInfo].job_;
            }
            
            if ([[Manager getUserInfo].role_ isEqualToString:@"0"]) {
                keyWord = @"应届生";
            }
            
            if (keyWord !=nil) {
                keyWord = [[keyWord componentsSeparatedByString:@"/"]objectAtIndex:0];
            }
            else
            {
                keyWord = @"";
            }
            
            [self changTipsLabel];
            [keyWorkLb setText:@""];
            searchParam_.searchKeywords_ = @"";
        }
    }
    else{
        searchParam_.regionId_ = messageRegionId_;
        searchParam_.searchKeywords_ = messageKw_;
        [self changTipsLabel];
        [keyWorkLb setText:messageKw_];
        NSString * regionStr = [CondictionListCtl getRegionStr:messageRegionId_];
        btn.titleLb.text = regionStr;
        isFromMessage_ = NO;
    }
    
    //处理为空
    NSString *wokeAge = searchParam_.workAgeValue_;
    NSString *wokeAge1 = searchParam_.workAgeValue_1;
    if (!wokeAge) {
        wokeAge = @"";
    }
    if (!wokeAge1) {
        wokeAge1 = @"";
    }
    
    
    [con getFindJobList:searchParam_.tradeId_ regionId:searchParam_.regionId_ kw:searchParam_.searchKeywords_ time:searchParam_.timeStr_ eduId:searchParam_.eduId_ workAge:wokeAge workAge1:wokeAge1 payMent:searchParam_.payMentValue_ workType:searchParam_.workTypeValue_ page:requestCon_.pageInfo_.currentPage_ pageSize:18 highlight:@""];
    
    //职业经纪人信息
    [self getProfessionalAgentInfo];
}

#pragma mark 获取职业经纪人信息
- (void)getProfessionalAgentInfo
{
    NSString *cityStr = [Manager shareMgr].regionName_;
    NSString *regionId = [CondictionListCtl getRegionId:cityStr];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setValue:[Manager getUserInfo].userId_.length > 0 ? [Manager getUserInfo].userId_:@"" forKey:@"person_id"];
    [conditionDic setValue:regionId forKey:@"regionid"];
    [conditionDic setValue:[Manager getUserInfo].tradeId forKey:@"tradeid"];
    
    SBJsonWriter *jsonwrite = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonwrite stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"condition_arr=%@", conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:@"jingji_person_busi" func:@"getJingJiPerson" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSArray *arr = result[@"data"];
        
        if ((![arr isKindOfClass:[NSNull class]]) && [arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arr) {
                profeAgentModel.id_ = dic[@"_id"];
                profeAgentModel.expertIntroduce_ = dic[@"grzz"];
                profeAgentModel.gznum_ = dic[@"gznum"];
                profeAgentModel.iname_ = dic[@"iname"];
                profeAgentModel.is_jjr = dic[@"is_broker"];//1不是经纪人 2是经纪人
                profeAgentModel.zw_ = dic[@"person_zw"];
                profeAgentModel.img_ = dic[@"pic"];
                profeAgentModel.myselfIsAgented = dic[@"hasEntrust"];//1未委托 2 委托
                profeAgentModel.isHaveBroker = @"1";
                isHaveBroker = YES;
            }
            ELMyjobBrokerDAO *brokerDAO = [[ELMyjobBrokerDAO alloc]init];
            [brokerDAO deleteAll];
            [brokerDAO save:profeAgentModel];
        }
        else
        {
            isHaveBroker = NO;
        }
        [self updateCom:nil];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

//点击底部导航按钮回到顶部刷新列表
-(void)refreshBtnList
{
    [self refreshLoad:nil];
}

-(void) showNoDataOkView:(BOOL)flag
{
    self.noDataViewStartY = 288;
    [super showNoDataOkView:flag];
    //[[super getNoDataView] removeFromSuperview];
}

//网络异常提示
- (void)showErrorView:(BOOL)flag
{
    [[super getNoDataView] removeFromSuperview];
}

-(void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    switch (type) {
        case Request_HeadButtonList:
        {
            @try {
                [self sortHeadButtons:nil];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        }
            break;
            
        default:
            break;
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_FindJobList:
        {
            if (dataArr.count > 0) {
                if (dataArray_.count > 0) {
                    [dataArray_ removeAllObjects];
                }
//                [dataArray_ addObjectsFromArray:dataArr];
//                [tableView_ reloadData];
                ELMyjobsearchDAO *DAO = [[ELMyjobsearchDAO alloc]init];
                if([DAO deleteAll]){
                    for (NewJobPositionDataModel *vo in dataArr) {
                        NSString *benifits;
                        NSString * companyname;
                        if ([vo.fldy count] > 0) {
                            benifits = [vo.fldy componentsJoinedByString:@","];
                        }
                        if (vo.cname.length > 0) {
                            companyname = vo.cname;
                        }else
                        {
                            companyname = vo.cname_all;
                        }
                        vo.cname = companyname;
                        vo.benefits = benifits;
                        [DAO save:vo];
                    }
                }
                 shouldRefresh_ = NO;
            }
            else{
                self.imgTopSpace = 70;
            }
        }
            break;
        case Request_GetJobSubscribedList:
        {
            _index = 1;
            [jobSubscribedArray_ removeAllObjects];
            jobSubscribedArray_ = [dataArr mutableCopy];
            [tableView_ reloadData];
        }
            break;
        case Request_TopAD:
        {
            _adArray = [NSArray arrayWithArray:dataArr];
        }
            break;
        case Request_HeadButtonList:
        {
            @try {
                //                NSLog(@"%@",dataArr);
                [self sortHeadButtons:dataArr];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark--scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if ([scrollView isEqual:conScrollView]) {
//        CGPoint contentSet = scrollView.contentOffset;
//        page.currentPage = contentSet.x / ScreenWidth;
//    }
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    _currentLocation = [locations lastObject];
    
    //根据经纬度反向编译城市信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             for (CLPlacemark * placemark in array) {
                 //当前城市名称
                 NSString *myCity = placemark.locality;   // 比如：“西安市”
                 NSString *userLocationCity = getUserDefaults(kLocationCityName);
//                 New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
//                 if (![myCity isEqualToString:btn.titleLb.text]) {
                     if (!([userLocationCity isEqualToString:myCity])) {
                         NSString *msg = [NSString stringWithFormat:@"当前定位城市是%@，是否切换？",myCity];
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                         alertView.tag = 1000;
                         [alertView show];
                         _locationCity = myCity;
//                         isFirstLocation = YES;
                        }
//                     }
                 }
         }
     }];
    
    // 停止位置更新
    [_cllocation stopUpdatingLocation];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        switch (buttonIndex) {
            case 1:
            {                
                New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
                btn.titleLb.text = _locationCity;
                searchParam_.regionStr_ = _locationCity;
                searchParam_.regionId_ = [CondictionListCtl getRegionId:searchParam_.regionStr_];
                kUserDefaults(_locationCity, kLocationCityName);
                kUserSynchronize;
                //地区参数改变后自动请求
                [self refreshLoad:nil];
            }
                break;
                
            default:
                break;
        }
    }
    else if (alertView.tag == 50){
            switch (buttonIndex) {
                case 0:
                {
                    //确认委托
                    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&broker_user_id=%@&conditionArr={\"logs_remark\":\"100\"}&", [Manager getUserInfo].userId_, profeAgentModel.id_];
                    [ELRequest postbodyMsg:bodyMsg op:@"broker_entrust_busi" func:@"doEntrust" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                        if ([result[@"code"] isEqualToString:@"200"]) {
                            [BaseUIViewController showAutoDismissSucessView:nil msg:result[@"status_desc"] seconds:2.f];
                            profeAgentModel.myselfIsAgented = @"2";
                        }else{
                            [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"] seconds:2.f];
                        }
                        
                    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                        
                    }];
                }
                    break;
                default:
                    break;
            }
        }
}

- (void)changeSearchCondiction:(NSNotification *)info
{
    searchDefaul_ = NO;
    SearchParam_DataModal *model = [info object];
    if (model.searchKeywords_ != nil) {
        searchParam_.searchKeywords_ = model.searchKeywords_;
    }
    if (model.regionId_ != nil) {
        searchParam_.regionId_ = model.regionId_;
    }
    if (searchParam_.regionStr_ != nil) {
        searchParam_.regionStr_ = model.regionStr_;
    }
    New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
    btn.titleLb.text = _locationCity;
    if (searchParam_.regionStr_ == nil || [searchParam_.regionStr_ isEqualToString:@""]) {
        btn.titleLb.text = @"不限";
    }else{
        btn.titleLb.text = searchParam_.regionStr_;
    }
    
    [self refreshLoad:nil];
}

-(void)getCity
{
    [[MMLocationManager shareLocation] getCity:^(NSString *cityString) {
        searchParam_.regionStr_ = cityString;
        New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
        btn.titleLb.text = cityString;
        [self refreshLoad:nil];
    }];
}



#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewJobPositionDataModel *dataModal;
    if (dataArray_.count > 0) {
        if (indexPath.row < dataArray_.count) {
            dataModal = [dataArray_ objectAtIndex:indexPath.row];
        }
    }
    else{
        if (indexPath.row < requestCon_.dataArr_.count) {
            dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        }
    }
    if ([dataModal.fldy isKindOfClass:[NSNull class]] || dataModal.fldy.count == 0) {
        return 95;
    }else{
        return 118;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataArray_ count] > 0) {
        return [dataArray_ count];
    }
    else{
        return [requestCon_.dataArr_ count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyJobSearchCtlCell";
    MyJobSearchCtlCell *cell = (MyJobSearchCtlCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobSearchCtlCell" owner:self options:nil] firstObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = cellBgView;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    NewJobPositionDataModel *dataModal;
    if (dataArray_.count > 0) {
        if (indexPath.row < dataArray_.count) {
            dataModal = [dataArray_ objectAtIndex:indexPath.row];
        }
    }
    else{
        if (indexPath.row < requestCon_.dataArr_.count) {
            dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        }
    }
    
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
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
  
    NewJobPositionDataModel *dataModal;
    if(dataArray_.count > 0){
        dataModal = dataArray_[indexPath.row];
    }
    else{
        dataModal = requestCon_.dataArr_[indexPath.row];
    }
    if (![dataModal.zptype isEqualToString:@"1"]) {
        [BaseUIViewController showAlertView:@"" msg:@"该职位已停招" btnTitle:@"关闭"];
        return;
    }
    
    NSDictionary *dic = @{@"Function":@"职位推荐详情_MyJobSearchCtl"};
    [MobClick event:@"buttonClick" attributes:dic];
    
    if (_fromMessageList) {
        JobSearch_DataModal *modal = [[JobSearch_DataModal alloc] init];
        modal.zwID_ = dataModal.positionId;
        modal.zwName_ = dataModal.jtzw;
        modal.jtzw_ = dataModal.jtzw;
        modal.companyLogo_ = dataModal.logo;
        modal.companyName_ = dataModal.cname;
        modal.companyID_ = dataModal.uid;
        modal.salary_ = dataModal.xzdy;
        [_messageDelegate jobSearchMessageDelegateModal:modal];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    ZWDetail_DataModal *zwVO = [ZWDetail_DataModal new];
    zwVO.zwID_ = dataModal.positionId;
    zwVO.zwName_ = dataModal.jtzw;
    zwVO.jtzw_ = dataModal.jtzw;
    zwVO.companyLogo_ = dataModal.logo;
    zwVO.companyName_ = dataModal.cname;
    zwVO.companyID_ = dataModal.uid;
    zwVO.salary_ = dataModal.xzdy;
    PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
    detailCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:zwVO exParam:nil];
}

//获取搜索时需要的dataModal
-(SearchParam_DataModal *)getSearchDataModal
{
    SearchParam_DataModal *searchParam = [[SearchParam_DataModal alloc] init];
    searchParam.searchType_ = 3;
    searchParam.searchKeywords_ = keyWorkLb.text;
    searchParam.regionId_ = regionDataModal_.id_;
    searchParam.regionStr_ = regionDataModal_.str_;
    searchParam.bCampusSearch_ = NO;
    searchParam.tradeId_ = tradeDataModal_.id_;
    searchParam.tradeStr_ = tradeDataModal_.str_;
    searchParam.bParent_ = tradeDataModal_.bParent_;
    
    if (!searchParam.regionId_) {
        searchParam.regionId_ = @"";
        searchParam.regionStr_= @"不限";
    }
    if (!searchParam.tradeId_) {
        searchParam.tradeId_ = @"1000";
    }
    if (!searchParam.searchKeywords_) {
        searchParam.searchKeywords_ = @"";
    }
    
    searchParam.timeStr_ = @"";
    
    searchParam.workAgeValue_ = @"";
    searchParam.workAgeValue_1 = @"";
    
    searchParam.workTypeValue_ = @"";
    searchParam.eduId_ = @"";
    searchParam.payMentValue_ = @"";
    
    searchParam.workAgeName_ = @"";
    searchParam.workTypeName_ = @"";
    searchParam.eduName_ = @"";
    searchParam.payMentName_ = @"";
    searchParam.timeName_ = @"";
    return searchParam;
}

#pragma mark--条件选择代理
-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType)
    {
        case RegionChange:
        {
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            SqlitData *modal = dataModel;
            [self chooseCityToSearch:modal];
        }
            break;
        case TradeChange:
        {
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            tradeDataModal_ = dataModel;
            if( !tradeDataModal_ || tradeDataModal_.id_ == nil ){
                selectedBtn.titleLb.text = @"所有行业";
                searchParam_.tradeId_ = @"1000";
                searchParam_.tradeStr_ = @"不限";
            }else{
                selectedBtn.titleLb.text = tradeDataModal_.str_;
                searchParam_.tradeId_ = tradeDataModal_.id_;
                searchParam_.tradeStr_ = tradeDataModal_.str_;
            }
            [self refreshLoad:nil];
        }
            break;
        case SalaryMonthChange:
        {
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            
            CondictionList_DataModal *modal = dataModel;
            searchParam_.payMentValue_ = modal.id_;
            searchParam_.payMentName_ = modal.str_;
            
            if ([modal.id_ isEqualToString:@"lt||3000"]) {
                selectedBtn.titleLb.text = @"3000以下";
            }else if ([modal.id_ isEqualToString:@"gte||3000"]) {
                selectedBtn.titleLb.text = @"3000以上";
            }else if ([modal.id_ isEqualToString:@"gte||5000"]) {
                selectedBtn.titleLb.text = @"5000以上";
            }else if ([modal.id_ isEqualToString:@"gte||7000"]){
                selectedBtn.titleLb.text = @"7000以上";
            }else if ([modal.id_ isEqualToString:@"gte||10000"]){
                selectedBtn.titleLb.text = @"10000...";
            }else if([modal.str_ isEqualToString:@"不限"]){
                selectedBtn.titleLb.text = @"月薪";
            }else{
                selectedBtn.titleLb.text = searchParam_.payMentName_;
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

- (void)changConditionLbView
{
    NSString *tempString = @"";
    if (searchParam_.workAgeName_ != nil && ![searchParam_.workAgeName_ isEqualToString:@"不限"] && ![searchParam_.workAgeName_ isEqualToString:@""]) {
        tempString = searchParam_.workAgeName_;
    }
    if (searchParam_.timeName_ != nil && ![searchParam_.timeName_ isEqualToString:@"所有日期"] && ![searchParam_.timeName_ isEqualToString:@""]) {
        if (![tempString isEqualToString:@""]) {
            tempString = [NSString stringWithFormat:@"%@-%@",tempString, searchParam_.timeName_];
        }else{
            tempString = searchParam_.timeName_;
        }
    }
    if (searchParam_.eduName_ != nil && ![searchParam_.eduName_ isEqualToString:@"不限"] && ![searchParam_.eduName_ isEqualToString:@""]) {
        if (![tempString isEqualToString:@""]) {
            tempString = [NSString stringWithFormat:@"%@-%@",tempString, searchParam_.eduName_];
        }else {
            tempString = searchParam_.eduName_;
        }
    }
    if (searchParam_.workTypeName_ != nil && ![searchParam_.workTypeName_ isEqualToString:@"不限"] && ![searchParam_.workTypeName_ isEqualToString:@""]) {
        if (![tempString isEqualToString:@""]) {
            tempString = [NSString stringWithFormat:@"%@-%@",tempString, searchParam_.workTypeName_];
        }else{
            tempString = searchParam_.workTypeName_;
        }
    }
}

#pragma mark - 搜索条件代理
- (void)conditionSelectedOK:(SearchParam_DataModal *)searchParam
{
    searchParam_ = searchParam;
    [self refreshLoad:nil];
    [self changConditionLbView];
}
 
- (void)subscriptionSuccess
{
    if (!jobSubscribedCon_) {
        jobSubscribedCon_ = [self getNewRequestCon:NO];
    }
    [jobSubscribedCon_ getJobSubscribedList:[Manager getUserInfo].userId_];
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

#pragma Responding to keyboard events
//- (void)mykeyboardWillShow:(NSNotification *)notification {
//    if( !singleTapRecognizer_ )
//        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
//}
//
//- (void)mykeyboardWillHide:(NSNotification *)notification {
//    if (singleTapRecognizer_) {
//        [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
//        singleTapRecognizer_ = nil;
//    }
//}

-(void)getRegionSuccess
{
    searchParam_.regionStr_ = [Manager shareMgr].regionName_;
    searchParam_.regionId_ = [CondictionListCtl getRegionId:searchParam_.regionStr_];
    searchParam_.isSelected = NO;
    New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
    btn.titleLb.text = searchParam_.regionStr_;
    [self refreshLoad:nil];
}

#pragma mark - 委托
- (IBAction)brokerBtnClick:(id)sender {
    
    if (sender == _moreBrokerBtn) {
        NSDictionary *dic = @{@"Function":@"职业经纪人推荐更多选择_MyJobSearchCtl"};
        [MobClick event:@"buttonClick" attributes:dic];
        YLExpertListCtl *expertList = [[YLExpertListCtl alloc] init];
        expertList.selectedTab = @"职业经纪人";
        expertList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:expertList animated:YES];
    }

}

#pragma mark--
#pragma mark - 通知
-(void)addObserVer{
//    //增加键盘事件的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //用于接收消息里订阅参数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSearchCondiction:) name:@"CHANGSEARCHCODICTION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRegionSuccess) name:@"JOBSEARCHGETREGIONSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moreCacel:) name:@"moreCacel" object:nil];
}

-(void)moreCacel:(NSNotification *)notyfi{
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    nowBtn.isSelected = !nowBtn.isSelected;
    if (!isPush) {
        bgView.hidden = YES;
    }
}

#pragma mark-- New_HeaderDelegate 条件筛选点击按钮事件
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
    
    if (idx == 0) {//地区
        SqlitData *data = [[SqlitData alloc] init];
        data.provinceld = searchParam_.regionId_;
        data.provinceName = searchParam_.regionStr_;
        data.selected = searchParam_.isSelected;
        [self selectedType:RegionChange Model:data nowSelBtn:btn];
    }
    else if(idx == 1){//行业
        [self selectedType:TradeChange Model:tradeDataModal_ nowSelBtn:btn];
    }
    else if(idx == 2){//月薪
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        modal.id_ = searchParam_.payMentValue_;
        modal.str_ = searchParam_.payMentName_;
        [self selectedType:SalaryMonthChange Model:modal nowSelBtn:btn];
    }
    else{//更多
        [self selectedType:MoreChange Model:searchParam_ nowSelBtn:btn];
    }
}

#pragma mark--
#pragma mark - 业务逻辑
#pragma mark -- 返回地区
- (void)chooseCityToSearch:(SqlitData *)regionModel
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = regionModel.provinceName;
    dataModal.id_ = regionModel.provinceld;
    dataModal.bSelected_ = regionModel.selected;
    
    regionDataModal_ = dataModal;
    
    //地区参数添加道搜索参数
    searchParam_.regionStr_ = dataModal.str_;
    searchParam_.regionId_ = dataModal.id_;
    searchParam_.isSelected = dataModal.bSelected_;
    if ([dataModal.str_ isEqualToString:@"不限"]) {
        dataModal.str_ = @"地区";
    }
    selectedBtn.titleLb.text = dataModal.str_;
    //地区参数改变后自动请求
    [self refreshLoad:nil];
}

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
#pragma mark--
#pragma mark - 事件
//搜素框点击
-(void) btnResponse:(id)sender
{
    searchDefaul_ = NO;
    
    if (sender == searchBtn)
    {
        searchParam_.searchKeywords_ = @"";
        JobSearchCtl *searchCtl = [[JobSearchCtl alloc]init];
        searchCtl.fromMessageList = self.fromMessageList;
        searchCtl.myJobSearchCtl = self;
        searchCtl.payMentArray = payMentArray;
        searchCtl.searchParam = [[SearchParam_DataModal alloc] init];
        
        searchCtl.searchParam.searchKeywords_ = searchParam_.searchKeywords_;
        if (regionDataModal_.id_) {
            searchCtl.searchParam.regionId_ = regionDataModal_.id_;
            searchCtl.searchParam.regionStr_ = regionDataModal_.str_;
        }else{
            searchCtl.searchParam.regionId_ = searchParam_.regionId_;
            searchCtl.searchParam.regionStr_ = searchParam_.regionStr_;
        }
        
       
//        searchCtl.searchParam.tradeId_ = @"";
//        searchCtl.searchParam.tradeStr_ = @"";
        
        searchCtl.oldSearchParam = searchParam_;
        searchCtl.colorArr = colorArr_;
        
        searchCtl.searchBlock = ^(SearchParam_DataModal *searchParamModel, BOOL freshFlag){
            isPush = NO;
//            searchParam_.searchKeywords_ = searchParamModel.searchKeywords_;
//            [self changTipsLabel];
//            New_HeaderBtn *regionbtn = [self.view viewWithTag:kSelBtnTag];
//            New_HeaderBtn *tradebtn = [self.view viewWithTag:kSelBtnTag + 1];
//            keyWorkLb.text = searchParam_.searchKeywords_;
//            if ([searchParam_.regionStr_ isEqualToString:@"(null)"]) {
//                searchParam_.regionStr_ = @"不限";
//            }
//            regionbtn.titleLb.text = searchParam_.regionStr_;
//            if ([searchParam_.tradeId_ isEqualToString:@"1000"]) {
//                tradebtn.titleLb.text = @"所有行业";
//            }else{
//                tradebtn.titleLb.text = searchParam_.tradeStr_;
//            }
//            
//            searchDefaul_ = NO;
//            if (freshFlag) {
//                [self refreshLoad:nil];
//            }
        };
        searchCtl.hidesBottomBarWhenPushed = YES;
        isPush = YES;
        [self.navigationController pushViewController:searchCtl animated:YES];
    }
}

//搜索按钮点击
- (void)rightBarBtnResponse:(id)sender
{
    
    searchParam_.searchKeywords_ = @"";
    JobSearchCtl *searchCtl = [[JobSearchCtl alloc]init];
    searchCtl.fromMessageList = self.fromMessageList;
    searchCtl.myJobSearchCtl = self;
    searchCtl.payMentArray = payMentArray;
    searchCtl.searchParam = [[SearchParam_DataModal alloc] init];
    
    searchCtl.searchParam.searchKeywords_ = searchParam_.searchKeywords_;
    searchCtl.searchParam.regionId_ = searchParam_.regionId_;
    searchCtl.searchParam.regionStr_ = searchParam_.regionStr_;
//    searchCtl.searchParam.tradeId_ = searchParam_.tradeId_;
//    searchCtl.searchParam.tradeStr_ = searchParam_.tradeStr_;
    
    searchCtl.oldSearchParam = searchParam_;
    searchCtl.colorArr = colorArr_;
    
    searchCtl.searchBlock = ^(SearchParam_DataModal *searchParamModel, BOOL freshFlag){
        isPush = NO;
//        [self changTipsLabel];
//        keyWorkLb.text = searchParamModel.searchKeywords_;
//        New_HeaderBtn *regionbtn = [self.view viewWithTag:kSelBtnTag];
//        New_HeaderBtn *tradebtn = [self.view viewWithTag:kSelBtnTag + 1];
//        regionbtn.titleLb.text = searchParamModel.regionStr_;
//        if ([searchParamModel.tradeId_ isEqualToString:@"1000"]) {
//            tradebtn.titleLb.text = @"所有行业";
//        }else{
//            tradebtn.titleLb.text = searchParamModel.tradeStr_;
//        }
//        searchDefaul_ = NO;
//        if (freshFlag) {
//            [self refreshLoad:nil];
//        }
    };
    searchCtl.hidesBottomBarWhenPushed = YES;
    isPush = YES;
    [self.navigationController pushViewController:searchCtl animated:YES];
}


//点击职业经纪人头像跳转个人主页
- (void)goPersonCentertTap
{
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    [personCenterCtl beginLoad:profeAgentModel.id_ exParam:nil];
    personCenterCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personCenterCtl animated:YES];
}

- (IBAction)changeTyoeBtnRespone:(UIButton *)sender
{
    NSString *btnTitle = sender.titleLabel.text;
    if ([btnTitle isEqualToString:@"宣讲会"]) {
        //宣讲会
        [Manager shareMgr].registeType_ = FromXjh;
        [self funcName:@"宣讲会_MyJobSearchCtl" ctrlName:@"PropagandaCtl" withModel:nil];
    }else if ([btnTitle isEqualToString:@"我的简历"]) {
        //我的简历
        [self funcName:@"我的简历_MyJobSearchCtl"];
        if ([Manager shareMgr].haveLogin)
        {
            MyResumeController *myresume = [[MyResumeController alloc]init];
            [myresume beginLoad:nil exParam:nil];
            myresume.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myresume animated:YES];
        }else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        }
    }else if ([btnTitle isEqualToString:@"招聘会"]) {
        //招聘会
        [Manager shareMgr].registeType_ = FromZph;
        [self funcName:@"招聘会_MyJobSearchCtl" ctrlName:@"RecruitmentCtl" withModel:nil];
    }else if ([btnTitle isEqualToString:@"附近职位"]) {
        //附近职位
        searchParam_.searchKeywords_ = keyWorkLb.text;
        [self funcName:@"附近职位_MyJobSearchCtl" ctrlName:@"NearWorksCtl" withModel:nil];
    }
}

-(void)funcName:(NSString *)funName ctrlName:(NSString *)ctrlName withModel:(AD_dataModal *)dataModal{
    [self funcName:funName];
    id ctrl = [[NSClassFromString(ctrlName) alloc]init];
    if (dataModal) {
        dataModal.url_ = kURL;
        dataModal.title_ = @"实习兼职";
        dataModal.shareUrl = dataModal.url_;
        [ctrl setIsApplication:YES];
        [ctrl setIsThirdUrl:YES];
    }
    [ctrl setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl beginLoad:dataModal exParam:nil];
}

//友盟统计
-(void)funcName:(NSString *)funName{
    NSDictionary *dic = @{@"Function":funName};
    [MobClick event:@"buttonClick" attributes:dic];
}

//点击pageControl实现scrollview 滚动
//-(void)pageChanged:(UIPageControl *)sender{
//    CGSize size = conScrollView.frame.size;
//    CGRect frame = CGRectMake(sender.currentPage * size.width, 0, size.width, size.height);
//    [conScrollView scrollRectToVisible:frame animated:YES];
//}

#pragma mark - 附近职位，宣讲，实习兼职，我的简历，招聘会顺序
-(void)sortHeadButtons:(NSArray*)arr
{
    //宣讲会等按钮配置
    [self configHeaderBtn];
    
    if (arr.count > 0){
        [btnProperty removeAllObjects];
        for (int i = 0; i < arr.count; i++) {
            NSArray *numArr = btnTitleDic[arr[i]];
            [btnProperty addObject:numArr];
        }
        
        for(int i = 0; i < btnProperty.count; i++){
            UIButton *btn = btnArr[i];
            [btn setTitle:btnProperty[i][0] forState:UIControlStateNormal];
            btn.titleLabel.font = FOURTEENFONT_CONTENT;
            [btn setImage:[UIImage imageNamed:btnProperty[i][1]] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -34, -45, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-18, 14, 0, 0);
        }
    }
}

#pragma mark ---- status Bar Notification method
- (void)statusBarTouchedAction
{
    CGPoint offect = tableView_.contentOffset;
    offect.y = - tableView_.contentInset.top;
    [tableView_ setContentOffset:offect animated:YES];
}

#if 0
#pragma mark 行业选择回调
-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetTradeType:
        {
            tradeDataModal_ = dataModal;
            if( !tradeDataModal_ || tradeDataModal_.id_ == nil ){
                selectedBtn.titleLb.text = @"所有行业";
                searchParam_.tradeId_ = @"1000";
                searchParam_.tradeStr_ = @"所有行业";
            }else{
                selectedBtn.titleLb.text = tradeDataModal_.str_;
                searchParam_.tradeId_ = tradeDataModal_.id_;
                searchParam_.tradeStr_ = tradeDataModal_.str_;
            }
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
    regionDataModal_ = dataModal;
    
    if( !regionDataModal_ )
    {
        regionDataModal_ = [[CondictionList_DataModal alloc] init];
        regionDataModal_.str_ = @"不限";
    }
    selectedBtn.titleLb.text = regionDataModal_.str_;
    
}

#pragma ChooseHotCityDelegate
-(void) chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = city;
    dataModal.id_ = [CondictionPlaceCtl getRegionId:city];
    
    regionDataModal_ = dataModal;
    
    //地区参数添加道搜索参数
    searchParam_.regionStr_ = dataModal.str_;
    searchParam_.regionId_ = dataModal.id_;
    
    selectedBtn.titleLb.text = searchParam_.regionStr_;
    //地区参数改变后自动请求
    [self refreshLoad:nil];
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
