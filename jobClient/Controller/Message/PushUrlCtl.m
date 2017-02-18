//
//  PushUrlCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-15.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "PushUrlCtl.h"
#import "NewCareerTalkDataModal.h"
#import "MyOfferPartyIndexCtl.h"
#import "YLExpertListCtl.h"

@interface PushUrlCtl ()<UIGestureRecognizerDelegate>
{
    NSString * url_;
    AD_dataModal *inModal;
    IBOutlet UIButton *shareBtn;
    IBOutlet UIButton *homePageBtn;
    IBOutlet UIButton *seeOABtn;
    BOOL isBackViewCtl;
    BOOL threeGood; //YES 表示三好一改
}

@end

@implementation PushUrlCtl
- (void)dealloc
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
        
    if (self.isApplication) {
        
        self.closeBtn_.alpha = 1.0;
        
        if ([inModal.title_ isEqualToString:@"一览公益"]) {
            [self shareBtnConfig];
        }
        
    }else{
        [self shareBtnConfig];
    }
    
    if (_fromEmploy || _hideShareButton) {
        shareBtn.hidden = YES;
    }
}

-(void)shareBtnConfig{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger width = -10;
    negativeSpacer.width = width;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if ([NoLoginPromptCtl getNoLoginManager].loginType > 0) {
        isBackViewCtl = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)updateCom:(RequestCon *)con
{
    if (url_) {
        
//        url_ = @"http://m.yl1001.com/article/6091485047167481.htm";
        NSURL * url = [NSURL URLWithString:url_];
        NSURLRequest * urlRequest= [[NSURLRequest alloc] initWithURL:url];
        [self.webView_ loadRequest:urlRequest];
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if ([dataModal isKindOfClass:[NSString class]]) {
        url_ = dataModal;
        if (self.fromThreeGoodOneChange == YES) {

            [self setNavTitle:@"三好一改"];
            threeGood = YES;
            if ([Manager shareMgr].haveLogin) {
                NSString *idStr = [self encryptionId:[Manager getUserInfo].userId_];
                url_ = [NSString stringWithFormat:@"%@&shcd=%@",url_,idStr];
                url_ = [self changeLinkUrl:url_ PersonId:[Manager getUserInfo].userId_];
            }
        }else{
            if ([exParam isKindOfClass:[NSString class]]) {
                [self setNavTitle:exParam];
            }else{
                [self setNavTitle:@"详情"];
            }
        }
    }
    else{
        
        inModal = dataModal;
        url_ = inModal.url_;
//        self.navigationItem.title = inModal.title_;
        if ([inModal.title_ isEqualToString:@"三好一改"]) {
            threeGood = YES;
        }else{
            threeGood = NO;
        }
        [self setNavTitle:inModal.title_];
    }
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [BaseUIViewController showAlertViewContent:@"当前网络可能没有连接" toView:nil second:1.0 animated:YES];
        return;
    }
    
    [self updateCom:nil];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.canGoBack) {
        homePageBtn.hidden = NO;
    }else{
        homePageBtn.hidden = YES;
        
    }
}

- (IBAction)homePageBtnClick:(id)sender {
    
    if (sender == homePageBtn) {
        if (url_) {//返回首页
            NSURL * url = [NSURL URLWithString:url_];
            NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
            [self.webView_ loadRequest:urlRequest];
        }
    }
}

