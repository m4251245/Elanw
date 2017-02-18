//
//  ELOfferPartyCompanyResumePreviewCtl.m
//  jobClient
//
//  Created by YL1001 on 16/10/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOfferPartyCompanyResumePreviewCtl.h"
#import "TheContactListCtl.h"
#import "TranspondResumeCtl.h"
#import "SendInterviewCtl.h"
#import "ELEvaluationResumeCtl.h"
#import "ELAddResumeReason.h"
#import "ELTextView.h"
#import "CompanyResumePrevierwModel.h"
#import "ELEmailTranspondCtl.h"

@interface ELOfferPartyCompanyResumePreviewCtl ()<ELShareManagerDelegate,TranspondResumeCtlDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UITextViewDelegate,evaluationDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_webViewBttomSpace;
    __weak IBOutlet UIView *_bottomView;
//    __weak IBOutlet NSLayoutConstraint *_transpondBtnWidth;
//    __weak IBOutlet NSLayoutConstraint *_appriseBtnWidth;
//    __weak IBOutlet NSLayoutConstraint *_primaryBtnWidth;
    
    User_DataModal *_inDataModel;
    NSString *_companyId;  //公司Id
    NSString *_url;  //简历Url
    
//    __weak IBOutlet UIButton *_transpondBtn;  //转发简历
//    __weak IBOutlet UIButton *_appraiseBtn;   //评价简历
//    __weak IBOutlet UIButton *_primaryBtn;    //通过初选
    
    TranspondResumeCtl *_transpondResumeCtl;
    ShareMessageModal *_shareModal;  //分享给一览好友的Modal
    
    UIScrollView   *_scrollView;
//    UIButton       *_shareBtn;    /** 转发按钮 */
//    UIButton       *_appraiseBtn; /** 简历评价 */
//    UIView         *rightView;
    NSMutableArray *_btnArr;
    UIButton       *_showBtn;
    NSMutableDictionary *urlModelDic;
    
    BOOL showBtn;//显示放弃按钮
    
    NSString *downloadSource;   //下载的来源
    
    ResumeState _resumeState;   //简历状态
    
    ELTextView *noteTextView;

}

@property (strong, nonatomic) CompanyResumePrevierwModel *previewModel;

@property (nonatomic, weak) UIButton *interviewBtn;   //面试 面试结果
@property (nonatomic, weak) UIButton *sendOfferBtn;   //发offer
@property (nonatomic, weak) UIButton *workedBtn;      //已上岗

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ELOfferPartyCompanyResumePreviewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //企业后台的简历预览界面
    [self setNavTitle:@"简历预览"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendOfferSuccess:) name:@"sendOfferSuccess" object:nil];
    
}

#pragma mark - 点击事件
- (void)rightBtnClick:(UIButton *)sender
{
    if (sender.tag == 50) {
        [self transmitResume];
    }
    else if (sender.tag == 51)
    {
        ELEvaluationResumeCtl *resumeCtl = [[ELEvaluationResumeCtl alloc] init];
        resumeCtl.userModel = _inDataModel;
        resumeCtl.companyId = _companyId;
        resumeCtl.delegate = self;
        [[Manager shareMgr].centerNav_ pushViewController:resumeCtl animated:YES];
//        [resumeCtl beginLoad:nil exParam:nil];
    }
}
#pragma mark - evaluationDelegate
- (void)refreshResume
{
    [self requestRersumeInfo];
}

-(void)creatUI{
    urlModelDic = [[NSMutableDictionary alloc] init];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64)];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(_arrData.count*ScreenWidth,0);
    if (_selectRow > 0) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth*_selectRow,0)];
    }
    [self scrollViewDidScroll:_scrollView];
}

/*
 发offer成功后把简历状态改为已发offer
 */
- (void)sendOfferSuccess:(NSNotification *)notification
{
    //已发offer
    [self requestRersumeInfo];
}

- (void)viewDidLayoutSubviews
{
    
}

