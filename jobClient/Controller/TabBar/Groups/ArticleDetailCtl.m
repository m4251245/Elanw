//
//  ArticleDetailCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ArticleDetailCtl.h"
#import "TJZWCell.h"
#import "PushUrlCtl.h"
#import "MD5.h"
#import "NoLoginPromptCtl.h"
#import "CommentListCtlCell.h"
#import "RewardAmountCtl.h"
#import "Reward_DataModal.h"
#import "ELPersonCenterCtl.h"
#import "ELMyRewardRecordListCtl.h"
#import "ELRewardLuckyBagAnimationCtl.h"
#import "ELArticleAbnormalCtl.h"
#import "ELArticlePublishBtnCtl.h"
#import "ELArticleHeaderView.h"
#import "ELArticleTitleView.h"
#import "ELArticleCommentView.h"
#import "ReplyCommentCtl.h"
#import "ELGroupCommentModel.h"
#import "ELArticleDetailModel.h"
#import "ELCommentReplyView.h"
#import "ELWebSocketManager.h"
#import "ELGroupDetailModal.h"
#import "ResumeCommentTag_DataModal.h"

@interface ArticleDetailCtl () <NoLoginDelegate,AttentionSuccessDelegate,AddReplyCommentDelegate,ReplyButtonResponeDelegate,ELWebSocketManagerDelegate>
{
    BOOL  haveScroll_;
    CGFloat backViewHeight;
    BOOL refreshList;
    BOOL hideTableView;
    
    BOOL webViewLoadFinish;
    BOOL commentLoadFinish;
    
    IBOutlet UIView *rewardView;
    IBOutlet UIView *imgBgView;
    IBOutlet UIButton *rewardBtn;
    IBOutlet UILabel *rewardCount;     /**<打赏人数 */
    IBOutlet UILabel *_rewardTipLb;
    RequestCon *rewardImgCon;
    RequestCon *addCommentlikeCon_;
    RequestCon *replyCon;
    NSMutableArray *rewardImgArr;

    __weak IBOutlet UIActivityIndicatorView *activityView;
    __weak IBOutlet UIButton *backBtnFour;
    
    ELArticleAbnormalCtl *abnormalCtl;  //文章禁用删除卡片
    ELArticlePublishBtnCtl *publishBtnCtl;  //活动报名卡片
    ELArticleHeaderView *otherView;    //评论上方所有卡片
    ELArticleTitleView *titleView;     //文章最顶部title卡片
    ELArticleCommentView *commentView;  //底部评论卡片
    
    NSString *articleId;
    
    id _selectData; //当前选中的评论卡片
    ELCommentReplyView *_selectOptionView;//点击评论弹出的视图
    ELGroupCommentModel *selectDataModal_;
    UITapGestureRecognizer *singleTapRecognizer_;
    
    UIView *joinView;
    ELBaseButton *joinGroupButton;
    RequestCon *joinCon;
    
    BOOL isMyPublishArticle;
    
    BOOL isHave;
    NSMutableArray *_tagArray;
    
    BOOL isAddNewMessage;
    NSMutableArray *newMessageArr;
    BOOL canAddNewMessage;
}

@property (nonatomic, strong) ELWebSocketManager *socketManager;
@end

@implementation ArticleDetailCtl
@synthesize type_;

@synthesize bScrollToComment_,isFromGroup_,isFromCompanyGroup;

-(void)dealloc
{
    [requestCon_ stopConnWhenBack];
    tableView_.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveSocketMsg" object:nil];
}

-(id)init{
    self = [super init];
    if (self) {
        bHeaderEgo_ = NO;
        bFooterEgo_ = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.socketManager.delegate = self;
    
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
    [commentView hideCommentKeyBoardAndFace];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [ELRequest cancelAllRequest];
    
    
    self.socketManager.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (refreshList) {
        [self refreshLoad:nil];
        refreshList = NO;
    }
    if ([Manager shareMgr].isShowRewardAnimat){
        [self starAnimation];
        [self refreshLoad:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isEnablePop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    webview_.dataDetectorTypes = UIDataDetectorTypeNone;
    webview_.delegate = self;
    webview_.userInteractionEnabled = YES;
    webview_.scrollView.alwaysBounceHorizontal = YES;
    webview_.scrollView.scrollEnabled = NO;
    
    backBtnFour.hidden = NO;
    [self addTapOnWebView];

    tableView_.backgroundView = nil;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.backgroundColor = [UIColor whiteColor];
    
    tableView_.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height - 60);
    tableView_.contentInset=UIEdgeInsetsMake(-20, 0, 0, 0);
    
    for (NSInteger i = 0;i<5;i++) {
        UIImageView *imageView = (UIImageView *)[imgBgView viewWithTag:201+i];
        imageView.layer.cornerRadius = 15.0;
        imageView.layer.masksToBounds = YES;
    }
    
    CGRect frame = activityView.frame;
    frame.origin.y = ([UIScreen mainScreen].bounds.size.height - 80)/2;
    frame.origin.x = (ScreenWidth/2) - 10;
    activityView.frame = frame;
    
    tableView_.alpha = 0;
    headView_.alpha = 0.0;
    [activityView startAnimating];
    
    otherView = [[ELArticleHeaderView alloc] initWithArticleCtl:self];
    otherView.articleId = articleId;
    [otherView loadDataWithIsFromNews:_isFromNews];
    
    [self requestArticleDetail];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    
    _tagArray = [[NSMutableArray alloc] init];
    [self requestResumeTag];
    
    canAddNewMessage = NO;
    newMessageArr = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewsMsg:) name:@"receiveSocketMsg" object:nil];
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;   //调用默认跟踪器
    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];  //这个屏幕名称将会在谷歌分析报告中显示
    [tracker send:[[GAIDictionaryBuilder createScreenView]build]];

}

-(void)textChanged:(UITextView *)textView{
    if (commentView){
        [commentView textChanged:textView];
    }
}

-(void)tapPersonCenterCtl:(UITapGestureRecognizer *)sender
{
    if(_isFromNews)
    {
        return;
    }
    if (myDataModal_.person_detail.person_id.length > 0 && ![myDataModal_._is_majia isEqualToString:@"1"])
    {
        ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc]init];
        [self.navigationController pushViewController:detailCtl animated:YES];
        detailCtl.isFromManagerCenterPop = YES;
        detailCtl.attentionDelegate = self;
        [detailCtl beginLoad:myDataModal_.person_detail.person_id exParam:nil];
    }
}

-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [webview_ addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:webview_];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [webview_ stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"article_url ==%@",urlToSave);
    if (![urlToSave isEqualToString:@""] && ![urlToSave isKindOfClass:[NSNull class]] && [myDataModal_._pic_list containsObject:urlToSave]) {
        if ([myDataModal_._pic_list count] !=0) {
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[myDataModal_._pic_list count]];
            for (int i=0; i<[myDataModal_._pic_list count]; i++) {
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:[myDataModal_._pic_list objectAtIndex:i]]; // 图片路径
                [photos addObject:photo];
            }
            NSInteger indexInt = [myDataModal_._pic_list indexOfObject:urlToSave];
            photoBrowser_ = [[MJPhotoBrowser alloc] init];
            photoBrowser_.isposition_ = YES;
            photoBrowser_.delegate = self;
            photoBrowser_.currentPhotoIndex = indexInt; // 弹出相册时显示的第一张图片是？
            photoBrowser_.photos = photos; // 设置所有的图片
            [photoBrowser_ show];
        }
    }
    
