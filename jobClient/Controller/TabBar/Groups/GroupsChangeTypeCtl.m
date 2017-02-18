//
//  GroupsChangeTypeCtl.m
//  jobClient
//
//  Created by 王新建 on 15-3-24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//  

#import "GroupsChangeTypeCtl.h"
#import "MyGroups_Cell.h"
#import "Groups_DataModal.h"
#import "RecommendGroups_Cell.h"
#import "CompanyGroupIndustryCtl.h"
#import "NoLoginPromptCtl.h"
//#import "ZBarScanLoginCtl.h"
#import "ELGroupSearchCtl.h"
#import "ELGroupListDetailModel.h"
#import "ELGroupCommentModel.h"
#import "ELGroupArticleModel.h"
#import "ELGroupTypeChangeView.h"
#import "NewCareerTalkDataModal.h"
#import "YLOfferListCtl.h"
#import "ELGroupListTypeCountModel.h"
#import "CycleScrollView.h"
#import "ELPersonCenterCtl.h"
#import "SalaryIrrigationDetailCtl.h"
#import "SalaryCompeteCtl.h"
#import "ELGroupDetailCtl.h"


@interface GroupsChangeTypeCtl () <ELGroupDetailCtlDelegate,UISearchBarDelegate,NoLoginDelegate,CycleScrollViewDelegate>
{
    //热门行业相关标签
    IBOutlet UIImageView *hyImageOne;
    IBOutlet UILabel *hyTitleOne;
    IBOutlet UILabel *hyDetailOne;
  
    IBOutlet UIImageView *hyImageTwo;
    IBOutlet UILabel *hyTitleTwo;
    IBOutlet UILabel *hyDetailTwo;
  
    IBOutlet UIImageView *hyImageThree;
    IBOutlet UILabel *hyTitleThree;
    IBOutlet UILabel *hyDetailThree;
   
    IBOutlet UIImageView *hyImageFour;
    IBOutlet UILabel *hyTitleFour;
    IBOutlet UILabel *hyDetailFour;
    
    RequestCon *adCon; //广告请求
    NSArray *adArray;  //广告数组
    RequestCon *_addAdClickCount; //广告点击数统计请求
    RequestCon *tradeCon;//热门行业请求
    NSMutableArray *arrTradeData;//热门行业数组

    IBOutlet UIButton *rightBtn;//右上角按钮

    __weak IBOutlet NSLayoutConstraint *tableViewTap;//tableView距离顶部的距离、用于显示和隐藏搜索框
    ELGroupTypeChangeView *typeListView;//顶部行业选择按钮列表
    NSMutableArray *jobTypeArr;//行业类型数组
}

@property (nonatomic,strong) NSMutableArray *arrSearchData;

@end

@implementation GroupsChangeTypeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    bFooterEgo_ = YES;
    switch (_groupType) {
        case 1:
            [self setNavTitle:@"精选群"];
            break;
        case 2:
            [self setNavTitle:@"职业群"];
            break;
        case 3:
            [self setNavTitle:@"公司群"];
            break;
        default:
            break;
    }
    searchBar_.delegate = self;
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    UITextField *searchField = [searchBar_ valueForKey:@"_searchField"];
    [searchField setValue:UIColorFromRGB(0xd8d8d8) forKeyPath:@"_placeholderLabel.textColor"];
    
    tableView_.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    _arrSearchData = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
    
    if ([Manager shareMgr].haveLogin) {
        rightBtn.hidden = NO;
    }
    else
    {
        rightBtn.hidden = YES;
    }
}

- (void)requestData
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId || [userId isEqualToString:@""]) {
        userId = @"";
    }
    NSInteger source = 0;
    if (_groupType == 1){
        source = 2;
    }else if(_groupType == 2){
        source = 1;
    }else if (_groupType == 100){
        source = 100;
    }else{
        source = 3;
    }
    NSString *totalId = @"";
    if (_totalId) {
        totalId = _totalId;
    }
    [normalCon_ getMyGroupsJobWithCompanyList:userId group_source:source pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:15 tradeId:@"" totalId:totalId code:_groupCode.length > 0 ? _groupCode:@""];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (!_hideSearchBar)
    {
        searchBar_.hidden = NO;
        tableViewTap.constant = 42;
        [self.view layoutSubviews];
    }
}

