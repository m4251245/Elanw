//
//  ConsultantResumePreviewCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-11.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//  顾问简历搜索－－简历预览

#import "ConsultantResumePreviewCtl.h"
#import "MessageContact_DataModel.h"
#import "MessageDailogListCtl.h"
#import "ConsultantToRecomResumeCtl.h"
#import "ConsultantVisitorReplyList.h"
#import "TranspondResumeCtl.h"
#import "TheContactListCtl.h"

@interface ConsultantResumePreviewCtl ()<TranspondResumeCtlDelegate,ELShareManagerDelegate,UIActionSheetDelegate>
{
    RequestCon *callCon;
    RequestCon *loadResumeCon;
    RequestCon *loadCantactCon;
    UIWebView  *phoneCallWebView;
    RequestCon *getLastTelCon;
    NSString   *email;
    TranspondResumeCtl * transpondResumeCtl_;
    NSString *urlStr;
    
    ShareMessageModal *shareModal;  //分享给一览好友的Modal
    PersonCenterDataModel *personCenterModel_;
    NSString *shareUrl;
    BOOL isSecret;
    BOOL isDown;
    IBOutlet UIView *_rightBarView;
}
@end

@implementation ConsultantResumePreviewCtl


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
    [self setNavTitle:@"简历预览"];
    self.webView_.dataDetectorTypes = UIDataDetectorTypeNone;
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarView];
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpace, rightBtnItem, nil];
    
    [self changPopView];
    // Do any additional setup after loading the view from its nib.
}

-(void)updateCom:(RequestCon *)con
{
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inDataModal_ = dataModal;
    
    companyId_ = exParam;
    urlStr = nil;
    
    [super beginLoad:dataModal exParam:exParam];
    [self requestShareUrl];
    [self requestDownLoadStatus];
}

#pragma mark - 顾问我的人才库获取简历下载状态
-(void)requestDownLoadStatus{
    if (!_salerId || [_salerId isEqualToString:@""]) {
        return;
    }
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&sa_user_id=%@",inDataModal_.userId_,_salerId];
    NSString * function = @"judgeContact";
    NSString * op = @"app_jjr_api_busi";
    [ELRequest newPostbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *status = @"";
            NSDictionary *dic1 = dic[@"isDownload"];
            if ([dic1 isKindOfClass:[NSDictionary class]]) {
                status = dic1[@"status"];
            }
            if ([status isEqualToString:@"OK"]) {
                inDataModal_.isDown = @"1";
                inDataModal_.isCanContract = @"1";
                isDown = YES;
                [self changPopView];
            }else{
                isDown = NO;
            }
            
            status = @"";
            NSDictionary *dic2 = dic[@"isSecret"];
            if ([dic2 isKindOfClass:[NSDictionary class]]) {
                status = dic2[@"status"];
            }
            if ([status isEqualToString:@"OK"]) {
                isSecret = YES;
            }else{
                isSecret = NO;
            }
        }

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)requestShareUrl{
    NSString * bodyMsg = @"";
    if (inDataModal_.keyWorkStr == nil) {
        bodyMsg = [NSString stringWithFormat:@"person_id=%@&roletype=%@",inDataModal_.userId_,@"10"];
    }else{
        NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
        [conditionDic setObject:inDataModal_.keyWorkStr forKey:@"analyze"];
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
        bodyMsg = [NSString stringWithFormat:@"person_id=%@&roletype=%@&conditionArray=%@",inDataModal_.userId_,@"10",conditionStr];
    }
    NSString * function = @"getPreivewResumeUrl_offerpai";
    NSString * op   =   @"offerpai_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         NSString * url = [dic objectForKey:@"url"];
         shareUrl = url.length > 0 ? url:@"";
         
     }failure:^(NSURLSessionDataTask *operation, NSError *error){
         
     }];
}