//    NSString *hrefJs = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).href", pt.x, pt.y];
//    NSString *href = [webview_ stringByEvaluatingJavaScriptFromString:hrefJs];
//    if (![href isEqualToString:@""] && ![href isKindOfClass:[NSNull class]]) {
//        PushUrlCtl *urlCtl = [[PushUrlCtl alloc]init];
//        [self.navigationController pushViewController:urlCtl animated:YES];
//        href = [self getLinkUrl:href];
//        [urlCtl beginLoad:href exParam:href];
//    }
}

#pragma mark 获取中转的URL
- (NSString *)getLinkUrl:(NSString *)url
{
    if (url && ![url isEqualToString:@""]) {
        NSString *timeNow = [NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970]];
        NSString *personIdStr = [Manager getUserInfo].userId_;
        if(!personIdStr || [personIdStr isEqualToString:@""]){
            return url;
        }
        NSString *mD5CodeStr = @"1qaz2wsx1001";
        NSString *md5_1 = [MD5 getMD5:[NSString stringWithFormat:@"%@%@", personIdStr, timeNow]];
        NSString *cksMD5Str = [MD5 getMD5:[NSString stringWithFormat:@"%@%@", md5_1, mD5CodeStr]];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateComArticleDetail
{
    if(myDataModal_){
        headView_.alpha = 1.0;
        if([myDataModal_.status isEqualToString:@"10"] || [myDataModal_.status isEqualToString:@"15"]){
            [self setAbnormalViewDeleteStatus:NO];
            return;
        }else if(myDataModal_.title.length <= 0 && myDataModal_.person_detail){
            [self setAbnormalViewDeleteStatus:YES];
            return;
        }else if(![MyCommon IsEnable3G] && ![MyCommon IsEnableWIFI]){
            [self showChooseAlertView:11 title:@"暂无网络哦，请检查网络设置" msg:nil okBtnTitle:@"返回" cancelBtnTitle:nil];
            hideTableView = YES;
            [activityView stopAnimating];
            return;
        }else if(myDataModal_.title.length <= 0){
            [self showChooseAlertView:11 title:@"出错啦，稍后再试吧" msg:nil okBtnTitle:@"返回" cancelBtnTitle:nil];
            hideTableView = YES;
            [activityView stopAnimating];
            return;
        }
        NSDictionary *dic = myDataModal_.dicJoinName;
        NSString *status = dic[@"status"];
        BOOL isActivity = [status isEqualToString:@"OK"];
        if (!isActivity) {
            NSString *groupPeopleStatus = @"";
            NSString *gs_view_content = @"";
            if ([myDataModal_.groupUserRel isKindOfClass:[NSDictionary class]]) {
                groupPeopleStatus = myDataModal_.groupUserRel[@"status"];
            }
            if (myDataModal_._group_info) {
                gs_view_content = myDataModal_._group_info.gs_view_content;
            }
            if([gs_view_content isEqualToString:@"200"] && ![Manager shareMgr].haveLogin){
                hideTableView = YES;
                [activityView stopAnimating];
                joinGroupButton.userInteractionEnabled = YES;
                [self creatJoinViewText:@"需要登录后才能浏览具体内容哦" buttonName:@"马上登录"];
                return;
            }
            if ([gs_view_content isEqualToString:@"100"] && [groupPeopleStatus isEqualToString:@"FAIL"]) {
                hideTableView = YES;
                [activityView stopAnimating];
                [self creatJoinViewText:@"成为本群成员才能浏览具体内容哦" buttonName:@"申请加入"];
                joinGroupButton.userInteractionEnabled = YES;
                if ([myDataModal_.apply_status_info isKindOfClass:[NSDictionary class]]) {
                    NSString *code = myDataModal_.apply_status_info[@"code"];
                    if ([code isEqualToString:@"199"]) {
                        [joinGroupButton setTitle:@"等待审核" forState:UIControlStateNormal];
                        joinGroupButton.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
                        [joinGroupButton setTitleColor:UIColorFromRGB(0xbdbdbd) forState:UIControlStateNormal];
                        joinGroupButton.userInteractionEnabled = NO;
                    }
                }
                joinView.hidden = NO;
                
                return;
            }else{
                if (joinView) {
                    joinView.hidden = YES;
                }
            }
        }
   
        if(!titleView){
            titleView = [[ELArticleTitleView alloc] initWithArticleCtl:self];
        }
        [titleView setMyDataModal:myDataModal_];
        titleView.type_ = type_;
        titleView.isFromGroup_ = isFromGroup_;
        backViewHeight = titleView.backBtnHeight;
        titleView.frame = CGRectMake(0,0,ScreenWidth,titleView.webViewY);
        [headView_ addSubview:titleView];
        
        titleView.titleViewThree.frame = CGRectMake(4,15,300,30);
        [self.view addSubview:titleView.titleViewThree];
        [self.view bringSubviewToFront:titleView.titleViewThree];
        
        CGRect rect7 = webview_.frame;
        rect7.origin.y = titleView.webViewY;
        webview_.frame = rect7;
        [otherView setMyModal:myDataModal_];
        
        if (![myDataModal_._group_info.groups_communicate_mode isEqualToString:@"10"]) {
            if (![myDataModal_.qi_id_isdefault isEqualToString:@"0"]) {
                isHave = YES;
            }
            else {
                isHave = NO;
            }
        }
        else {
            isHave = NO;
        }
        
        if(!commentView){
            commentView = [[ELArticleCommentView alloc] initWithArticleCtl:self isHave:isHave];
            
        }
        
        
        if (isHave) {
            tableView_.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height - 102);
            commentView.frame = CGRectMake(0,CGRectGetMaxY(tableView_.frame),ScreenWidth,82);
        }
        else{
            tableView_.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height - 60);
            commentView.frame = CGRectMake(0,CGRectGetMaxY(tableView_.frame),ScreenWidth,40);
        }
        [self.view addSubview:commentView];
        [commentView setMyModal:myDataModal_];
        commentView.hidden = YES;
    }else{
        if(![MyCommon IsEnable3G] && ![MyCommon IsEnableWIFI]){
            [self showChooseAlertView:11 title:@"暂无网络哦，请检查网络设置" msg:nil okBtnTitle:@"返回" cancelBtnTitle:nil];
        }else{
            [self showChooseAlertView:11 title:@"出错啦，稍后再试吧" msg:nil okBtnTitle:@"返回" cancelBtnTitle:nil];
        }
        hideTableView = YES;
        [activityView stopAnimating];
        return;
    }

    if (tableView_.contentOffset.y > backViewHeight-15){
        titleView.titleViewThree.hidden = NO;
    }else{
        titleView.titleViewThree.hidden = YES;
    }
    
    if (!publishBtnCtl) {
        publishBtnCtl = [[ELArticlePublishBtnCtl alloc] initWithArticleCtl:self];
    }
    [publishBtnCtl setMyDataModal_:myDataModal_];
    
    if (publishBtnCtl.showViewCtl) {
        [headView_ addSubview:publishBtnCtl];
    }
    

    if (myDataModal_.content.length > 0){
        NSMutableString * webStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"<div style=\"word-wrap:break-word; width:%fpx;\">",ScreenWidth]];
        NSString * endstr = @"</div>";
        
        
        if (myDataModal_.url.length > 0) {
            if (![myDataModal_.url containsString:@"&skipad=yes"]) {
                myDataModal_.url = [NSString stringWithFormat:@"%@&skipad=yes", myDataModal_.url];
            }
            NSString *urlStr = [NSString stringWithFormat:@"<iframe src=\"%@\" border=\"0\" frameborder=\"no\" width=\"%f\" />", myDataModal_.url, webview_.frame.size.width];
            myDataModal_.content = [NSString stringWithFormat:@"%@", urlStr];
            [webStr appendFormat:@"%@",myDataModal_.content];
            [webStr appendFormat:@"%@",endstr];
        }else{
            [webStr appendFormat:@"%@",myDataModal_.content];
            [webStr appendFormat:@"%@",endstr];
            NSString *str = [NSString stringWithFormat:@"%@",webStr];
            NSScanner *scanner = [NSScanner scannerWithString:str];
            NSString * text = nil;
            
            while([scanner isAtEnd]==NO)
            {
                [scanner scanUpToString:@"<p" intoString:nil];
                [scanner scanUpToString:@"</p>" intoString:&text];
                if ([text containsString:@"<img"]){
                    for (NSInteger i = 0;i<text.length;i++) {
                        NSString *strOne = [text substringWithRange:NSMakeRange(i,1)];
                        if ([strOne isEqualToString:@">"]) {
                            str  =  [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@</p>",text] withString:[NSString stringWithFormat:@"<p%@</p>",[text substringFromIndex:i]]];
                            break;
                        }
                    }
                }
            }
            webStr = [[NSMutableString alloc] initWithString:str];
        }
        
        

        //webStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>%@",ScreenWidth-16,webStr]];
       // NSString *str = [webStr stringByReplacingOccurrencesOfString:@"img{ max-width:100%;margin:5px auto; display:block;}" withString:@""];
        
//        webStr = [self scanner:webStr];
//        NSRange rang;
//        rang.location = 0;
//        rang.length = [webStr length];
        [webview_ loadHTMLString:[self scanner:webStr] baseURL:nil];
    }
}