- (void)configOfferOartyUI
{
    for (UIView *view in _bottomView.subviews){
        [view removeFromSuperview];
    }
    //0 待处理，1合适，5，不合适，20 待面试，30已到场，40已面试，60已发offer   35已离场 3待确定 45面试不通过  80已上岗
    NSArray *btnTitleArr = [[NSArray alloc] initWithObjects:@"不合适", @"简历合适", @"待确定", @"通知排队", @"放弃面试", @"面试通过", @"发offer", @"已离场",@"确认上岗",@"初面不通过",@"初面通过",@"已发offer",@"已上岗",@"已放弃面试",@"已标记不合适",nil];
    _btnArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < btnTitleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        if (i == 0 ) {
            [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xf8fafa)];
        }
        else if (i == 4 || i == 2||i == 3)
        {
            [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xf39c12)];
        }
        else if (i == 9){
            [button setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xf8fafa)];
            
        }
        else if (i == 14){
            [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xbdbdbd)];
            button.enabled = NO;
        }
        else
        {
            [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xe13e3e)];
        }
        
        [button setTitle:[btnTitleArr objectAtIndex:i] forState:UIControlStateNormal];
        
        button.tag = 500 + i;
        [button addTarget:self action:@selector(offerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr addObject:button];
    }
    
    switch ([_previewModel.action_state integerValue]) {
        case ResumeStateToProcessed:
//        case OPResumeTypeWait:
        {
            [self takeOutBtnWithTag1:0 tag2:2 tag3:1];
        }
            break;
            
//        case OPResumeTypeAdvisersRecommend:
//        {
//            [self takeOutBtnWithTag1:0 tag2:2 tag3:1];
//        }
//            break;
        case ResumeStateQualified:
        {
            _showBtn = [_btnArr objectAtIndex:1];
            _showBtn.frame = CGRectMake(0, 0, ScreenWidth, 44);
            _showBtn.enabled = NO;
            [_bottomView addSubview:_showBtn];
            
            [_showBtn setTitleColor:UIColorFromRGB(0xf8d1d1) forState:UIControlStateNormal];
            [_showBtn setBackgroundColor:UIColorFromRGB(0xe65b5b)];
        }
            break;
        case ResumeStateUnQualified:
        {
            [self takeOutBtnWithTag1:14 tag2:1 tag3:999];
        }
            break;
        case ResumeStateToInterview:
       
//        case OPResumeTypeConfirmFit:
        {
            if (([_previewModel.company_state isEqualToString:@"0"] || [_previewModel.company_state isEqualToString:@"3"] || [_previewModel.company_state isEqualToString:@"2"]) && [_previewModel.tj_laber isEqualToString:@"0"]) {
                [self takeOutBtnWithTag1:9 tag2:4 tag3:10];
            }else{
                [self takeOutBtnWithTag1:9 tag2:10 tag3:999];
            }
        }
            break;
//        case OPResumeTypeInterviewSelfDeliver:
//        
//        {
//            if ([_inDataModel.add_user isEqualToString:@"1"] && [_inDataModel.wait_mianshi isEqualToString:@"1"]) {
//                [self takeOutBtnWithTag1:9 tag2:4 tag3:10];
//            }
//        }
//            break;
        case ResumeStateHasPresent:
        {
            [self takeOutBtnWithTag1:9 tag2:3 tag3:10];
      
        }
            break;
        case ResumeStateThroughInterview:
        {
            [self takeOutBtnWithTag1:6 tag2:10 tag3:999];
        
        }
            break;
        case ResumeStateSendOffer:
        {
            [self takeOutBtnWithTag1:11 tag2:8 tag3:1001];
        }
            break;
        case ResumeStateLeaved:
        {
            _showBtn = [_btnArr objectAtIndex:7];
            _showBtn.frame = CGRectMake(0, 0, ScreenWidth, 44);
            _showBtn.enabled = NO;
            [_bottomView addSubview:_showBtn];
            
            [_showBtn setTitleColor:UIColorFromRGB(0xf8d1d1) forState:UIControlStateNormal];
            [_showBtn setBackgroundColor:UIColorFromRGB(0xe65b5b)];
        }
            break;
        case ResumeStateNOThroughInterview:
        {
            [self takeOutBtnWithTag1:9 tag2:10 tag3:999];
        }
            break;
        case ResumeStateMountGuard:
        {
            [self takeOutBtnWithTag1:11 tag2:12 tag3:999];
        }
            break;
        case ResumeStateToDetermine:
        {
            [self takeOutBtnWithTag1:0 tag2:2 tag3:1];
            
        }
            break;
        case ResumeStateGiveUpInterview:
        {
            _showBtn = [_btnArr objectAtIndex:13];
            _showBtn.frame = CGRectMake(0, 0, ScreenWidth, 44);
            _showBtn.enabled = NO;
            [_bottomView addSubview:_showBtn];
            
            [_showBtn setTitleColor:UIColorFromRGB(0xf8d1d1) forState:UIControlStateNormal];
            [_showBtn setBackgroundColor:UIColorFromRGB(0xe65b5b)];
        }
            break;
        default:
            break;
    }
}

