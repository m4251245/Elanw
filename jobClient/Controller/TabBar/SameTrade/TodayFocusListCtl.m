//
//  TodayFocusListCtl.m
//  jobClient
//
//  Created by 彭永 on 15-4-6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#define INDEX_OFFSET 1001
#import "TodayFocusListCtl.h"
#import "TodayFocus_Cell.h"
#import "Article_DataModal.h"
#import <objc/runtime.h>
#import "TodayFocusFrame_DataModal.h"
#import "SameTradeTipsCell.h"
#import "SameTradeListCtl.h"
#import "IndexNavView.h"
#import "MyJobGuideCtl.h"
#import "RecentNewsCtl.h"
#import "SalaryIrrigationDetailCtl.h"
#import "YLTheTopicCell.h"
#import "TheContactListCtl.h"
#import "MyOfferPartyIndexCtl.h"
#import "SalaryFutureListCtl.h"
#import "NearWorksCtl.h"
#import "ServiceInfo.h"
#import "ELRecommendView.h"
#import "YLAddListViewCtl.h"
#import "AlbumListCtl.h"
#import "NewsCtl.h"
#import "RecommendYLCtl.h"
#import "ELPublishActivityCtl.h"
#import "ELBecomeExpertCtl.h"
//#import "ELEmployerViewCtl.h"
#import "ELTodayFocusSearchCtl.h"
#import "ELPersonCenterCtl.h"
#import "RegInfoOneCtl.h"
#import "MyJobGuide_RewardCell.h"
#import "ELActivityListCell.h"
#import "CycleScrollView.h"
#import "NewCareerTalkDataModal.h"
#import "ELSalaryModel.h"
#import "ELOfferGuidanceCtl.h"
#import "YLExpertListCtl.h"
#import "SalaryCompeteCtl.h"
#import "SalaryListCtl.h"
#import "CHRIndexCtl.h"
#import "HRLoginCtl.h"
#import "SalaryCtl2.h"
//#import "BindCtl.h"

@interface TodayFocusListCtl ()<ELShareManagerDelegate,CycleScrollViewDelegate,NoLoginDelegate,SalaryIrrigationDetailDelegate,YLTheTopicCellDeletage,AddBtnDelegate,UISearchBarDelegate>
{
    NSMutableArray *_adArray;
    NSMutableArray *addListArr;
    NSInteger arrListCount;
    NSIndexPath *changPath;
    NSString *oldUserId;
    
    TodayFocusFrame_DataModal * _shareArticle;
    YLAddListViewCtl *addListView;
    ELOfferGuidanceCtl *_guideCtl; //offer派引导
    
    __weak IBOutlet UIImageView *addBtnImage;
    __weak IBOutlet UISearchBar *searchBar_;
    IBOutlet UIView *rightBtnView;
}
@property (weak, nonatomic) IBOutlet UIImageView *markImgShow;

@end

@implementation TodayFocusListCtl

@synthesize mynewMsgArray_, delegate_,moreBtn_;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"statusBarTouchedAction" object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setHidesBackButton:YES animated:NO];
        self.noRefershLoadData = YES;
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self changeMoreViewData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self oppAppWith3G];
    [self loadData];
}