-(void)creatJoinViewText:(NSString *)text buttonName:(NSString *)name{
    if (!joinView) {
        joinView = [[UIView alloc] initWithFrame:CGRectMake(0,(ScreenHeight-210)/2.0,ScreenWidth,210)];
        [self.view addSubview:joinView];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-90)/2.0,0,90,102)];
        image.image = [UIImage imageNamed:@"private"];
        [joinView addSubview:image];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,117,ScreenWidth,18)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x999999);
        label.tag = 1001;
        label.font = [UIFont systemFontOfSize:15];
        [joinView addSubview:label];
        
        joinGroupButton = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:15] title:@"" textColor:UIColorFromRGB(0xe13e3e) Target:self action:@selector(btnResponse:) frame:CGRectMake((ScreenWidth-120)/2.0,170,130,30)];
        [joinGroupButton setLayerCornerRadius:5.0];
        [joinGroupButton setBorderWidth:1 borderColor:[UIColor redColor]];
        [joinView addSubview:joinGroupButton];
    }
    UILabel *lable = (UILabel *)[joinView viewWithTag:1001];
    lable.text = text;
    [joinGroupButton setTitle:name forState:UIControlStateNormal];
}

- (NSString *)scanner:(NSString *)str
{
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<table" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        str  =  [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:[NSString stringWithFormat:@"<table class=\"MsoNormalTable\" style=\"width:%fpx;\">",ScreenWidth-36]];
    }
    return str;
}
#pragma mark - 异常情况下显示的视图
-(void)setAbnormalViewDeleteStatus:(BOOL)isDelete
{
    if (!abnormalCtl) {
        abnormalCtl = [[ELArticleAbnormalCtl alloc] init];
        abnormalCtl.view.frame = CGRectMake(0,0,ScreenWidth,150);
        abnormalCtl.view.center = self.view.center;
    }
    [self.view addSubview:abnormalCtl.view];
    [self.view bringSubviewToFront:abnormalCtl.view];
    if (isDelete) {
        [abnormalCtl showDeleteStatus:YES];
    }else{
        [abnormalCtl showDeleteStatus:NO];
    }
    hideTableView = YES;
    [activityView stopAnimating];
}

#pragma mark - 请求文章内容详情
-(void)requestArticleDetail
{
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"change_v_cnt"];
    [conditionDic setObject:@"1" forKey:@"get_zhiwei_flag"];
    [conditionDic setObject:@"1" forKey:@"get_other_article"];
    [conditionDic setObject:@"1" forKey:@"get_content_img_flag"];
    [conditionDic setObject:@"1" forKey:@"get_favorite_flag"];
    [conditionDic setObject:@"1" forKey:@"get_media_flag"];
    [conditionDic setObject:@"1" forKey:@"get_group_flag"];
    NSString *userId = @"";
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }
    [conditionDic setObject:userId forKey:@"login_person_id"];
    [conditionDic setObject:@"1" forKey:@"activity_article_type"];
    
    if ([Manager getUserInfo].userId_) {
        [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    }
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"art_id=%@&conditionArr=%@",articleId,conditionStr];
    
    WS(weakSelf)
    [ELRequest postbodyMsg:bodyMsg op:@"comm_article_busi" func:@"getArtContent" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
    {
        NSDictionary *dic = result;
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        if ([dataDic isKindOfClass:[NSDictionary class]]) {
            myDataModal_ = [[ELArticleDetailModel alloc] initWithDictionary:dataDic];
            myDataModal_.id_ = articleId;
            myDataModal_.isLike_ = [Manager getIsLikeStatus:myDataModal_.id_];
            if ([[Manager getUserInfo].userId_ isEqualToString:myDataModal_.person_detail.person_id]) {
                isMyPublishArticle = YES;
            }else{
                isMyPublishArticle = NO;
            }
        }
        if (isFromGroup_ ){
            myDataModal_.other_article = nil;
            myDataModal_.zhiwei = nil;
        }
        
        [weakSelf changeRewardViewHeight];
        [weakSelf updateComArticleDetail];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [activityView stopAnimating];
        [self showChooseAlertView:11 title:@"出错啦，稍后再试吧" msg:nil okBtnTitle:@"返回" cancelBtnTitle:nil];
    }];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    Article_DataModal *modal;
    if ([dataModal isKindOfClass:[Article_DataModal class]]) {
        modal = dataModal;
        articleId = modal.id_;
    }else{
        articleId = dataModal;
        modal = [[Article_DataModal alloc] init];
        modal.id_ = articleId;
    }
    [super beginLoad:modal exParam:exParam];
    
    myDataModal_ = nil;
    haveScroll_ = NO;
    if (!rewardImgCon) {
        rewardImgCon = [self getNewRequestCon:NO];
    }
    [rewardImgCon getArticleRewardImg:articleId];
}

