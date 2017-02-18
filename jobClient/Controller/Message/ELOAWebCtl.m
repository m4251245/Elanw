//
//  ELOAWebCtl.m
//  jobClient
//
//  Created by YL1001 on 16/5/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOAWebCtl.h"
#import "ELAddOAListCtl.h"

@interface ELOAWebCtl ()<AddOADelegate>
{
    IBOutlet UIButton *_moreBtn;
    IBOutlet UIImageView *_addImg;
    
    NSString *_url;
    AD_dataModal *_inModal;
    ELAddOAListCtl *_addOAListCtl;
    
    NSString *_loadUrl;
}
@end

@implementation ELOAWebCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];;
    
    if ([string containsString:@"login.php"] || ![Manager shareMgr].haveLogin) {
        myRightBarBtnItem_.hidden = YES;
    }
    else
    {
        myRightBarBtnItem_.hidden = NO;
    }
    
    self.closeBtn_.alpha = 1.0;
    self.webView_.scalesPageToFit = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavTitle:_inModal.title_];
}

-(void)updateCom:(RequestCon *)con
{
    if (_url) {
        NSURL * url = [NSURL URLWithString:_url];
        NSURLRequest * urlRequest= [[NSURLRequest alloc] initWithURL:url];
        [self.webView_ loadRequest:urlRequest];
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
    _inModal = dataModal;
    
    NSString *idStr;
    if ([Manager shareMgr].haveLogin) {
        idStr = [self encryptionId:[Manager getUserInfo].userId_];
        myRightBarBtnItem_.hidden = NO;
    }
    else
    {
        idStr = @"";
        myRightBarBtnItem_.hidden = YES;
    }
    
    if ([_inModal.url_ rangeOfString:@"?"].location != NSNotFound) {
        _url = [NSString stringWithFormat:@"%@&appflag=1002&person_id=%@",_inModal.url_,idStr];
    }else{
        _url = [NSString stringWithFormat:@"%@?appflag=1002&person_id=%@",_inModal.url_,idStr];
    }
    
//    self.navigationItem.title = _inModal.title_;
    [self setNavTitle:_inModal.title_];
    
    [self updateCom:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL];

    if (![urlStr containsString:@"3g.crm1001.com"] && ![urlStr containsString:@"m.job1001.com"]) {
        return NO;
    }
    
    _loadUrl = urlStr;
    
    if ([request.URL.relativeString rangeOfString:@"gotoapp=login"].location != NSNotFound) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_OA;
        return NO;
    }
    return YES;
}

#pragma mark - NoLogionDelegate
-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_OA:
        {
            NSString *idStr = [self encryptionId:[Manager getUserInfo].userId_];
            _url = [NSString stringWithFormat:@"%@&shcd=%@",_url,idStr];
            _url = [self changeLinkUrl:_url PersonId:[Manager getUserInfo].userId_];
            [self updateCom:nil];
        }
            break;
        default:
            break;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *isLogin;
    
    if ([_loadUrl containsString:@"login.php"] || ![Manager shareMgr].haveLogin) {
        myRightBarBtnItem_.hidden = YES;
        isLogin = @"login.php";
    }
    else
    {
        myRightBarBtnItem_.hidden = NO;
        isLogin = @"index.php";
    }

    [[NSUserDefaults standardUserDefaults] setObject:isLogin forKey:@"isLogin"];
}


- (IBAction)moreBtnClick:(id)sender {
    
    if (!_addOAListCtl) {
        _addOAListCtl = [[ELAddOAListCtl alloc] init];
        _addOAListCtl.addOADelegate = self;
        
    }
    [_addOAListCtl showViewCtl];
}


-(void)btnResponse:(id)sender
{
    if (sender == self.backBtn_) {
        if ([_loadUrl containsString:@"login.php"]) {
            _myBlock(YES);
            [super backBarBtnResponse:nil];
        }
        else if (self.webView_.canGoBack) {
    
            [self.webView_ goBack];
        }
        else
        {
            _myBlock(YES);
            [super backBarBtnResponse:nil];
        }
    }
    else if(sender == self.closeBtn_)
    {
        _myBlock(YES);
        [super backBarBtnResponse:nil];
    }
}


#pragma mark - AddOADelegate
- (void)hideOABtnView:(BOOL)hide
{
    if (hide) {
        [UIView animateWithDuration:0.3 animations:^{
            _addImg.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _addImg.transform = CGAffineTransformMakeRotation(-M_PI_4);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

- (void)btnResponeWithIndex:(NSInteger)index
{
    
//    我要请假 链接地址
//    http://3g.crm1001.com/index.php?mode=userleave&action=userleave&detail=index
//    
//    发送公文 链接地址
//    http://3g.crm1001.com/index.php?mode=message&action=message&detail=send&loadtype=send
    
    NSString * urlStr;
    switch (index) {
        case 100:
        {
            NSLog(@"请假");
            urlStr = @"http://3g.crm1001.com/index.php?mode=userleave&action=userleave&detail=index";
        }
            break;
        case 101:
        {
            NSLog(@"公文");
            urlStr = @"http://3g.crm1001.com/index.php?mode=message&action=message&detail=send&loadtype=send";
        }
            break;
        default:
            break;
    }
   
    NSString *idStr = [self encryptionId:[Manager getUserInfo].userId_];
    if([urlStr containsString:@"?"]){
        urlStr = [NSString stringWithFormat:@"%@&appflag=1002&person_id=%@",urlStr,idStr];
    }else{
        urlStr = [NSString stringWithFormat:@"%@?appflag=1002&person_id=%@",urlStr,idStr];
    }

    
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView_ loadRequest:urlRequest];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