#pragma mark - 通过3G页面打开app相关页面跳转
-(void)oppAppWith3G{
    if (![Manager shareMgr].haveLogin) {
        [Manager shareMgr].openAppZwModel = nil;
        [Manager shareMgr].openAppArticleId = nil;
        [Manager shareMgr].openAppPersonId = nil;
        [Manager shareMgr].openAppGroupId = nil;
        [Manager shareMgr].openAppArticleModal = nil;
        [Manager shareMgr].openAppSalaryModel = nil;
        [Manager shareMgr].openAppQuestionId = nil;
        [Manager shareMgr].openAppTeachinsModel = nil;
        [Manager shareMgr].openAppType = nil;
        return;
    }
    
    if (![Manager shareMgr].openAppType) {
        return;
    }
    
    if([[Manager shareMgr].openAppArticleId isKindOfClass:[NSString class]] && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_normal_publish_detail"]){
        if ([Manager shareMgr].openAppArticleId.length > 0) {
            //判断由网页打开app跳转文章详情
            ArticleDetailCtl *ctl = [[ArticleDetailCtl alloc] init];
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:[Manager shareMgr].openAppArticleId exParam:nil];
            [Manager shareMgr].openAppArticleId = nil;
        }
    }else if ([Manager shareMgr].openAppZwModel && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_job_zw"]){
        //判断由网页打开app跳转职位详情
        PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
        detailCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:[Manager shareMgr].openAppZwModel exParam:nil];
        [Manager shareMgr].openAppZwModel = nil;
    }else if ([[Manager shareMgr].openAppPersonId isKindOfClass:[NSString class]] && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_expert"]){
        if ([Manager shareMgr].openAppPersonId.length > 0) {
            //判断由网页打开app跳转个人或行家主页
            ELPersonCenterCtl *personCtl = [[ELPersonCenterCtl alloc] init];
            personCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personCtl animated:YES];
            [personCtl beginLoad:[Manager shareMgr].openAppPersonId exParam:nil];
            [Manager shareMgr].openAppPersonId = nil;
        }
    }else if ([[Manager shareMgr].openAppGroupId isKindOfClass:[NSString class]] && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_group"]){
        //社群主页
        if ([Manager shareMgr].openAppGroupId.length > 0) {
            ELGroupDetailCtl *detailCtl = [[ELGroupDetailCtl alloc] init];
            detailCtl.hidesBottomBarWhenPushed = YES;
            [[Manager shareMgr] selectdVCWithIndex:0];
            [[Manager shareMgr] pushWithCtl:detailCtl];
            [detailCtl beginLoad:[Manager shareMgr].openAppGroupId exParam:nil];
            [Manager shareMgr].openAppGroupId = nil;
        }
    }else if ([[Manager shareMgr].openAppPersonId isKindOfClass:[NSString class]] && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_user_publish_list"]){
        //用户发表列表
        if ([Manager shareMgr].openAppPersonId.length > 0) {
            ExpertPublishCtl *detailCtl = [[ExpertPublishCtl alloc] init];
            if ([[Manager shareMgr].openAppPersonId isEqualToString:[Manager getUserInfo].userId_]) {
                detailCtl.isMyCenter = YES;
            }else{
                detailCtl.isMyCenter = NO;
            }
            detailCtl.hidesBottomBarWhenPushed = YES;
            [[Manager shareMgr] selectdVCWithIndex:4];
            [[Manager shareMgr] pushWithCtl:detailCtl];
            [detailCtl beginLoad:[Manager shareMgr].openAppPersonId exParam:nil];
            [Manager shareMgr].openAppPersonId = nil;
        }
    }else if ([Manager shareMgr].openAppArticleModal && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_group_topic_detail"]){
        //社群话题详情页
        ArticleDetailCtl *detailCtl = [[ArticleDetailCtl alloc] init];
        detailCtl.isFromGroup_ = YES;
        detailCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr] selectdVCWithIndex:4];
        [[Manager shareMgr] pushWithCtl:detailCtl];
        [detailCtl beginLoad:[Manager shareMgr].openAppArticleModal exParam:nil];
        [Manager shareMgr].openAppArticleModal = nil;
        
    }else if ([Manager shareMgr].openAppSalaryModel && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_guan_detail"]){
        //灌薪水
        SalaryIrrigationDetailCtl *salaryCtl = [[SalaryIrrigationDetailCtl alloc] init];
        salaryCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr] selectdVCWithIndex:0];
        [[Manager shareMgr] pushWithCtl:salaryCtl];
        [salaryCtl beginLoad:[Manager shareMgr].openAppSalaryModel exParam:nil];
        [Manager shareMgr].openAppSalaryModel = nil;
        
    }else if ([Manager shareMgr].openAppZwModel && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_job_company"]){
        //公司主页
        PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
        positionDetailCtl.type_ = 2;
        positionDetailCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr] selectdVCWithIndex:2];
        [[Manager shareMgr] pushWithCtl:positionDetailCtl];
        [positionDetailCtl beginLoad:[Manager shareMgr].openAppZwModel exParam:nil];
        [Manager shareMgr].openAppZwModel = nil;
        
    }else if ([[Manager shareMgr].openAppQuestionId isKindOfClass:[NSString class]] && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_zd_question"]){
        //问答详情
        if ([Manager shareMgr].openAppQuestionId.length > 0) {
            AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
            answerDetailCtl.hidesBottomBarWhenPushed = YES;
            [[Manager shareMgr] selectdVCWithIndex:4];
            [[Manager shareMgr] pushWithCtl:answerDetailCtl];
            [answerDetailCtl beginLoad:[Manager shareMgr].openAppQuestionId exParam:nil];
            [Manager shareMgr].openAppQuestionId = nil;
        }
    }else if ([Manager shareMgr].openAppTeachinsModel && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_teachins_xjh"]){
        //宣讲会详情
        CareerTailDetailCtl *careerTail = [[CareerTailDetailCtl alloc] init];
        careerTail.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr] selectdVCWithIndex:1];
        [[Manager shareMgr] pushWithCtl:careerTail];
        [careerTail beginLoad:[Manager shareMgr].openAppTeachinsModel exParam:nil];
        [Manager shareMgr].openAppTeachinsModel = nil;
        
    }else if ([Manager shareMgr].openAppTeachinsModel && [[Manager shareMgr].openAppType isEqualToString:@"yl_app_teachins_zph"]){
        //招聘会
        JobFairDetailCtl *detailCtl = [[JobFairDetailCtl alloc] init];
        detailCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr] selectdVCWithIndex:1];
        [[Manager shareMgr] pushWithCtl:detailCtl];
        [detailCtl beginLoad:[Manager shareMgr].openAppTeachinsModel exParam:nil];
        [Manager shareMgr].openAppTeachinsModel = nil;
    
    }else if ([[Manager shareMgr].openAppType isEqualToString:@"yl_app_skip_vs_pay"]){
        //比薪资
        SalaryCompeteCtl *salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
        salaryCompeteCtl_.type_ = 2;
        User_DataModal *userModel = [Manager getUserInfo];
        [salaryCompeteCtl_ beginLoad:userModel.zym_ exParam:nil];
        salaryCompeteCtl_.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr] pushWithCtl:salaryCompeteCtl_];
         [Manager shareMgr].openAppType = nil;
    
    }else if ([[Manager shareMgr].openAppType isEqualToString:@"yl_app_skip_recomm_offer"]){
        //offer派报名
        MyOfferPartyIndexCtl *ctl = [[MyOfferPartyIndexCtl alloc] init];
        ctl.isFromHome = YES;
        [ctl beginLoad:nil exParam:nil];
        ctl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr] pushWithCtl:ctl];
        [Manager shareMgr].openAppType = nil;
    
    }else if ([[Manager shareMgr].openAppType isEqualToString:@"yl_app_skip_recomm_job"]){
        //职业经纪人
        YLExpertListCtl *expertList = [[YLExpertListCtl alloc] init];
        expertList.selectedTab = @"职业经纪人";
        expertList.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr] pushWithCtl:expertList];
        [Manager shareMgr].openAppType = nil;
    }
    //兼容旧版本
    else if([[Manager shareMgr].openAppArticleId isKindOfClass:[NSString class]]){
        if ([Manager shareMgr].openAppArticleId.length > 0) {
            //判断由网页打开app跳转文章详情
            ArticleDetailCtl *ctl = [[ArticleDetailCtl alloc] init];
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:[Manager shareMgr].openAppArticleId exParam:nil];
            [Manager shareMgr].openAppArticleId = nil;
        }
    }else if ([Manager shareMgr].openAppZwModel){
        //判断由网页打开app跳转职位详情
        PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
        detailCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:[Manager shareMgr].openAppZwModel exParam:nil];
        [Manager shareMgr].openAppZwModel = nil;
    }
    
    else{
        [Manager shareMgr].openAppZwModel = nil;
        [Manager shareMgr].openAppArticleId = nil;
        [Manager shareMgr].openAppPersonId = nil;
        [Manager shareMgr].openAppGroupId = nil;
        [Manager shareMgr].openAppArticleModal = nil;
        [Manager shareMgr].openAppSalaryModel = nil;
        [Manager shareMgr].openAppQuestionId = nil;
        [Manager shareMgr].openAppTeachinsModel = nil;
        
    }
    [Manager shareMgr].openAppType = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMesh:) name:@"launch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchedAction) name:@"statusBarTouchedAction" object:nil];
    [self setNavTitle:@"今日看点"];
    
    self.hideBackButton = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect rect = self.tableView.frame;
    rect.size.height = rect.size.height - 44;
    self.tableView.frame = rect;
    
    searchBar_.delegate = self;
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    [Manager clearLikeData];
    [Manager changeWebViewUserAgent];
}

//- (void)pushMesh:(NSNotification *)noti
//{
//    [[Manager shareMgr] receiveRemoteNotification:noti.object];
//}
#pragma mark - 加载数据
-(void)loadData{
    if ((![oldUserId isEqualToString:[Manager getUserInfo].userId_] || !oldUserId || [oldUserId isEqualToString:@""]) && ![oldUserId isEqualToString:@"noLogin"]) {
        NSDictionary *dicList = [self getListData];
        NSDictionary *dicAd = [self getAd];
        
        if (dicAd) {
            [self jsonAdDataWithDic:dicAd];
        }
        [self getAllListData];
        if (dicList){
            [self parserTodayFocusList:dicList];
        }else{
            [self refreshLoad];
        }
        if ([Manager shareMgr].haveLogin) {
            oldUserId = [Manager getUserInfo].userId_;
        }else{
            oldUserId = @"noLogin";
        }
        
    }
}

#pragma mark - 根据是否为行家刷新数据
-(void)changeMoreViewData{
    if ([Manager shareMgr].haveLogin){
        if([Manager getUserInfo].isExpert_){//行家可以发布活动
            if (addListArr){
                if (![addListArr containsObject:@"fbhd"]){
                    [addListArr addObject:@"fbhd"];
                }
            }
        }else{
            if (addListArr){
                if ([addListArr containsObject:@"fbhd"]){
                    [addListArr removeObject:@"fbhd"];
                }
            }
        }
    }else{
        if (addListArr){
            if ([addListArr containsObject:@"fbhd"]){
                [addListArr removeObject:@"fbhd"];
            }
        }
    }
    
    if (addListArr) {
        if (addListArr.count != arrListCount) {
            addListView = [[YLAddListViewCtl alloc] init];
            addListView.addBtnDelegate = self;
            arrListCount = addListArr.count;
        }
    }
}

#pragma mark - offerPai相关
- (void)checkForOfferPartys
{
    if ([Manager shareMgr].haveLogin) {
        NSString *op = @"jobfair_person_busi";
        NSString *function = @"getJobfairByPersonid";
        
        NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@", [Manager getUserInfo].userId_];
        
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            
            NSDictionary *dict = result;
            BOOL ishold = [dict[@"ishold"] boolValue];
            NSString *jobfairId = dict[@"jobfair_id"];
            if (ishold && ![jobfairId isEqualToString:@""]) {
                [self showOfferPartyGuideController:jobfairId];
            }
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
    }
}