// 一览精选-交付业务 点击事件
- (void)offerBtnClick:(UIButton *)sender
{
    //@"不合适", @"简历合适", @"待确定", @"通知排队", @"放弃面试", @"面试通过", @"发offer",@"确认上岗",@"初面不通过"
    switch (sender.tag - 500) {
        case 0://不合适
        {
            [self showEvaluationView:0];
        }
            break;
        case 1://简历合适
        {
            [self showEvaluationView:1];
        }
            break;
        case 2://待确定
        {
             [self showEvaluationView:2];
        }
            break;
        case 3://通知排队
        {
            [self showConfirmation:1003];
        }
            break;
        case 4://放弃面试
        {
            [self showConfirmation:1004];
        }
            break;
        case 5://面试通过
        case 10:
        {
              [self showEvaluationView:5];
        }
            break;
        case 6://发offer
        {
            SendInterviewCtl * sendInterviewCtl = [[SendInterviewCtl alloc] init];
            sendInterviewCtl.type_ = Interview_Emial;
            sendInterviewCtl.operationType = OperationTypeOPSendOffer;
            sendInterviewCtl.companyId = _companyId;
            [[Manager shareMgr].centerNav_ pushViewController:sendInterviewCtl animated:YES];
            [sendInterviewCtl beginLoad:_inDataModel exParam:nil];
            
        }
            break;
        case 8://确认上岗
        {

            [self showEvaluationView:8];
        }
            break;
        case 9://初面不通过
        {
            ELAddResumeReason *reason = [[ELAddResumeReason alloc] init];
            reason.userModel = _inDataModel;
            reason.companyId = _companyId;
            WS(weakSelf)
            reason.addReasonBlock = ^{
//                [weakSelf changeDeliverResumeWithType:@"mianshi" State:@"7" operationType:@"初面不通过"];
                [weakSelf requestRersumeInfo];
            };
            [self.navigationController pushViewController:reason animated:YES];

        }
            break;
            
        default:
            break;
    }
    
}