-(void)viewDidLayoutSubviews{
    [self.view layoutSubviews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [searchBar_ resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnResponse:(id)sender{
    if (sender == rightBtn) {
        //扫码加群
        if ([Manager shareMgr].haveLogin) {
//            ZBarScanLoginCtl *ctl = [[ZBarScanLoginCtl alloc] init];
            ELScanQRCodeCtl *ctl = [[ELScanQRCodeCtl alloc] init];
            ctl.isZbar = YES;
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        }
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    searchBar_.text = @"";
    if (_hideSearchBar){
        searchBar_.hidden = YES;
        tableViewTap.constant = 0;
    }
    [super beginLoad:dataModal exParam:exParam];
}

#pragma mark - 获取JAVA,销售等标签信息
-(void)getDataList{
    __weak typeof(self) WeakSelf = self;
    [ELRequest postbodyMsg:@"" op:@"groups_busi" func:@"getGroupModuleList" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSArray *arr = result;
         if([arr isKindOfClass:[NSArray class]]){
             if (arr.count > 0) {
                 jobTypeArr = [[NSMutableArray alloc] init];
                 for (NSDictionary *dic in arr) {
                     ELGroupListTypeCountModel *modal = [[ELGroupListTypeCountModel alloc] initWithDictionary:dic];
                     [jobTypeArr addObject:modal];
                 }
                 typeListView = [[ELGroupTypeChangeView alloc] init];
                 [typeListView setButtonNameArr:jobTypeArr] ;
                 typeListView.frame = CGRectMake(0,0,ScreenWidth,typeListView.viewHeight);
                 typeListView.selectBlock = ^(ELGroupListTypeCountModel *dataModal){
                     GroupsChangeTypeCtl *ctl = [[GroupsChangeTypeCtl alloc] init];
                     ctl.groupType = 100;
                     ctl.groupCode = dataModal.code;
                     ctl.hideSearchBar = NO;
                   //  ctl.title = dataModal.name;
                     [ctl setNavTitle:dataModal.name];
                     
                     ctl.hidesBottomBarWhenPushed = YES;
                     [WeakSelf.navigationController pushViewController:ctl animated:YES];
                     [ctl beginLoad:nil exParam:nil];
                 };
                 tableView_.tableHeaderView = typeListView;
                 [self adjustFooterViewFrame];
             }
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

#pragma mark - 请求广告数据
-(void)getDataAD{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId || [userId isEqualToString:@""]) {
        userId = @"";
    }
    if (!adCon){
        adCon = [self getNewRequestCon:NO];
    }
    [adCon getTopAD:userId Type:@"app_sq"];
}

#pragma mark - 设置顶部广告
- (void)setAd
{
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    NSMutableArray *adImageArr = [[NSMutableArray alloc] init];
    for (AD_dataModal *modal in adArray)
    {
        NSString *titleStr = [NSString stringWithFormat:@"已有%ld人参与",(long)[modal.articleJoinCnt integerValue]];
        [titleArray addObject:titleStr];
        
        [adImageArr addObject:modal.pic_];
    }
    
    CycleScrollView *cycleView = [CycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 50, self.view.frame.size.width, (self.view.frame.size.width*100.0)/320.0) delegate:self placeholderImage:[UIImage imageNamed:@"ad_default.png"]];
    cycleView.pageControlAliment = CycleScrollViewPageContolAlimentCenter;
    cycleView.titleLabelStyle = CycleScrollViewCellTitleLabelRight;
    cycleView.titlesGroup = titleArray;
    cycleView.imageURLStringGroup = adImageArr;
    cycleView.currentPageDotColor = [UIColor whiteColor];
    cycleView.autoScrollTimeInterval = 10.0f;
    
    tableView_.tableHeaderView = cycleView;
    [self adjustFooterViewFrame];
}

#pragma mark CycleScrollViewDelegate
- (void)cycleScrollView:(CycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary * dic;
    
    AD_dataModal *dataModal = [adArray objectAtIndex:index];
    [_addAdClickCount addAdClickCount:dataModal.adId userId:[Manager getUserInfo].userId_?[Manager getUserInfo].userId_:@"" clientId:[Common idfvString]];
    if (![dataModal.type_ isEqualToString:@"3g"]){
        //v社群主页
        if ([dataModal.type_ isEqualToString:@"group"]){
            dic = @{@"Function":@"v社群主页"};
            ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
            Groups_DataModal *groupModal = [[Groups_DataModal alloc] init];
            groupModal.id_ = dataModal.gid;
            detaliCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detaliCtl animated:YES];
            [detaliCtl beginLoad:groupModal exParam:nil];
        }
        //v用户个人主页和行家
        if ([dataModal.type_ isEqualToString:@"yl_app_expert"]){
            dic = @{@"Function":@"v用户个人主页和行家"};
            ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
            personCenterCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personCenterCtl animated:YES];
            [personCenterCtl beginLoad:dataModal.pid exParam:nil];
        }
        //普通发表的文章详情页
        if ([dataModal.type_ isEqualToString:@"yl_app_normal_publish_detail"]){
            dic = @{@"Function":@"普通发表的文章详情页"};
            ArticleDetailCtl *articleDetail = [[ArticleDetailCtl alloc] init];
            Article_DataModal *articleModal = [[Article_DataModal alloc] init];
            articleModal.id_ = dataModal.aid;
            articleDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:articleDetail animated:YES];
            [articleDetail beginLoad:articleModal exParam:nil];
        }
        //用户发表列表页
        if ([dataModal.type_ isEqualToString:@"yl_app_user_publish_list"]){
            dic = @{@"Function":@"用户发表列表页"};
            ExpertPublishCtl *expertPublishCtl = [[ExpertPublishCtl alloc] init];
            PersonCenterDataModel *expertModal = [[PersonCenterDataModel alloc] init];
            expertModal.userModel_.id_ = dataModal.pid;
            expertPublishCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:expertPublishCtl animated:YES];
            [expertPublishCtl beginLoad:expertModal.userModel_ exParam:nil];
        }
        //社群话题详情页
        if ([dataModal.type_ isEqualToString:@"yl_app_group_topic_detail"]){
            dic = @{@"Function":@"社群话题详情页"};
            ArticleDetailCtl *articleDetail = [[ArticleDetailCtl alloc] init];
            articleDetail.isFromGroup_ = YES;
            Article_DataModal *articleModal = [[Article_DataModal alloc] init];
            articleModal.articleType_ = Article_Group;
            articleModal.groupId_ = dataModal.gid;
            articleModal.id_ = dataModal.aid;
            articleModal.code = dataModal.code;
            articleModal.group_open_status = dataModal.group_open_status;
            articleDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:articleDetail animated:YES];
            [articleDetail beginLoad:articleModal exParam:nil];
            [self getDataAD];
        }
        //灌薪水详情
        if ([dataModal.type_ isEqualToString:@"yl_app_guan_detail"]){
            dic = @{@"Function":@"灌薪水详情"};
            SalaryIrrigationDetailCtl *salaryCtl = [[SalaryIrrigationDetailCtl alloc] init];
            ELSalaryModel *arModal = [[ELSalaryModel alloc] init];
            arModal.article_id = dataModal.aid;
            salaryCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:salaryCtl animated:YES];
            [salaryCtl beginLoad:arModal exParam:nil];
        }
        //职位详情页
        if ([dataModal.type_ isEqualToString:@"yl_app_job_zw"]){
            dic = @{@"Function":@"职位详情页"};
            PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
            ZWDetail_DataModal *zwModal = [[ZWDetail_DataModal alloc] init];
            zwModal.zwID_ = dataModal.zwid;
            zwModal.companyName_ = dataModal.company_name;
            zwModal.companyID_ = dataModal.company_id;
            zwModal.companyLogo_ = dataModal.company_logo;
            positionDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:positionDetailCtl animated:YES];
            [positionDetailCtl beginLoad:zwModal exParam:nil];
        }
        //公司主页
        if ([dataModal.type_ isEqualToString:@"yl_app_job_company"]){
            dic = @{@"Function":@"公司主页"};
            PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
            positionDetailCtl.type_ = 2;
            ZWDetail_DataModal *zwModal = [[ZWDetail_DataModal alloc] init];
            zwModal.companyName_ = dataModal.company_name;
            zwModal.companyID_ = dataModal.company_id;
            positionDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:positionDetailCtl animated:YES];
            [positionDetailCtl beginLoad:zwModal exParam:nil];
        }
        //职导问答详情
        if ([dataModal.type_ isEqualToString:@"yl_app_zd_question"]){
            dic = @{@"Function":@"职导问答详情"};
            AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
            Answer_DataModal *answerModal = [[Answer_DataModal alloc] init];
            answerModal.questionId_ = dataModal.question_id;
            answerDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:answerDetailCtl animated:YES];
            [answerDetailCtl beginLoad:answerModal.questionId_ exParam:nil];
        }
        //宣讲会详情
        if ([dataModal.type_ isEqualToString:@"yl_app_teachins_xjh"]){
            dic = @{@"Function":@"宣讲会详情"};
            CareerTailDetailCtl *careerTail = [[CareerTailDetailCtl alloc] init];
            NewCareerTalkDataModal *xjhModal = [[NewCareerTalkDataModal alloc] init];
            xjhModal.xjhId = dataModal.teachins_id;
            xjhModal.type = 2;
            careerTail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:careerTail animated:YES];
            [careerTail beginLoad:xjhModal exParam:nil];
        }
        //招聘会详情页
        if ([dataModal.type_ isEqualToString:@"yl_app_teachins_zph"]){
            dic = @{@"Function":@"招聘会详情页"};
            JobFairDetailCtl *detailCtl = [[JobFairDetailCtl alloc] init];
            NewCareerTalkDataModal *zphModal = [[NewCareerTalkDataModal alloc]init];
            zphModal.xjhId = dataModal.teachins_id;
            zphModal.type = 1;
            detailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:zphModal exParam:nil];
        }
        //比薪资页面
        if ([dataModal.type_ isEqualToString:@"yl_app_skip_vs_pay"]){
            dic = @{@"Function":@"比薪资页面"};
            SalaryCompeteCtl *salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
            salaryCompeteCtl_.type_ = 2;
            User_DataModal *userModel = [Manager getUserInfo];
            [salaryCompeteCtl_ beginLoad:userModel.zym_ exParam:nil];
            salaryCompeteCtl_.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:salaryCompeteCtl_ animated:YES];
            
        }
        //offer派报名列表
        if ([dataModal.type_ isEqualToString:@"yl_app_skip_recomm_offer"]){
            dic = @{@"Function":@"offer派报名列表"};
            YLOfferListCtl *ctl = [[YLOfferListCtl alloc] init];
            [ctl beginLoad:nil exParam:nil];
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        }
        [MobClick event:@"buttonClick" attributes:dic];
    }else{
        NSArray *ylUrls = [[Manager shareMgr] getUrlArr];
        for (NSString *url in ylUrls){
            if ([dataModal.url_ rangeOfString:url].location != NSNotFound){
                NSDictionary *dic = @{@"Function":@"PushUrlCtl"};
                [MobClick event:@"buttonClick" attributes:dic];
                
                PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
                dataModal.shareUrl = dataModal.url_;
                pushurlCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pushurlCtl animated:YES];
                if ([dataModal.url_ containsString:@"?"]) {
                    dataModal.url_ = [dataModal.url_ stringByAppendingString:@"&appflag=1002"];
                }else{
                    dataModal.url_ = [dataModal.url_ stringByAppendingString:@"?appflag=1002"];
                }
                NSString *url = [self changeLinkUrl:dataModal.url_];
                [pushurlCtl beginLoad:url exParam:dataModal.title_];
                break;
            }
        }
    }
}