- (void)changPopView
{
    if (!inDataModal_.isDown) {
        inDataModal_.isDown = @"0";
    }
    if (!inDataModal_.isCanContract) {
         inDataModal_.isCanContract = @"0";
    }
    
    if ([inDataModal_.isDown isEqualToString:@"0"])
    {//未下载
        loadResumeBtn.enabled = YES;
        [loadResumeBtn setImage:[UIImage imageNamed:@"download_white.png"] forState:UIControlStateNormal];
    }
    else
    {//已下载
        loadResumeBtn.enabled = NO;
        [loadResumeBtn setImage:[UIImage imageNamed:@"download_already.png"] forState:UIControlStateNormal];
    }
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:NO];
    }
    [con getResumeURL:inDataModal_.userId_ roletype:@"30" companyId:companyId_ analyze:inDataModal_.keyWorkStr];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ResumeURL:
        {
            urlStr = [dataArr objectAtIndex:0];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
            [self.webView_ loadRequest:urlRequest];
        }
            break;
        case Request_GuwenCallPerson:
        {
            Status_DataModal *model = dataArr[0];
            if ([model.status_ isEqualToString:@"FAIL"]) {
                [BaseUIViewController showAutoDismissFailView:@"" msg:model.des_ seconds:1.0];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ConsultantFreshCount" object:nil];
                inDataModal_.isDown = @"1";
                [self changPopView];
                [BaseUIViewController showAutoDismissSucessView:@"" msg:@"拨号成功" seconds:1.0];
            }
        }
            break;
//        case Request_GunwenLoadResume:
//        {
//            Status_DataModal *model = dataArr[0];
//            if ([model.status_ isEqualToString:@"OK"]) {
//                [BaseUIViewController showAutoDismissSucessView:@"" msg:model.des_ seconds:1.0];
//                inDataModal_.isDown = @"1";
//                [self changPopView];
//                //简历下载成功回调
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ConsultantFreshCount" object:nil];
//                [_delegate loadRcResumeSuccess];
//            }else{
//                [BaseUIViewController showAutoDismissFailView:@"" msg:model.des_ seconds:1.0];
//            }
//        }
//            break;
        case Request_GunwenLoadConstanct:
        {
            Status_DataModal *model = dataArr[0];
            if ([model.status_ isEqualToString:@"OK"]) {
                inDataModal_.isCanContract = @"1";
                inDataModal_.isDown = @"1";
                [self requestShareUrl];
                [self requestDownLoadStatus];
                [self changPopView];
                [self.webView_ reload];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ConsultantFreshCount" object:nil];
            }
            [BaseUIViewController showAutoDismissSucessView:nil msg:model.des_];
        }
            break;
        case Request_getLastTelTime:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            [BaseUIViewController showAutoDismissSucessView:@"" msg:@"" seconds:1.0];
            if ([model.status_ isEqualToString:@"OK"]) {
                if ([[Manager getHrInfo].userType isEqualToString:@"0"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"是否调用内部电话拨打?\n%@",model.exObj_] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 1000;
                    [alert show];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"是否拨打电话给人才?\n%@",model.exObj_] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 2000;
                    [alert show];
                }
            }else{
                if ([[Manager getHrInfo].userType isEqualToString:@"0"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否调用内部电话拨打?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 1000;
                    [alert show];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否拨打电话给人才?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 2000;
                    [alert show];
                }
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - 按钮点击事件
-(void)btnResponse:(id)sender
{
    if (sender == selfBackBtn_)
    {
        [self backBarBtnResponse:nil];
    }
    else if (sender == moreBtn_)
    {//推荐
        if (!isDown) {
            [BaseUIViewController showAlertViewContent:@"请下载后再推荐!" toView:nil second:1.5 animated:YES];
            return;
        }
        if (!isSecret) {
            [BaseUIViewController showAlertViewContent:@"该人才设置了保密，近期内若无沟通记录将无法进行推荐" toView:nil second:1.5 animated:YES];
            return;
        }
        ConsultantToRecomResumeCtl *consultantToRecomResumeCtl = [[ConsultantToRecomResumeCtl alloc] init];
        consultantToRecomResumeCtl.inModel = inDataModal_;
        consultantToRecomResumeCtl.salerId = _salerId;
        [self.navigationController pushViewController:consultantToRecomResumeCtl animated:YES];
    }
    else if (sender == sendinterviewBtn_)
    {//联系他
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"电话联系", @"私信联系", nil];
        [actionSheet showInView:self.view];
    }else if (sender == recordButton)
    {//回访记录
        ConsultantVisitorReplyList *replayList = [[ConsultantVisitorReplyList alloc] init];
        [replayList beginLoad:inDataModal_ exParam:nil];
        [self.navigationController pushViewController:replayList animated:YES];
    }
    else if (sender == zhuanfajianliBtn)
    {//顾问转发简历
        NSURL *imgUrl = [NSURL URLWithString:inDataModal_.img_];
        NSData *data = [NSData dataWithContentsOfURL:imgUrl];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString * sharecontent = [NSString stringWithFormat:@"%@的微简历",inDataModal_.name_];
        
        NSString * titlecontent = @"微简历";
        
        NSString * url = [NSString stringWithFormat:@"%@&mobile=share",urlStr];
        NSError *error = NULL;
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"role_id=\\d+" options:NSRegularExpressionCaseInsensitive error:&error];
        NSRange range = NSMakeRange(0, urlStr.length);
        NSTextCheckingResult *reuslt = [regularExpression firstMatchInString:urlStr options:0 range:range];
        NSString *sharedUrl = [urlStr copy];
        if (reuslt) {
            sharedUrl = [sharedUrl stringByReplacingCharactersInRange:reuslt.range withString:@"role_id="];
        }
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
    }
    else if (sender == loadResumeBtn)
    {
//        if (!loadResumeCon) {
//            loadResumeCon = [self getNewRequestCon:NO];
//        }
//        [loadResumeCon gunwenLoadResume:[Manager getHrInfo].userName rencaiId:inDataModal_.userId_];
        
        if (!loadCantactCon) {
            loadCantactCon =  [self getNewRequestCon:NO];
        }
        [loadCantactCon gunwenLoadConstanct:[Manager getHrInfo].userName rencaiId:inDataModal_.userId_];
    }
}

