//
//  YLOfferApplyUrlCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/7/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLOfferApplyUrlCtl.h"
#import "YLOfferApplyPromptCtl.h"
#import "MyOfferPartyDetailCtl.h"
#import "ELGroupDetailCtl.h"
#import "ArticleDetailCtl.h"
#import "PositionDetailCtl.h"
#import "NoLoginPromptCtl.h"
#import "ELPersonCenterCtl.h"

#import "MyResumeController.h"
#import "ModifyResumeViewController.h"

@interface YLOfferApplyUrlCtl () <OfferApplyDelegate, UIWebViewDelegate,NoLoginDelegate>
{
    
    IBOutlet UIView *backView;
    
    __weak IBOutlet UIButton *detailBtn;
    __weak IBOutlet UIButton *shareBtn;
    
    __weak IBOutlet UIScrollView *scrollView_;
    __weak IBOutlet UIButton *applyBtn;
    UIImageView *imageView;
    
    YLOfferApplyPromptCtl *promptCtl;
    RequestCon *applyCon;
    UIActivityIndicatorView *activityView;
    
}
@end

@implementation YLOfferApplyUrlCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Offer派详情";
    
    promptCtl = [[YLOfferApplyPromptCtl alloc] init];
    promptCtl.applyDelegare = self;
    promptCtl.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    if (_modal.iscome){
        [applyBtn setTitle:@"已签到" forState:UIControlStateNormal];
    }else if (_modal.isjoin) {
       [applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
    }
    _indicatorView.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUp:) name:@"YLOfferApplyUrlCtlSignUpOfferParty" object:nil];
}

