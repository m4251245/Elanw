//
//  ResumePreviewCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-11.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//  顾问端offer派

#import "OfferResumePreviewCtl.h"
//#import "MessageDailogListCtl.h"
#import "OfferToRecomResumeCtl.h"
#import "OfferrRecomDetail.h"
#import "YLMediaModal.h"
#import "YLArticleAttachmentCtl.h"
#import "ConsultantVisitorReplyList.h"
#import "TheContactListCtl.h"
#import "ELEmailTranspondCtl.h"

@interface OfferResumePreviewCtl ()<UIActionSheetDelegate,ELShareManagerDelegate>
{
    NSString * _urlStr;
    NSString * fujianUrl;
    NSString * pages;
    UIWebView * phoneCallWebView;
    BOOL       _isInterview;//是否能够面试
    RequestCon      *statusCon;
    RequestCon      *loadCantactCon;
    RequestCon      *loadResumeCon;
    RequestCon      *callCon;
    RequestCon      *fujianCon;
    RequestCon      *getLastTelCon;
    
    IBOutlet UIView *_rightBarView;
    NSString    *_email;
    RequestCon *_getEmailCon;
    
    __weak IBOutlet UIButton *_transpondBtn;
    ShareMessageModal *shareModal;  //分享给一览好友的Modal
}
@end

@implementation OfferResumePreviewCtl
@synthesize delegate_,bRecommended_;

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"简历预览";
    self.webView_.dataDetectorTypes = UIDataDetectorTypeNone;
    
    _optionView1.frame = CGRectMake(0, 0,ScreenWidth/3.0, _optionView1.frame.size.height);
    _optionView2.frame = CGRectMake(ScreenWidth/3.0, 0,ScreenWidth/3.0, _optionView2.frame.size.height);
    _optionView3.frame = CGRectMake((ScreenWidth/3.0)*2, 0, ScreenWidth/3.0, _optionView3.frame.size.height);
    
    //offer派
//    if (_resumeListType >= 0) {
        [self layoutOfferPartyMenu:_resumeListType];
//    }
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarView];
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpace, rightBtnItem, nil];
    
    [self changPopView];
}

#pragma mark - 初始化数据
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inDataModal_ = dataModal;
    companyId_ = exParam;
    _urlStr = nil;
    if (!bRecommended_) {
        _isInterview = YES;
    }
    [super beginLoad:dataModal exParam:exParam];
    
}