- (void)takeOutBtnWithTag1:(NSInteger)tag1 tag2:(NSInteger)tag2 tag3:(NSInteger)tag3
{
    CGFloat btnWidth;
    if (tag3 >= 999) {//表示底部只有两个按钮
        btnWidth = ScreenWidth / 2;
    }
    else {
        btnWidth = ScreenWidth / 3;
    }
    
    _showBtn = [_btnArr objectAtIndex:tag1];
    _showBtn.frame = CGRectMake(0, 0, btnWidth, 44);
    [_bottomView addSubview:[_btnArr objectAtIndex:tag1]];
    
    _showBtn = [_btnArr objectAtIndex:tag2];
    _showBtn.frame = CGRectMake(btnWidth, 0, btnWidth, 44);
    [_bottomView addSubview:[_btnArr objectAtIndex:tag2]];
    
    if (tag3 < 999) {
        
        _showBtn = [_btnArr objectAtIndex:tag3];
        _showBtn.frame = CGRectMake(2*btnWidth, 0, btnWidth, 44);
        [_bottomView addSubview:[_btnArr objectAtIndex:tag3]];
        
    }else{
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, 7, 1, 29)];
        lineView1.backgroundColor = UIColorFromRGB(0xea7979);
        [_bottomView addSubview:lineView1];
    }
    
    
    switch ([_previewModel.action_state integerValue]) {//变色按钮 不可点击
        case ResumeStateThroughInterview://面试通过
        {
            UIButton *button = [_bottomView viewWithTag:510];
            [button setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xe13e3e)];
            button.enabled = NO;
            
        }
            break;
        case ResumeStateNOThroughInterview://面试不通过
        {
            UIButton *button = [_bottomView viewWithTag:509];
            [button setTitleColor:UIColorFromRGB(0xf8fafa) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xbdbdbd)];
            button.enabled = NO;
        }
            break;
        case ResumeStateSendOffer:
        {
            UIButton *button = [_bottomView viewWithTag:511];
            [button setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xe13e3e)];
            button.enabled = NO;
        }
            break;
        case ResumeStateMountGuard:
        {
            for (int i=0; i<_bottomView.subviews.count; i++) {
                if ([_bottomView.subviews[i] isKindOfClass:[UIButton class]]
                    ) {
                    UIButton *btn = _bottomView.subviews[i];
                    [btn setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
                    [btn setBackgroundColor:UIColorFromRGB(0xe13e3e)];
                    btn.enabled = NO;
                }
            }
            
        }
            break;
        case ResumeStateUnQualified:
        {
            UIButton *button = [_bottomView viewWithTag:514];
//            [button setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xbdbdbd)];
            button.enabled = NO;
        }
            break;
        case ResumeStateToInterview:
        {
            UIButton *button = [_bottomView viewWithTag:502];
//            [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
//            [button setBackgroundColor:UIColorFromRGB(0xf39c12)];
            button.enabled = NO;
        }
            break;
        case ResumeStateQualified:
        {
            UIButton *button = [_bottomView viewWithTag:510];
            [button setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xe13e3e)];
            button.enabled = NO;
        }
            break;
        case ResumeStateToDetermine:
        {
            UIButton *button = [_bottomView viewWithTag:502];
            [button setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xf39c12)];
            button.enabled = NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 简历转发
- (void)transmitResume
{
    NSURL *imgUrl = [NSURL URLWithString:_inDataModel.img_];
    NSData *data = [NSData dataWithContentsOfURL:imgUrl];
    UIImage *image = [UIImage imageWithData:data];
    
    NSString * sharecontent = [NSString stringWithFormat:@"%@的微简历", _inDataModel.uname_];
    
    NSString * titlecontent = @"微简历";
    
    NSString * url = [NSString stringWithFormat:@"%@&mobile=share", _url];
    NSString * URL = [self dealShareStr:url];
    
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"role_id=\\d+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange range = NSMakeRange(0, url.length);
    NSTextCheckingResult *reuslt = [regularExpression firstMatchInString:url options:0 range:range];
    NSString *sharedUrl = [url copy];
    if (reuslt) {
        sharedUrl = [sharedUrl stringByReplacingCharactersInRange:reuslt.range withString:@"role_id="];
    }
    NSString *shareURL = [self dealShareStr:sharedUrl];
    //调用分享
    
    if ([Manager shareMgr].haveLogin) {
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:shareURL shareType:ShareTypeFour];
        [[ShareManger sharedManager] setShareDelegare:self];
    }
    else
    {
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:URL];
    }
    
    if (!_shareModal) {
        _shareModal = [[ShareMessageModal alloc] init];
    }
    _shareModal.personId = _inDataModel.userId_;
    _shareModal.personName = _inDataModel.uname_;
    _shareModal.person_pic = _inDataModel.img_;
    _shareModal.person_zw = _inDataModel.job_;
    if (!_shareModal.personName) {
        _shareModal.personName = @"";
    }
    if (!_shareModal.person_pic) {
        _shareModal.person_pic = @"";
    }
    if (_shareModal.person_zw.length == 0)
    {
        _shareModal.person_zw = @"";
    }
    
}
//处理分享的URL
-(NSString *)dealShareStr:(NSString *)detailStr{
    if ([detailStr containsString:@"&"]) {
        NSArray *arr = [detailStr componentsSeparatedByString:@"&"];
        NSMutableArray *strArr = [NSMutableArray arrayWithArray:arr];
        NSString *markStr;
        for (NSString *str in strArr) {
            if ([str containsString:@"roletype"]) {
                markStr = str;
            }
        }
        NSUInteger index = [strArr indexOfObject:markStr];
        NSString *roletype = @"roletype=10";
        [strArr replaceObjectAtIndex:index withObject:roletype];
        NSString *str = [strArr componentsJoinedByString:@"&"];
        return str;
    }
    return detailStr;
}