#pragma mark - 代理
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {//电话联系
            if (!getLastTelCon) {
                getLastTelCon = [self getNewRequestCon:NO];
            }
            [getLastTelCon getLastTelTime:inDataModal_.userId_];

        }
            break;
        case 1:
        {//私信联系
            MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
            MessageContact_DataModel *model = [[MessageContact_DataModel alloc] init];
            model.boolHrFlag = YES;
            ctl.isHr = YES;
            ctl.refreshGuwenCountFlag = YES;
            model.userId = inDataModal_.userId_;
            model.userIname = inDataModal_.name_;
            [ctl beginLoad:model exParam:nil];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000)
    {
        if (buttonIndex == 1) {
            if (!callCon) {
                callCon = [self getNewRequestCon:NO];
            }
            [callCon guwenCallPerson:[Manager getHrInfo].userName personId:[Manager getUserInfo].userId_ personMmobile:inDataModal_.mobile_];
        }
    }
    else if (alertView.tag == 2000)
    {
        if (buttonIndex == 1) {
            if ([inDataModal_.isCanContract isEqualToString:@"1"]) {
                Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
                if (messageClass != nil) {
                    if ([messageClass canSendText]) {
                        //不停留在打电话页面
                        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",inDataModal_.mobile_]];
                        if ( !phoneCallWebView ) {
                            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
                        }
                        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
                    }else {
                        [BaseUIViewController showAlertView:@"设备没有电话功能" msg:nil btnTitle:@"知道了"];
                    }
                }
            }else{
                [BaseUIViewController showAlertView:@"" msg:@"请下载人才联系方式" btnTitle:@"知道了"];
            }
        }
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    sendinterviewBtn_.enabled = YES;
    moreBtn_.enabled = YES;
}

#pragma mark - TranspondResumeCtlDelegate
-(void)backView
{
    [self btnResponse:zhuanfajianliBtn];
}

-(void)removeView
{
    [transpondResumeCtl_.view removeFromSuperview];
}

#pragma mark 分享到一览好友
-(void)shareYLFriendBtn
{
    TheContactListCtl *contact = [[TheContactListCtl alloc] init];
    contact.isPushShareCtl = YES;
    shareModal.shareType = @"25";
    shareModal.shareContent = @"简历";
    contact.isPersonChat = YES;
    contact.shareDataModal = shareModal;
    [self.navigationController pushViewController:contact animated:YES];
    [contact beginLoad:nil exParam:nil];
}

#pragma mark 复制链接
-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
   // NSString * url = [NSString stringWithFormat:@"%@&mobile=share",urlStr];
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"role_id=\\d+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange range = NSMakeRange(0, urlStr.length);
    NSTextCheckingResult *reuslt = [regularExpression firstMatchInString:urlStr options:0 range:range];
    NSString *sharedUrl = [urlStr copy];
    if (reuslt) {
        sharedUrl = [sharedUrl stringByReplacingCharactersInRange:reuslt.range withString:@"role_id="];
    }
    pasteboard.string = sharedUrl;
    if(sharedUrl.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

-(void)emailShare
{
    transpondResumeCtl_ = [[TranspondResumeCtl alloc] init];
    transpondResumeCtl_.isGUWEN = YES;
    transpondResumeCtl_.delegate_ = self;
    transpondResumeCtl_.url_ = shareUrl;
    
    [transpondResumeCtl_ beginLoad:inDataModal_ exParam:companyId_];
    [transpondResumeCtl_.view setFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:transpondResumeCtl_.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