- (IBAction)shareBtnRespone:(id)sender
{
    UIImage * image ;
    if (_fromThreeGoodOneChange == YES) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img105.job1001.com/others/2015-11/26/1448508307_fou.jpg"]]];
    }else
    {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:inModal.sharePic]]];
    }
    
    if (!image)
    {
        image = [UIImage imageNamed:@"160"];
    }
    
    if (inModal.shareContent.length == 0)
    {
        inModal.shareContent = @"分享自一览";
    }
    if (_fromThreeGoodOneChange == YES) {
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:@"古有三省吾身，今有“三好一改”" content:@"用心去发现，用行动去改变" image:image url:@"http://m.yl1001.com/zhuanti/shyg/"];
    }else{
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:inModal.title_ content:inModal.shareContent image:image url:inModal.shareUrl];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL];
    
    if (self.fromThreeGoodOneChange == YES) {
        if ([request.URL.relativeString rangeOfString:@"gotoapp=login"].location != NSNotFound) {
            if (self.fromThreeGoodOneChange == YES)
            {//未登录提示去登录
                if (![Manager getUserInfo].userId_) {
                    [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                    [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PushUrl;
                    isBackViewCtl = YES;
                    return NO;
                }
            }
        }
    }
    
    
    if ([urlStr containsString:@"about:blank"]) {
        return NO;
    }
    //不包含白名单域名不跳转
    if (![NSString domainNameConstantString:urlStr]) {
        return NO;
    }
    
    if(_isThirdUrl)
    {
        return YES;
    }
    
    if ([request.URL.relativeString rangeOfString:@"gotoapp=login"].location != NSNotFound) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PushUrl;
        isBackViewCtl = YES;
        return NO;
    }
    else if (![urlStr containsString:@"appflag"])
    {//子页面没有包含appflag，则拼接appflag=1002
        //判断用户是否的登录,登录则拼接用户Id，没有传空
        if ([Manager shareMgr].haveLogin) {
            NSString *idStr = [self encryptionId:[Manager getUserInfo].userId_];
            if([urlStr containsString:@"?"]){
                urlStr = [NSString stringWithFormat:@"%@&appflag=1002&shcd=%@",urlStr,idStr];
            }else{
                urlStr = [NSString stringWithFormat:@"%@?appflag=1002&shcd=%@",urlStr,idStr];
            }
        }
        else
        {
            if([urlStr containsString:@"?"]){
                urlStr = [NSString stringWithFormat:@"%@&appflag=1002",urlStr];
            }else{
                urlStr = [NSString stringWithFormat:@"%@?appflag=1002",urlStr];
            }
        }
        
        //跳转原生页面后 3g页面是否仍然进行跳转
        if (![self from3GJumpToApp:urlStr]) {
            return NO;
        }else{
            return YES;
        }
        
        
        NSURL * url = [NSURL URLWithString:urlStr];
        NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [self.webView_ loadRequest:urlRequest];
        
        return NO;
    }
    
    if(_fromEmploy)
    {
        if ([urlStr isEqualToString:@"http://m.job1001.com/wgz/xuanchuan_2015"])
        {
            [self setNavTitle:@"了解微雇主"];
        }
        else{
            [self setNavTitle:@"申请建立微雇主"];
        }
        threeGood = NO;
    }
    NSArray *ylUrls = [[Manager shareMgr] getUrlArr];
    for (NSString *url in ylUrls)
    {
        if ([urlStr rangeOfString:url].location != NSNotFound)
        {
            if ([request.URL.relativeString rangeOfString:@"gotoapp=login"].location != NSNotFound) {
                NSString *userId = [Manager getUserInfo].userId_;
                if (navigationType == UIWebViewNavigationTypeLinkClicked) {
                    if (!userId) {
                        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PushUrl;
                        isBackViewCtl = YES;
                    }
                    return NO;
                }
            }
        }
        else
        {
            if ([request.URL.relativeString rangeOfString:@"weixin"].location != NSNotFound) {
                return NO;
            }
        }
    }

    return YES;
}