#pragma mark 分享到一览好友
-(void)shareYLFriendBtn
{
    TheContactListCtl *contact = [[TheContactListCtl alloc] init];
    contact.isPersonChat = YES;
    contact.isPushShareCtl = YES;
    _shareModal.shareType = @"25";
    _shareModal.shareContent = @"简历";
    contact.isPersonChat = YES;
    contact.shareDataModal =_shareModal;
    [self.navigationController pushViewController:contact animated:YES];
    [contact beginLoad:nil exParam:nil];
}

#pragma mark 复制链接
-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * url = [NSString stringWithFormat:@"%@&mobile=share",_url];
    pasteboard.string = url;
    if(url.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

#pragma mark 邮件转发
-(void)emailShare
{
    ELEmailTranspondCtl *emailCtl = [[ELEmailTranspondCtl alloc] init];
    [[Manager shareMgr].centerNav_ pushViewController:emailCtl animated:YES];
    [emailCtl beginLoad:_inDataModel exParam:_companyId];
    
    /*
    _transpondResumeCtl = [[TranspondResumeCtl alloc] init];
    _transpondResumeCtl.delegate_ = self;
    _transpondResumeCtl.url_ = _url;
    _transpondResumeCtl.type = TranspondAdviserRecommend;
    
    [_transpondResumeCtl beginLoad:_inDataModel exParam:_companyId];
    [_transpondResumeCtl.view setFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_transpondResumeCtl.view];
     */
}

#pragma mark - 代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self finishLoadWithDelegate];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self finishLoadWithDelegate];
}

#pragma mark ResumeOperateDelegate
-(void)refreshResumeDetail:(BOOL)bPassed
{
    if (bPassed) {
        _inDataModel.resumeType = OPResumeTypeInterviewed;
    }
    else {
        _inDataModel.resumeType = OPResumeTypeInterviewUnqualified;
    }
//    [self configUI];
    [self configOfferOartyUI];
}
#pragma mark TranspondResumeCtlDelegate
-(void)removeView
{
     [_transpondResumeCtl.view removeFromSuperview];
}
-(void)backView
{
     [self transmitResume];
}
#pragma mark - 数据请求
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    _inDataModel = dataModal;
    _companyId = exParam;
    _url = nil;
    
    [super beginLoad:dataModal exParam:exParam];
    
    [self requestRersumeInfo];
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!_inDataModel.userId_) {
        _inDataModel.userId_ = @"";
    }
    if (_isRecommend) {//推荐报告URL
        [con getRecReportURL:_inDataModel.userId_ roletype:@"20" companyId:_companyId tjtype:_inDataModel.jlType tjid:_inDataModel.recommendId];
        return;
    }
    
    [con getResumeURL:_inDataModel.userId_ roletype:@"20" companyId:_companyId analyze:_inDataModel.keyWorkStr];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ResumeURL:
        {
            _url = [dataArr objectAtIndex:0];
//            [self changeState];
//            [self configOfferOartyUI];
            if ([_delegate respondsToSelector:@selector(finishLoadWithModel:)]) {
                [_delegate finishLoadWithModel:_url];
            }
        }
            break;
        default:
            break;
    }
}

