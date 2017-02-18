//
//  ResumePreviewCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-11.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//  企业端简历搜索－－简历预览

#import "RecommendResumePreviewCtl.h"
#import "TheContactListCtl.h"

@interface RecommendResumePreviewCtl () <ELShareManagerDelegate>
{
    NSString * url_;
    BOOL       pop1_;
    BOOL       pop2_;
    BOOL       _isInterview;//是否能够面试
    UIWebView * phoneCallWebView;
    RequestCon *_isLookPersonCantactCon;//是否能够面试
    RequestCon *_downloadResumeCon;//下载简历
    
    ShareMessageModal *shareModal;  //分享给一览好友的Modal
    PersonCenterDataModel *personCenterModel_;
}
@end

@implementation RecommendResumePreviewCtl
@synthesize hideBottomView_,delegate_;

#pragma mark - lifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
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
//    self.navigationItem.title = @"简历预览";
    [self setNavTitle:@"简历预览"];
    self.webView_.dataDetectorTypes = UIDataDetectorTypeNone;
    _bottomView0.frame = CGRectMake(0, self.view.frame.size.height-ToolBarHeight, self.view.bounds.size.width, ToolBarHeight);
    [self.view addSubview:_bottomView0];
        
    popView1_.alpha = 0.0;
    popView2_.alpha = 0.0;
    if (hideBottomView_) {
        bottomView_.alpha = 0.0;
        CGRect rect = self.webView_.frame;
        rect.size.height = rect.size.height + 49;
        self.webView_.frame = rect;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    if ( url_ ) {
        NSURL * url = [NSURL URLWithString:url_];
        NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [self.webView_ loadRequest:urlRequest];
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inDataModal_ = dataModal;
    companyId_ = exParam;
    url_ = nil;
    [super beginLoad:dataModal exParam:exParam];
    
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!_isLookPersonCantactCon) {
        _isLookPersonCantactCon = [self getNewRequestCon:NO];
    }
    [_isLookPersonCantactCon companyIslookPersonContact:companyId_ userId:inDataModal_.userId_];
    [con getResumeURL:inDataModal_.userId_ roletype:@"20" companyId:companyId_ analyze:inDataModal_.keyWorkStr];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ResumeURL:
        {
            url_ = [dataArr objectAtIndex:0];
        }
            break;
         case Request_SetResumePass:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissAlertView:@"处理成功" msg:@"" seconds:2.0];
                
            }
            else
            {
                [BaseUIViewController showAutoDismissAlertView:dataModal.des_ msg:@"" seconds:2.0];
            }

        }
            break;
        case Request_CollectResume:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissAlertView:@"暂存成功!\n此简历已被归档至暂存列表" msg:@"" seconds:2.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectResumeSuccess" object:nil];
            }
            else
            {
                [BaseUIViewController showAutoDismissAlertView:dataModal.des_ msg:@"" seconds:2.0];//后台改
            }
        }
            break;
        case Request_CompanyIslookPersonContact://是否能查看联系方式
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                
                [bottomView_ setHidden:NO];
                [_bottomView0 setHidden:YES];
                _isInterview = YES;
                
            }else{
                _isInterview = NO;
                [_bottomView0 setHidden:NO];
                [bottomView_ setHidden:YES];
                
            }
        }
            break;
        case Request_DownloadResume:// 下载简历
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            NSString *leftgjcnt = dataModal.leftgjcnt;
            NSString *leftptcnt = dataModal.leftptcnt;
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                _isInterview = YES;
                
                [bottomView_ setHidden:NO];
                [_bottomView0 setHidden:YES];
                //_resumeLb.text = @"面试通知";
                [delegate_ downloadResume:inDataModal_];
                [self.webView_ reload];
                
                NSString *msg = [NSString stringWithFormat:@"下载成功！\n此简历已被归类至已下载列表\n剩余简历下载数:普通%@ 高级%@",leftptcnt,leftgjcnt];//后台改
                [BaseUIViewController showAlertView:@"提示" msg:msg btnTitle:@"确定"];
                
            }else{
                [_bottomView0 setHidden:NO];
                [bottomView_ setHidden:YES];
                [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_ seconds:2.0];
            }
        }
            break;
        default:
            break;
    }
    
}