- (NSString *)changeLinkUrl:(NSString *)url
{
    if (url && ![url isEqualToString:@""]){
        NSString *timeNow = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
        NSString *personIdStr = [Manager getUserInfo].userId_;
        if(!personIdStr || [personIdStr isEqualToString:@""]){
            return url;
        }
        NSString *mD5CodeStr = @"1qaz2wsx1001";
        NSString *md5_1 = [MD5 getMD5:[NSString stringWithFormat:@"%@%@",personIdStr,timeNow]];
        NSString *cksMD5Str = [MD5 getMD5:[NSString stringWithFormat:@"%@%@",md5_1, mD5CodeStr]];
        NSString *encodedString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)url,
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  NULL,
                                                                  kCFStringEncodingUTF8));
        
        NSString *relUrl = [NSString stringWithFormat:@"http://m.yl1001.com/general/login?pid=%@&time=%@&cks=%@&jumpurl=%@", personIdStr, timeNow, cksMD5Str, encodedString];
        return relUrl;
    }
    return nil;
}


-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId || [userId isEqualToString:@""]) {
        userId = @"";
    }
    NSInteger source = 0;
    if (_groupType == 1){
        source = 2;
    }else if(_groupType == 2){
        source = 1;
    }else if (_groupType == 100){
        source = 100;
    }else{
        source = 3;
    }
    NSString *totalId = @"";
    if (_totalId) {
        totalId = _totalId;
    }
    [con getMyGroupsJobWithCompanyList:userId group_source:source pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:15 tradeId:@"" totalId:totalId code:_groupCode.length > 0 ? _groupCode:@""];
    if (_isHaveTradeChange && arrTradeData.count <= 0) {
        if (!tradeCon) {
            tradeCon = [self getNewRequestCon:NO];
        }
        [tradeCon getTradeType:0 page_size:1000];
    }
    if (_showAdView && adArray.count <= 0){
        [self getDataAD];
    }
    if (_showTypeChangeList && !jobTypeArr) {
        [self getDataList];
    }
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];

    switch (type) {
        case Request_GetMyGroupsJobAndCompany:
        {
            _finishRefresh = YES;
        }
            break;
        case request_TotalTradeList:
        {
            arrTradeData = [[NSMutableArray alloc] initWithArray:dataArr];
            
            [hyImageOne sd_setImageWithURL:[NSURL URLWithString:[arrTradeData[0] pic_]]];
            [hyImageTwo sd_setImageWithURL:[NSURL URLWithString:[arrTradeData[1] pic_]]];
            [hyImageThree sd_setImageWithURL:[NSURL URLWithString:[arrTradeData[2] pic_]]];
            [hyImageFour sd_setImageWithURL:[NSURL URLWithString:[arrTradeData[3] pic_]]];
            
            hyTitleOne.text = [arrTradeData[0] name_];
            hyTitleTwo.text = [arrTradeData[1] name_];
            hyTitleThree.text = [arrTradeData[2] name_];
            hyTitleFour.text = [arrTradeData[3] name_];
            
            hyDetailOne.text = [arrTradeData[0] intro_];
            hyDetailTwo.text = [arrTradeData[1] intro_];
            hyDetailThree.text = [arrTradeData[2] intro_];
            hyDetailFour.text = [arrTradeData[3] intro_];
            
            [tableView_ reloadData];
            [self adjustFooterViewFrame];
        }
            break;
        case Request_TopAD:
        {
            adArray = [NSArray arrayWithArray:dataArr];
            if (adArray.count > 0) {
                [self setAd];
            }else{
                tableView_.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,0.1)];
            }
        }
            break;
        default:
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    static NSString *CellIdentifier = @"MyGroupsCtlCell";
    MyGroups_Cell *cell = (MyGroups_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyGroups_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (requestCon_.dataArr_.count > 0) {
        ELGroupListDetailModel * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        
        [cell cellGiveDataWithModal:dataModal];
    }
    cell.lineImageLeft.constant = -10;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isHaveTradeChange && arrTradeData) {
        return 191.0;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)];
    view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_isHaveTradeChange && arrTradeData)
    {
        return _headerView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)];
    view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    return view;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    NSDictionary * dict = @{@"Function":@"群详情"};
    [MobClick event:@"buttonClick" attributes:dict];
    ELGroupDetailCtl *detailCtl = [[ELGroupDetailCtl alloc]init];
    if (_groupType == 3) {
        detailCtl.isCompanyGroup = YES;
    }
    detailCtl.delegate = self;
    ELGroupListDetailModel *dataModal = requestCon_.dataArr_[indexPath.row];
    if (_groupType == 3) {
        detailCtl.isCompanyGroup = YES;
    }
    detailCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:dataModal.group_id exParam:nil];
        
}
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)refresh
{
    [self refreshLoad:nil];
}
#pragma mark - SearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    ELGroupSearchCtl *ctl = [[ELGroupSearchCtl alloc] init];
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
    return NO;
}