- (void)showOfferPartyGuideController:(NSString *)currentJobfairId
{
    BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"showOfferPartyGuide"];
    if (isShow) {
        NSLog(@"---------showOfferPartyGuide---------");
        //当前正在进行的offer派Id  currentJobfairId
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        //缓存的offer派Id
        NSString *offerPartyId = [userdefault objectForKey:@"offerPartyId"];
        
        if (![offerPartyId isEqualToString:currentJobfairId]) {
            //重新缓存offer派Id
            [userdefault setObject:currentJobfairId forKey:@"offerPartyId"];
            [userdefault synchronize];
        
            //弹出引导页
            if (!_guideCtl) {
                _guideCtl = [[ELOfferGuidanceCtl alloc] init];
                _guideCtl.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            }
            
            [_guideCtl showViewCtl];
        }
    }
}

#pragma mark - 本页面相关数据获取

- (void)beginLoad:(id)dataModal exParam:(id)exParam{
    [super beginLoad:dataModal exParam:exParam];
    [self requestListData];
    //[con getTodayFoucsListByUserId:userId currentPage:con.pageInfo_.currentPage_ pageSize:10];
}

-(void)requestListData{
    if (![Manager shareMgr].accessTokenModal) {
        [[ELRequest sharedELRequest] requestWithUserName:WebService_User pwd:WebService_Pwd baseUrl:SeviceURL block:^(NSDictionary *dic){
            AccessToken_DataModal *dataModal = [[AccessToken_DataModal alloc] init];
            dataModal.sercet_ = [dic objectForKey:@"secret"];
            dataModal.accessToken_ = [dic objectForKey:@"access_token"];
            [dataModal saveDataModalWithUserDefaultType:AccessTokenTypeOne];
            [Manager shareMgr].accessTokenModal = dataModal;
            [self beginLoad:nil exParam:nil];
        }];
    }
    if (!_navView || self.pageInfo.currentPage_==0){
        [self getAllListData];
        [[Manager shareMgr] requestAdUrl3GArr];
    }
    [ELRequest postbodyMsg:[self getBodyMsgString] op:@"yl_es_person_busi" func:@"getJrkdList" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        [self jsonListDataWithDic:dic];
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

-(NSString *)getBodyMsgString{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = @"";
    [searchDic setObject:[MyCommon getAddressBookUUID] forKey:@"client_id"];
    if (userId && ![userId isEqualToString:@""]) {
        [searchDic setObject:userId forKey:@"person_id"];
        searchDicStr = [jsonWriter stringWithObject:searchDic];
    }
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@&", searchDicStr, conditionDicStr];
    return bodyMsg;
}

-(void)jsonListDataWithDic:(NSDictionary *)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        
        NSArray * dataArray = [dic objectForKey:@"data"];
        if ([dataArray isKindOfClass:[NSNull class]]) {
            dataArray = @[];
        }
        if (dataArray.count > 0 && self.pageInfo.currentPage_ == 0) {
            [self saveListDataWithArr:dic];
            [_dataArray removeAllObjects];
        }
        [self parserPageInfo:dic];
        for (NSDictionary * subDic in dataArray) {
            TodayFocusFrame_DataModal * dataModal = [[TodayFocusFrame_DataModal alloc] init];
            NSString *articleType = subDic[@"_source_type"];
            if ([articleType isEqualToString:@"hytt"]){//行业头条
                dataModal.articleType_ = Article_Trade_Head;
            }else if ([articleType isEqualToString:@"article_gxs"]){//灌薪水
                dataModal.articleType_ = Article_GXS;
            }else if ([articleType isEqualToString:@"article_group"]){//社群
                dataModal.articleType_ = Article_Group;
            }else if ([articleType isEqualToString:@"question"]) {//问答
                dataModal.articleType_ = Article_Question;
            }else if ([articleType isEqualToString:@"article"]) {//其他文章（同行文章）
                dataModal.articleType_ = Article_Follower;
            }
            ELSameTrameArticleModel *model = [[ELSameTrameArticleModel alloc] initWithDictionary:subDic];
            if ([model.is_recommend isEqualToString:@"1"]) {
                dataModal.isRecommentAnswer = YES;
            }
            if (model._activity_info) {
                dataModal.isActivityArtcle = YES;
                model._activity_info.person_id = model.personId;
                model._activity_info.person_pic = model.person_pic;
                model._activity_info.person_iname = model.person_iname;
            }
            dataModal.sameTradeArticleModel = model;
            if (model.article_id) {
                [_dataArray addObject:dataModal];
            }
        }
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
        [delegate_ finishGetMyData];
        [self checkForOfferPartys];
    }
}

#pragma mark - 请求四个列表的数据
-(void)getAllListData
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    NSString *str = [Manager shareMgr].regionName_;
    NSString *region = [[NSUserDefaults standardUserDefaults] objectForKey:MMLastCity];
    if (region.length > 0) {
        str = region;
    }
    if (!str || [str isEqual:[NSNull null]] || str == nil)
    {
        str = @"";
    }
    NSString * idstr = [CondictionListCtl getRegionId:str];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:idstr forKey:@"regionid"];
    
//    [conditionDic setObject:@"528" forKey:@"type"];
//    [conditionDic setObject:@"2481473219516983" forKey:@"jobfair_id"];
//    [conditionDic setObject:@"3181474275063353" forKey:@"tuijian_id"];
//    [conditionDic setObject:@"0" forKey:@"state"];
//    [conditionDic setObject:@"cm1473220109625" forKey:@"company_id"];
//    [conditionDic setObject:@"0" forKey:@"msgtype"];

    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@",userId,conditionDicStr];
    NSString * function = @"getTonghModuleSort";
    NSString * op = @"control_position_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if (dic.count < 1) {
            return ;
        }
        [self saveAdWithArr:dic];
        [self jsonAdDataWithDic:dic];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)jsonAdDataWithDic:(NSDictionary *)dic{
    [self getFirstListArr:dic[@"tongh"]];
    //[self getRecommendMenu:dic[@"xiaob"]];
    [self getTonghangAdvData:dic[@"adv"]];
    if (!addListArr) {
        addListArr = [[NSMutableArray alloc] init];
    }
    [addListArr removeAllObjects];
    [addListArr addObjectsFromArray:dic[@"plus"]];
    if ([Manager shareMgr].haveLogin)
    {
        if (![Manager getUserInfo].isExpert_)
        {
            if ([addListArr containsObject:@"fbhd"]) {
                [addListArr removeObject:@"fbhd"];
            }
        }
    }
    else
    {
        if ([addListArr containsObject:@"fbhd"])
        {
            [addListArr removeObject:@"fbhd"];
        }
    }
    arrListCount = addListArr.count;
    
    [self refreshHeaderView];
}

-(void)refreshHeaderView{
    CGFloat height = 0;
    CGRect frame = CGRectZero;
    if (_navView) {
        frame = _navView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        _navView.frame = frame;
        height += frame.size.height;
    }
    if (_adView) {
        frame = _adView.frame;
        frame.origin.x = 0;
        frame.origin.y = height;
        _adView.frame = frame;
        height += frame.size.height;
    }
//    if (_recommendView) {
//        frame = _recommendView.frame;
//        frame.origin.x = 0;
//        frame.origin.y = height;
//        _recommendView.frame = frame;
//        height += frame.size.height;
//    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,height)];
    if (_navView) {
        [headerView addSubview:_navView];
    }
    if (_adView) {
        [headerView addSubview:_adView];
    }
//    if (_recommendView) {
//        [headerView addSubview:_recommendView];
//    }
    self.tableView.tableHeaderView = headerView;
    [self.tableView reloadData];
    [self adjustFooterViewFrame];
}