-(void)refreshLoad:(RequestCon *)con{
    [super refreshLoad:con];
    if (!rewardImgCon) {
        rewardImgCon = [self getNewRequestCon:NO];
    }
    [rewardImgCon getArticleRewardImg:articleId];
}

-(void)getDataFunction:(RequestCon *)con
{
    [super getDataFunction:con];
    [con getCommentList:requestCon_.pageInfo_.currentPage_ pageSize:20 article:articleId parentId:@"" userId:[Manager getUserInfo].userId_];
    [self getNoDataView].hidden = YES;
}

-(void)showErrorView:(BOOL)flag{
    [super showErrorView:NO];
}

-(void)showNoDataOkView:(BOOL)flag
{
    [super showNoDataOkView:NO];
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource:(EGORefreshTableView *)egoView
{
    if( egoView == refreshHeaderView_ ){
        [MyLog Log:@"header refresh" obj:self];
        
        //refresh data
        [self refreshLoad:requestCon_];
    }else if( egoView == refreshFooterView_ ){
        [MyLog Log:@"foot load" obj:self];
        
        //load more
        [self loadMoreData:requestCon_];
    }else{
        [MyLog Log:@"null refresh" obj:self];
    }
}

-(void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch ( type ) {
        case Request_AddComment:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                commentView.giveCommentTv_.text = @"";
                commentView.isReply = NO;
                commentView.tipsStr = @"我来说两句";
                commentView.tipsLb_.text = @"我来说两句";
                [commentView.pingLunBtn setTitle:@"评论" forState:UIControlStateNormal];
                [self addReplyCommentOK:nil dataModal:nil];
                NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
                NSDictionary *dict = @{@"Source" : typeStr};
                [MobClick event:@"commentCount" attributes:dict];
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_ seconds:1.0];
            }
        }
            break;
        case Request_CommentContent:
        {
        }
            break;
        case Request_CommentList:
        {
            commentLoadFinish = YES;
            [self firstSetTableViewContentOfSet];
            if (requestCon_.dataArr_.count > 0) {
                otherView.haveComment = YES;
            }
            canAddNewMessage = YES;
            isAddNewMessage = NO;
        }
            break;
        case Request_getArticleRewardImg:
        {
            rewardImgArr = [[NSMutableArray alloc] init];
            
            NSDictionary *dic = dataArr[0];
            NSString *count;
            if ([dic[@"cnt"] isEqualToString:@""]) {
                count = @"0";
            }
            else
            {
                count = dic[@"cnt"];
            }
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"等%@人进行打赏",count]];
            [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE4403A) range:NSMakeRange(1,string.length-5)];
            [rewardCount setAttributedText:string];
            [rewardCount sizeToFit];
            
            NSMutableArray *dataArray = dic[@"list"];
            if (![dataArray isKindOfClass:[NSNull class]]){
                for (NSDictionary *dic in dataArray) {
                    Reward_DataModal *model = [[Reward_DataModal alloc] init];
                    model.personId = dic[@"personId"];
                    model.name_ = dic[@"person_iname"];   //应聘人数
                    model.nickname_ = dic[@"person_nickname"];
                    model.img_ = dic[@"person_pic"];
                    model.job_ = dic[@"person_zw"];
                    
                    [rewardImgArr addObject:model.img_];
                }
            }
            [self changeRewardViewHeight];
        }
            break;
        case Request_JoinGroup:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                if ([dataModal.code_ isEqualToString:@"200"]) {
                    //审核中
                    [BaseUIViewController showAutoDismissSucessView:@"申请成功,等待审核" msg:nil];
                    [joinGroupButton setTitle:@"等待审核" forState:UIControlStateNormal];
                    joinGroupButton.userInteractionEnabled = NO;
                    joinGroupButton.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
                    [joinGroupButton setTitleColor:UIColorFromRGB(0xbdbdbd) forState:UIControlStateNormal];
                }else if ([dataModal.code_ isEqualToString:@"100"]){
                    [BaseUIViewController showAutoDismissSucessView:@"加入成功" msg:nil];
                    hideTableView = NO;
                    joinView.hidden = YES;
                    tableView_.alpha = 0;
                    headView_.alpha = 0.0;
                    [activityView startAnimating];
                    [self requestArticleDetail];
                }
            }else{
                [BaseUIViewController showAutoDismissSucessView:dataModal.des_ msg:nil];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return [requestCon_.dataArr_ count];
        }
            break;
        case 1:
        {
            if (myDataModal_.zhiwei.count > 0) 
            {
                if (requestCon_.pageInfo_.totalCnt_ == requestCon_.dataArr_.count && !_isFromNews) {
                    return 1;
                }
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1)];
    switch (section) {
        case 0:
        {
            if (otherView.viewHeight > 0) {
                return otherView;
            }
        }
            break;
        case 1:
        {
            if (myDataModal_.zhiwei && !_isFromNews)
            {
                if(requestCon_.pageInfo_.totalCnt_ == requestCon_.dataArr_.count)
                {
                    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                    view.backgroundColor = [UIColor whiteColor];
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 36)];
                    label.backgroundColor = [UIColor clearColor];
                    [label setFont:SEVENTEENFONT_FRISTTITLE];
                    [label setTextColor:BLACKCOLOR];
                    [view addSubview:label];
                    
                    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 20,ScreenWidth-100, 1)];
                    [imgView setImage:[UIImage imageNamed:@"bg_line_article"]];
                    [view addSubview:imgView];
                    label.text = @"推荐职位";
                    return view;
                }
            }
        }
            break;
        default:
            break;
    }
    return viewBack;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (otherView.viewHeight > 0) {
                return otherView.viewHeight;
            }
        }
            break;
        case 1:
        {
            if (myDataModal_.zhiwei && !_isFromNews) {
                if(requestCon_.pageInfo_.totalCnt_ == requestCon_.dataArr_.count)
                {
                    return 45;
                }
            }
        }
            break;
        default:
            break;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            return 100;
        }
            break;
        case 0:
        {
            ELGroupCommentModel *dataModal = [requestCon_.dataArr_ objectAtIndex:[indexPath row]];
            return dataModal.cellHeight;
        }
            break;
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row > requestCon_.dataArr_.count - 1) {
                return [UITableViewCell new];
            }
            static NSString *CellIdentifier = @"CommentListCtlCell";
            CommentListCtlCell *cell = (CommentListCtlCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentListCtlCell" owner:self options:nil] lastObject];
                cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf5f5f5);
            }
            ELGroupCommentModel *dataModal = [requestCon_.dataArr_ objectAtIndex:[indexPath row]];
            [cell setDataModal:dataModal];
            if ([myDataModal_._group_source isEqualToString:@"3"]){
                cell.picBtn_.userInteractionEnabled = NO;
            }
            else{
                cell.picBtn_.userInteractionEnabled = YES;
            }
            /*
            if ([dataModal.personId isEqualToString:[Manager getUserInfo].userId_]) {
                cell.exceptionalBtn.hidden = YES;
            }else{
                cell.exceptionalBtn.hidden = NO;
                cell.exceptionalBtn.tag = 111111+indexPath.row;
                [cell.exceptionalBtn addTarget:self action:@selector(exceptionalAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            */
            if (![myDataModal_.qi_id_isdefault isEqualToString:@"2"]) {
                cell.likeBtn_.hidden = NO;
                cell.likeCountLb.hidden = NO;
                cell.likeImageView.hidden = NO;
            }
            
            return cell;
        }
            break;
        case 1:
        {
            static NSString *CellIdentifier = @"TJZWCell";
            
            TJZWCell * cell = (TJZWCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TJZWCell" owner:self options:nil] lastObject];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [cell setMyDataModal:myDataModal_];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}
-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        [super loadDetail:selectData exParam:exParam indexPath:indexPath];
        _selectData = selectData;                       
        if (!_selectOptionView) {
            _selectOptionView = [[ELCommentReplyView alloc] init];
            _selectOptionView.replyDelegate = self;
        }
        [_selectOptionView showView];
    }
}