- (IBAction)changeTradeBtnRespone:(UIButton *)sender
{
    NSDictionary * dict;

    if (sender.tag == 1100) {
        dict = @{@"Function":@"公司群_更多热门行业_GroupsChangeTypeCtl"};
        CompanyGroupIndustryCtl *ctl = [[CompanyGroupIndustryCtl alloc] init];
        ctl.arrData = arrTradeData;
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
        ctl.companyCtl = self;
    }
    else
    {
        dict = @{@"Function":@"公司群_热门行业_GroupsChangeTypeCtl"};
        GroupsChangeTypeCtl *ctl = [[GroupsChangeTypeCtl alloc] init];
        switch (sender.tag) {
            case 1001:
                ctl.totalId = [arrTradeData[0] id_];
                break;
            case 1002:
                ctl.totalId = [arrTradeData[1] id_];
                break;
            case 1003:
                ctl.totalId = [arrTradeData[2] id_];
                break;
            case 1004:
                ctl.totalId = [arrTradeData[3] id_];
                break;
            default:
                break;
        }
        ctl.groupType = 3;
        [ctl beginLoad:nil exParam:nil];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    [MobClick event:@"buttonClick" attributes:dict];
}

-(void)pushViewCtl:(NSString *)tradeId
{
    GroupsChangeTypeCtl *ctl = [[GroupsChangeTypeCtl alloc] init];
    ctl.groupType = 3;
    ctl.totalId = tradeId;
    [ctl beginLoad:nil exParam:nil];
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)tableViewContentSizeZero{
    [tableView_ setContentOffset:CGPointZero animated:YES];
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
            rect.origin.y = (int)((superView.frame.size.height - rect.size.height + 44)/2.0 + 42);
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


@end