#pragma mark - 创建小编推荐上方卡片
-(void)getFirstListArr:(NSArray *)dic{
    if (_navView) {
        [_navView removeFromSuperview];
    }
    IndexNavView *navView = [[IndexNavView alloc]init];
    __weak TodayFocusListCtl  *weakSelf = self;
    navView.clickBlock = ^(NSString *type){
        [weakSelf buttonResponeRecommentWithType:type];
    };
    navView.indexNavArray = dic;
    navView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _navView = navView;
    
    [navView reloadFriendMessageCountLb:[Manager shareMgr].messageCountDataModal.sameTradeMessageCnt withFriendCount:[Manager shareMgr].messageCountDataModal.friendMessageCnt];
}

#pragma mark - 顶部按钮点击
-(void)buttonResponeRecommentWithType:(NSString *)type{
    NSString *dictStr;
    if ([type isEqualToString:@"pengyq"]){//朋友圈
        if(![Manager shareMgr].haveLogin){
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_Today_Recomment;
            [NoLoginPromptCtl getNoLoginManager].noLoginDic = @{@"type":type};
            return;
        }
        dictStr = [NSString stringWithFormat:@"%@_%@", @"朋友圈", [self class]];
        RecentNewsCtl *recentNewsCtl = [[RecentNewsCtl alloc]init];
        recentNewsCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:recentNewsCtl animated:YES];
        [recentNewsCtl beginLoad:nil exParam:nil];
        [Manager shareMgr].messageCountDataModal.sameTradeMessageCnt = 0;
    }
    else if ([type isEqualToString:@"zhid"]) {//业问
        dictStr = [NSString stringWithFormat:@"%@_%@", @"业问", [self class]];
        MyJobGuideCtl *myJobGuideCtl_ = [[MyJobGuideCtl alloc] init];
        myJobGuideCtl_.hidesBottomBarWhenPushed = YES;
        myJobGuideCtl_.noSegment = YES;
        [self.navigationController pushViewController:myJobGuideCtl_ animated:YES];
    }
    else if ([type isEqualToString:@"zhaoth"]) {//找同行
        dictStr = [NSString stringWithFormat:@"%@_%@", @"找同行", [self class]];
        
        SameTradeListCtl *sameTradeCtl = [[SameTradeListCtl alloc]init];
        sameTradeCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sameTradeCtl animated:YES];
        [sameTradeCtl beginLoad:nil exParam:nil];
    }
    else if ([type isEqualToString:@"chagz"]){//查工资， 曝工资
        dictStr = [NSString stringWithFormat:@"%@_%@", @"查工资", [self class]];
        
        SalaryListCtl *salaryCompareCtl = [[SalaryListCtl alloc]init];
        salaryCompareCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:salaryCompareCtl animated:YES];
        [salaryCompareCtl beginLoad:nil exParam:nil];
    }
    else if ([type isEqualToString:@"guanxs"]){//灌薪水
        dictStr = [NSString stringWithFormat:@"%@_%@", @"灌薪水", [self class]];
        
        SalaryCtl2 *salaryIrrigationCtl = [[SalaryCtl2 alloc]init];
        salaryIrrigationCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:salaryIrrigationCtl animated:YES];
        [salaryIrrigationCtl beginLoad:nil exParam:nil];
    }
    else if ([type isEqualToString:@"offer"]) {
        //offer派
        dictStr = [NSString stringWithFormat:@"%@_%@", @"offer派", [self class]];
        
        MyOfferPartyIndexCtl *ctl = [[MyOfferPartyIndexCtl alloc] init];
        ctl.isFromHome = YES;
        [ctl beginLoad:nil exParam:nil];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if ([type isEqualToString:@"shyg"]) {//三好一改
        dictStr = [NSString stringWithFormat:@"%@_%@", @"三好一改", [self class]];
        
        NSString *url = @"http://m.yl1001.com/zhuanti/shyg/";
        PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
        
        if ([url containsString:@"?"]) {
            url = [url stringByAppendingString:@"&appflag=1002"];
        }else{
            url = [url stringByAppendingString:@"?appflag=1002"];
        }
        pushurlCtl.fromThreeGoodOneChange = YES;
        pushurlCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushurlCtl animated:YES];
        [pushurlCtl beginLoad:url exParam:nil];
    }
    else if ([type isEqualToString:@"bixz"]){//比薪资
        if (![Manager shareMgr].haveLogin) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_Today_Recomment;
            [NoLoginPromptCtl getNoLoginManager].noLoginDic = @{@"type":type};
            return;
        }
        if (![AFNetworkReachabilityManager sharedManager].isReachable  && [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusUnknown) {
            [BaseUIViewController showAlertViewContent:@"当前网络可能没有连接" toView:nil second:1.0 animated:YES];
        }else{
            // [weakSelf.querySalaryCountCon getSalaryQueryCountWithUserId:userId];
            SalaryCompeteCtl * salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
            salaryCompeteCtl_.type_ = 2;
            User_DataModal *userModel = [Manager getUserInfo];
            [salaryCompeteCtl_ beginLoad:userModel.zym_ exParam:nil];
            salaryCompeteCtl_.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:salaryCompeteCtl_ animated:YES];
        }
        
        dictStr = [NSString stringWithFormat:@"%@_%@", @"比薪资", [self class]];
    }
    else if ([type isEqualToString:@"kanqj"]){//看前景
        dictStr = [NSString stringWithFormat:@"%@_%@", @"看前景", [self class]];
        
        SalaryFutureListCtl *futureCtl = [[SalaryFutureListCtl alloc]init];
        futureCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:futureCtl animated:YES];
        [futureCtl beginLoad:nil exParam:nil];
    }
    else if ([type isEqualToString:@"shuoxw"]){//说新闻
        dictStr = [NSString stringWithFormat:@"%@_%@", @"说薪闻", [self class]];
        
        NewsCtl *newsCtl = [[NewsCtl alloc]init];
        newsCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsCtl animated:YES];
        [newsCtl beginLoad:nil exParam:nil];
    }else if ([type isEqualToString:@"zhaorc"]){//找人才
        if ([Manager shareMgr].haveLogin) {
            [Manager shareMgr].registeType_ = FromCompany;
            [self requestFindPeople];
            dictStr = [NSString stringWithFormat:@"%@_%@", @"找人才", [self class]];
        }else{
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_Today_Recomment;
            [NoLoginPromptCtl getNoLoginManager].noLoginDic = @{@"type":type};
            return;
        }
    }
    else if ([type isEqualToString:@"group"]){//社群
        dictStr = [NSString stringWithFormat:@"%@_%@", @"社群", [self class]];
        ELMyGroupCenterCtl *myGroupCtl = [[ELMyGroupCenterCtl alloc] init];
        myGroupCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:myGroupCtl animated:YES];
    }
    //记录友盟统计模块使用量
    NSDictionary *dict = @{@"Function" : dictStr};
    [MobClick event:@"buttonClick" attributes:dict];

}
#pragma mark - 找人才请求
-(void)requestFindPeople{
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",[Manager getUserInfo].userId_];
    NSString *function = @"isBindingPerson";
    NSString *op = @"binding_salerperson_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:NO progressMsg:nil success:^(NSURLSessionDataTask *operation, id result){
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]){
            NSString *status = dic[@"status"];
            id dataModel = nil;
            if ([status isEqualToString:@"OK"]) {
                NSString *type = dic[@"type"];
                if ([type isEqualToString:@"2"]){
                    CompanyInfo_DataModal * dataModal = [[CompanyInfo_DataModal alloc] init];
                    dataModal.companyID_ = [dic objectForKey:@"company_id"];
                    dataModel = dataModal;
                    [CommonConfig setDBValueByKey:@"companyID" value:dataModal.companyID_];
                }else{
                    [CommonConfig setDBValueByKey:@"companyID" value:@""];
                }
            }else{
                [CommonConfig setDBValueByKey:@"companyID" value:@""];
            }
            return ;
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 小编推荐的菜单
- (void)getRecommendMenu:(NSArray *)dic
{
    _recommendView = [[ELRecommendView alloc]init];
    _recommendView.recommendArr = (NSArray *)dic;
    _recommendView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
}

#pragma mark - 解析同行广告页
-(void)getTonghangAdvData:(NSArray *)dic{
    _adArray = [[NSMutableArray alloc] init];
    if ([dic isKindOfClass:[NSArray class]]){
        for (NSDictionary * subDic in dic){
            AD_dataModal * dataModal = [[AD_dataModal alloc] initWithDictionary:subDic];
            [_adArray addObject:dataModal];
        }
        if ([_adArray count] > 0 ) {
            [self setAd];
        }
    }
}

#pragma mark - 设置顶部广告
-(void)setAd
{
    if (_adView) {
        [_adView removeFromSuperview];
    }
    NSMutableArray *adImageArr = [[NSMutableArray alloc] init];
    for (AD_dataModal *modal in _adArray)
    {
        [adImageArr addObject:modal.pic_];
    }
    
    CycleScrollView *cycleView = [CycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 50, ScreenWidth, (ScreenWidth*100.0)/320.0) delegate:self placeholderImage:[UIImage imageNamed:@"ad_default.png"]];
    cycleView.pageControlAliment = CycleScrollViewPageContolAlimentCenter;
    cycleView.titleLabelStyle = CycleScrollViewPageContolAlimentRight;
    cycleView.imageURLStringGroup = adImageArr;
    cycleView.currentPageDotColor = [UIColor whiteColor];
    cycleView.autoScrollTimeInterval = 10.0f;
    
    UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(0,cycleView.frame.size.height, ScreenWidth, 5)];
    separateLine.backgroundColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.f];
    [cycleView addSubview:separateLine];
    
    CGRect frame = cycleView.frame;
    frame.size.height +=5;
    cycleView.frame = frame;
    
    _adView = cycleView;
}