-(void)getDataFunction:(RequestCon *)con
{
    if (_isRecommend) {//推荐报告URL
        [con getRecReportURL:inDataModal_.userId_ roletype:@"30" companyId:[Manager getHrInfo].salerId tjtype:inDataModal_.jlType tjid:inDataModal_.recommendId];
        return;
    }
    //offer派简历URL和附件URL
    [con getResumeURL:inDataModal_.userId_ roletype:@"30" companyId:[Manager getHrInfo].salerId analyze:inDataModal_.keyWorkStr];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_getLastTelTime:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                if ([[Manager getHrInfo].userType isEqualToString:@"0"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"是否调用内部电话拨打?\n%@",model.exObj_] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 1000;
                    [alert show];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"是否拨打电话给人才?\n%@",model.exObj_] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 2000;
                    [alert show];
                }
            }
            else{
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
//                inDataModal_.isDown = @"1";
//                [self changPopView];
//                [BaseUIViewController showAutoDismissSucessView:@"" msg:model.des_ seconds:1.0];
//                inDataModal_.isDown = @"1";
//                //简历下载成功回调
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ConsultantFreshCount" object:nil];
//            }
//            else{
//                [BaseUIViewController showAutoDismissFailView:@"" msg:model.des_ seconds:1.0];
//            }
//        }
//            break;
        case Request_GunwenLoadConstanct:
        {
            Status_DataModal *model = dataArr[0];
            if ([model.status_ isEqualToString:@"OK"]) {
                inDataModal_.isDown = @"1";
                inDataModal_.isCanContract = @"1";
                [self changPopView];
                [self.webView_ reload];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ConsultantFreshCount" object:nil];
            }
            [BaseUIViewController showAutoDismissSucessView:nil msg:model.des_];
        }
            break;
        case Request_joinPerson:
        {
            Status_DataModal *model = dataArr[0];
            if ([model.status_ isEqualToString:@"OK"]) {
                
                [BaseUIViewController showAutoDismissSucessView:@"" msg:model.des_ seconds:1.0];
                inDataModal_.joinstate = 1;
                [self layoutOfferPartyMenu:_resumeListType];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OFFERPAICOUNREFRESH" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHRResumeListCtlRefresh" object:nil];
            }
            else{
                [BaseUIViewController showAutoDismissFailView:@"" msg:model.des_ seconds:1.0];
            }
        }
            break;
        case Request_ResumeURL:
        {
            if ([dataArr count] != 0) {
                _urlStr = [dataArr objectAtIndex:0];
            }else{
                _urlStr = @"";
            }
            if ([dataArr count] >= 2) {
                fujianUrl = dataArr[1];
            }else{
                fujianUrl = @"";
            }
            if ([dataArr count] >=3) {
                pages = dataArr[2];
            }
            if (_urlStr) {
                NSURL * url = [NSURL URLWithString:_urlStr];
                NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
                [self.webView_ loadRequest:urlRequest];
            }
        }
            break;
        case Request_GetGuwenEmail:
        {
            Status_DataModal *model = dataArr[0];
            if ([model.status_ isEqualToString:@"OK"]) {
                _email = model.exObj_;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否把该人才的简历发送到此邮箱" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 5000;
                [alertView show];
            }else{
                [MBProgressHUD showAlertContent:model.des_ toView:self.view withSecond:1.0 animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - offer派菜单
- (void)layoutOfferPartyMenu:(OPResumeListType)resumeOPType
{
    if (_consultantCompanyFlag) {//企业参会企业列表
        [_daochangBtn setTitle:@"推荐详情" forState:UIControlStateNormal];
        _recomBtn = _daochangBtn;
        _daochangBtn = nil;
        [_optionView2 setHidden:YES];
        _optionView1.frame = CGRectMake(0, 0,ScreenWidth/2.0, _optionView1.frame.size.height);
        _optionView3.frame = CGRectMake(ScreenWidth/2.0, 0, ScreenWidth/2.0, _optionView3.frame.size.height);

        return;
    }
    
    switch (_resumeListType) {
        case OPResumeListTypeAllResume:
        case OPResumeListTypeConfirmToAttend:
        case OPResumeListTypePrimaryElection:
        {
            if (inDataModal_.joinstate == 1) {
                _daochangBtn.enabled = NO;
                [_daochangBtn setTitle:@"已到场" forState:UIControlStateNormal];
                [_daochangBtn setTitleColor:UIColorFromRGB(0xf8d1d1) forState:UIControlStateNormal];
            }
            else
            {
                _daochangBtn.enabled = YES;
                [_daochangBtn setTitle:@"确认到场" forState:UIControlStateNormal];
                [_daochangBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            }
        }
            break;
        case OPResumeListTypeHasPresent://已到场列表
        {
            if ([inDataModal_.leaveState isEqualToString:@"1"]) {
                _daochangBtn.enabled = NO;
                [_daochangBtn setTitle:@"已离场" forState:UIControlStateNormal];
                [_daochangBtn setTitleColor:UIColorFromRGB(0xf8d1d1) forState:UIControlStateNormal];
            }
            else
            {
                _daochangBtn.enabled = YES;
                [_daochangBtn setTitle:@"确认离场" forState:UIControlStateNormal];
                [_daochangBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            }
        }
            break;
        case OPResumeListTypeReceiveOffer://已faoffer
        {
            [_daochangBtn setTitle:@"Offer详情" forState:UIControlStateNormal];
            [_optionView2 setHidden:YES];
            
            _optionView1.frame = CGRectMake(0, 0, ScreenWidth/2.0, _optionView1.frame.size.height);
            _optionView3.frame = CGRectMake(ScreenWidth/2.0, 0, ScreenWidth/2.0, _optionView3.frame.size.height);
        }
            break;
        case OPResumeListTypeWorked://已上岗
        {
            [_daochangBtn setTitle:@"上岗详情" forState:UIControlStateNormal];
            [_optionView2 setHidden:YES];
            
            _optionView1.frame = CGRectMake(0, 0, ScreenWidth/2.0, _optionView1.frame.size.height);
            _optionView3.frame = CGRectMake(ScreenWidth/2.0, 0, ScreenWidth/2.0, _optionView3.frame.size.height);
            [_recomBtn setHidden:YES];
        }
            break;
        default:
            break;
    }
}


-(void)updateCom:(RequestCon *)con
{
    if ([fujianUrl isEqualToString:@""] || fujianUrl == nil) {
        [_btnFujian setHidden:YES];
    }else{
        [_btnFujian setHidden:NO];
    }
}

- (void)changPopView
{
    if ([inDataModal_.isDown isEqualToString:@"0"])
    {//未下载
        _loadResumeBtn.enabled = YES;
        [_loadResumeBtn setImage:[UIImage imageNamed:@"download_white.png"] forState:UIControlStateNormal];
    }
    else
    {//已下载
        _loadResumeBtn.enabled = NO;
        [_loadResumeBtn setImage:[UIImage imageNamed:@"download_already.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - 按钮点击事件
#pragma mark 右上角按钮
- (IBAction)rightBtnClick:(id)sender {
    
    if (sender == _transpondBtn) {
        NSURL *imgUrl = [NSURL URLWithString:inDataModal_.img_];
        NSData *data = [NSData dataWithContentsOfURL:imgUrl];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString * sharecontent = [NSString stringWithFormat:@"%@的微简历",inDataModal_.name_];
        NSString * titlecontent = @"微简历";
        
        NSString * url = [NSString stringWithFormat:@"%@&mobile=share",_urlStr];
        NSError *error = NULL;
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"role_id=\\d+" options:NSRegularExpressionCaseInsensitive error:&error];
        NSRange range = NSMakeRange(0, _urlStr.length);
        NSTextCheckingResult *reuslt = [regularExpression firstMatchInString:_urlStr options:0 range:range];
        NSString *sharedUrl = [_urlStr copy];
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
    else if (sender == _loadResumeBtn) {//下载简历
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

#pragma mark 底部按钮
-(void)btnResponse:(id)sender
{
    if (sender == _btnFujian) {
        YLMediaModal *modal = [[YLMediaModal alloc] init];
        modal.file_pages = pages;
        modal.file_swf = [MyCommon getWithFileSwf:fujianUrl];
        YLArticleAttachmentCtl *ctl = [[YLArticleAttachmentCtl alloc] init];
        ctl.dataModal = modal;
        ctl.isPushFavoriteListCtl = YES;
        [ctl.saveBtn setHidden:YES];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _daochangBtn)
    {//确认到场
        switch (_resumeListType) {
            case OPResumeListTypeAllResume:
            case OPResumeListTypeConfirmToAttend:
            case OPResumeListTypePrimaryElection:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认人才到场" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertView.tag = 3000;
                [alertView show];
            }
                break;
            case OPResumeListTypeHasPresent://确认离场
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认人才离场" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertView.tag = 4000;
                [alertView show];
            }
                break;
            case OPResumeListTypeReceiveOffer:
            {//Offer详情
                OfferrRecomDetail *detailCtl = [[OfferrRecomDetail alloc] init];
                detailCtl.jobfair_id = _jobfair_id;
                detailCtl.navTitle = @"Offer详情";
                [detailCtl beginLoad:inDataModal_ exParam:nil];
                [self.navigationController pushViewController:detailCtl animated:YES];
            }
                break;
            case OPResumeListTypeWorked:
            {//上岗详情
                OfferrRecomDetail *detailCtl = [[OfferrRecomDetail alloc] init];
                detailCtl.jobfair_id = _jobfair_id;
                detailCtl.navTitle = @"上岗详情";
                [detailCtl beginLoad:inDataModal_ exParam:nil];
                [self.navigationController pushViewController:detailCtl animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if (sender == _dianlianBtn)
    {//打电话
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"电话联系", @"私信联系", @"回访记录", nil];
        actionSheet.tag = 1001;
        [actionSheet showInView:self.view];
    }
    else if (sender == _recomBtn)
    {
        if (_consultantCompanyFlag) {//企业参会企业列表
            OfferrRecomDetail *detailCtl = [[OfferrRecomDetail alloc] init];
            detailCtl.jobfair_id = _jobfair_id;
            detailCtl.consultantCompanyFlag = _consultantCompanyFlag;
            [detailCtl beginLoad:inDataModal_ exParam:nil];
            [self.navigationController pushViewController:detailCtl animated:YES];
        }
        else
        {
            switch (_resumeListType) {
                case OPResumeListTypeAllResume:
                case OPResumeListTypeConfirmToAttend:
                case OPResumeListTypePrimaryElection:
                {
                    //leftbtn 推荐简历
                    if (_resumeListType == OPResumeListTypeAllResume || _resumeListType == OPResumeListTypeConfirmToAttend) {
                        
                        OfferrRecomDetail *detailCtl = [[OfferrRecomDetail alloc] init];
                        detailCtl.jobfair_id = _jobfair_id;
                        detailCtl.consultantCompanyFlag = _consultantCompanyFlag;
                        [detailCtl beginLoad:inDataModal_ exParam:nil];
                        [self.navigationController pushViewController:detailCtl animated:YES];
                    }
                    else
                    {
                        OfferrRecomDetail *detailCtl = [[OfferrRecomDetail alloc] init];
                        detailCtl.jobfair_id = _jobfair_id;
                        [detailCtl beginLoad:inDataModal_ exParam:nil];
                        [self.navigationController pushViewController:detailCtl animated:YES];
                    }
                }
                    break;
                case OPResumeListTypeHasPresent://已到场列表
                {
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"推荐排队", @"推荐企业", nil];
                    actionSheet.tag = 1002;
                    [actionSheet showInView:self.view];
                }
                    break;
                default:
                    break;
            }
        }
    }
    else if (sender == self.backBtn_){
        [super backBarBtnResponse:sender];
    }
}

#pragma mark - 代理
#pragma mark UIActionSheetDegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1001) {
        switch (buttonIndex) {
            case 0:
            {//电话联系
                //内部用户
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
            case 2:
            {//回访记录
                ConsultantVisitorReplyList *replayList = [[ConsultantVisitorReplyList alloc] init];
                [replayList beginLoad:inDataModal_ exParam:nil];
                [self.navigationController pushViewController:replayList animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if (actionSheet.tag == 1002)
    {
        if (buttonIndex == 0) {//推荐排队
            OfferToRecomResumeCtl *recomCtl = [[OfferToRecomResumeCtl alloc] init];
            recomCtl.recommendLineUpFlag = YES;
            [recomCtl beginLoad:inDataModal_ exParam:nil];
            recomCtl.jobfair_id = _jobfair_id;
            [self.navigationController pushViewController:recomCtl animated:YES];
        }
        else if (buttonIndex == 1)
        {//推荐企业
            OfferrRecomDetail *detailCtl = [[OfferrRecomDetail alloc] init];
            detailCtl.jobfair_id = _jobfair_id;
            [detailCtl beginLoad:inDataModal_ exParam:nil];
            [self.navigationController pushViewController:detailCtl animated:YES];
        }
    }
    
}

#pragma mark UIAlertViewDegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
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
    else if (alertView.tag == 3000)
    {//确认到场
        if (buttonIndex == 1) {
            if (!statusCon) {
                statusCon = [self getNewRequestCon:NO];
            }
            [statusCon joinPerson:inDataModal_.jobfair_person_id jonstate:@"1" roleId:[Manager getHrInfo].salerId role:@"30" editDesc:nil];
        }
    }
    else if (alertView.tag == 4000)
    {//确认离场
        if (buttonIndex == 1) {
            
            NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
            [condictionDic setObject:@"30" forKey:@"role"];
            [condictionDic setObject:[Manager getHrInfo].salerId forKey:@"roleid"];
           
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
            NSString *bodyMsg = [NSString stringWithFormat:@"jobfair_person_id=%@&field=leave_state&state=1&conditionArr=%@", inDataModal_.jobfair_person_id,condictionStr];
            
            [ELRequest postbodyMsg:bodyMsg op:@"offerpai_busi" func:@"updateField" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                
                if([result[@"status"] isEqualToString:Success_Status]){
                    
                    inDataModal_.leaveState = @"1";
                    [self layoutOfferPartyMenu:_resumeListType];
                    [BaseUIViewController showAutoDismissSucessView:nil msg:result[@"status_desc"]];
                    
                    if ([self.delegate_ respondsToSelector:@selector(rejectResume:passed:)]) {
                        [self.delegate_ rejectResume:nil passed:YES];
                    }
                }
                else{
                    [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"]];
                }
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                
            }];
        }
    }
}

#pragma mark - TranspondResumeCtlDelegate
-(void)removeView
{
    [transpondResumeCtl_.view removeFromSuperview];
}

-(void)backView
{
    [self rightBtnClick:_transpondBtn];
}

#pragma mark 分享到一览好友
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

#pragma mark 复制链接
-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"role_id=\\d+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange range = NSMakeRange(0, _urlStr.length);
    NSTextCheckingResult *reuslt = [regularExpression firstMatchInString:_urlStr options:0 range:range];
    NSString *sharedUrl = [_urlStr copy];
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
    transpondResumeCtl_.url_ = _urlStr;
    transpondResumeCtl_.resumeType = _resumeType;//招聘顾问简历预览
    
    [transpondResumeCtl_ beginLoad:inDataModal_ exParam:companyId_];
    [transpondResumeCtl_.view setFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:transpondResumeCtl_.view];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
}

- (void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