#pragma mark - ReplyButtonResponeDelegate评论弹框的代理
-(void)btnResponeWithTitle:(NSString *)buttoName{
    if ([buttoName isEqualToString:@"回复"]){
//        ReplyCommentCtl *replyCommentCtl = [[ReplyCommentCtl alloc] init];
//        replyCommentCtl.delegate_ = self;
//        replyCommentCtl.niMingPersonId = myDataModal_._majia_info.personId;
//        replyCommentCtl.isNiMingComment = [commentView getPersonNameNiMingStatus];
//        replyCommentCtl.groupModel = myDataModal_._group_info;
//        replyCommentCtl.qiId = myDataModal_.qi_id_isdefault;
//        if ([myDataModal_._group_source isEqualToString:@"3"] && [Manager shareMgr].haveLogin){
//            replyCommentCtl.isCompanyGroup = YES;
//        }
        selectDataModal_ = _selectData;
        commentView.isReply = YES;
        NSString *personName = @"匿名";
        if (selectDataModal_.person_iname && ![selectDataModal_.person_iname isEqualToString:@""]) {
            personName = selectDataModal_.person_iname;
        }else if (selectDataModal_.person_nickname && ![selectDataModal_.person_nickname isEqualToString:@""]){
            personName = selectDataModal_.person_nickname;
        }
        commentView.tipsStr = [NSString stringWithFormat:@"回复：%@",personName];
        [commentView.pingLunBtn setTitle:@"回复" forState:UIControlStateNormal];
        [commentView.giveCommentTv_ becomeFirstResponder];
        
//        NSString * myid = @"";
//        NSString * proid = @"";
//        myid = articleId;
//        [self.navigationController pushViewController:replyCommentCtl animated:YES];
//        replyCommentCtl.objId_ = myid;
//        replyCommentCtl.proId_ = proid;
//        [replyCommentCtl beginLoad:selectDataModal_ exParam:nil];
    }else if([buttoName isEqualToString:@"复制"]){
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        ELGroupCommentModel *selectData = (ELGroupCommentModel *)_selectData;
        pastboard.string = selectData.content;
    }
}

#pragma AddReplyCommentDelegate 回复成功后的代理
-(void) addReplyCommentOK:(ReplyCommentCtl *)ctl dataModal:(Comment_DataModal *)dataModal{
    [self refreshLoad:nil];
    [self setMycontentoffset];
    [commentView commentSuccessRefresh];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSArray *ylUrls = [[Manager shareMgr] getUrlArr];        
        for (NSString *url in ylUrls) {
            NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
            if ([strUrl rangeOfString:url].location != NSNotFound && ![strUrl hasSuffix:@".jpg"]) {
                
                PushUrlCtl *urlCtl = [[PushUrlCtl alloc]init];
                [self.navigationController pushViewController:urlCtl animated:YES];
                NSString *href = [self getLinkUrl:[NSString stringWithFormat:@"%@",request.URL]];
                [urlCtl beginLoad:href exParam:href];
                
                break;
        
            }
        }

        return NO;
    }else{
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSMutableString *webStr = [MyCommon convertHtmlStyle:[NSString stringWithFormat:@"<body width=300px style=\"word-wrap:break-word; font-family:Arial\">%@", myDataModal_.content_]];
//    [webview_ loadHTMLString:webStr baseURL:nil];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    return;
    if (!hideTableView)
    {
        tableView_.alpha = 1.0;
        commentView.hidden = NO;
        [abnormalCtl.view removeFromSuperview];
        
        titleView.coverView.hidden = YES;
        backBtnFour.hidden = YES;
    }
    [activityView stopAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSString * emojImg = @"function imgAutoFit() {\
//    var nodes = document.getElementsByTagName('img');\
//    for(var i=0;i<nodes.length;i++){\
//    nodes[i].style.display = inline;\
//    nodes[i].style.vertical-align = bottom;}\
//    }";
//    [webView stringByEvaluatingJavaScriptFromString:emojImg];
//    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
//    
//    NSString * otherImg = @"function otherImgFit(){\
//    var nodes = document.getElementsByTagName('p');\
//    for(var i=0;i<nodes.length;i++){\
//    if(nodes[i].childNodes > 0){\
//        var pNodes = nodes[i].getElementsByTagName('img');\
//        for(var j = 0 ; j < pNodes.length ; j++){\
//            pNodes[j].style.display = block;\
//        }\
//      }\
//     }\
//    }";
//    [webView stringByEvaluatingJavaScriptFromString:otherImg];
//    [webView stringByEvaluatingJavaScriptFromString:@"otherImgFit()"];
//    
//    NSString *st = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('p')[0].getElementsByTagName('img').length"];
//    
//    NSString *all = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
//    NSLog(@"---------------------------%@  ------%@",st,all);
//
//    static  NSString * const jsGetImages =
//    @"function getImages(){\
//    var objs = document.getElementsByTagName(\"img\");\
//    var imgScr = '';\
//    for(var i=0;i<objs.length;i++){\
//    imgScr = imgScr + objs[i].src + '+';\
//    };\
//    return imgScr;\
//    };";
//    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
//    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
//    [webView stringByEvaluatingJavaScriptFromString:
//     [NSString stringWithFormat:@"var script = document.createElement('script');"   
//      "script.type = 'text/javascript';"   
//      "script.text = \"function ResizeImages() { "   
//      "var myimg,oldwidth;"  
//      "var maxwidth=%f;" //缩放系数   
//      "for(i=0;i <document.images.length;i++){"   
//      "myimg = document.images[i];"  
//      "if(myimg.width > maxwidth){"   
//      "oldwidth = myimg.width;"   
//      "myimg.width = maxwidth;"   
//      "myimg.height = (myimg.height * maxwidth)/(oldwidth*1.0);"   
//      "}"   
//      "}"   
//      "}\";"   
//      "document.getElementsByTagName('head')[0].appendChild(script);",ScreenWidth-32]];
//    
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 36];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
    height = height > 65? height : 65;
    
    CGRect rect = webview_.frame;
    rect.size.height = height;
    [webview_ setFrame:rect];
    
    CGRect frame = publishBtnCtl.frame;
    frame.origin.y = webview_.frame.size.height + webview_.frame.origin.y;
    frame.origin.x = 0;
    publishBtnCtl.frame = frame;
    
    CGRect rewardViewFrame = rewardView.frame;
    rewardViewFrame.origin.y = CGRectGetMaxY(webview_.frame) + (publishBtnCtl.showViewCtl?40:0);
    rewardView.frame = rewardViewFrame;
    
    rect = headView_.frame;
    rect.size.height = CGRectGetMaxY(rewardView.frame)+10;
    [headView_ setFrame:rect];
    
    tableView_.tableHeaderView = headView_;
    [tableView_ reloadData];
    [self adjustFooterViewFrame];

    [self updateLoadingCom:requestCon_];
    
    if (!hideTableView){
        tableView_.alpha = 1.0;
        commentView.hidden = NO;
        [abnormalCtl.view removeFromSuperview];
        titleView.coverView.hidden = YES;
        backBtnFour.hidden = YES;
    }
    [activityView stopAnimating];
    
    webViewLoadFinish = YES;
    [self firstSetTableViewContentOfSet];
}