#pragma mark - 广告代理CycleScrollViewDelegate
- (void)cycleScrollView:(CycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    AD_dataModal * dataModal = [_adArray objectAtIndex:index];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"rel_id=%@&statInfo={\"person_id\":\"%@\", \"client_id\":\"%@\"}&", dataModal.adId, [Manager getUserInfo].userId_?[Manager getUserInfo].userId_:@"", [Common idfvString]];
    [ELRequest postbodyMsg:bodyMsg op:@"yl_adv_busi" func:@"addAdvStat" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {}];
    
    if (![dataModal.type_ isEqualToString:@"3g"])
    {
        //v社群主页
        if ([dataModal.type_ isEqualToString:@"yl_app_group"])
        {
            ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
            Groups_DataModal *groupModal = [[Groups_DataModal alloc] init];
            groupModal.id_ = dataModal.gid;
            detaliCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detaliCtl animated:YES];
            [detaliCtl beginLoad:groupModal exParam:nil];
        }
        
        //v用户个人主页和行家
        else if ([dataModal.type_ isEqualToString:@"yl_app_expert"])
        {
            ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
            personCenterCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personCenterCtl animated:YES];
            [personCenterCtl beginLoad:dataModal.pid exParam:nil];
        }
        
        //普通发表的文章详情页
        else if ([dataModal.type_ isEqualToString:@"yl_app_normal_publish_detail"])
        {
            ArticleDetailCtl *articleDetail = [[ArticleDetailCtl alloc] init];
            Article_DataModal *articleModal = [[Article_DataModal alloc] init];
            articleModal.id_ = dataModal.aid;
            articleDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:articleDetail animated:YES];
            [articleDetail beginLoad:articleModal exParam:nil];
        }
        
        //用户发表列表页
        else if ([dataModal.type_ isEqualToString:@"yl_app_user_publish_list"])
        {
            ExpertPublishCtl *expertPublishCtl = [[ExpertPublishCtl alloc] init];
            PersonCenterDataModel *expertModal = [[PersonCenterDataModel alloc] init];
            expertModal.userModel_.id_ = dataModal.pid;
            expertPublishCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:expertPublishCtl animated:YES];
            [expertPublishCtl beginLoad:expertModal.userModel_ exParam:nil];
        }
        
        //社群话题详情页
        else if ([dataModal.type_ isEqualToString:@"yl_app_group_topic_detail"])
        {
            ArticleDetailCtl *articleDetail = [[ArticleDetailCtl alloc] init];
            articleDetail.isFromGroup_ = YES;
            Article_DataModal *articleModal = [[Article_DataModal alloc] init];
            articleModal.articleType_ = Article_Group;
            articleModal.groupId_ = dataModal.gid;
            articleModal.id_ = dataModal.aid;
//            articleModal.code = dataModal.code;
            articleModal.group_open_status = dataModal.group_open_status;
            articleDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:articleDetail animated:YES];
            [articleDetail beginLoad:articleModal exParam:nil];
            
        }
        
        //灌薪水详情
        else if ([dataModal.type_ isEqualToString:@"yl_app_guan_detail"])
        {
            SalaryIrrigationDetailCtl *salaryCtl = [[SalaryIrrigationDetailCtl alloc] init];
            ELSalaryModel *arModal = [[ELSalaryModel alloc] init];
            arModal.article_id = dataModal.aid;
            salaryCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:salaryCtl animated:YES];
            [salaryCtl beginLoad:arModal exParam:nil];
        }
        
        //职位详情页
        else if ([dataModal.type_ isEqualToString:@"yl_app_job_zw"])
        {
            PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
            ZWDetail_DataModal *zwModal = [[ZWDetail_DataModal alloc] init];
            zwModal.zwID_ = dataModal.zwid;
            zwModal.companyName_ = [dataModal.company_name URLDecodedForString];
            zwModal.companyID_ = dataModal.company_id;
            zwModal.companyLogo_ = dataModal.company_logo;
            positionDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:positionDetailCtl animated:YES];
            [positionDetailCtl beginLoad:zwModal exParam:nil];
        }
        
        //公司主页
        else if ([dataModal.type_ isEqualToString:@"yl_app_job_company"])
        {
            PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
            positionDetailCtl.type_ = 2;
            ZWDetail_DataModal *zwModal = [[ZWDetail_DataModal alloc] init];
            zwModal.companyName_ = [dataModal.company_name URLDecodedForString];
            zwModal.companyID_ = dataModal.company_id;
            positionDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:positionDetailCtl animated:YES];
            [positionDetailCtl beginLoad:zwModal exParam:nil];
        }
        
        //职导问答详情
        else if ([dataModal.type_ isEqualToString:@"yl_app_zd_question"])
        {
            AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
            answerDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:answerDetailCtl animated:YES];
            [answerDetailCtl beginLoad:dataModal.question_id exParam:nil];
        }
        
        //宣讲会详情
        else if ([dataModal.type_ isEqualToString:@"yl_app_teachins_xjh"])
        {
            CareerTailDetailCtl *careerTail = [[CareerTailDetailCtl alloc] init];
            NewCareerTalkDataModal *xjhModal = [[NewCareerTalkDataModal alloc] init];
            xjhModal.xjhId = dataModal.teachins_id;
            xjhModal.type = 2;
            careerTail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:careerTail animated:YES];
            [careerTail beginLoad:xjhModal exParam:nil];
        }
        
        //招聘会详情页
        else if ([dataModal.type_ isEqualToString:@"yl_app_teachins_zph"])
        {
            JobFairDetailCtl *detailCtl = [[JobFairDetailCtl alloc] init];
            NewCareerTalkDataModal *zphModal = [[NewCareerTalkDataModal alloc]init];
            zphModal.xjhId = dataModal.teachins_id;
            zphModal.type = 1;
            detailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:zphModal exParam:nil];
        }
        
        //比薪资页面
        else if ([dataModal.type_ isEqualToString:@"yl_app_skip_vs_pay"])
        {
            SalaryCompeteCtl *salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
            salaryCompeteCtl_.type_ = 2;
            User_DataModal *userModel = [Manager getUserInfo];
            [salaryCompeteCtl_ beginLoad:userModel.zym_ exParam:nil];
            salaryCompeteCtl_.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:salaryCompeteCtl_ animated:YES];
        }
        //offer派报名列表
        else if ([dataModal.type_ isEqualToString:@"yl_app_skip_recomm_offer"])
        {
            MyOfferPartyIndexCtl *ctl = [[MyOfferPartyIndexCtl alloc] init];
            ctl.isFromHome = YES;
            [ctl beginLoad:nil exParam:nil];
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:NO];
        }
        //职业经纪人
        else if ([dataModal.type_ isEqualToString:@"yl_app_skip_recomm_job"])
        {
            YLExpertListCtl *expertList = [[YLExpertListCtl alloc] init];
            expertList.selectedTab = @"职业经纪人";
            expertList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:expertList animated:YES];
        }
        
    }
    else
    {
        NSArray *ylUrls = [[Manager shareMgr] getUrlArr];
        for (NSString *url in ylUrls)
        {
            if ([dataModal.url_ rangeOfString:url].location != NSNotFound)
            {
                dataModal.shareUrl = dataModal.url_;
                PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
                pushurlCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pushurlCtl animated:YES];
                if ([dataModal.url_ containsString:@"?"]) {
                    dataModal.url_ = [dataModal.url_ stringByAppendingString:@"&appflag=1002"];
                }else{
                    dataModal.url_ = [dataModal.url_ stringByAppendingString:@"?appflag=1002"];
                }
                dataModal.url_ = [self changeLinkUrl:dataModal.url_];
                [pushurlCtl beginLoad:dataModal exParam:nil];
                break;
            }
        }

    }
}