-(void)updateCom:(RequestCon *)con
{
    if ( _url ) {
        NSString *webUrl = [NSString httpToHttps:_url];
        NSURL * url = [NSURL URLWithString:webUrl];
        NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [self.webView_ loadRequest:urlRequest];
    }
}

//修改简历状态
/**
 * offerpai 简历操作    添加 评论\备注  start
 * @param [type] $tjresumeArr         [description]   tjresumeArr
 $tjresumeArr['reid']    必须传 简历对应的企业编号
 $tjresumeArr['id']        必须传 简历对应的主键
 $tjresumeArr['company_id']        必须传 登录的企业编号，
 $tjresumeArr['type']               必须传  修改的类型 如 mianshi,
 $tjresumeArr['state']              必须传
 @param [type] $commentArr          [description]   commentArr
 $commentArr['jobid']   评论的内容
 $commentArr['commentContent']   评论的内容
 $commentArr['comment_type']       操作的类型 比如：简历合适，面试通过
 $commentArr['tags_name'] =''   评论的内容标签名 array()
 $commentArr['person_id']    评论人 不要传登录账号id
 $commentArr['synergy_m_id']   协同账号的ID
 $commentArr['company_resume_comment_label_id'] = '40'
 $commentArr['person_type']          = 5
 */
- (void)changeDeliverResumeWithType:(NSString *)type State:(NSString *)state operationType:(NSString *)operation
{
    NSMutableDictionary *tjresumeDic = [[NSMutableDictionary alloc] init];
    [tjresumeDic setObject:_previewModel.reid forKey:@"reid"];
    [tjresumeDic setObject:_previewModel.forkey forKey:@"id"];
    [tjresumeDic setObject:_companyId forKey:@"company_id"];
    [tjresumeDic setObject:type forKey:@"type"];
    [tjresumeDic setObject:state forKey:@"state"];

    
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
    [commentDic setObject:_inDataModel.zpId_ forKey:@"jobid"];
    [commentDic setObject:noteTextView.text?noteTextView.text:@"" forKey:@"commentContent"];
    [commentDic setObject:operation forKey:@"comment_type"];
    [commentDic setObject:_inDataModel.userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [commentDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    [commentDic setObject:@"40" forKey:@"company_resume_comment_label_id"];
    [commentDic setObject:@"5" forKey:@"person_type"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"20" forKey:@"role"];
    [conditionDic setObject:_companyId forKey:@"role_id"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *tjresumeStr = [jsonWrite stringWithObject:tjresumeDic];
    NSString *commentStr = [jsonWrite stringWithObject:commentDic];
    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"tjresumeArr=%@&commentArr=%@&conditionArr=%@", tjresumeStr, commentStr, conditionStr];
    
    NSString * function = @"updateTjStateNew";
    NSString * op = @"offerpai_busi";
    
    [BaseUIViewController showLoadView:YES content:@"正在处理" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        if ([result isEqual:@1]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作成功"];
            [self requestRersumeInfo];
            [self hideEvaluationView];
        
            if ([self.delegate respondsToSelector:@selector(operationSuccessful)]) {
                [self.delegate operationSuccessful];
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}


/**
 * @Purpose
 * app预览简历url接口 一览社区绑定企业账号后预览简历
 * @Paramter $person_id         人才编号
 * @Paramter $roletype          预览者身份类型 10用户自己预览,20企业用户预览,30招聘顾问预览简历
 * @Paramter $role_id           预览者身份ID 如果是企业就是企业ID
 * @Paramter $conditionArray    先传空
 *   $conditionArray['reid']    简历对应的企业编号
 *   $conditionArray['forkey']  推荐ID，
 *   $conditionArray['tjid']    推荐ID，
 *   $conditionArray['fortype'] 列表页简历对应的简历类型， 主动投递 2000，一览精选 交付（offer,vph,kpb）3000,(顾问推荐)30001，主动下载4000，转发给我的简历5000，暂存简历6000，其他的传0
 * @Return      String
 */
- (void)requestRersumeInfo
{
    NSString * function = @"getPreivewResumeUrlForApp";
    NSString * op   =   @"company_person_busi";
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    
    if (!_inDataModel.recommendId) {
        _inDataModel.recommendId = @"";
    }
    
    [conditionDic setObject:_inDataModel.recommendId forKey:@"tjid"];
    [conditionDic setObject:_inDataModel.fromType forKey:@"tjtype"];


//    [conditionDic setObject:_inDataModel.companyId forKey:@"reid"];
    [conditionDic setObject:_inDataModel.recommendId forKey:@"forkey"];
    [conditionDic setObject:@"3000" forKey:@"fortype"];
//    if (!downloadSource) {
//        downloadSource = @"";
//    }
//    [conditionDic setObject:downloadSource forKey:@"download_source"];

    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *personId;
    if (_inDataModel.userId_.length > 0) {
        personId = _inDataModel.userId_;
    }
    else{
        personId = @"";
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&roletype=%@&role_id=%@&conditionArray=%@", personId, @"20", _companyId, conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            CompanyResumePrevierwModel *resumeModel = [[CompanyResumePrevierwModel alloc] init];
            [resumeModel setValuesForKeysWithDictionary:dic];
            if ([_delegate respondsToSelector:@selector(finishLoadWithModel:)]) {
                [_delegate finishLoadWithModel:resumeModel];
            }
            
            if (!_previewModel) {
                _previewModel = [[CompanyResumePrevierwModel alloc] init];
            }
            [_previewModel setValuesForKeysWithDictionary:dic];
            if([_previewModel.is_show isKindOfClass:[NSString class]] && [_previewModel.is_show isEqualToString:@"5"]){
                [self showChooseAlertView:401 title:@"提示" msg:@"简历已经设置保密" okBtnTitle:@"确定" cancelBtnTitle:nil];
            }else{
                [self setResumeListTypeWithModel:_previewModel];
                [self updateCom:nil];
            }
        }else{
            [self finishLoadWithDelegate];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self finishLoadWithDelegate];
    }];
}

- (void)setResumeListTypeWithModel:(CompanyResumePrevierwModel *)model
{
//    _resumeState = [model.action_state integerValue];
    _previewModel = [[CompanyResumePrevierwModel alloc] init];
    _previewModel = model;
    [self configOfferOartyUI];
}

- (void)finishLoadWithDelegate
{
    if ([_delegate respondsToSelector:@selector(finishLoad)]) {
        [_delegate finishLoad];
    }
}

#pragma mark - AlertView
- (void)showConfirmation:(int)type
{
    NSString *string;
    switch (type) {
        case 1003:
        {
            string = @"是否确认通知排队？";
        }
            break;
        case 1004:
        {
            string = @"是否确认放弃面试？";
        }
            break;
            
        default:
            break;
    }
    [self showChooseAlertView:type title:@"提示" msg:string okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
}

- (void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 1003:
        {
            [self changeDeliverResumeWithType:@"mianshi" State:@"3" operationType:@"通知排队"];
        }
            break;
        case 1004:
        {
             [self changeDeliverResumeWithType:@"mianshi" State:@"60" operationType:@"放弃面试"];
        }
            break;
        case 401:
        {
            [[Manager shareMgr].centerNav_ popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 弹窗
/*
 *  不合适0  简历合适1  待确定传2
 */
- (void)showEvaluationView:(NSUInteger)tag
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _maskView.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.5];
        
        [self.view addSubview:_maskView];
        [self.view bringSubviewToFront:_maskView];
    }
    
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(30, ScreenHeight/2-150, ScreenWidth-60, 285)];
        _bgView.layer.cornerRadius = 5;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgView];
        [self.view bringSubviewToFront:_bgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, _bgView.width-20, 17)];
        label.font = [UIFont systemFontOfSize:17];
        
        NSString *placeholder;
        switch (tag) {
            case 0:
            {
                placeholder = @"是否确认将简历设为不合适？";
            }
                break;
            case 1:
            {
                placeholder = @"是否确认将简历设为合适？";
            }
                break;
            case 2:
            {
                placeholder = @"是否确认将简历设为待确定?";
            }
                break;
            case 5:
            {
                placeholder = @"是否确认将简历设为面试通过?";
            }
                break;
            case 8:
            {
                placeholder = @"是否确认上岗?";
            }
                break;
            default:
                break;
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x212121);
        label.text = placeholder;
        [_bgView addSubview:label];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, label.bottom+20, label.width, 14)];
        label2.text = @"备注内容";
        label2.textColor = UIColorFromRGB(0x757575);
        label2.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:label2];
        
        noteTextView = [[ELTextView alloc] initWithFrame:CGRectMake(20, label2.bottom+8, _bgView.width-40, 110)];
        
        //        noteTextView.placeholder = @"可填写备注内容";
        //        noteTextView.placeColor = UIColorFromRGB(0xbdbdbd);
        //        noteTextView.placeFont = [UIFont systemFontOfSize:14];
        noteTextView.textColor = UIColorFromRGB(0x212121);
        noteTextView.layer.cornerRadius = 2;
        noteTextView.layer.borderWidth = 1;
        noteTextView.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
        noteTextView.delegate = self;
        [_bgView addSubview:noteTextView];
        
        UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, noteTextView.width, 14)];
        placeHolderLabel.text = @"可填写备注内容";
        placeHolderLabel.textColor = UIColorFromRGB(0xbdbdbd);
        placeHolderLabel.font = [UIFont systemFontOfSize:14];
        placeHolderLabel.tag = 10001;
        [noteTextView addSubview:placeHolderLabel];
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(noteTextView.left, noteTextView.bottom + 20, (_bgView.width-60)/2, 39);
        cancleBtn.backgroundColor = UIColorFromRGB(0xf5f5f5);
        cancleBtn.layer.borderWidth = 1;
        cancleBtn.layer.cornerRadius = 2;
        cancleBtn.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancleBtn.tag = 100;
        [cancleBtn setTitleColor:UIColorFromRGB(0x9e9e9e) forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:cancleBtn];
        
        UIButton *determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        determineBtn.frame = CGRectMake(cancleBtn.right+20, cancleBtn.top, cancleBtn.width, cancleBtn.height);
        determineBtn.backgroundColor = UIColorFromRGB(0xe13e3e);
        determineBtn.layer.cornerRadius = 2;
        [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        determineBtn.tag = 200+tag;
        [determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [determineBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:determineBtn];
    }
}