- (IBAction)buttonClick:(id)sender {//未下载条件下

    if (sender == _transmit0Btn) {//转发简历
        if (inDataModal_.company_ == nil || ![inDataModal_.company_ isKindOfClass:[NSString class]]) {
            inDataModal_.company_ = @"";
        }
        
        NSString *imagePath = inDataModal_.img_; //[Manager getUserInfo].img_;
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
        
        NSString * sharecontent = [NSString stringWithFormat:@"%@的微简历",inDataModal_.name_];
        
        NSString * titlecontent = @"微简历";
        
        NSString * url = url_;
        //调用分享
        
        if ([Manager shareMgr].haveLogin) {
            [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeFour];
            [[ShareManger sharedManager] setShareDelegare:self];
        }
        else
        {
            [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
        }
        
        if (!shareModal) {
            shareModal = [[ShareMessageModal alloc] init];
        }
        shareModal.personId = inDataModal_.userId_;
        shareModal.personName = inDataModal_.name_;
        shareModal.person_pic = inDataModal_.img_;
        shareModal.person_zw = inDataModal_.job_;
        if (!shareModal.personName) {
            shareModal.personName = @"";
        }
        if (!shareModal.person_pic) {
            shareModal.person_pic = @"";
        }
        if (shareModal.person_zw.length == 0)
        {
            shareModal.person_zw = @"";
        }

    }else if (sender == _storeBtn){//暂存简历

        if(!collectCon_)
        {
            collectCon_ = [self getNewRequestCon:NO];
        }
        [collectCon_ collectResume:companyId_ personId:inDataModal_.userId_];

    }else if (sender == _downLoadBtn){
        if (!_isInterview) {//下载简历
            [self showChooseAlertView:2 title:nil msg:@"你是否确认下载查看简历联系方式，下载成功后将扣除相应的下载数" okBtnTitle:@"下载" cancelBtnTitle:@"取消"];
            return;
        }
        pop1_ = !pop1_;
        if (pop1_) {
            popView1_.alpha = 1.0;
        }
        else
            popView1_.alpha = 0.0;
        if (pop2_) {
            pop2_ = NO;
            popView2_.alpha = 0.0;
        }
        return;

    }

    if (pop1_) {
        pop1_ = NO;
        popView1_.alpha = 0.0;
    }
    if (pop2_) {
        pop2_ = NO;
        popView2_.alpha = 0.0;
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
    NSString * url = [NSString stringWithFormat:@"%@&mobile=share",url_];
    pasteboard.string = url;
    if(url.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

#pragma mark -邮件分享
-(void)emailShare
{
    transpondResumeCtl_ = [[TranspondResumeCtl alloc] init];
    transpondResumeCtl_.delegate_ = self;
    transpondResumeCtl_.url_ = url_;
    transpondResumeCtl_.resumeType = 0;//招聘顾问简历预览
    
    [transpondResumeCtl_ beginLoad:inDataModal_ exParam:companyId_];
    [transpondResumeCtl_.view setFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:transpondResumeCtl_.view];

}

//下载完条件下
-(void)btnResponse:(id)sender
{
    if (sender == sendinterviewBtn_){
        if (!_isInterview) {//下载简历
            [self showChooseAlertView:2 title:nil msg:@"您是否确认下载查看简历联系方式，下载成功后将扣除相应的下载数" okBtnTitle:@"下载" cancelBtnTitle:@"取消"];
            return;
        }
        pop1_ = !pop1_;
        if (pop1_) {
            popView1_.alpha = 1.0;
        }
        else
            popView1_.alpha = 0.0;
        if (pop2_) {
            pop2_ = NO;
            popView2_.alpha = 0.0;
        }
        return;
        
    }
    
    if (pop1_) {
        pop1_ = NO;
        popView1_.alpha = 0.0;
    }
    if (pop2_) {
        pop2_ = NO;
        popView2_.alpha = 0.0;
    }

    if(sender == _transmitBtn){//企业转发简历
     
        if (inDataModal_.company_ == nil || ![inDataModal_.company_ isKindOfClass:[NSString class]]) {
            inDataModal_.company_ = @"";
        }
        
        NSURL *imgUrl = [NSURL URLWithString:inDataModal_.img_];
        NSData *data = [NSData dataWithContentsOfURL:imgUrl];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString * sharecontent = [NSString stringWithFormat:@"%@的微简历",inDataModal_.name_];
        
        NSString * titlecontent = @"微简历";
        
        NSString * url = [NSString stringWithFormat:@"%@&mobile=share",url_];
        NSError *error = NULL;
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"role_id=\\d+" options:NSRegularExpressionCaseInsensitive error:&error];
        NSRange range = NSMakeRange(0, url.length);
        NSTextCheckingResult *reuslt = [regularExpression firstMatchInString:url options:0 range:range];
        NSString *sharedUrl = [url copy];
        if (reuslt) {
            sharedUrl = [sharedUrl stringByReplacingCharactersInRange:reuslt.range withString:@"role_id="];
        }
        //调用分享
        
        if ([Manager shareMgr].haveLogin) {
            [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:sharedUrl shareType:ShareTypeFour];
            [[ShareManger sharedManager] setShareDelegare:self];
        }
        else
        {
            [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:sharedUrl];
        }
        
        if (!shareModal) {
            shareModal = [[ShareMessageModal alloc] init];
        }
        shareModal.personId = inDataModal_.userId_;
        shareModal.personName = inDataModal_.name_;
        shareModal.person_pic = inDataModal_.img_;
        shareModal.person_zw = inDataModal_.job_;
        if (!shareModal.personName) {
            shareModal.personName = @"";
        }
        if (!shareModal.person_pic) {
            shareModal.person_pic = @"";
        }
        if (shareModal.person_zw.length == 0)
        {
            shareModal.person_zw = @"";
        }
    }
    else if (sender == emailBtn_){
        SendInterviewCtl * sendInterviewCtl = [[SendInterviewCtl alloc] init];
        sendInterviewCtl.type_ = Interview_Emial;
        sendInterviewCtl.operationType = OperationTypeInterview;
        [self.navigationController pushViewController:sendInterviewCtl animated:YES];
        [sendInterviewCtl beginLoad:inDataModal_ exParam:nil];
    }
    else if (sender == msgBtn_){
        SendInterviewCtl * sendInterviewCtl = [[SendInterviewCtl alloc] init];
        sendInterviewCtl.type_ = Interview_SMS;
        sendInterviewCtl.operationType = OperationTypeInterview;
        [self.navigationController pushViewController:sendInterviewCtl animated:YES];
        [sendInterviewCtl beginLoad:inDataModal_ exParam:nil];
    }
    else if (sender == callBtn_)
    {
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass != nil) {
            if ([messageClass canSendText]) {
                //不停留在打电话页面
                NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",inDataModal_.mobile_]];
                if ( !phoneCallWebView ) {
                    phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
                }
                [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
            }
            else {
                [BaseUIViewController showAlertView:@"设备没有电话功能" msg:nil btnTitle:@"知道了"];
            }
        }
        
    }
    else if(sender == collectBtn_)
    {
        if(!collectCon_)
        {
            collectCon_ = [self getNewRequestCon:NO];
        }
        [collectCon_ collectResume:companyId_ personId:inDataModal_.userId_];
    }
    else
        [super btnResponse:sender];
    
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [super alertViewChoosed:alertView index:index type:type];
    switch (type) {
        case 1:
        {
            if (!rejectCon_) {
                rejectCon_ = [self getNewRequestCon:NO];
            }
            [rejectCon_ setResumePass:inDataModal_.emailId_ isPass:@"1" crnd:[Manager getUserInfo].companyModal_.crnd_];
        }
            break;
        case 2:
        {
            if (!_downloadResumeCon) {
                _downloadResumeCon = [self getNewRequestCon:NO];
            }
            [_downloadResumeCon downloadResume:companyId_ userId:inDataModal_.userId_];
        }
            break;
        default:
            break;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    sendinterviewBtn_.enabled = YES;
    zhuanfaBtn_.enabled = YES;
    collectBtn_.enabled = YES;
}


#pragma TranspondResumeCtlDelegate
-(void)removeView
{
    [transpondResumeCtl_.view removeFromSuperview];
}

#pragma mark - 返回按钮
-(void)backView
{
    [self buttonClick:_transmit0Btn];
}
@end