- (NSString *)changeLinkUrl:(NSString *)url
{
    if (url && ![url isEqualToString:@""])
    {
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
                                                                  NULL,
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  kCFStringEncodingUTF8));
        NSString *relUrl = [NSString stringWithFormat:@"http://m.yl1001.com/general/login?pid=%@&time=%@&cks=%@&jumpurl=%@", personIdStr, timeNow, cksMD5Str, encodedString];
        return relUrl;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){//显示新的消息
        return [mynewMsgArray_ count];
    }else{
        return _dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else{
        if (!_dataArray.count) {
            return 0;
        }
        TodayFocusFrame_DataModal *articleModel;
        if (indexPath.row < _dataArray.count) {
           articleModel = _dataArray[indexPath.row];
        }
        if ([articleModel.sameTradeArticleModel.status isEqualToString:@"OK"]){
            CGSize size = [articleModel.sameTradeArticleModel.summary sizeNewWithFont:[UIFont systemFontOfSize:15]];
            CGFloat height = 0;
            if (size.width > ScreenWidth-32) {
                height = 40;
            }else{
                height = 20;
            }
            return height + 60 + 45 * articleModel.sameTradeArticleModel._vote_info.option_info.count + 60;
        }else if (articleModel.isActivityArtcle){
            if (_dataArray.count > indexPath.row+1) {
                TodayFocusFrame_DataModal *model = _dataArray[indexPath.row +1];
                if (model.isActivityArtcle) {
                    return 162;
                }
            }
            return 170;
        }else if (articleModel.isRecommentAnswer){
            return [MyJobGuide_RewardCell getCellHeight];
        }
        return articleModel.height + CELL_MARGIN_TOP;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SameTradeTipsCell *sameCell = (SameTradeTipsCell *)cell;
        [sameCell setDataModel:[mynewMsgArray_ objectAtIndex:indexPath.row]];
    }
    TodayFocusFrame_DataModal *articleModel = _dataArray[indexPath.row];
    if (articleModel.isActivityArtcle) {
        ELActivityListCell *activityCell = (ELActivityListCell *)cell;
        activityCell.dataModel = articleModel.sameTradeArticleModel._activity_info;
        activityCell.activityLable.hidden = NO;
    }
    if ([articleModel.sameTradeArticleModel.status isEqualToString:@"OK"]) {
        YLTheTopicCell *topicCell = (YLTheTopicCell *)cell;
        topicCell.likeBtn.tag = INDEX_OFFSET + indexPath.row;
        topicCell.shareBtn.tag = INDEX_OFFSET + indexPath.row;
        [topicCell.likeBtn addTarget:self action:@selector(addArticleLike:) forControlEvents:UIControlEventTouchUpInside];
        [topicCell.shareBtn addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        topicCell.cellDelegate = self;
        [topicCell giveDateModal:articleModel.sameTradeArticleModel._vote_info];
    }
    if (articleModel.isRecommentAnswer) {
        MyJobGuide_RewardCell *rewardCell = (MyJobGuide_RewardCell *)cell;
        [rewardCell setCount:articleModel.sameTradeArticleModel.hot_count withContent:articleModel.sameTradeArticleModel.question_title];
    }
    
    if ([cell isKindOfClass:[TodayFocus_Cell class]]) {
        TodayFocus_Cell *focusCell = (TodayFocus_Cell *)cell;
        focusCell.tag = indexPath.row;
        focusCell.model = articleModel;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        if (indexPath.section == 0) {

            static NSString *CellIdentifier = @"SameTradeTipsCell";
            SameTradeTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SameTradeTipsCell" owner:self options:nil] lastObject];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        
//            [cell setDataModel:[mynewMsgArray_ objectAtIndex:indexPath.row]];
            return cell;
        }
        if (!_dataArray.count) {
            return [[UITableViewCell alloc]init];
        }
        TodayFocusFrame_DataModal *articleModel = _dataArray[indexPath.row];
        
        if (articleModel.isActivityArtcle)
        {
            static NSString *cellStr = @"ELActivityListCell";
            ELActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (cell == nil) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"ELActivityListCell" owner:self options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
//            cell.dataModel = articleModel.sameTradeArticleModel._activity_info;
//            cell.activityLable.hidden = NO;
            return cell;
        }
        
        if ([articleModel.sameTradeArticleModel.status isEqualToString:@"OK"]) {
            static NSString *cellStr = @"YLTheTopicCell";
            
            YLTheTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (cell == nil) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"YLTheTopicCell" owner:self options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
//            cell.likeBtn.tag = INDEX_OFFSET + indexPath.row;
//            cell.shareBtn.tag = INDEX_OFFSET + indexPath.row;
//            [cell.likeBtn addTarget:self action:@selector(addArticleLike:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.shareBtn addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
//            cell.cellDelegate = self;
//            [cell giveDateModal:articleModel.sameTradeArticleModel._vote_info];
            return cell;
        }
        
        if (articleModel.isRecommentAnswer) {// 1悬赏问答，0或空不是

            static NSString *rewardCellIden = @"MyJobGuide_RewardCell";
            MyJobGuide_RewardCell *rewardCell = (MyJobGuide_RewardCell *)[tableView dequeueReusableCellWithIdentifier:rewardCellIden];
            if (rewardCell == nil)
            {
                rewardCell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobGuide_RewardCell" owner:self options:nil] lastObject];
                [rewardCell setSelectionStyle:UITableViewCellSelectionStyleNone];
               
            }
//            [rewardCell.hotBtn setTitle:[NSString stringWithFormat:@"%@热度",articleModel.sameTradeArticleModel.hot_count] forState:UIControlStateNormal];
//            rewardCell.contentLb.text = articleModel.sameTradeArticleModel.question_title;
            
            return rewardCell;
        }
        
        static NSString *reuseIdentifier = @"TodayFocus_Cell";
        TodayFocus_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"TodayFocus_Cell" owner:self options:nil][0];
             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
//        cell.tag = indexPath.row;
//        cell.model = articleModel;
        return cell;
    }
    @catch (NSException *exception) {
        return [[UITableViewCell alloc]init];
    }
    @finally {
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        Status_DataModal *model = [mynewMsgArray_ objectAtIndex:indexPath.row];
        model.exObj_ = @"0";
        MyAudienceListCtl *audienceCtl = [[MyAudienceListCtl alloc]init];
        NSString *type = [NSString stringWithFormat:@"2"];
        [audienceCtl beginLoad:type exParam:nil];
        [mynewMsgArray_ removeObject:model];
        audienceCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:audienceCtl animated:YES];
        [self.tableView reloadData];
        return;
    }
    TodayFocusFrame_DataModal *article = [_dataArray objectAtIndex:indexPath.row];
    switch (article.articleType_) {
        case Article_GXS://灌薪水
        {
            ELSalaryModel *model = [[ELSalaryModel alloc] init];
            model.bgColor_ = [UIColor whiteColor];
            model.status = article.sameTradeArticleModel.status;
            model.article_id = article.sameTradeArticleModel.article_id;
            SalaryIrrigationDetailCtl * articleDetailCtl = [[SalaryIrrigationDetailCtl alloc] init];
            articleDetailCtl.salaryDetailDelegate = self;
            articleDetailCtl.path = indexPath.row;
            articleDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:articleDetailCtl animated:YES];
            [articleDetailCtl beginLoad:model exParam:nil];
        }
            break;
        case Article_Question://问答
        {
            //记录友盟统计模块使用量
            NSDictionary * dict = @{@"Function":@"职导"};
            [MobClick event:@"personused" attributes:dict];
            
            AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
            answerDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:answerDetailCtl animated:YES];
            
            [answerDetailCtl beginLoad:article.sameTradeArticleModel.question_id exParam:nil];
        }
            break;
        default:
        {
            ArticleDetailCtl *articleDetailCtl = [[ArticleDetailCtl alloc]init];
            articleDetailCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:articleDetailCtl animated:YES];
            if (article.articleType_ == Article_Group) {
                articleDetailCtl.isFromGroup_ = YES;
            }
            [articleDetailCtl beginLoad:article.sameTradeArticleModel.article_id exParam:nil];
            //进入社群先加入社区
            // [articleDetailCtl joinCompany:article.groupId_];
        }
            break;
    }
}