#pragma mark - 文章内容和评论加载完成后判断是否滚动到评论
-(void)firstSetTableViewContentOfSet
{
    if (!webViewLoadFinish || !commentLoadFinish || requestCon_.dataArr_.count <= 0) {
        return;
    }
    if (bScrollToComment_&&!haveScroll_) {
        [self performSelector:@selector(setMycontentoffset) withObject:nil afterDelay:0.2];
        haveScroll_ = YES;
    }
}

#pragma mark - NoLoginDelegate
-(void)loginDelegateCtl{
    [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_ArticleRefresh;
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_Dasang:
        {
            [self btnResponse:rewardBtn];
        }
            break;
        case LoginType_ArticleRefresh:
        {
            hideTableView = NO;
            joinView.hidden = YES;
            tableView_.alpha = 0;
            headView_.alpha = 0.0;
            [activityView startAnimating];
            [self requestArticleDetail];
        }
            break;
        default:
            break;
    }
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type{
    switch ( type ) {
        case 11:
        {
            [super backBarBtnResponse:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - MJPhotoBrowserDelegate
-(void) photoBrowserHide:(MJPhotoBrowser *)photoBrowser{

}

#pragma mark - UIScrollViewDelegate
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == tableView_){
        [commentView hideCommentKeyBoardAndFace];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    if (backViewHeight < 15) {
        return;
    }
    if (scrollView == tableView_){
        [titleView scrollViewWithTitleView:scrollView withHeight:backViewHeight];
    }
}

#pragma mark - 打赏相关
- (void)goRewardListCtlclick:(UIButton *)sender{
    ELMyRewardRecordListCtl *ctl = [[ELMyRewardRecordListCtl alloc] init];
    ctl.personId = myDataModal_.person_detail.person_id;
    ctl.personImg = myDataModal_.person_detail.person_pic;
    [self.navigationController pushViewController:ctl animated:YES];
    [ctl beginLoad:nil exParam:nil];
}

//打赏成功动画
- (void)starAnimation{
    ELRewardLuckyBagAnimationCtl *luckyBagCtl = [[ELRewardLuckyBagAnimationCtl alloc] init];
    luckyBagCtl.view.frame = [UIScreen mainScreen].bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:luckyBagCtl.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:luckyBagCtl.view];
    [luckyBagCtl initBagView];
    [Manager shareMgr].isShowRewardAnimat = NO;
}

-(void)changeRewardViewHeight
{
    rewardView.clipsToBounds = YES;
    CGRect rewardViewFrame = rewardView.frame;
    rewardViewFrame.origin.y = CGRectGetMaxY(webview_.frame) + (publishBtnCtl.showViewCtl?40:0);
    
    if (rewardImgArr.count == 0) {
        imgBgView.hidden = YES;
        _rewardTipLb.hidden = NO;
    }else{
        _rewardTipLb.hidden = YES;
        imgBgView.hidden = NO;
        rewardViewFrame.size.height = 101;
        
        imgBgView.userInteractionEnabled = YES;
        [imgBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goRewardListCtlclick:)]];
        
        CGFloat imageX = (ScreenWidth - ((rewardImgArr.count*38)+rewardCount.frame.size.width))/2.0;
        
        for (NSInteger i = 0;i<5;i++) {
            UIImageView *imageView = (UIImageView *)[imgBgView viewWithTag:201+i];
            if (i < rewardImgArr.count){
                imageView.hidden = NO;
                CGRect frame = imageView.frame;
                frame.origin.x = imageX + 38*i;
                imageView.frame = frame;
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:rewardImgArr[i]] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"] options:SDWebImageAllowInvalidSSLCertificates];
            }else{
                imageView.hidden = YES;
            }
        }
        CGRect countLbF = rewardCount.frame;
        countLbF.origin.x = rewardImgArr.count*38 + imageX;
        rewardCount.frame = countLbF;
    }
    
    if (isMyPublishArticle){
        rewardBtn.hidden = YES;
        CGRect imgViewFrame = imgBgView.frame;
        imgViewFrame.origin.y = 8;
        imgBgView.frame = imgViewFrame;
        rewardViewFrame.size.height = 54;
    }
    if ((isMyPublishArticle && rewardImgArr.count == 0) || [myDataModal_.qi_id_isdefault isEqualToString:@"2"]){
        rewardViewFrame.size.height = 0;
    }
    rewardView.frame = rewardViewFrame;
    
    CGRect rect = headView_.frame;
    rect.size.height = CGRectGetMaxY(rewardView.frame)+10;
    [headView_ setFrame:rect];
    
    tableView_.tableHeaderView = headView_;
    
    [tableView_ reloadData];
    [self adjustFooterViewFrame];
}

#pragma mark - 点击事件
- (void)exceptionalAction:(UIButton *)btn
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
        
    }
    NSInteger tag = btn.tag - 111111;
    ELGroupCommentModel *dataModal = [requestCon_.dataArr_ objectAtIndex:tag];
    RewardAmountCtl *rewardAmountCtl = [[RewardAmountCtl alloc] init];
    rewardAmountCtl.personPic = dataModal.person_pic;
    rewardAmountCtl.personId = dataModal.personId;
    rewardAmountCtl.personName = dataModal.person_iname;
    rewardAmountCtl.productId = dataModal.id_;
    rewardAmountCtl.productType = @"40";
    [Manager shareMgr].dashangBackCtlIndex = self.navigationController.viewControllers.count-1;
    [self.navigationController pushViewController:rewardAmountCtl animated:YES];
}

-(void)viewSingleTap:(id)sender{
    [commentView hideCommentKeyBoardAndFace];
}

-(void)btnResponse:(id)sender{
    if(sender == rewardBtn){
        //记录友盟统计模块使用量
        NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"打赏文章", [self class]];
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
        
        if ([Manager shareMgr].haveLogin)
        {
            RewardAmountCtl *rewardAmountCtl = [[RewardAmountCtl alloc] init];
            rewardAmountCtl.personPic = myDataModal_.person_detail.person_pic;
            rewardAmountCtl.personId = myDataModal_.person_detail.person_id;
            rewardAmountCtl.personName = myDataModal_.person_detail.person_iname;
            rewardAmountCtl.productId = myDataModal_.id_;
            rewardAmountCtl.productType = @"10";
            [Manager shareMgr].dashangBackCtlIndex = self.navigationController.viewControllers.count-1;
            [self.navigationController pushViewController:rewardAmountCtl animated:YES];
        }
        else
        {
            [Manager shareMgr].registeType_ = FromMessage;
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
            [Manager shareMgr].showLoginBackBtn = YES;
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_Dasang;
            [NoLoginPromptCtl getNoLoginManager].noLoginDelegare = self;
        }
        refreshList = YES;
    }else if (joinGroupButton){
        if([joinGroupButton.titleLabel.text isEqualToString:@"马上登录"]){
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_ArticleRefresh;
        }else{
            if ([Manager shareMgr].haveLogin) {
                if (!joinCon) {
                    joinCon = [self getNewRequestCon:NO];
                }
                [joinCon joinGroup:[Manager getUserInfo].userId_ group:myDataModal_._group_info.group_id content:@" "];
            }else{
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            } 
        }
    }else{
        [super btnResponse:sender];
    }
}

