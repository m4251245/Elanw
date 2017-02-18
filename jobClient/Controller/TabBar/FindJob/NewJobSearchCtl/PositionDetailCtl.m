//
//  PositionDetailCtl.m
//  Association
//
//  Created by 一览iOS on 14-6-23.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "PositionDetailCtl.h"
#import "ZWDescript_Cell.h"
#import "TheContactListCtl.h"
#import "NoLoginPromptCtl.h"
#import "CompanyMapCtl.h"
#import "NewCareerTalkDataModal.h"
#import "ELPersonCenterCtl.h"



@interface PositionDetailCtl () <ELShareManagerDelegate,NoLoginDelegate>
{
    NSString * schoolShareUrl_;
    UIButton *shareBtn;
    UIButton *favoriteBtn;
    NSString *pf_id; /**职位收藏ID */
    NSInteger detailType;//记录详情类型 1 职位详情  2 企业详情
    
    __weak IBOutlet NSLayoutConstraint *webViewBttomH;
}
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIButton *applyBtn;

@end

@implementation PositionDetailCtl
@synthesize applyBtn_,type_;

- (void)dealloc
{
   
    NSLog(@"%s",__func__);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bReloadBySelf_ = NO;
        self.isXjh = NO;
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

#pragma mark 设置右边导航按钮
// flag 是否企业
- (void)setRightBarBtns:(BOOL)flag
{
    if (_isConsultantFlag) {
        return;
    }
    if (_offerPartyFlag) {
        return;
    }
 
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger width = -10;
    negativeSpacer.width = width;
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 35, 35);
    [shareBtn setImage:[UIImage imageNamed:@"share_white-2"] forState:UIControlStateNormal];
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    [shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBtn.frame = CGRectMake(0, 0, 35, 35);
    [favoriteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [favoriteBtn setHidden:YES];
    UIBarButtonItem *favorite = [[UIBarButtonItem alloc]initWithCustomView:favoriteBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,share, favorite];
    
    if (flag) {
        self.navigationItem.rightBarButtonItems = @[negativeSpacer,share];
    }else{
        self.navigationItem.rightBarButtonItems = @[negativeSpacer,share, favorite];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    [self setNavTitle:@"职位详情"];
    detailType = 1;
    
//    webView_.dataDetectorTypes = UIDataDetectorTypeNone;
    [bottomView_ setHidden:NO];
    closeBtn_.alpha = 0.0;
    [rightBarBtn_ setHidden:YES];
    CALayer *layer=[bottomView_ layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:0.0];
    [layer setBorderColor:[[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1] CGColor]];
    
    if (type_ == 2) {
        //从公司详情页进入
        [rightBarBtn_ setHidden:NO];
        [self setRightBarBtns:YES];
    }else{
        [self setRightBarBtns:NO];
    }
    
    if (_offerPartyFlag || _jobManager){//offer派入口进来
        bottomView_.hidden = YES;
    }
//    webView_.delegate = self;
    [applyBtn_ setBackgroundImage:[UIImage imageNamed:@"positionApplayNormal.png"] forState:UIControlStateNormal];
    [applyBtn_ setBackgroundImage:[UIImage imageNamed:@"positionApplaySeleted.png"] forState:UIControlStateDisabled];
    
    if (self.showJobSuccessView) 
    {
        if (!jobSuccessCtl) {
            jobSuccessCtl = [[ELJobSuccessShowCtl alloc] init];
        }
        [jobSuccessCtl showViewCtl];
        self.showJobSuccessView = NO;
    }
    
    // 谷歌分析设置屏幕名称并发送
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;   //调用默认跟踪器
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];  //这个屏幕名称将会在谷歌分析报告中显示
    [tracker send:[[GAIDictionaryBuilder createScreenView]build]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (bridge) { return; }
    [WebViewJavascriptBridge enableLogging];
    
//    __weak PositionDetailCtl *weakSelf = self;
//    bridge = [WebViewJavascriptBridge bridgeForWebView:webView_ webViewDelegate:weakSelf handler:^(id data, WVJBResponseCallback responseCallback) {
//        [weakSelf showImageWithData:data];
//    }];
  
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)showImageWithData:(id)data{
    NSString *imageStr = [data stringByReplacingOccurrencesOfString:@"com//" withString:@"com/"];
    NSArray *urlArray = [imageStr componentsSeparatedByString:@"||"];
    if ([urlArray count] < 2) {
        return;
    }
    NSString *indexUrl = [urlArray objectAtIndex:0];
    imageItemString_ = indexUrl;
    NSString *listUrl = [urlArray objectAtIndex:1];
    NSArray *tempArray = [listUrl componentsSeparatedByString:@","];
    if ([tempArray count]!=0) {
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[tempArray count]];
        for (int i=0; i<[tempArray count]; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:[tempArray objectAtIndex:i]]; // 图片路径
            [photos addObject:photo];
        }
        NSInteger indexInt = [tempArray indexOfObject:indexUrl];
        
        photoBrowser_ = [[MJPhotoBrowser alloc] init];
        photoBrowser_.isposition_ = YES;
        photoBrowser_.delegate = self;
        photoBrowser_.currentPhotoIndex = indexInt; // 弹出相册时显示的第一张图片是？
        photoBrowser_.photos = photos; // 设置所有的图片
        [photoBrowser_ show];
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [photoBrowser_ removeFromParentViewController];
    photoBrowser_.delegate = nil;
//    webView_.delegate = nil;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest %@",request.URL.absoluteString);
    NSString *urlString = request.URL.absoluteString;
    urlString = [urlString lowercaseString];
    NSArray *urlArray = [[NSArray alloc] init];
    
    if ([urlString containsString:@"company_xjh"])
    {
        NSRange range = [urlString rangeOfString:@"company_xjh&id="];
        CGFloat length = range.length + range.location;
        NSInteger lastLength = 0;
        
        for (NSInteger i = length; i<[urlString length];i++) {
            NSString *strOne = [urlString substringWithRange:NSMakeRange(i,1)];
            if ([strOne isEqualToString:@"&"]) {
                lastLength = i - length;
                break;
            }
            lastLength = i - length;
        }
        
        NSString *strId = [urlString substringWithRange:NSMakeRange(length,lastLength)];
        if (self.isXjh) {
            NewCareerTalkDataModal *modal = [[NewCareerTalkDataModal alloc] init];
            modal.xjhId = strId;
            [_careerCtl beginLoad:modal exParam:nil];
            [self.navigationController popToViewController:_careerCtl animated:YES];
        }
        else
        {
            NewCareerTalkDataModal *modal = [[NewCareerTalkDataModal alloc] init];
            modal.xjhId = strId;
            CareerTailDetailCtl *ctl = [[CareerTailDetailCtl alloc] init];
            [ctl beginLoad:nil exParam:nil];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        return NO;
    }
    else if ([urlString containsString:@"map"]){
        CompanyMapCtl *companyMapCtl = [[CompanyMapCtl alloc] init];
        [companyMapCtl beginLoad:zwDetailModel_ exParam:nil];
        [self.navigationController pushViewController:companyMapCtl animated:YES];
        return NO;
    }
    
    if ([urlString containsString:@"http://m.yl1001.com/u/"]) {
        
        NSString *userId = [[urlString componentsSeparatedByString:@"u/"] lastObject];
        
        ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
        [personCenterCtl beginLoad:userId exParam:nil];
        [self.navigationController pushViewController:personCenterCtl animated:YES];
        return NO;
    }
    
    //正式服务器
    //职位详情
    if ([urlString containsString:@"jobdetail"])
    {
        [rightBarBtn_ setHidden:YES];
        
        
        if ([urlString containsString:@"jobdetail_"]) 
        {
            urlArray = [urlString componentsSeparatedByString:@"jobdetail_"];
            urlString = [urlArray objectAtIndex:1];
            positionId_ = [[urlString componentsSeparatedByString:@".htm"] objectAtIndex:0];
        }
        else
        {
            urlArray = [urlString componentsSeparatedByString:@"jobdetail"];
            urlString = [urlArray objectAtIndex:1];
            NSString *str1 = [[urlString componentsSeparatedByString:@"zwid="] objectAtIndex:1];
            positionId_ = [[str1 componentsSeparatedByString:@"&"] objectAtIndex:0];
        }
        
        @try {
            NSString *applayStr;
            if (urlString) {
                NSArray *applayArray = [urlString componentsSeparatedByString:@"fav="];
                if (applayArray.count > 1) {
                    applayStr = applayArray[1];
                }
            }
            
            NSArray *statusArray = [applayStr componentsSeparatedByString:@"&job="];
            if (statusArray.count > 1) {
               applayStr = [statusArray objectAtIndex:1];
            }
            applayStr = [[applayStr componentsSeparatedByString:@"&location"] objectAtIndex:0];
            
            NSString *colleStatuStr = [statusArray objectAtIndex:0];
            NSArray *colleStatuArray = [colleStatuStr componentsSeparatedByString:@"&pf_id="];
            
            NSString *collectionStr = [colleStatuArray objectAtIndex:0];
            if (colleStatuArray.count > 1) {
               pf_id = [colleStatuArray objectAtIndex:1];
            }
            
            if (![applayStr isEqualToString:@"2"]) {
                canapplay = YES;
            }else{
                canapplay = NO;
            }
            if (![collectionStr isEqualToString:@"2"]) {
                cancollection = YES;
            }else{
                cancollection = NO;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
            canapplay = YES;
            cancollection = YES;
        }
        @finally {
            
        }
        //判断是否能申请 收藏
        //绑定企业
        if (type_ == 3 || _offerPartyFlag || _jobManager)
        {
//            [bottomView_ setHidden:YES];
//            webViewBttomH.constant = 0;
            [self isHiddenBottomView:YES];
        }
        else
        {
//            [bottomView_ setHidden:NO];
//            webViewBttomH.constant = 45;
            [self isHiddenBottomView:NO];
    
        }

        [self setNavTitle:@"职位详情"];
        detailType = 1;
        [self setRightBarBtns:NO];
        if(!_jobManager)
        {
            [self updateStatus];
        }
    }
    else{
        //公司详情
        [self setNavTitle:@"企业详情"];
        detailType = 2;
        [self setRightBarBtns:YES];
        [self isHiddenBottomView:YES];
//        webViewBttomH.constant = 0;
    }
    
    if (_isConsultantFlag) {
        [self isHiddenBottomView:YES];
        [myRightBarBtnItem_ setHidden:YES];
//        webViewBttomH.constant = 0;
    }
    return YES;
}

- (void)isHiddenBottomView:(BOOL)isHidden
{
    UIWebView *webView = [self.view viewWithTag:1001];
//    UIView *view = [self.view viewWithTag:1002];
    if (isHidden) {
        CGRect frame = webView.frame;
        frame.size.height = ScreenHeight-NavBarHeight;
        bottomView_.hidden = YES;
        webView.frame = frame;
    }else{
        CGRect frame = webView.frame;
        frame.size.height = ScreenHeight-NavBarHeight-45;
        bottomView_.hidden = NO;
        webView.frame = frame;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad %@",webView.request.URL.absoluteString);
    if (!activityView_) {
        activityView_ = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView_ setColor:[UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0]];
        [activityView_ setFrame:CGRectMake(142, (webView.frame.size.height-37)/2, 37, 37)];
        activityView_.center = CGPointMake(webView.center.x, webView.center.y);
        [self.view addSubview:activityView_];
        activityView_.hidesWhenStopped = YES;
    }
    [activityView_ startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad %@",webView.request.URL.absoluteString);
    if (webView.canGoBack) {
        closeBtn_.alpha = 1.0;
    }
    [activityView_ stopAnimating];
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    NSLog(@"DidFailLoadWithError:%@",error);
}

#pragma mark - 请求数据
- (void)updateStatus
{
    [favoriteBtn setHidden:NO];
    if (cancollection) {
//        [favoriteBtn setEnabled:YES];
        [favoriteBtn setImage:[UIImage imageNamed:@"icon_collect.png"] forState:UIControlStateNormal];
    }else{
//        [favoriteBtn setEnabled:NO];
        [favoriteBtn setImage:[UIImage imageNamed:@"icon_collect_select.png"] forState:UIControlStateNormal];
    }
    
    if (canapplay) {
        [applyBtn_ setEnabled:YES];
    }else{
        [applyBtn_ setEnabled:NO];
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    zwDetailModel_ = dataModal;
    positionId_ = zwDetailModel_.zwID_;
    positionName_ = zwDetailModel_.zwName_;
    companyId_ = zwDetailModel_.companyID_;
    [super beginLoad:dataModal exParam:nil];
    
    if ([companyId_ isEqualToString:@"cm1287987635752"])
    {
        if (!schoolZPShareUrlCon_) {
            schoolZPShareUrlCon_ = [self getNewRequestCon:NO];
        }
        [schoolZPShareUrlCon_ getSchoolZPShareUrl:[Manager getUserInfo].userId_ zwId:positionId_];
    }
}

- (void)getDataFunction:(RequestCon *)con
{
    if (!positionUrlCon_) {
        positionUrlCon_ = [self getNewRequestCon:NO];
    }
    if (type_ == 2 || type_ == 3) {//企业详情
        [positionUrlCon_ getCompanyDetail3GURLWithUserId:[Manager getUserInfo].userId_ companyId:companyId_];
    }else{//职位详情
        
        if ([zwDetailModel_.nearByWords isEqualToString:@"nearWords"]) {
            [positionUrlCon_ getPositionDetail3GURLWithUserId:[Manager getUserInfo].userId_ positionId:positionId_ location:@"near"];
        }
        else
        {
            [positionUrlCon_ getPositionDetail3GURLWithUserId:[Manager getUserInfo].userId_ positionId:positionId_ location:nil];
        }
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
        case Request_GetCompanyPositionDetailUrl:
        {//获取公司详情3GURL
            Status_DataModal *model = [dataArr objectAtIndex:0];
            position3GUrl_ = model.exObj_;
            if (position3GUrl_ != nil) {
                position3GUrl_ = [NSString stringWithFormat:@"%@&fromtype=app",position3GUrl_];

                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight+10)];
                webView.delegate = self;
                webView.tag = 1001;
                webView.dataDetectorTypes = UIDataDetectorTypeNone;
                NSURL *url = [[NSURL alloc]initWithString:position3GUrl_];
                [webView loadRequest:[NSURLRequest requestWithURL:url]];
                [self.view addSubview:webView];
            }
        }
            break;
        case Request_GetPositionNameWith:
        {//获取职位名称
            positionName_ = [dataArr objectAtIndex:0];
            [self share];
        }
            break;
        case Request_PositionDetail3GURL_:
        {//获取职位详情3GURL
            Status_DataModal *model = [dataArr objectAtIndex:0];
            position3GUrl_ = model.exObj_;
            
            if (position3GUrl_ != nil) {
                
                //全局webview 有时无法拦截url
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight+10)];
                webView.delegate = self;
                webView.tag = 1001;
                webView.dataDetectorTypes = UIDataDetectorTypeNone;
                NSURL *url = [[NSURL alloc]initWithString:position3GUrl_];
                [webView loadRequest:[NSURLRequest requestWithURL:url]];
                [self.view addSubview:webView];
            }
        }
            break;
        case Request_CollectPosition:
        {//收藏职位
             Status_DataModal *model =  [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                pf_id = model.exObj_;
                cancollection = NO;
                [self updateStatus];
                [BaseUIViewController showAutoDismissSucessView:model.des_ msg:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FRESHCOLLECTIONCOUNT" object:@"+"];
            }else{
                [BaseUIViewController showAutoDismissFailView:model.des_ msg:nil];
            }
        }
            break;
        case Request_DeleteCollectPosition:
        {//取消收藏职位
            Status_DataModal *statusModel = [dataArr objectAtIndex:0];
            if ([statusModel.status_ isEqualToString:@"OK"]) {
                cancollection = YES;
                [self updateStatus];
                [BaseUIViewController showAutoDismissSucessView:@"取消收藏成功" msg:nil];
            }else{
                [BaseUIViewController showAutoDismissFailView:statusModel.des_ msg:nil];
            }
        }
            break;
        case Request_ApplyOneZw:
        {//申请职位
            Status_DataModal *model =  [dataArr objectAtIndex:0];
            [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
            if ([model.status_ isEqualToString:@"OK"]) {
                canapplay = NO;
                [self updateStatus];
                if ([positionId_ isEqualToString:@"46289033"]||[positionId_ isEqualToString:@"46289032"]||[positionId_ isEqualToString:@"46289030"]||[positionId_ isEqualToString:@"46289028"]||[positionId_ isEqualToString:@"46289025"]) {
                    if (!schoolShareUrl_ || [schoolShareUrl_ isEqualToString:@""]) {
                        if (!schoolZPShareUrlCon_) {
                            schoolZPShareUrlCon_ = [self getNewRequestCon:NO];
                        }
                        [schoolZPShareUrlCon_ getSchoolZPShareUrl:[Manager getUserInfo].userId_ zwId:positionId_];
                    }
                    [self showChooseAlertView:101 title:@"投递成功！分享给好友，向他们集赞。\n集赞最多者将获直通资格。" msg:nil okBtnTitle:@"分享" cancelBtnTitle:@"取消"];
                }
                else {
                    [BaseUIViewController showAutoDismissSucessView:@"申请成功" msg:nil];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FRESHAPLAYCOUNT" object:@"+"];
            }
            else if([model.status_ isEqualToString:@"FAIL"] && [model.code_ isEqualToString:@"199"]){
                NSString *str = model.exDic_[@"job_url"];
                if (str) {
                    if (str.length > 0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    }
                }
            }
            else
            {
                NSString * failMsg_;
                if([model.code_ isEqualToString:@"1"])
                {
                    failMsg_ = @"简历不完善，请先完善简历";
                    //自动收藏
                    cancollection = NO;
                    [self updateStatus];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"FRESHCOLLECTIONCOUNT" object:@"+"];
                }
                
                else if ([model.code_ isEqualToString:@"2"]) {
                    failMsg_ = @"三天内不能重复申请同一职位";
                }
                else
                {
                    failMsg_ = @"申请失败，未知错误";
                }
                [BaseUIViewController showAutoDismissFailView:failMsg_ msg:nil];
            }
        }
            break;
        case Request_GetSchoolZPShareUrl:
        {//获取校园招聘活动分享的url
            schoolShareUrl_ = [dataArr objectAtIndex:0];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 点击事件
-(void)btnResponse:(id)sender
{
    if (sender == applyBtn_) {
        if( ![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_ApplyPostion;
            return;
        }
        if (!canapplay) {
            [BaseUIViewController showAlertView:@"请勿重复申请" msg:@"你已经申请过该职位了" btnTitle:@"确定"];
            return;
        }
        if (!applayCon_) {
            applayCon_ = [self getNewRequestCon:NO];
        }
        [BaseUIViewController showModalLoadingView:YES title:@"正在申请该职位" status:nil];
        if (![Manager getUserInfo].userId_) {
            [Manager getUserInfo].userId_ = @"";
        }
        if (!positionId_) {
            positionId_ = @"";
        }
        if (!zwDetailModel_.companyID_) {
            zwDetailModel_.companyID_ = @"";
        }
        
        //谷歌分析 创建事件并发送
        NSMutableDictionary *event = [[GAIDictionaryBuilder createEventWithCategory:@"Action"        //事件分类
                                                                             action:@"ButtonPress"   //事件动作
                                                                              label:@"resumeDeliver" //事件标签(简历投递)
                                                                              value:nil] build];
        [[GAI sharedInstance].defaultTracker send:event];
        [[GAI sharedInstance] dispatch]; //发送

        [applayCon_ applyOneZW:[Manager getUserInfo].userId_ zwid:positionId_ cid:zwDetailModel_.companyID_ jobName:@""];
    }
    else if(sender == favoriteBtn){
        if( ![Manager shareMgr].haveLogin ){
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            return;
        }
        
        if (!collectionCon_) {
            collectionCon_ =[self getNewRequestCon:NO];
        }
        
        if (!cancollection) {
            [collectionCon_ deleteCollectPosition:[Manager getUserInfo].userId_ positionId:pf_id];
        }else{
            [collectionCon_ collectPosition:[Manager getUserInfo].userId_ positionId:positionId_];
        }
    }
    else if (sender == shareBtn){
        if (detailType == 1) {
            if (!positionNameCon_) {
                positionNameCon_ = [self getNewRequestCon:NO];
            }
            [positionNameCon_ getPositionNameWith:positionId_];
        }else{
            [self showCompanyDetail];
        }
    }
    else if (sender == backBtn_) {
        UIWebView *webview = [self.view viewWithTag:1001];
        if (webview.canGoBack) {
            [webview goBack];
        }
        else
        {
            NSInteger count = self.navigationController.viewControllers.count;
            if (_backTwoTier && count >= 3){
                [self.navigationController popToViewController:self.navigationController.viewControllers[count-3] animated:YES];
                return;
            }
            [super backBarBtnResponse:nil];
        }
    }
    else if(sender == closeBtn_)
    {
        NSInteger count = self.navigationController.viewControllers.count;
        if (_backTwoTier && count >= 3){
            [self.navigationController popToViewController:self.navigationController.viewControllers[count-3] animated:YES];
            return;
        }
        [super backBarBtnResponse:nil];
    }

}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_ApplyPostion:
        {
             [self btnResponse:applyBtn_];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 分享
- (void)share
{
    if (zwDetailModel_.companyName_ == nil || ![zwDetailModel_.companyName_ isKindOfClass:[NSString class]]) {
        zwDetailModel_.companyName_ = @"";
    }
    NSString * title = [NSString stringWithFormat:@"%@ 招聘【%@】",zwDetailModel_.companyName_,positionName_];
    
    NSString * url = [NSString stringWithFormat:@"http://m.job1001.com/jobdetail_%@.htm",positionId_];
    
    NSString * sharecontent = [NSString stringWithFormat:@"如果有意向即可投递简历，如果身边有人求职，欢迎转发。点击产看详情。"];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:zwDetailModel_.companyLogo_]]];
    //调用分享
    
    if ([Manager shareMgr].haveLogin) {
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:title content:sharecontent image:image url:url shareType:ShareTypeThree];
        [[ShareManger sharedManager] setShareDelegare:self];
    }
    else
    {
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:title content:sharecontent image:image url:url];
    }
}

-(void)shareYLFriendBtn
{
    TheContactListCtl *contact = [[TheContactListCtl alloc] init];
    contact.isPersonChat = YES;
    contact.isPushShareCtl = YES;
    if (!shareModal) {
        shareModal = [[ShareMessageModal alloc] init];
    }
    shareModal.shareType = @"20";
    shareModal.shareContent = @"职位";
    
    shareModal.position_id = positionId_;
    shareModal.position_name = positionName_;
    shareModal.position_logo = zwDetailModel_.companyLogo_;
    shareModal.position_company = zwDetailModel_.companyName_;
    shareModal.position_company_id = zwDetailModel_.companyID_;
    
    if (!shareModal.position_name) {
        shareModal.position_name = @"";
    }
    if (!shareModal.position_logo) {
        shareModal.position_logo = @"";
    }
    if (!shareModal.position_company) {
        shareModal.position_company = @"";
    }
    if (!shareModal.position_company_id)
    {
        shareModal.position_company_id = @"";
    }
    
    if (zwDetailModel_.salary_.length > 0) {
        shareModal.position_salary = zwDetailModel_.salary_;
    }
    else
    {
        shareModal.position_salary = @"面议";
    }
    contact.shareDataModal = shareModal;
    [self.navigationController pushViewController:contact animated:YES];
    [contact beginLoad:nil exParam:nil];
}

-(void)showCompanyDetail
{
    NSString * title = [NSString stringWithFormat:@"%@诚聘英才",[zwDetailModel_.companyName_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    NSString * url = [NSString stringWithFormat:@"http://m.job1001.com/company/wgz_%@.htm?p_id=%@",zwDetailModel_.companyID_,[Manager getUserInfo].userId_];
    NSMutableString * mStr = [[NSMutableString alloc] initWithString:zwDetailModel_.companyName_.length>0?zwDetailModel_.companyName_:@""];
    NSRange rang;
    rang.location = 0;
    rang.length = [mStr length];
    [mStr replaceOccurrencesOfString:@"<style>" withString:@"<" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [mStr length];
    [mStr replaceOccurrencesOfString:@"</style>" withString:@">" options:NSCaseInsensitiveSearch range:rang];
    NSString* des = mStr;
    NSString * sharecontent =  [MyCommon removeHTML2:des];
    sharecontent = [MyCommon filterHTML:sharecontent];
    @try {
        sharecontent = [NSString stringWithFormat:@"%@",[sharecontent substringToIndex:sharecontent.length>50?50:sharecontent.length]];
    }
    @catch (NSException *exception) {

    }
    @finally {
        
    }
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:zwDetailModel_.companyLogo_]]];
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:title content:sharecontent image:image url:url];
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [super alertViewChoosed:alertView index:index type:type];
    switch (type) {
        case 111:
        {
            [self backBarBtnResponse:nil];
        }
            break;
        case 101:
        {
            //分享一览的职位集赞
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024"  ofType:@"png"];
            
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            NSString * sharecontent = @"我正在参加2015一览网络校园招聘。请为我点赞，助我直通，拿到offer。";
            
            NSString * titlecontent = @"请为我点赞，助我拿到offer！";
            
            NSString * url = schoolShareUrl_;
            
            //调用分享
            [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url]; 
        }
            break;
        default:
            break;
    }
}

- (void)backBarBtnResponse:(id)sender
{
    UIWebView *webview = [self.view viewWithTag:1001];
    if (webview.canGoBack) {
        [webview goBack];
    }
    else
    {
        NSInteger count = self.navigationController.viewControllers.count;
        if (_backTwoTier && count >= 3){
            [self.navigationController popToViewController:self.navigationController.viewControllers[count-3] animated:YES];
            return;
        }
        [super backBarBtnResponse:sender];
    }
}

- (void)showImage
{
    NSLog(@"showImage success");
}

#pragma mark - MJPhotoBrowserDelegate
-(void) photoBrowserHide:(MJPhotoBrowser *)photoBrowser
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
