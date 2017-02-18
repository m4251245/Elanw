//
//  ResumePreviewController.m
//  Association
//
//  Created by 一览iOS on 14-6-26.
//  Copyright (c) 2014年 job1001. All rights reserved.
//  个人的简历预览

#import "ResumePreviewController.h"
#import "TheContactListCtl.h"
#import "TranspondResumeCtl.h"
#import "MessageContact_DataModel.h"
//#import "MessageDailogListCtl.h"

@interface ResumePreviewController () <TranspondResumeCtlDelegate,ELShareManagerDelegate>
{
    __weak IBOutlet UIView *messageVIew;
    
    __weak IBOutlet UIButton *sendMessageBtn;
    __weak IBOutlet UIButton *zhuanFaBtn;
    
    ShareMessageModal *shareModal;
    ShareMessageModal *dataModal_;
    
    TranspondResumeCtl *_transpondResumeCtl;
    User_DataModal     *_inModal;
}
@end

@implementation ResumePreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rightNavBarStr_ = @"分享";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"简历预览";
    [self setNavTitle:@"简历预览"];
    webView_.dataDetectorTypes = UIDataDetectorTypeNone;
    webView_.scalesPageToFit = YES;
    webView_.delegate = self;
    // Do any additional setup after loading the view from its nib.
    
    CGRect frame = webView_.frame;
    if (_showTranspontResumeBtn)
    {
        messageVIew.hidden = NO;
        frame.size.height = [UIScreen mainScreen].bounds.size.height - 64 - 40;
    }
    else
    {
        messageVIew.hidden = YES;
        frame.size.height = [UIScreen mainScreen].bounds.size.height - 64;
    }
    webView_.frame = frame;
    
    if ([dataModal_.personId isEqualToString:[Manager getUserInfo].userId_] || dataModal_ == nil)
    {
        rightBarBtn_.hidden = NO;
    }
    else
    {
        rightBarBtn_.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//     [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.navigationItem.title = @"简历预览";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

-(void)btnResponse:(id)sender
{
    if (sender == sendMessageBtn)
    {
        MessageContact_DataModel *model = [[MessageContact_DataModel alloc]init];
        model.userId = dataModal_.personId;
        model.userIname = dataModal_.personName;
        model.pic = dataModal_.person_pic;
        model.gzNum = dataModal_.person_gznum;
        model.userZW = dataModal_.person_zw;
        
        
        MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
        [ctl beginLoad:model exParam:nil];
        [self.navigationController pushViewController:ctl animated:YES];

    }
    else if (sender == zhuanFaBtn)
    {
//        [self shareYLFriendBtn];
        
        [self rightBarBtnResponse:nil];
    }
}

//设置右按扭的属性
-(void) setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if( [rightNavBarStr_ length] >= 4 ){
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    }else
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    
    rightBarBtn_.titleLabel.font = [UIFont boldSystemFontOfSize:13];//[UIFont boldSystemFontOfSize:14];
    [rightBarBtn_ setImage:[UIImage imageNamed:@"share_white-2"] forState:UIControlStateNormal];
}

-(void)rightBarBtnResponse:(id)sender
{
    NSString *imagePath = shareModal.person_pic; //[Manager getUserInfo].img_;
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    NSString * sharecontent = [NSString stringWithFormat:@"%@的简历",shareModal.personName];
    NSString * titlecontent = @"微简历";
    
    //调用分享
    
    NSString *url = [NSString stringWithFormat:@"%@",resumePath_];
    if ([Manager shareMgr].haveLogin) {
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeOne];
        [[ShareManger sharedManager] setShareDelegare:self];
    }
    else
    {
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
    }
}

#pragma mark - 分享到一览好友
-(void)shareYLFriendBtn
{
    TheContactListCtl *contact = [[TheContactListCtl alloc] init];
    contact.isPersonChat = YES;
    contact.isPushShareCtl = YES;
    shareModal.shareType = @"25";
    shareModal.shareContent = @"简历";
    contact.shareDataModal = shareModal;
    [self.navigationController pushViewController:contact animated:YES];
    [contact beginLoad:nil exParam:nil];
}

#pragma mark - 复制链接
-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * url = [NSString stringWithFormat:@"%@",resumePath_];
    pasteboard.string = url;
    if(url.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

#pragma TranspondResumeCtlDelegate
-(void)removeView
{
    [_transpondResumeCtl.view removeFromSuperview];
}

#pragma mark - 返回按钮
-(void)backView
{
    [self btnResponse:zhuanFaBtn];
}


- (void)backBarBtnResponse:(id)sender
{
    if (self.block) {
        self.block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if( resumePath_ ){
        NSString * str = [NSString stringWithString:resumePath_];
        NSURL *path = [[NSURL alloc] initWithString:str];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:path];
        [webView_ loadRequest:request];
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:nil];
    dataModal_ = dataModal;
    
    
    if (dataModal_ && dataModal_.personId.length > 0)
    {
        if([dataModal_.personId isEqualToString:[Manager getUserInfo].userId_])
        {
            _showTranspontResumeBtn = NO;
        }
        [self loadResumeInfomation:dataModal_.personId];
    }
    else
    {
        [self loadResumeInfomation:[Manager getUserInfo].userId_];
        _showTranspontResumeBtn = NO;
    }
}

-(void)loadResumeInfomation:(NSString *)userId
{
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"getPersonInfo" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
    {
        NSDictionary *dic = result;
        shareModal = [[ShareMessageModal alloc] init];
        shareModal.personId = dic[@"person_id"];
        shareModal.personName = dic[@"person_iname"];
        shareModal.person_pic = dic[@"person_pic"];
        shareModal.person_gznum = dic[@"person_gznum"];
        shareModal.person_edu = dic[@"person_edu"];
        shareModal.person_zw = dic[@"person_zw"];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)getDataFunction:(RequestCon *)con
{
    RequestCon  *urlCon = [self getNewRequestCon:NO];
    
    NSString *userId = @"";
    if (dataModal_ && dataModal_.personId.length > 0) {
        userId = dataModal_.personId;
    }
    else
    {
        userId = [Manager getUserInfo].userId_;
    }
    NSString *companyId = @"";
    if (_formMessage){
        if ([userId isEqualToString:[Manager getUserInfo].userId_]) {
           companyId = [Manager getUserInfo].userId_; 
        }        
    }else{
        companyId = userId;
    }
    [urlCon getResumeURL:userId roletype:@"10" companyId:companyId analyze:nil];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ResumeURL:
        {
            resumePath_ = [dataArr objectAtIndex:0];
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (!activity_) {
        activity_ = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity_ setColor:[UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0]];
        activity_.hidesWhenStopped = YES;
    }
    [activity_ startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activity_ stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [BaseUIViewController showAutoDismissFailView:@"加载失败" msg:nil];
    [activity_ stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    switch ( navigationType ) {
        case UIWebViewNavigationTypeLinkClicked:
            return NO;
            break;
            
        default:
            break;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