- (IBAction)backBarBtnResponeTwo:(id)sender{
    [tableView_ setContentOffset:CGPointMake(0,0) animated:NO];
    [self backBarBtnResponse:sender];
}

-(void)backBarBtnResponse:(id)sender{
    [super backBarBtnResponse:sender];
}

-(void)setTableViewContentOffset{
    [tableView_ setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)setMycontentoffset{
    CGFloat height = tableView_.contentSize.height - (tableView_.tableHeaderView.frame.size.height + otherView.viewHeight - 40);
    CGFloat contentSetY = 0;
    if (height >= (ScreenHeight - 64)) {
        contentSetY = tableView_.tableHeaderView.frame.size.height + otherView.viewHeight - 40;
    }else{
        contentSetY = tableView_.contentSize.height-(ScreenHeight-64);
    }
    contentSetY = contentSetY>0 ? contentSetY:0;
    [tableView_ setContentOffset:CGPointMake(0,contentSetY) animated:NO];
}

-(void)addLikeSuccessRefresh{
    [BaseUIViewController showAutoDismissAlertView:nil msg:@"点赞成功" seconds:1.0];
    myDataModal_.like_cnt = [NSString stringWithFormat:@"%ld",(long)([myDataModal_.like_cnt integerValue]+1)];
    myDataModal_.isLike_ = YES;
    [Manager saveAddLikeWithAticleId:myDataModal_.id_];
    if (self.addCommentSuccessBlock) {
        self.addCommentSuccessBlock(YES,NO);
    }
}

-(void)refreshCommentSuccess{   
    [self refreshLoad:requestCon_];
}

-(void)keyBoardShow{
    //停止scrollview的滚动
    [tableView_ setContentOffset:tableView_.contentOffset animated:NO];
    [self addGesture];
}

-(void)addGesture{
    if (singleTapRecognizer_) {
        [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
        singleTapRecognizer_ = nil;
    }
    //添加点击事件
    singleTapRecognizer_ = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
}

-(void)removeGesture{
    [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
}

-(void)addKeyBoardNotification{
    [commentView addKeyBoardNotification];
}

-(void)removeKeyBoardNotification{
    [commentView removeKeyBoardNotification];
}

-(void)attentionSuccessRefresh:(BOOL)isSuccess{
    if (isSuccess) {
        myDataModal_.person_detail.rel = @"1";
    }
    else{
        myDataModal_.person_detail.rel = @"0";
    }
    [otherView attentionSuccessRefresh:isSuccess];
}

-(void)tableReloadData{
    [tableView_ reloadData];
    [self adjustFooterViewFrame];
}

#pragma mark - ELWebSocketManagerDelegate
- (ELWebSocketManager *)socketManager
{
    _socketManager = [ELWebSocketManager defaultManager];
    _socketManager.delegate = self;
    return _socketManager;
}

- (void)receiveNewsMsg:(NSNotification *)notifi
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [notifi.userInfo objectForKey:@"data"];
        NSString *topicId = [dic objectForKey:@"topic_id"];
        NSString *resultId = [dic objectForKey:@"result_id"];
        
        if ([resultId isKindOfClass:[NSString class]]) {
            if ([topicId isEqualToString:articleId]) {
                NSString *parentId = [dic objectForKey:@"parent_id"];
                if (!isAddNewMessage) {
                    [newMessageArr removeAllObjects];
                }
                
                if ([parentId isEqualToString:@""])
                {
                    ELGroupCommentModel *dataModal = [[ELGroupCommentModel alloc] init];
                    dataModal.comment_type = [dic objectForKey:@"comment_type"];
                    dataModal.comment_content_type = [dic objectForKey:@"comment_content_type"];
                    dataModal.pageCnt_ = requestCon_.pageInfo_.pageCnt_;
                    dataModal.totalCnt_ = requestCon_.pageInfo_.totalCnt_;
                    
                    if ([dataModal.comment_type isEqualToString:@"1"]
                        || [dataModal.comment_content_type isEqualToString:@"11"])
                    {
                        dataModal.id_ = [dic objectForKey:@"result_id"];
                        dataModal.article_id = [dic objectForKey:@"topic_id"];
                        if ([[dic objectForKey:@"qi_id_isdefault"] isEqualToString:@"2"]) {
                            dataModal.content = [dic objectForKey:@"article_content"];
                        }
                        else {
                            dataModal.content = [dic objectForKey:@"content"];
                        }
                        
                        dataModal.ctime = [MyCommon getDateWithMsecTime:[dic objectForKey:@"timestamp"]];
                        
                        dataModal.personId = [dic objectForKey:@"from_id"];
                        dataModal.person_pic = [dic objectForKey:@"avatar"];
                        dataModal.person_iname = [dic  objectForKey:@"username"];
                        dataModal.person_nickname = [dic  objectForKey:@"username"];
                        
                        NSString *tagId = [dic objectForKey:@"contentTag"];
                        dataModal.tagsList = [[NSMutableArray alloc] init];
                        for (ResumeCommentTag_DataModal *tagModel in _tagArray) {
                            if ([tagId isEqualToString:tagModel.tagId_]) {
                                [dataModal.tagsList addObject:tagModel];
                                break;
                            }
                        }
                        
                        [dataModal changeCellHeight];
                        [newMessageArr addObject:dataModal];
                        
                        if (!isAddNewMessage) {
                            isAddNewMessage = YES;
                            [self performSelector:@selector(addNewMessage) withObject:nil afterDelay:0.3];
                        }
                        
                        if ([dataModal.personId isEqualToString:[Manager getUserInfo].userId_]
                            && myDataModal_._group_info != nil)
                        {
                            [self setMycontentoffset];
                        }
                    }
                }
                else {
                    [self getMessageInfo:resultId];
                }
            }
        }
    });
}