#pragma mark - 3G跳转App
- (BOOL)from3GJumpToApp:(NSString *)url
{
//    url = [NSString stringWithFormat:@"%@&gotoapp=jumpto",url];
    BOOL result = YES;
//    url = [url URLDecodedForString];
    if ([url containsString:@"?"]) {
        NSString *usefulUrl = [[url componentsSeparatedByString:@"?"] lastObject];
        if ([usefulUrl containsString:@"&"]) {
            NSArray *urlArr = [usefulUrl componentsSeparatedByString:@"&"];
            NSMutableDictionary *paramsDic = [self fromUrlParamsArrayToDic:urlArr];
            
            NSString *pid = paramsDic[@"pid"];//用户id
            NSString *gid = paramsDic[@"gid"];//社群id
            NSString *aid = paramsDic[@"aid"];//文章id
            NSString *appType = paramsDic[@"appType"];//跳转类型
            
            //判断是跳转到原生还是3G页面
            if ([paramsDic[@"gotoapp"] isEqualToString:@"jumpto"]) {
                
                result = NO;
                if ([appType isEqualToString:@"yl_app_group"])
                {
                    ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
                    detaliCtl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:detaliCtl animated:YES];
                    [detaliCtl beginLoad:gid exParam:nil];
                }
                
                //v用户个人主页和行家
                else if ([appType isEqualToString:@"yl_app_expert"])
                {
                    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
                    personCenterCtl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:personCenterCtl animated:YES];
                    [personCenterCtl beginLoad:pid exParam:nil];
                }
                
                //普通发表的文章详情页
                else if ([appType isEqualToString:@"yl_app_normal_publish_detail"])
                {
                    ArticleDetailCtl *articleDetail = [[ArticleDetailCtl alloc] init];
                    articleDetail.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:articleDetail animated:YES];
                    [articleDetail beginLoad:aid exParam:nil];
                }
                
                //用户发表列表页
                else if ([appType isEqualToString:@"yl_app_user_publish_list"])
                {
                    ExpertPublishCtl *expertPublishCtl = [[ExpertPublishCtl alloc] init];
                    PersonCenterDataModel *expertModal = [[PersonCenterDataModel alloc] init];
                    expertModal.userModel_.id_ = pid;
                    if ([[Manager getUserInfo].userId_ isEqualToString:pid]) {
                        expertPublishCtl.isMyCenter = YES;
                    }
                    expertPublishCtl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:expertPublishCtl animated:YES];
                    [expertPublishCtl beginLoad:expertModal.userModel_ exParam:nil];
                }
                
                //社群话题详情页
                else if ([appType isEqualToString:@"yl_app_group_topic_detail"])
                {
                    NSString *group_open_status = paramsDic[@"group_open_status"];//社群开放状态
                    NSString *code = paramsDic[@"code"];//是否屏蔽社群消息
                    
                    ArticleDetailCtl *articleDetail = [[ArticleDetailCtl alloc] init];
                    articleDetail.isFromGroup_ = YES;
                    Article_DataModal *articleModal = [[Article_DataModal alloc] init];
                    articleModal.articleType_ = Article_Group;
                    articleModal.groupId_ = gid;
                    articleModal.id_ = aid;
                    articleModal.code = code;
                    articleModal.group_open_status = group_open_status;
                    articleDetail.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:articleDetail animated:YES];
                    [articleDetail beginLoad:articleModal exParam:nil];
                    
                }
                //灌薪水详情
                else if ([appType isEqualToString:@"yl_app_guan_detail"])
                {
                    ELSalaryModel *model = [[ELSalaryModel alloc] init];
                    SalaryIrrigationDetailCtl *salaryCtl = [[SalaryIrrigationDetailCtl alloc] init];
                    salaryCtl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:salaryCtl animated:YES];
                    model.article_id = aid;
                    model.title_ = [paramsDic[@"title"] URLDecodedForString];
                    model.bgColor_ = [UIColor whiteColor];
                    [salaryCtl beginLoad:model exParam:nil];
                }
                //职位详情页
                else if ([appType isEqualToString:@"yl_app_job_zw"])
                {
                    NSString *zwid = paramsDic[@"zwid"];//职位id
                    //用作分享
                    NSString *company_id = paramsDic[@"company_id"];//公司Id
                    NSString *company_logo = [paramsDic[@"company_logo"] URLDecodedForString];
                    NSString *company_name = [paramsDic[@"company_name"] URLDecodedForString];
                    
                    PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
                    ZWDetail_DataModal *zwModal = [[ZWDetail_DataModal alloc] init];
                    zwModal.zwID_ = zwid;
                    zwModal.companyName_ = company_name;
                    zwModal.companyID_ = company_id;
                    zwModal.companyLogo_ = company_logo;
                    positionDetailCtl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:positionDetailCtl animated:YES];
                    [positionDetailCtl beginLoad:zwModal exParam:nil];
                }
                
                //公司主页
                else if ([appType isEqualToString:@"yl_app_job_company"])
                {
                    NSString *company_id = paramsDic[@"company_id"];//公司Id
                    NSString *company_name = [paramsDic[@"company_name"] URLDecodedForString];
                    
                    PositionDetailCtl *positionDetailCtl = [[PositionDetailCtl alloc] init];
                    positionDetailCtl.type_ = 2;
                    ZWDetail_DataModal *zwModal = [[ZWDetail_DataModal alloc] init];
                    zwModal.companyName_ = company_name;
                    zwModal.companyID_ = company_id;
                    positionDetailCtl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:positionDetailCtl animated:YES];
                    [positionDetailCtl beginLoad:zwModal exParam:nil];
                }
                //职导问答详情
                else if ([appType isEqualToString:@"yl_app_zd_question"])
                {
                    NSString *question_id = paramsDic[@"question_id"];//问题id
                    
                    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
                    answerDetailCtl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:answerDetailCtl animated:YES];
                    [answerDetailCtl beginLoad:question_id exParam:nil];
                }
                //宣讲会详情
                else if ([appType isEqualToString:@"yl_app_teachins_xjh"])
                {
                    NSString *teachins_id = paramsDic[@"teachins_id"];
                    
                    CareerTailDetailCtl *careerTail = [[CareerTailDetailCtl alloc] init];
                    NewCareerTalkDataModal *xjhModal = [[NewCareerTalkDataModal alloc] init];
                    xjhModal.xjhId = teachins_id;
                    xjhModal.type = 2;
                    careerTail.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:careerTail animated:YES];
                    [careerTail beginLoad:xjhModal exParam:nil];
                }
                
                //招聘会详情页
                else if ([appType isEqualToString:@"yl_app_teachins_zph"])
                {
                    NSString *teachins_id = paramsDic[@"teachins_id"];
                    
                    JobFairDetailCtl *detailCtl = [[JobFairDetailCtl alloc] init];
                    NewCareerTalkDataModal *zphModal = [[NewCareerTalkDataModal alloc]init];
                    zphModal.xjhId = teachins_id;
                    zphModal.type = 1;
                    detailCtl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:detailCtl animated:YES];
                    [detailCtl beginLoad:zphModal exParam:nil];
                }
                
                //比薪资页面
                else if ([appType isEqualToString:@"yl_app_skip_vs_pay"])
                {
                    SalaryCompeteCtl *salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
                    salaryCompeteCtl_.type_ = 2;
                    User_DataModal *userModel = [Manager getUserInfo];
                    [salaryCompeteCtl_ beginLoad:userModel.zym_ exParam:nil];
                    salaryCompeteCtl_.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:salaryCompeteCtl_ animated:YES];
                }
                //offer派报名列表
                else if ([appType isEqualToString:@"yl_app_skip_recomm_offer"])
                {
                    MyOfferPartyIndexCtl *ctl = [[MyOfferPartyIndexCtl alloc] init];
                    ctl.isFromHome = YES;
                    [ctl beginLoad:nil exParam:nil];
                    ctl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:ctl animated:NO];
                }
                //职业经纪人
                else if ([appType isEqualToString:@"yl_app_skip_recomm_job"])
                {
                    YLExpertListCtl *expertList = [[YLExpertListCtl alloc] init];
                    expertList.selectedTab = @"职业经纪人";
                    expertList.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:expertList animated:YES];
                }

            }else{
                result = YES;
            }
            
        }
    }
    return result;
}