#pragma mark - 点赞
-(void)addArticleLike:(UIButton *)button
{
    TodayFocusFrame_DataModal *article = _dataArray[button.tag-INDEX_OFFSET];
    if (article.isLike_) {
        return;
    }
    article.isLike_ = YES;
    [Manager saveAddLikeWithAticleId:article.sameTradeArticleModel.article_id];
    article.sameTradeArticleModel.like_cnt = [NSString stringWithFormat:@"%ld",(long)([article.sameTradeArticleModel.like_cnt integerValue]+1)];
    [self.tableView reloadData];
    NSString *personId = @"";
    if ([Manager shareMgr].haveLogin) {
        personId = [Manager getUserInfo].userId_;
    }
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@&type=%@",article.sameTradeArticleModel.article_id,personId,@"add"];
    NSString * function = @"addArticlePraise";
    NSString * op = @"yl_praise_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 文章分享
-(void)shareArticle:(UIButton *)button
{
    TodayFocusFrame_DataModal *shareArticle = _dataArray[button.tag-INDEX_OFFSET];
    _shareArticle = shareArticle;
    NSString *imagePath = shareArticle.sameTradeArticleModel.thumb;
    NSString * sharecontent = shareArticle.sameTradeArticleModel.summary;
    NSString * titlecontent = shareArticle.sameTradeArticleModel.title;
    if (shareArticle.articleType_ == Article_Question)
    {
        titlecontent = [NSString stringWithFormat:@"%@",shareArticle.sameTradeArticleModel.summary];
    }
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",shareArticle.sameTradeArticleModel.article_id];
    if (shareArticle.articleType_ == Article_Group) {
        url = [NSString stringWithFormat:@"http://m.yl1001.com/group_article/%@.htm",shareArticle.sameTradeArticleModel.article_id];
    }else if(shareArticle.articleType_==Article_GXS){
        url = [NSString stringWithFormat:@"http://m.yl1001.com/gxs_article/%@.htm",shareArticle.sameTradeArticleModel.article_id];
    }
    else if(shareArticle.articleType_ == Article_Question)
    {
        url = [NSString stringWithFormat:@"http://m.yl1001.com/answer_detail/%@.htm?type=all",shareArticle.sameTradeArticleModel.article_id];
    }
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    //可以分享到一览动态
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeTwo];
    [[ShareManger sharedManager] setShareDelegare:self];
}

#pragma mark - 分享代理myShareManager
-(void)shareYlBtn
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@",_shareArticle.sameTradeArticleModel.article_id,userId];
    NSString * function = @"shareArticle";
    NSString * op = @"groups_newsfeed_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        Status_DataModal *dataModal = [[Status_DataModal alloc]init];
        dataModal.status_ = [dic objectForKey:@"status"];
        dataModal.code_ = [dic objectForKey:@"code"];
        dataModal.des_ = dic[@"status_desc"];
        if( [dataModal.status_ isEqualToString:Success_Status] ){
            if ([dataModal.code_ isEqualToString:@"200"]) {
                [BaseUIViewController showAutoDismissAlertView:nil msg:@"分享成功" seconds:2.0];
            }else{
                [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
            }
        }else if( [dataModal.status_ isEqualToString:Fail_Status] ){
            [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
        }else{
            [BaseUIViewController showAlertView:nil msg:@"分享失败,请稍后再试" btnTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showAlertView:nil msg:@"分享失败,请稍后再试" btnTitle:@"确定"];
    }];
}