//根据resultId获取评论信息 回复的消息
- (void)getMessageInfo:(NSString *)resultId
{
    NSString *bodyMsg = [NSString stringWithFormat:@"result_id=%@&type=group", resultId];
    NSString *op = @"comm_comment_busi";
    NSString *func = @"get_result_id_info";
    
    __weak typeof(self) weakSelf = self;
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSNull class]]
            || [dic isEqual:[NSNull null]]
            || dic.count == 0)
        {
            NSLog(@"get_result_id_info返回空");
            [weakSelf refreshLoad:nil];
        }
        
        if ([dic isKindOfClass:[NSDictionary class]])
        {
            ELGroupCommentModel *dataModal = [[ELGroupCommentModel alloc] init];
            dataModal.comment_type = [dic objectForKey:@"comment_type"];
            dataModal.comment_content_type = [dic objectForKey:@"comment_content_type"];
            dataModal.pageCnt_ = requestCon_.pageInfo_.pageCnt_;
            dataModal.totalCnt_ = requestCon_.pageInfo_.totalCnt_;
            
            if ([dataModal.comment_type isEqualToString:@"1"] || [dataModal.comment_content_type isEqualToString:@"11"])
            {
                dataModal.id_ = [dic objectForKey:@"id"];
                dataModal.article_id = [dic objectForKey:@"article_id"];
                dataModal.content = [dic objectForKey:@"content"];
                dataModal.ctime = [dic objectForKey:@"ctime"];
                
                dataModal.personId = [dic objectForKey:@"user_id"];
                dataModal.person_pic = [[dic objectForKey:@"person_detail"] objectForKey:@"person_pic"];
                dataModal.person_iname = [[dic objectForKey:@"person_detail"] objectForKey:@"person_iname"];
                dataModal.person_nickname = [[dic objectForKey:@"person_detail"] objectForKey:@"nickname"];
                
                NSString *tagStr = [dic objectForKey:@"tags"];
                if ([tagStr isKindOfClass:[NSString class]]) {
                    dataModal.tagsList = [[NSMutableArray alloc] init];
                    for (ResumeCommentTag_DataModal *tagModel in _tagArray) {
                        if ([tagStr isEqualToString:tagModel.tagId_]) {
                            [dataModal.tagsList addObject:tagModel];
                            break;
                        }
                    }
                }
                
                NSDictionary *parentDic = [dic objectForKey:@"_parent_info"];
                if ([parentDic isKindOfClass:[NSDictionary class]]) {
                    dataModal._parent_comment = [[ELGroupCommentModel alloc] init];
                    dataModal._parent_person_detail = [[ELGroupPersonModel alloc] init];
                    
                    dataModal._parent_person_detail.personId = [[parentDic objectForKey:@"person_detail"] objectForKey:@"personId"];
                    dataModal._parent_person_detail.person_iname = [[parentDic objectForKey:@"person_detail"] objectForKey:@"person_iname"];
                    dataModal._parent_person_detail.person_nickname = [[parentDic objectForKey:@"person_detail"] objectForKey:@"person_nickname"];
                    dataModal._parent_person_detail.person_pic = [[parentDic objectForKey:@"person_detail"] objectForKey:@"person_pic"];
                    dataModal._parent_comment.content = [[parentDic objectForKey:@"comment_info"] objectForKey:@"content"];
                }
                
                [dataModal changeCellHeight];
                [newMessageArr addObject:dataModal];
                
                if (!isAddNewMessage) {
                    isAddNewMessage = YES;
                    [self performSelector:@selector(addNewMessage) withObject:nil afterDelay:0.3];
                }
            }
        }

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)addNewMessage
{
    if (canAddNewMessage) {
        isAddNewMessage = NO;
        
        /**
         *计算总页数
         *每页20条
        */
        NSInteger pageCnt = requestCon_.pageInfo_.totalCnt_/20;
        //余数
        NSInteger remainder = requestCon_.pageInfo_.totalCnt_%20;
        if (remainder != 0) {
            pageCnt += 1;
        }
        
        if (requestCon_.pageInfo_.currentPage_ < pageCnt) {
            if (requestCon_.dataArr_.count >= 20) {
                for (NSInteger i = 0; i < newMessageArr.count; i++) {
                    [requestCon_.dataArr_ removeLastObject];
                }
            }
        }
        
        for (ELGroupCommentModel *model in newMessageArr) {
            [requestCon_.dataArr_ insertObject:model atIndex:0];
        }
        
        [tableView_ reloadData];
        [self adjustFooterViewFrame];
    }
}

- (void)chatManager:(ELWebSocketManager *)manager didSendMessage:(NSDictionary *)messageDic
{
    [commentView.giveCommentTv_ resignFirstResponder];
    commentView.giveCommentTv_.text = @"";
    commentView.tipsStr = @"我来说两句";
    commentView.tipsLb_.text = @"我来说两句";
    if (commentView.isReply) {
        commentView.isReply = NO;
        [commentView.pingLunBtn setTitle:@"评论" forState:UIControlStateNormal];
    }
}

- (void)requestResumeTag
{
    NSString *op = @"yl_tag_busi";
    NSString *func = @"getZpgroupResumeCommentTag";
    
    NSString *source = @"zp_group_all";
    NSString *bodyMsg = [NSString stringWithFormat:@"source=%@", source];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dict = result;
        NSArray *tagArr = [dict objectForKey:@"info"];
        if (![tagArr isKindOfClass:[NSNull class]]) {
            for (NSDictionary *tagDic in tagArr) {
                ResumeCommentTag_DataModal *model = [[ResumeCommentTag_DataModal alloc] init];
                model.tagId_ = [tagDic objectForKey:@"labelId"];
                model.tagName_ = [tagDic objectForKey:@"labelName"];
                [_tagArray addObject:model];
            }
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 回复相关
-(void)sendReplyMessageWithText:(NSString *)text tagId:(NSString *)tagId
{
    if (!replyCon) {
        replyCon = [self getNewRequestCon:NO];
    }
    [commentView.giveCommentTv_ resignFirstResponder];
    text = [MyCommon convertContent:text];
    if ([myDataModal_._group_source isEqualToString:@"3"] && [Manager shareMgr].haveLogin){
        if ([commentView getPersonNameNiMingStatus]) {
            [replyCon addComment:articleId parentId:selectDataModal_.id_ userId:myDataModal_._majia_info.personId content:text proID:@"" insider:[Manager getUserInfo].userId_];
        }else{
            [replyCon addComment:articleId parentId:selectDataModal_.id_ userId:[Manager getUserInfo].userId_ content:text proID:@"" insider:@""];
        }
    }
    else{
        if (myDataModal_._group_info != nil) {
            //webSocket
            if ([myDataModal_.qi_id_isdefault isEqualToString:@"2"]) {
                
                NSMutableDictionary *shareDic = [[NSMutableDictionary alloc] init];
                [shareDic setObject:@"11" forKey:@"type"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:@"" forKey:@"path"];
                [dic setObject:@"" forKey:@"url"];
                [dic setObject:articleId forKey:@"article_id"];
                [shareDic setObject:dic forKey:@"slave"];
                
                SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
                NSString *shareStr = [jsonWriter stringWithObject:shareDic];
                
                [[ELWebSocketManager defaultManager] sendMessage:text GroupModel:myDataModal_._group_info TopicId:articleId TagId:tagId QiId:myDataModal_.qi_id_isdefault ParentId:selectDataModal_.id_ CommentType:@"3" ContentType:@"11" share:shareStr];
  
            }
            else {
                [[ELWebSocketManager defaultManager] sendMessage:text GroupModel:myDataModal_._group_info TopicId:articleId TagId:tagId QiId:myDataModal_.qi_id_isdefault ParentId:selectDataModal_.id_ CommentType:@"1" ContentType:@"1" share:nil];
            }
        }
        else {
            [replyCon addComment:articleId parentId:selectDataModal_.id_ userId:[Manager getUserInfo].userId_ content:text proID:@""];
        }
    }
}

@end