- (NSMutableDictionary *)fromUrlParamsArrayToDic:(NSArray *)array
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    for (NSString *url in array) {
        if ([url containsString:@"="]) {
            NSArray *cutUrl = [url componentsSeparatedByString:@"="];
            [dic setObject:[cutUrl lastObject]  forKey:[cutUrl firstObject]];
        }
    }
    return dic;
}


#pragma mark 退出登录
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_PushUrl:
        {
            NSString *idStr = [self encryptionId:[Manager getUserInfo].userId_];
            url_ = [NSString stringWithFormat:@"%@&shcd=%@",url_,idStr];
            url_ = [self changeLinkUrl:url_ PersonId:[Manager getUserInfo].userId_];
            [self updateCom:nil];
        }
            break;
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if (isBackViewCtl && threeGood) {
        [self backBarBtnResponse:nil];
        return;
    }
    [super btnResponse:sender];
}

-(void)backBarBtnResponse:(id)sender{
    if (_backTowCtl){
        id ctl = nil;
        if (self.navigationController.viewControllers.count >= 3) {
            ctl = self.navigationController.viewControllers[self.navigationController.viewControllers.count-3];
        }
        if (ctl) {
           [self.navigationController popToViewController:ctl animated:YES];
            return;
        }
    }
    [super backBarBtnResponse:sender];
}

@end