- (void)refreshSignUp:(NSNotification *)notification
{
    _modal.isjoin = YES;
    [applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Offer派详情";
}

#pragma mark
- (void)getDataFunction:(RequestCon *)con
{
    [con getOfferPartyDetailUrl:_modal.jobfair_id];
}

- (IBAction)applyRespone:(UIButton *)sender
{
    if (sender == applyBtn)
    {
        if (_modal.isjoin) {
            return;
        }
        [self showChooseAlertView:30 title:@"温馨提示" msg:@"是否确定报名" okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
        return;
    }
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 30:
        {
            if (![Manager shareMgr].haveLogin) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^
                {
                    [promptCtl showApplyCtlViewType:1];
                });
                return;
            }
            if (!applyCon) {
                applyCon = [self getNewRequestCon:NO];
            }
            [applyCon addPersonToOfferPersonId:[Manager getUserInfo].userId_ jobFairId:_modal.jobfair_id];
        }
        default:
            break;
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_AddPersonToOffer:
        {
            Status_DataModal *modal = dataArr[0];
            if ([modal.status_ isEqualToString:@"OK"])
            {
                [self performSelector:@selector(delay) withObject:nil afterDelay:1.0];
                _modal.isjoin = YES;
                [applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyOfferPartyDetailCtlSignUpOfferParty" object:nil];
            }
            else if([modal.code_ isEqualToString:@"2"])
            {
                _modal.isjoin = YES;
                [applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
                [BaseUIViewController showAlertView:nil msg:modal.des_ btnTitle:@"确定"];
            }
            else
            {
                _modal.isjoin = NO;
                [BaseUIViewController showAlertView:nil msg:modal.des_ btnTitle:@"确定"];
            }
        }
            break;
        case Request_OfferPartyDetailUrl://offer派的URL
        {
            NSDictionary *result = dataArr[0];
            NSString *urlStr = result[@"url"];
            NSURL * url = [NSURL URLWithString:urlStr];
            NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
            [_webView loadRequest:urlRequest];
        }
            break;
        default:
            break;
    }
}

- (void)delay
{
    if (_resumeComplete) {
        [promptCtl showApplyCtlViewType:3];
    }
    else
    {
        [promptCtl showApplyCtlViewType:2];
    }

}

-(void)applyDelegateCtlWithType:(NSInteger)type
{
    switch (type) {
        case 1:
        {
            [NoLoginPromptCtl loginOutWithDelegate:self type:LoginType_OfferPayJoin loginRefresh:NO];
        }
            break;
        case 2:
        {
            ModifyResumeViewController *modifyResumeVC = [[ModifyResumeViewController alloc]init];
            [modifyResumeVC beginLoad:nil exParam:nil];
            [self.navigationController pushViewController:modifyResumeVC animated:YES];
        }
            break;
        default:
            break;
    }
}


-(void)btnResponse:(id)sender
{
    if (sender == shareBtn)
    {
        UIImage * image = nil;
        NSString *imageUrl = _modal.logo_src;
        NSString *title = _modal.jobfair_name;
        NSString *content = @"";
        
        if (_modal.share_friend_title.length > 0) {
            title = _modal.share_friend_title;
        }
        
        if (_modal.share_friend_content.length > 0) {
            content = _modal.share_friend_content;
        }
        else
        {
            content = @"面试复试一站式服务，大把offer轻松拿";
        }
        if (_modal.xuanchuan_url.length > 0) {
            imageUrl = _modal.xuanchuan_url;
        }
        
        if (imageUrl.length > 0)
        {
            UIImage *imageOne = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            if (imageOne) {
                image = imageOne;
            }
        }
        
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:title content:content image:image url:_modal.xuanchuan_url];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *path = request.URL.absoluteString;
    if ([path containsString:@"group"]) {//社群
        NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.length) {
            NSString *groupId = [path substringFromIndex:range.location +1];
            ELGroupDetailCtl *detailCtl = [[ELGroupDetailCtl alloc]init];
            Groups_DataModal *dataModal = [[Groups_DataModal alloc] init];
            dataModal.id_ = groupId;
            [self.navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:dataModal exParam:nil];
        }
        return NO;
    }else if ([path containsString:@"article"]) {//文章详情
        NSRange range = [path rangeOfString:@"article/" options:NSBackwardsSearch];
        if (range.length) {
            NSInteger location = range.location +8;
            NSInteger length = path.length;
            NSString *articleId = [path substringWithRange:NSMakeRange(location, length-location)];
            Article_DataModal *articleModel = [[Article_DataModal alloc]init];
            articleModel.id_ = articleId;
            articleModel.title_ = @"";
            ArticleDetailCtl * articleDetailCtl = [[ArticleDetailCtl alloc] init];
            [self.navigationController pushViewController:articleDetailCtl animated:YES];
            [articleDetailCtl beginLoad:articleModel exParam:nil];
        }
        return NO;
    }else if ([path containsString:@"jobDetail"]) {//职位详情
        NSRange range = [path rangeOfString:@"zwid=" options:NSBackwardsSearch];
        if (range.length) {
            NSDictionary *queryDic = [self parseQueryString:request.URL.query];
            NSString *zwid = queryDic[@"zwid"];
            ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
            dataModel.companyID_ = queryDic[@"companyid"];
            dataModel.zwID_ =zwid;
            dataModel.companyName_ = queryDic[@"cname"];
            dataModel.companyLogo_ = queryDic[@"logo"];
            PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
            positionCtl.offerPartyFlag = YES; //offer派入口
            positionCtl.type_ = 4;
            [self.navigationController pushViewController:positionCtl animated:YES];
            [positionCtl beginLoad:dataModel exParam:nil];
        }
        
        return NO;
    }else if ([path containsString:@"/message"]){//私信联系
        if (![Manager shareMgr].haveLogin) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            return NO;
        }
        NSDictionary *queryDic = [self parseQueryString:request.URL.query];
        NSString *userId = queryDic[@"person_id"];
        NSString *userName = queryDic[@"person_iname"];
        MessageContact_DataModel *model = [[MessageContact_DataModel alloc] init];
        model.userId = userId;
        model.userIname = userName;
        MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:model exParam:nil];
        
        return NO;
    }else if ([path containsString:@"/ask"]){//问他
        NSDictionary *queryDic = [self parseQueryString:request.URL.query];
        NSString *expert_id = queryDic[@"expert_id"];
        AskDefaultCtl* askDefaultCtl_ = [[AskDefaultCtl alloc]init];
        askDefaultCtl_.backCtlIndex = self.navigationController.viewControllers.count;
        [self.navigationController pushViewController:askDefaultCtl_ animated:YES];
        [askDefaultCtl_ beginLoad:expert_id exParam:nil];
        return NO;
    }else if ([path containsString:@"/hangjia"]){//行家详情
        NSDictionary *queryDic = [self parseQueryString:request.URL.query];
        NSString *expert_id = queryDic[@"expert_id"];
        
        ELPersonCenterCtl *ctl = [[ELPersonCenterCtl alloc] init];
        ctl.isFromJobAnswer = YES;
        [ctl beginLoad:expert_id exParam:nil];
        [self.navigationController pushViewController:ctl animated:YES];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - NoLoginDelegate
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_OfferPayJoin:
        {
            if (!applyCon) {
                applyCon = [self getNewRequestCon:NO];
            }
            [applyCon addPersonToOfferPersonId:[Manager getUserInfo].userId_ jobFairId:_modal.jobfair_id];
        }
            break;
        default:
            break;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_indicatorView startAnimating];
    _indicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicatorView stopAnimating];
    _indicatorView.hidden = YES;
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if ([elements count] <= 1) {
            continue;
        }
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:gbkEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:gbkEncoding];
        if (!key || !val) {
            continue;
        }
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end