- (void)hideEvaluationView
{
    [_maskView removeFromSuperview];
    _maskView = nil;
    
    [_bgView removeFromSuperview];
    _bgView = nil;
}

- (void)btnAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    if (tag == 100) {
        [self hideEvaluationView];
    }else {
         [self operationResume:tag];
    }
}

- (void)operationResume:(NSInteger)tag
{
    switch (tag) {
        case 200:
        {
             [self changeDeliverResumeWithType:@"company" State:@"2" operationType:@"简历不合适"];
        }
            break;
        case 201:
        {
             [self changeDeliverResumeWithType:@"company" State:@"1" operationType:@"简历合适"];
        }
            break;
        case 202:
        {
            [self changeDeliverResumeWithType:@"company" State:@"3" operationType:@"简历待确定"];
        }
            break;
        case 205:
        {
             [self changeDeliverResumeWithType:@"mianshi" State:@"6" operationType:@"面试通过"];
        }
            break;
        case 208:
        {
             [self changeDeliverResumeWithType:@"work" State:@"" operationType:@"确认上岗"];
        }
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[[event allTouches] anyObject] locationInView:self.view];
    
    if (CGRectContainsPoint(_bgView.frame, location)) {
        return;
    }
    
    [_maskView removeFromSuperview];
    _maskView = nil;
    
    [_bgView removeFromSuperview];
    _bgView = nil;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_bgView) {
        WS(weakSelf)
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _bgView.frame;
            frame.origin.y = ScreenHeight/2-100;
            weakSelf.bgView.frame = frame;
        }];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView viewWithTag:10001].hidden = YES;
    
    WS(weakSelf)
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _bgView.frame;
        frame.origin.y = 0;
        weakSelf.bgView.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