-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",_shareArticle.sameTradeArticleModel.article_id];
    if (_shareArticle.articleType_ == Article_Group) {
        url = [NSString stringWithFormat:@"http://m.yl1001.com/group_article/%@.htm",_shareArticle.sameTradeArticleModel.article_id];
    }
    pasteboard.string = url;
    if(url.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

#pragma  mark - YLTheTopicCellDeletage灌薪水帖子
-(void)changeBtnModal:(YLVoteDataModal *)modal indexPath:(NSIndexPath *)path{
    changPath = path;
    TodayFocusFrame_DataModal *dataModal = _dataArray[path.row];
    dataModal.sameTradeArticleModel._vote_info.isVote = @"1";

    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = @"";
    if (conditionDic.count > 0) {
        conDicStr = [jsonWriter stringWithObject:conditionDic];
    }
    NSString *uid = @"";
    if ([Manager getUserInfo].userId_) {
        uid = [Manager getUserInfo].userId_;
    }
    
    NSString * bodyMsg = [NSString stringWithFormat:@"gaap_id=%@&person_id=%@&client_id=%@&conditionArr=%@",modal.gaapId,uid,[MyCommon getAddressBookUUID],conDicStr];
    [ELRequest postbodyMsg:bodyMsg op:@"comm_article_busi" func:@"add_vote_logs" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if ([dic[@"status"] isEqualToString:@"OK"])
            {
                TodayFocusFrame_DataModal *dataModal = _dataArray[changPath.row];
                dataModal.sameTradeArticleModel._vote_info = [[ELSalaryModel alloc] initWithDictionary:dic];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 未登录引导页代理
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}
-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginFollow_Today_Recomment:
        {
            NSDictionary *dic = [NoLoginPromptCtl getNoLoginManager].noLoginDic;
            [self buttonResponeRecommentWithType:dic[@"type"]];
        }
            break;
        default:
            break;
    }
}


-(void)refreshAddLikeIndex:(NSInteger)indexPathRow Count:(NSInteger)count
{
    if (_dataArray.count > indexPathRow) {
        TodayFocusFrame_DataModal *modal = _dataArray[indexPathRow];
        modal.sameTradeArticleModel.like_cnt = [NSString stringWithFormat:@"%ld",(long)count];
        [self reloadTableView];
    }
}

-(void)refreshActivityCell:(ELSalaryModel *)modal index:(NSInteger)row
{
    if (modal && row < _dataArray.count) {
        TodayFocusFrame_DataModal *articleModel = _dataArray[row];
        articleModel.sameTradeArticleModel._vote_info = modal;
        [self reloadTableView]; 
    }
}

-(void)refreshCommentIndex:(NSInteger)indexPathRow Count:(NSInteger)count
{
    if (_dataArray.count > indexPathRow) {
        TodayFocusFrame_DataModal *modal = _dataArray[indexPathRow];
        modal.sameTradeArticleModel.c_cnt = [NSString stringWithFormat:@"%ld",(long)count];;
        [self reloadTableView];
    }
}

-(void)reloadTableView
{
    [self.tableView reloadData];
    [self adjustFooterViewFrame];
}

-(void)refreshDelegateCtl{
    [self refreshLoad];
}

#pragma mark - 点击底部导航按钮回到顶部刷新列表
-(void)refreshBtnList{
    [self refreshLoad];
}

#pragma mark - 刷新朋友圈红点个数
-(void)reloadFriendMessageCount{
    if (!_navView) {
        return;
    }
    IndexNavView *nav = (IndexNavView *)_navView;
    [nav reloadFriendMessageCountLb:[Manager shareMgr].messageCountDataModal.sameTradeMessageCnt withFriendCount:[Manager shareMgr].messageCountDataModal.friendMessageCnt];
}

#pragma mark - AddBtnDelegate 右上角+号代理

-(void)hideBtnAndView:(BOOL)hide{
    __weak typeof(self) weakSelf = self;
    if (hide){
        [UIView animateWithDuration:0.3 animations:^{
            addBtnImage.transform = CGAffineTransformMakeRotation(0);
            weakSelf.markImgShow.hidden = YES;
        } completion:^(BOOL finished) {}];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            addBtnImage.transform = CGAffineTransformMakeRotation(-M_PI_2/2);
            weakSelf.markImgShow.hidden = NO;
        } completion:^(BOOL finished) {}];
    }
}

#pragma mark - 点击事件    
-(void)btnResponse:(id)sender
{
    if (sender == moreBtn_){
        if (addListArr.count == 0) {
            return;
        }
        if (!addListView)
        {
            addListView = [[YLAddListViewCtl alloc] init];
            addListView.addBtnDelegate = self;
        }
        [addListView giveDataArr:addListArr];
        [addListView showViewCtl];
    }
}

#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    ELTodayFocusSearchCtl *ctl = [[ELTodayFocusSearchCtl alloc] init];
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
    return NO;
}

#pragma mark - 状态栏单机事件相关statusBarNotificationmethod
- (void)statusBarTouchedAction
{
    CGPoint offect = self.tableView.contentOffset;
    offect.y = - self.tableView.contentInset.top;
    [self.tableView setContentOffset:offect animated:YES];
}

#pragma mark - 缓存一页信息
-(NSString *)getLiseName{
    if ([Manager shareMgr].haveLogin) {
        return [NSString stringWithFormat:@"TodayFocusListDataArr%@",[Manager getUserInfo].userId_];
    }
    return @"TodayFocusListDataArrNoLogin";
}

-(NSString *)getAdName{
    if ([Manager shareMgr].haveLogin) {
        return [NSString stringWithFormat:@"TodayFocusAdArr%@",[Manager getUserInfo].userId_];
    }
    return @"TodayFocusAdArrNoLogin";
}

-(void)saveListDataWithArr:(NSDictionary *)data{
    if (!data) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:[self getLiseName]];
    if ([str isKindOfClass:[NSString class]]) {
        [user removeObjectForKey:[self getLiseName]];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if(string){
       [user setObject:string forKey:[self getLiseName]]; 
    }
    [user synchronize];
}

-(void)saveAdWithArr:(NSDictionary *)dic{
    if (!dic) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:[self getAdName]];
    if ([str isKindOfClass:[NSString class]]) {
        [user removeObjectForKey:[self getAdName]];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if(string){
        [user setObject:string forKey:[self getAdName]];
    }
    [user synchronize];
}

-(NSDictionary *)getListData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:[self getLiseName]];
    if(!str || ![str isKindOfClass:[NSString class]]){
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }
    return nil;
}

-(NSDictionary *)getAd{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:[self getAdName]];
    if(!str || ![str isKindOfClass:[NSString class]]){
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }
    return nil;
}

-(void)parserTodayFocusList:(NSDictionary *)dic
{
    [super beginLoad:nil exParam:nil];
    [self parserPageInfo:dic];
    NSArray * dataArray = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in dataArray) {
        TodayFocusFrame_DataModal * dataModal = [[TodayFocusFrame_DataModal alloc] init];
        NSString *articleType = subDic[@"_source_type"];
        
        if ([articleType isEqualToString:@"hytt"]){//行业头条
            dataModal.articleType_ = Article_Trade_Head;
        }else if ([articleType isEqualToString:@"article_gxs"]){//灌薪水
            dataModal.articleType_ = Article_GXS;
        }else if ([articleType isEqualToString:@"article_group"]){//社群
            dataModal.articleType_ = Article_Group;
        }else if ([articleType isEqualToString:@"question"]) {//问答
            dataModal.articleType_ = Article_Question;
        }else if ([articleType isEqualToString:@"article"]) {//其他文章（同行文章）
            dataModal.articleType_ = Article_Follower;
        }
        ELSameTrameArticleModel *model = [[ELSameTrameArticleModel alloc] initWithDictionary:subDic];
        if ([model.is_recommend isEqualToString:@"1"]) {
            dataModal.isRecommentAnswer = YES;
        }
        if (model._activity_info) {
            dataModal.isActivityArtcle = YES;
            model._activity_info.person_id = model.personId;
            model._activity_info.person_pic = model.person_pic;
            model._activity_info.person_iname = model.person_iname;
        }
        dataModal.sameTradeArticleModel = model;
        if (model.article_id) {
            [_dataArray addObject:dataModal];
        }
    }
    [self.tableView reloadData];
    [self finishReloadingData];
    [self refreshEGORefreshView];
    [self adjustFooterViewFrame];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if (![Manager shareMgr].messageCountDataModal && [Manager shareMgr].haveLogin) {
            [[Manager shareMgr].messageRefreshCtl requestCount];
        }
        [self refreshLoad];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
