//
//  ELNewResumePreviewCtl.m
//  jobClient
//
//  Created by YL1001 on 16/8/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewResumePreviewCtl.h"
#import "TranspondResumeCtl.h"
#import "TheContactListCtl.h"
#import "ELEvaluationResumeCtl.h"
#import "User_DataModal.h"
#import "CompanyResumePrevierwModel.h"
#import "SendInterviewCtl.h"
#import "OfferPartyResumeEnumeration.h"
#import "ELAddResumeReason.h"
#import "ELTextView.h"
#import "ELEmailTranspondCtl.h"
#import "ELResumeTranspondCtl.h"

@interface ELNewResumePreviewCtl ()<TranspondResumeCtlDelegate,UIActionSheetDelegate,UIAlertViewDelegate,ELShareManagerDelegate,UITextViewDelegate,evaluationDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_webViewBottmSapce;
    User_DataModal *_userModal;
    NSString *_companyId;
    
    TranspondResumeCtl * _transpondResumeCtl;
    ShareMessageModal *_shareModal;
    
    __weak IBOutlet UIView *_bottomBtnView;
    
    NSMutableArray *_btnArr;  //存放底部九个按钮
    UIButton *_showBtn;
    
//    UIButton *_shareBtn;    /** 转发按钮 */
//    UIButton *_appraiseBtn; /** 简历评价 */
    
    NSMutableArray *_unfitTitleArr; /** 不合适标题 */
    
    ResumeState _resumeState;   //简历状态
    NSString *_operatingHints;  //操作提示
    NSString *downloadSource;   //下载的来源
    
    ELTextView *noteTextView;   //备注
}

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ELNewResumePreviewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![_forType isEqualToString:@"3000"]) {
        
        [self configUI];
    }
    self.webView_.opaque = NO;
    self.webView_.backgroundColor = [UIColor clearColor];
    self.webView_.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendOfferSuccess:) name:@"sendOfferSuccess" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

//一览精选-交付业务 button
- (void)configOfferOartyUI
{
    for (UIView *view in _bottomBtnView.subviews){
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
//            button.enabled = NO;
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

    switch (_resumeState) {
        case ResumeStateToProcessed:
        {
            [self takeOutBtnWithTag1:0 tag2:2 tag3:1];
           
        }
            break;
        case ResumeStateQualified:
        {
            _showBtn = [_btnArr objectAtIndex:1];
            _showBtn.frame = CGRectMake(0, 0, ScreenWidth, 44);
            _showBtn.enabled = NO;
            [_bottomBtnView addSubview:_showBtn];
            
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
        {
            if (([_previewModel.company_state isEqualToString:@"0"] || [_previewModel.company_state isEqualToString:@"3"] || [_previewModel.company_state isEqualToString:@"2"]) && [_previewModel.tj_laber isEqualToString:@"0"]) {
                [self takeOutBtnWithTag1:9 tag2:4 tag3:10];
            }else{
                [self takeOutBtnWithTag1:9 tag2:10 tag3:999];
            }

        }
            break;
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
            [_bottomBtnView addSubview:_showBtn];
            
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
            [_bottomBtnView addSubview:_showBtn];
            
            [_showBtn setTitleColor:UIColorFromRGB(0xf8d1d1) forState:UIControlStateNormal];
            [_showBtn setBackgroundColor:UIColorFromRGB(0xe65b5b)];
        }
            break;
        default:
            break;
    }
}

//非一览精选-交付业务 button
- (void)configUI
{
    NSArray *btnTitleArr = [[NSArray alloc] initWithObjects:@"不合适", @"马上沟通", @"简历合适", @"邀请面试", @"面试通过", @"发offer", @"复活", @"下载", @"暂存", @"已离场", nil];
    NSArray *btnBackColorArr = [[NSArray alloc] initWithObjects:UIColorFromRGB(0xf8fafa), UIColorFromRGB(0xf39c12), UIColorFromRGB(0xe13e3e), nil];
    _btnArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < btnTitleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        if (i < 2) {
            [button setBackgroundColor:[btnBackColorArr objectAtIndex:i]];
        }
        else {
            [button setBackgroundColor:[btnBackColorArr objectAtIndex:2]];
        }
        
        if (i == 0) {
            [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }
        else {
            [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        }
        
        [button setTitle:[btnTitleArr objectAtIndex:i] forState:UIControlStateNormal];
        
        if (i == 1) {
            [button setImage:[UIImage imageNamed:@"talk.png"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        else if (i == 7) {
            [button setImage:[UIImage imageNamed:@"chr_download.png"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        else if (i == 8) {
            [button setImage:[UIImage imageNamed:@"chr_save.png"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        
        button.tag = 100 + i;
        [button addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr addObject:button];
    }
}

- (void)setBottomBtnForApplyList
{
    [self configUI];
    
    for (UIView *view in _bottomBtnView.subviews){
        [view removeFromSuperview];
    }
    //不是暂存简历 转发给我列表
    if (_resumeListType != ResumeTypeTempSaved && _resumeListType != ResumeTypeTranspondForMe) {
        
        if (_resumeState == ResumeStateToProcessed)
        {//待处理
//            [self takeOutBtnWithTag1:0 tag2:1 tag3:2];
            [self resumeStatusBtnWithTag1:0 tag2:1 tag3:2];
        }
        else if (_resumeState == ResumeStateQualified)
        {//合适
//            [self takeOutBtnWithTag1:0 tag2:1 tag3:3];
            [self resumeStatusBtnWithTag1:0 tag2:1 tag3:3];
        }
        else if (_resumeState == ResumeStateToInterview)
        {//等待面试
//            [self takeOutBtnWithTag1:0 tag2:1 tag3:4];
            [self resumeStatusBtnWithTag1:0 tag2:1 tag3:4];
        }
        else if (_resumeState == ResumeStateThroughInterview)
        {//通过面试
//            [self takeOutBtnWithTag1:5 tag2:6 tag3:999];
            [self resumeStatusBtnWithTag1:0 tag2:1 tag3:5];
        }
        else if (_resumeState == ResumeStateNOThroughInterview)
        {//未通过面试
//            [self takeOutBtnWithTag1:11 tag2:10 tag3:999];
            [self resumeStatusBtnWithTag1:11 tag2:10 tag3:999];
        }
        else if (_resumeState == ResumeStateSendOffer)
        {//已发offer
            _showBtn = [_btnArr objectAtIndex:1];
            _showBtn.frame = CGRectMake(0, 0, ScreenWidth, 44);
            [_bottomBtnView addSubview:_showBtn];
        }
        else if (_resumeState == ResumeStateUnQualified)
        {//不合适
//            [self takeOutBtnWithTag1:1 tag2:6 tag3:9999];
            [self resumeStatusBtnWithTag1:1 tag2:6 tag3:9999];
        }
        else if (_resumeState == ResumeStateToDownload)
        {//未下载
//            [self takeOutBtnWithTag1:7 tag2:8 tag3:9999];
            [self resumeStatusBtnWithTag1:7 tag2:8 tag3:9999];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 7, 1, 29)];
            lineView.backgroundColor = UIColorFromRGB(0xea7979);
            [_bottomBtnView addSubview:lineView];
            [_bottomBtnView bringSubviewToFront:lineView];
        }
        else if (_resumeState == ResumeStateLeaved)
        {
            _showBtn = _btnArr.lastObject;
            _showBtn.frame = CGRectMake(0, 0, ScreenWidth, 44);
            _showBtn.enabled = NO;
            [_bottomBtnView addSubview:_showBtn];
            
            [_showBtn setTitleColor:UIColorFromRGB(0xf8d1d1) forState:UIControlStateNormal];
            [_showBtn setBackgroundColor:UIColorFromRGB(0xe65b5b)];
        }
    }
    else if (_resumeListType == ResumeTypeTempSaved)
    {//暂存简历
        _showBtn = [_btnArr objectAtIndex:7];
        _showBtn.frame = CGRectMake(0, 0, ScreenWidth/2, 44);
        [_bottomBtnView addSubview:_showBtn];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 44);
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [deleteBtn setTitle:@"取消暂存" forState:UIControlStateNormal];
        [deleteBtn setBackgroundColor:UIColorFromRGB(0xe13e3e)];
        [deleteBtn setImage:[UIImage imageNamed:@"chr_save_cancel.png"] forState:UIControlStateNormal];
        [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtnView addSubview:deleteBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 7, 1, 29)];
        lineView.backgroundColor = UIColorFromRGB(0xea7979);
        [_bottomBtnView addSubview:lineView];
        [_bottomBtnView bringSubviewToFront:lineView];
    }
    else if (_resumeListType == ResumeTypeTranspondForMe)
    {//转发给我
        if ([_previewModel.type isEqualToString:@"0"] && [_previewModel.state isEqualToString:@"0"])
        {//转发-未评价

            [self resumeStatusBtnWithTag1:0 tag2:2 tag3:9999];
        }
        else if ([_previewModel.type isEqualToString:@"1"] && [_previewModel.state isEqualToString:@"0"])
        {//面试-未评价

            [self resumeStatusBtnWithTag1:0 tag2:4 tag3:9999];
        }
        else if ([_previewModel.state isEqualToString:@"1"])
        {//通过
            _showBtn = [_btnArr objectAtIndex:0];
            _showBtn.enabled = NO;
            _showBtn.frame = CGRectMake(0, 0, ScreenWidth, 44);
            [_bottomBtnView addSubview:_showBtn];
            
            if ([_previewModel.type isEqualToString:@"1"]) {
                [_showBtn setTitle:@"面试已通过" forState:UIControlStateNormal];
            }
            else
            {
                [_showBtn setTitle:@"评审已通过" forState:UIControlStateNormal];
            }
            [_showBtn setTitleColor:UIColorFromRGB(0xf8d1d1) forState:UIControlStateNormal];
            [_showBtn setBackgroundColor:UIColorFromRGB(0xe65b5b)];
        }
        else if ([_previewModel.state isEqualToString:@"5"])
        {//不合适
            _showBtn = [_btnArr objectAtIndex:0];
            _showBtn.enabled = NO;
            _showBtn.frame = CGRectMake(0, 0, ScreenWidth, 44);
            [_bottomBtnView addSubview:_showBtn];
         
            [_showBtn setTitle:@"不合适" forState:UIControlStateNormal];
            [_showBtn setTitleColor:UIColorFromRGB(0xf8d1d1) forState:UIControlStateNormal];
            [_showBtn setBackgroundColor:UIColorFromRGB(0xe65b5b)];
        }        
    }
}
//一览精选
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
    [_bottomBtnView addSubview:[_btnArr objectAtIndex:tag1]];
    
    _showBtn = [_btnArr objectAtIndex:tag2];
    _showBtn.frame = CGRectMake(btnWidth, 0, btnWidth, 44);
   [_bottomBtnView addSubview:[_btnArr objectAtIndex:tag2]];
    
    if (tag3 < 999) {
        
        _showBtn = [_btnArr objectAtIndex:tag3];
        _showBtn.frame = CGRectMake(2*btnWidth, 0, btnWidth, 44);
        [_bottomBtnView addSubview:[_btnArr objectAtIndex:tag3]];
        
    }else{
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, 7, 1, 29)];
        lineView1.backgroundColor = UIColorFromRGB(0xea7979);
        [_bottomBtnView addSubview:lineView1];
    }
    
    
    switch ([_previewModel.action_state integerValue]) {//变色按钮 不可点击
        case ResumeStateThroughInterview:
        {
            UIButton *button = [_bottomBtnView viewWithTag:510];
            [button setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xe13e3e)];
            button.enabled = NO;

        }
            break;
        case ResumeStateNOThroughInterview:
        {
            UIButton *button = [_bottomBtnView viewWithTag:509];
            [button setTitleColor:UIColorFromRGB(0xf8fafa) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xbdbdbd)];
            button.enabled = NO;
        }
            break;
        case ResumeStateSendOffer:
        {
            UIButton *button = [_bottomBtnView viewWithTag:511];
            [button setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xe13e3e)];
            button.enabled = NO;
            
        }
            break;
        case ResumeStateMountGuard:
        {
            for (int i=0; i<_bottomBtnView.subviews.count; i++) {
                if ([_bottomBtnView.subviews[i] isKindOfClass:[UIButton class]]
                    ) {
                    UIButton *btn = _bottomBtnView.subviews[i];
                    [btn setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
                    [btn setBackgroundColor:UIColorFromRGB(0xe13e3e)];
                    btn.enabled = NO;
                }
            }
          
        }
            break;
        case ResumeStateUnQualified:
        {
            UIButton *button = [_bottomBtnView viewWithTag:514];
//            [button setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xbdbdbd)];
            button.enabled = NO;
        }
            break;
        case ResumeStateToInterview:
        {
            UIButton *button = [_bottomBtnView viewWithTag:502];
            //            [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            //            [button setBackgroundColor:UIColorFromRGB(0xf39c12)];
            button.enabled = NO;
        }
            break;
        case ResumeStateQualified:
        {
            UIButton *button = [_bottomBtnView viewWithTag:510];
            [button setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xe13e3e)];
            button.enabled = NO;
        }
            break;
        case ResumeStateToDetermine:
        {
             UIButton *button = [_bottomBtnView viewWithTag:502];
            [button setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xf39c12)];
            button.enabled = NO;
        }
            break;
        default:
            break;
    }
}

- (void)resumeStatusBtnWithTag1:(NSInteger)tag1 tag2:(NSInteger)tag2 tag3:(NSInteger)tag3
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
    [_bottomBtnView addSubview:[_btnArr objectAtIndex:tag1]];
    
    _showBtn = [_btnArr objectAtIndex:tag2];
    _showBtn.frame = CGRectMake(btnWidth, 0, btnWidth, 44);
    [_bottomBtnView addSubview:[_btnArr objectAtIndex:tag2]];
    
    if (tag3 < 999) {
        
        _showBtn = [_btnArr objectAtIndex:tag3];
        _showBtn.frame = CGRectMake(2*btnWidth, 0, btnWidth, 44);
        [_bottomBtnView addSubview:[_btnArr objectAtIndex:tag3]];
        
    }else{
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, 7, 1, 29)];
        lineView1.backgroundColor = UIColorFromRGB(0xea7979);
        [_bottomBtnView addSubview:lineView1];
    }
    
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
        resumeCtl.userModel = _userModal;
        resumeCtl.companyId = _companyId;
        resumeCtl.delegate = self;
        [[Manager shareMgr].centerNav_ pushViewController:resumeCtl animated:YES];
//        [resumeCtl beginLoad:nil exParam:nil];
    }
}

/*暂存简历删除
 *@param  $company_id
 *@param  $company_uids
 *@param  $id 是要删除的id，可以是单个id，也可以是个数组
 *@return $returnArr  是一个数组
 array("code"=>200,'state'=>'OK');
 array("code"=>400,'state'=>'FAIL');
 *@author
 */
- (void)deleteBtnClick:(UIButton *)sender
{
    NSString *opStr = @"company_person_busi";
    NSString *funcStr = @"deleteResumeTemp";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&company_uids=%@&id=%@", _companyId, _previewModel.uids, _previewModel.resumeTempId];
    
    [BaseUIViewController showLoadView:YES content:@"正在处理" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:opStr func:funcStr requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        
        NSDictionary *dic = result;
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = [dic objectForKey:@"state"];;
        dataModal.code_ = [dic objectForKey:@"code"];
        
        if ([dataModal.code_ isEqualToString:@"200"]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"取消暂存成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownLoadResumeSucess" object:@(_idx) userInfo:nil];
            [[Manager shareMgr].centerNav_ popViewControllerAnimated:YES];
        }
        else {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"取消暂存失败"];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

// 一览精选-交付业务 点击事件
- (void)offerBtnClick:(UIButton *)sender
{
    //@"不合适", @"简历合适", @"待确定", @"通知排队", @"放弃面试", @"面试通过", @"发offer",@"确认上岗"
    switch (sender.tag - 500) {
        case 0://简历不合适
        {
            [self showEvaluationView:0];
//            [self changeDeliverResumeWithType:@"company" State:@"2"];
        }
            break;
        case 1://简历合适
        {

            [self showEvaluationView:1];
//            [self changeDeliverResumeWithType:@"company" State:@"1"];
        }
            break;
        case 2://待确定
        {
            [self showEvaluationView:2];
//            [self changeDeliverResumeWithType:@"company" State:@"3"];
        }
            break;
        case 3://通知排队
        {
            [self showConfirmation:103];
//            [self changeDeliverResumeWithType:@"mianshi" State:@"3"];
        }
            break;
        case 4://放弃面试
        {
            [self showConfirmation:104];
//            [self changeDeliverResumeWithType:@"company" State:@"2"];
        }
            break;
        case 5://面试通过
        case 10:
        {
            [self showEvaluationView:5];
//            [self changeDeliverResumeWithType:@"mianshi" State:@"6"];
        }
            break;
        case 6://发offer
        {
            SendInterviewCtl * sendInterviewCtl = [[SendInterviewCtl alloc] init];
            sendInterviewCtl.type_ = Interview_Emial;
            sendInterviewCtl.operationType = OperationTypeOPSendOffer;
            [[Manager shareMgr].centerNav_ pushViewController:sendInterviewCtl animated:YES];
            [sendInterviewCtl beginLoad:_userModal exParam:_previewModel];
            
        }
            break;
        case 8://上岗
        {
            [self showEvaluationView: 8];
//            _operatingHints = @"操作成功";
//            [self changeResumeSate:@"shanggang"];
        }
            break;
        case 9://初面不通过
        {
            ELAddResumeReason *reason = [[ELAddResumeReason alloc] init];
            reason.userModel = _userModal;
            reason.companyId = _companyId;
            WS(weakSelf)
            reason.addReasonBlock = ^{
//                [weakSelf changeDeliverResumeWithType:@"mianshi" State:@"7" operationType:@"初面不通过" ];
                [weakSelf requestRersumeInfo];
                
                                       };
            [self.navigationController pushViewController:reason animated:YES];

        }
            break;
       
        default:
            break;
    }
    
//    [self requestRersumeInfo];
}

// 非一览精选-交付业务 修改简历状态
- (void)bottomBtnClick:(UIButton *)sender
{
    _operatingHints = @"操作成功";
    switch (sender.tag - 100) {
        case 0:
        {//@"不合适"
            
            [self showEvaluationView:200];
            
        }
            break;
        case 1:
        {//@"沟通"
            
            
            
            MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
            [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
            MessageContact_DataModel *model = [[MessageContact_DataModel alloc] init];
            model.boolHrFlag = YES;
            ctl.isHr = YES;
            model.userId = _userModal.userId_;
            model.userIname = _userModal.name_;
            [ctl beginLoad:model exParam:nil];
            
        }
            break;
        case 2:
        {//@"简历合适",
            
            [self  showEvaluationView:201];
        }
            break;
        case 3:
        {//@"邀请面试",
            ELResumeTranspondCtl *ctl = [[ELResumeTranspondCtl alloc] init];
            [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
            [ctl beginLoad:_userModal exParam:_companyId];
            /*
            SendInterviewCtl * sendInterviewCtl = [[SendInterviewCtl alloc] init];
            sendInterviewCtl.type_ = Interview_Emial;
            sendInterviewCtl.operationType = OperationTypeInterview;
            [[Manager shareMgr].centerNav_ pushViewController:sendInterviewCtl animated:YES];
            [sendInterviewCtl beginLoad:_userModal exParam:nil];
             */
        }
            break;
        case 4:
        {//@"面试通过",
             [self  showEvaluationView:202];
        }
            break;
        case 5:
        {//@"发offer",
//            [self changeResumeSate:@"60"];
            
            SendInterviewCtl * sendInterviewCtl = [[SendInterviewCtl alloc] init];
            sendInterviewCtl.type_ = Interview_Emial;
            sendInterviewCtl.operationType = OperationTypeSendOffer;
            [[Manager shareMgr].centerNav_ pushViewController:sendInterviewCtl animated:YES];
            [sendInterviewCtl beginLoad:_userModal exParam:_previewModel];
        }
            break;
        case 6:
        {// @"复活",
            [self changeResumeSate:@"0" comment_type:@"复活"];
            _operatingHints = @"简历复活成功！";
        }
            break;
        case 7:
        {// @"下载",
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您是否确认下载查看简历联系方式，下载成功后将扣除1个简历下载数" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            alertView.tag = 51;
            [alertView show];
        }
            break;
        case 8:
        {//@"暂存"
            
            NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
            NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
            
            NSString * conditionStr;
            if (synergy_id && synergy_id.length > 1) {
                [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
                SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
                conditionStr = [jsonWriter stringWithObject:conditionDic];
            }
            
            NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&company_id=%@&conditionArr=%@", _userModal.userId_, _companyId,conditionStr];
            NSString * function = @"resumeTempSave";
            NSString * op = @"company";
            
            [BaseUIViewController showLoadView:YES content:nil view:nil];
            [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
                
                [BaseUIViewController showLoadView:NO content:nil view:nil];
                NSDictionary *dic = result;
                Status_DataModal * dataModal = [[Status_DataModal alloc] init];
                NSString * str = [dic objectForKey:@"status"];
                NSString *upperStr = [str uppercaseString];
                dataModal.status_ = upperStr;
                dataModal.des_ = [dic objectForKey:@"status_desc"];
                
                if ([dataModal.status_ isEqualToString:Success_Status]) {
                    [BaseUIViewController showAutoDismissAlertView:nil msg:@"暂存简历成功" seconds:2.0];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectResumeSuccess" object:nil];
                    [self requestRersumeInfo];
                }
                else {
                    [BaseUIViewController showAutoDismissAlertView:@"" msg:@"暂存简历失败" seconds:2.0];
                }
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [BaseUIViewController showLoadView:NO content:nil view:nil];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 代理方法
//UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 51:
        {//下载简历
            if (buttonIndex != 0) {
                
                NSString *m_isDown = [CommonConfig getDBValueByKey:@"m_isDown"];
                if (m_isDown && [m_isDown isEqualToString:@"0"]) {
                    [BaseUIViewController showAlertView:@"" msg:@"该账号没有此权限哟" btnTitle:@"关闭"];
                    return;
                }
                
                NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
                
                NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
                
                NSString * conditionStr;
                if (synergy_id && synergy_id.length > 1) {
                    [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
                    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
                    conditionStr = [jsonWriter stringWithObject:conditionDic];
                }
                
                NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&conditionArr=%@",_companyId, _userModal.userId_,conditionStr];
                NSString * function = @"resumeDownload";
                NSString * op   =   @"company";
                
                [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
                    
                    NSDictionary *dic = result;
                    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
                    dataModal.status_ = [dic objectForKey:@"status"];;
                    dataModal.des_ = [dic objectForKey:@"status_desc"];
                    dataModal.code_ = [dic objectForKey:@"code"];
                    dataModal.leftgjcnt = dic[@"info"][@"leftgjcnt"];
                    dataModal.leftptcnt = dic[@"info"][@"leftptcnt"];
                    
                    if ([dataModal.status_ isEqualToString:Success_Status]) {
                        //可发面试通知
                        downloadSource = @"1";
                        [self.delegate downloadResume:_userModal];
                        NSString *msg = [NSString stringWithFormat:@"下载成功！\n此简历已被归类至已下载列表\n剩余简历下载数:高级%@ 普通%@", dataModal.leftgjcnt, dataModal.leftgjcnt];//后台改
                        
                        [BaseUIViewController showAutoDismissAlertView:nil msg:msg seconds:2.0];
                        [self requestRersumeInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownLoadResumeSucess" object:@(_idx) userInfo:nil];
                    }
                    else {
                        [self performSelector:@selector(showAlertTips:) withObject:[NSString stringWithFormat:@"%@",dataModal.des_] afterDelay:0.5];
                    }
                    
                } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    
                }];
            }
        }
            break;
        case 103:
        {
            [self changeDeliverResumeWithType:@"mianshi" State:@"3" operationType:@"通知排队"];
        }
            break;
        case 104:
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

- (void)showAlertTips:(NSString *)content
{
    [BaseUIViewController showAutoDismissFailView:nil msg:content seconds:2.0];
}

//UIWebViewDelegate
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

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self finishLoadWithDelegate];
}

#pragma mark TranspondResumeCtlDelegate
-(void)removeView
{
    [_transpondResumeCtl.view removeFromSuperview];
}

-(void)backView
{
    [self transmitResume];
    //[self rightBtnClick:_shareBtn];
}

#pragma mark - 简历分享
- (void)transmitResume
{
    if (_userModal.company_ == nil || ![_userModal.company_ isKindOfClass:[NSString class]]) {
        _userModal.company_ = @"";
    }
    
    NSURL *imgUrl = [NSURL URLWithString:_userModal.img_];
    NSData *data = [NSData dataWithContentsOfURL:imgUrl];
    UIImage *image = [UIImage imageWithData:data];
    
    NSString * sharecontent = [NSString stringWithFormat:@"%@的微简历",_userModal.name_];
    NSString * titlecontent = @"微简历";
    
    NSString * url = [NSString stringWithFormat:@"%@&mobile=share",_previewModel.url];
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
        [[ShareManger sharedManager] shareWithCtl:[Manager shareMgr].centerNav_ title:titlecontent content:sharecontent image:image url:shareURL shareType:ShareTypeFour];
        [[ShareManger sharedManager] setShareDelegare:self];
    }
    else {
        [[ShareManger sharedManager] shareWithCtl:[Manager shareMgr].centerNav_ title:titlecontent content:sharecontent image:image url:URL];
    }
    
    if (!_shareModal) {
        _shareModal = [[ShareMessageModal alloc] init];
    }
    _shareModal.personId = _userModal.userId_;
    _shareModal.personName = _userModal.name_;
    _shareModal.person_pic = _userModal.img_;
    _shareModal.person_zw = _userModal.job_;
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
    contact.shareDataModal = _shareModal;
    [[Manager shareMgr].centerNav_ pushViewController:contact animated:YES];
    [contact beginLoad:nil exParam:nil];
}

#pragma mark 复制链接
-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * url = [NSString stringWithFormat:@"%@&mobile=share",_previewModel.url];
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
    [emailCtl beginLoad:_userModal exParam:_companyId];

    /*
    _transpondResumeCtl = [[TranspondResumeCtl alloc] init];
    _transpondResumeCtl.delegate_ = self;
    _transpondResumeCtl.url_ = _previewModel.url;
    if ([_forType isEqualToString:@"3000"]) {
        _transpondResumeCtl.type = TranspondAdviserRecommend;
        //邮件转发默认使用jlType 因涉及页面太多 暂时不修改
        _userModal.jlType = _userModal.fromType;
    }
    else
    {
        _transpondResumeCtl.resumeType = _resumeListType;//企业后台简历列表类型
    }
    
    [_transpondResumeCtl beginLoad:_userModal exParam:_companyId];
    [_transpondResumeCtl.view setFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_transpondResumeCtl.view];
     */
}

#pragma mark - 数据请求
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
  
    _userModal = dataModal;
    _companyId = exParam;
  
    if (_previewModel) {
        [self setResumeListTypeWithModel:_previewModel];
        [self updateCom:nil];
    }else{
        [self requestRersumeInfo];
    }
    
}

- (void)updateCom:(RequestCon *)con
{
    if (_previewModel.url) {
        NSURL * url = [NSURL URLWithString:[NSString httpToHttps:_previewModel.url]];
        NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [self.webView_ loadRequest:urlRequest];
    }else{
        [self finishLoadWithDelegate];
    }
}

/**
 * @Purpose
 * app预览简历url接口 一览社区绑定企业账号后预览简历
 * @Paramter $person_id         人才编号
 * @Paramter $roletype          预览者身份类型 10用户自己预览,20企业用户预览,30招聘顾问预览简历
 * @Paramter $role_id           预览者身份ID 如果是企业就是企业ID
 * @Paramter $conditionArray    先传空
 *   $conditionArray['reid']    简历对应的企业编号
 *   $conditionArray['forkey']  列表页简历对应的主键ID，
 *   $conditionArray['fortype'] 列表页简历对应的简历类型， 主动投递 2000，一览精选 交付（offer,vph,kpb）3000,(顾问推荐)0，主动下载4000，转发给我的简历5000，暂存简历6000，其他的传0
 * @Return      String
 */
- (void)requestRersumeInfo
{
    NSString * function = @"getPreivewResumeUrlForApp";
    NSString * op   =   @"company_person_busi";
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    
    if ([_userModal.forType isEqualToString:@"0"]) {
        [conditionDic setObject:_forType forKey:@"fortype"];
    }
    else
    {
        if ([_userModal.forType isEqualToString:@"5000"]) { //只有转发给我才有
            [conditionDic setObject:_userModal.sr_id forKey:@"sr_id"];
        }
        else if ([_userModal.forType isEqualToString:@"3000"])
        {
            if (!_userModal.recommendId) {
                _userModal.recommendId = @"";
            }

            [conditionDic setObject:_userModal.recommendId forKey:@"tjid"];
            [conditionDic setObject:_userModal.fromType forKey:@"tjtype"];
        }
        if (_userModal.companyId) {
            [conditionDic setObject:_userModal.companyId forKey:@"reid"];
        }
        if (_userModal.forKey) {
            [conditionDic setObject:_userModal.forKey forKey:@"forkey"];
        }
        if (_userModal.forType) {
            [conditionDic setObject:_userModal.forType forKey:@"fortype"];
        }
        if (!downloadSource) {
            downloadSource = @"";
        }
        [conditionDic setObject:downloadSource forKey:@"download_source"];
        
    }
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *personId;
    if (_userModal.userId_.length > 0) {
        personId = _userModal.userId_;
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
            if ([_loadDelegate respondsToSelector:@selector(finishLoadWithModel:)]) {
                [_loadDelegate finishLoadWithModel:resumeModel];
            }
          
            if (!_previewModel) {
                _previewModel = [[CompanyResumePrevierwModel alloc] init];
            }
            [_previewModel setValuesForKeysWithDictionary:dic];
            if([_previewModel.is_show isKindOfClass:[NSString class]] && [_previewModel.is_show isEqualToString:@"5"]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"简历已经设置保密" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertView.tag = 401;
                [alertView show];
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

-(void)finishLoadWithDelegate{
    if ([_loadDelegate respondsToSelector:@selector(finishLoad)]) {
        [_loadDelegate finishLoad];
    }
}


/*
 *主动投递 2000，一览精选 交付（offer,vph,kpb）3000,(顾问推荐)3001，主动下载4000，转发给我的简历，5000，暂存简历6000，其他的传0
 
 顾问推荐 3001 -> 0   2016.12.22
 */
- (void)setResumeListTypeWithModel:(CompanyResumePrevierwModel *)model
{
    switch ([model.fortype integerValue]) {
        case 2000:  //主动投递
        {
            _resumeListType = ResumeTypePersonDelivery;
            [self setResumeStateWithProcessState:model.process_state];
        }
            break;
        case 4000:  //主动下载
        {
            _resumeListType = ResumeTypeDownload;
            if ([model.process_state isEqualToString:@"0"])
            {//主动下载没有待处理状态，最初状态是合适简历
                model.process_state = @"1";
            }
            [self setResumeStateWithProcessState:model.process_state];
        }
            break;
        case 3000:  //一览精选 交付（offer vph kpb）
        {
            _resumeListType = ResumeTypeAdviserRecommend;
            _resumeState = [model.action_state integerValue];
            [self configOfferOartyUI];
        }
            break;
        case 3001:  //一览精选 顾问推荐
        {
            _resumeListType = ResumeTypeAdviserRecommend;
           
            if ([_previewModel.is_temp isEqualToString:@"1"] && [_previewModel.is_download isEqualToString:@"0"])
            {//已暂存简历但未下载简历走 暂存简历流程
                _resumeListType = ResumeTypeTempSaved;
                [self setBottomBtnForApplyList];
            }
            else
            {
                if ([_previewModel.is_download isEqualToString:@"0"])
                {//未下载
                    _resumeState = ResumeStateToDownload;
                    [self setBottomBtnForApplyList];
                }
                else {
                    if ([model.process_state isEqualToString:@"0"])
                    {//一览精选 顾问推荐没有待处理状态，最初状态是合适简历
                        model.process_state = @"1";
                    }
                    [self setResumeStateWithProcessState:model.process_state];
                }
            }
        }
            break;
        case 5000:  //转发给我
        {
            _resumeListType = ResumeTypeTranspondForMe;
            [self setBottomBtnForApplyList];
        }
            break;
        case 6000:
        {
            [self setBottomBtnForApplyList];
        }
            break;
        case 0:
        {
            if ([_previewModel.is_download isEqualToString:@"0"])
            {//未下载
                if ([_previewModel.is_temp isEqualToString:@"1"]) {
                    _userModal.resumeId = _previewModel.resumeTempId;
                    _resumeListType = ResumeTypeTempSaved;
                    [self setBottomBtnForApplyList];
                }
                else {
                    _resumeState = ResumeStateToDownload;
                    [self setBottomBtnForApplyList];
                }
            }
            else {
                [self setResumeStateWithProcessState:model.process_state];
            }
        }
            break;
        default:
            break;
    }
}

/* 
 主动投递，一览精选-交付（offer vph kpb），主动下载 暂存简历，其他
 设置简历状态
 */
- (void)setResumeStateWithProcessState:(NSString *)processState
{
    //0 待处理，1合适，5，不合适，20 待面试，30已到场，40已面试，60已发offer
    NSArray *array = [[NSArray alloc] initWithObjects:@"0", @"1", @"5", @"20", @"30", @"40", @"60", nil];
    if ([array containsObject:processState]) {
        _webViewBottmSapce.constant = 45;
        _bottomBtnView.hidden = NO;
    }
    else {
        _webViewBottmSapce.constant = 0;
        _bottomBtnView.hidden = YES;
    }
    [self.webView_ layoutIfNeeded];
    
    _resumeState = [processState integerValue];
    [self setBottomBtnForApplyList];
}

#pragma - mark Button触发事件
// 一览精选-交付业务 修改简历状态
/*
 * filetype  @"mianshi" 面试结果   state   @"3" 排队   @“6” 面试合格  @“7” 面试不合格
             @"company" 通过初选   state   2 不通过初选  1 通过初选   3 待确定
             @"offer"   发offer   state   @""
 * conditionArr['role']    = $role;//30顾问20企业10人才40其他
 * conditionArr['role_id']   = $role_id;//企业编号，人才编号，或招聘顾问编号
   updateTjState($tuijianarr,$filetype,$state,$conditionArr);
**/
- (void)changeDeliverResumeWithType:(NSString *)type State:(NSString *)state operationType:(NSString *)operation
{
    NSMutableDictionary *tjresumeDic = [[NSMutableDictionary alloc] init];
    [tjresumeDic setObject:_userModal.companyId forKey:@"reid"];
    [tjresumeDic setObject:_previewModel.forkey forKey:@"id"];
    [tjresumeDic setObject:_companyId forKey:@"company_id"];
    [tjresumeDic setObject:type forKey:@"type"];
    [tjresumeDic setObject:state forKey:@"state"];
    
    
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
    [commentDic setObject:_userModal.zpId_ forKey:@"jobid"];
    [commentDic setObject:noteTextView.text?noteTextView.text:@"" forKey:@"commentContent"];
    [commentDic setObject:operation forKey:@"comment_type"];
    [commentDic setObject:_userModal.userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [commentDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    [commentDic setObject:@"40" forKey:@"company_resume_comment_label_id"];
    [commentDic setObject:@"5" forKey:@"person_type"];
    
    
//    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:@"20" forKey:@"role"];
//    [conditionDic setObject:_companyId forKey:@"role_id"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *tjresumeStr = [jsonWrite stringWithObject:tjresumeDic];
    NSString *commentStr = [jsonWrite stringWithObject:commentDic];
//    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"tjresumeArr=%@&commentArr=%@&conditionArr=&", tjresumeStr, commentStr];
    
    NSString * function = @"updateTjStateNew";
    NSString * op = @"offerpai_busi";
    
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        
        if ([result isEqual:@1]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作成功"];
            [self requestRersumeInfo];
            [self hideEvaluationView];
        }
        else {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"操作失败"];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

#pragma mark - 修改简历状态 非一览精选
// 非一览精选-交付业务 修改简历状态
/**
 * 说明 process_state 0 待处理，1合适（通过初选），5，不合适，20 待面试，30已到场，40已面试，60已发offer
 * @param [type] $forkey     [必须传] $forkey 主键的ID   一般只对应的数据中的 forkey
 * @param [type] $fortype    [必须传]    简历的类型  2000主动投递的 ，0会员服务推荐的, 4000主动下载的，
 * @param [type] $state      [必须传]    修改后的状态的值 传入的是原表的状态值，在 2000,0,4000，是 $state = $process_state
 @param $paramArr['company_id']     [必须传]    企业的id, 传入的是 数据中的 uid,或者是 reid
 @param $conditionArr['company_id']     [必须传]    企业的id, 传入的是 数据中的 uid,或者是 reid
 
 $paramArr['jobid'];
 $paramArr['commentContent'];      //评论的内容
 $paramArr['comment_type'];      //评论的内容标签名
 $paramArr['tags_name'];       //评论的内容标签名 array()
 $paramArr['person_id'];       //评论人
 $paramArr['synergy_m_id'];      //协同账号的ID
 
**/
- (void)changeResumeSate:(NSString *)state comment_type:(NSString *)comment_type
{
    NSString *op = @"company_person_busi";
    NSString *func = @"setCompanyPersonResumeState";
    
    NSMutableDictionary *paramArrDic = [[NSMutableDictionary alloc] init];
    [paramArrDic setObject:_previewModel.reid forKey:@"company_id"];
    [paramArrDic setObject:_userModal.zpId_ forKey:@"jobid"];
    [paramArrDic setObject:noteTextView.text?noteTextView.text:@"" forKey:@"commentContent"];
    [paramArrDic setObject:comment_type forKey:@"comment_type"];
    [paramArrDic setObject:_userModal.userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [paramArrDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    
    if ([state isEqualToString:@"shanggang"]) {
        state = @"1";
        [paramArrDic setObject:@"work" forKey:@"filetype"];
        [paramArrDic setObject:@"60" forKey:@"process_state"];
    }
    NSMutableDictionary *conditionArrDic = [[NSMutableDictionary alloc] init];
    [conditionArrDic setObject:_previewModel.reid forKey:@"company_id"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *paramArrStr = [jsonWriter stringWithObject:paramArrDic];
    NSString *conditionArrStr = [jsonWriter stringWithObject:conditionArrDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"forkey=%@&fortype=%@&state=%@&paramArr=%@&conditionArr=%@", _previewModel.forkey, _previewModel.fortype, state, paramArrStr, conditionArrStr];
    
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        noteTextView.text =@"";
        NSDictionary *dic = result;
        Status_DataModal *model = [[Status_DataModal alloc] init];
        model.status_ = dic[@"status"];
        model.code_ = dic[@"code"];
        model.des_ = dic[@"status_desc"];
        if ([model.code_ isEqualToString:@"200"]) {
            [self requestRersumeInfo];
        }
        [self hideEvaluationView];
        
        [BaseUIViewController showAutoDismissFailView:nil msg:_operatingHints];
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        noteTextView.text =@"";
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
    
}

/**
 * 转发给我的简历 超级统一的接口 App
 * @param [type] $id             [必须传]   $id 主键的sr_id
 * @param [type] $state          [必须传]   1，合适或者面试通过，  5，不合适
 * @$info_arr   ['person_type']  [必须传]   对应数据中的 person_type
 * @$info_arr   ['tradeid']      [必须传]   对应数据中的 tradeid
 * @$info_arr   ['totalid']      [必须传]   对应数据中的 totalid
 * @$info_arr   ['company_id']   [必须传]   对应数据中的 company_id
 * @$info_arr   ['person_id']    [必须传]   对应数据中的 person_id
 * @$info_arr   ['cmailbox_id']  [必须传]   对应数据中的 cmailbox_id
 
 $info_arr['tags_name'] = ''
 $info_arr['comment_type'] = ''      操作的类型，如简历合适，简历不合适，面试通过，不合适
 $info_arr['commentContent']       备注的内容
 */
- (void)updateSendToMeResume:(NSString *)state comment_type:(NSString *)comment_type
{
    NSString *op = @"company_person_busi";
    NSString *func = @"updateSendToMeResume";
    
    NSMutableDictionary *infoArrDic = [[NSMutableDictionary alloc] init];
    [infoArrDic setObject:_previewModel.person_type forKey:@"person_type"];
    [infoArrDic setObject:_previewModel.person_id forKey:@"person_id"];
    [infoArrDic setObject:_previewModel.tradeid forKey:@"tradeid"];
    [infoArrDic setObject:_previewModel.totalid forKey:@"totalid"];
    [infoArrDic setObject:_previewModel.company_id forKey:@"company_id"];
    [infoArrDic setObject:_previewModel.cmailbox_id forKey:@"cmailbox_id"];
    [infoArrDic setObject:comment_type forKey:@"comment_type"];
    [infoArrDic setObject:noteTextView.text?noteTextView.text:@"" forKey:@"commentContent"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *infoArrStr = [jsonWriter stringWithObject:infoArrDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"id=%@&state=%@&info_arr=%@&condition_arr=", _previewModel.sr_id, state, infoArrStr];
    
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        NSDictionary *dic = result;
        Status_DataModal *model = [[Status_DataModal alloc] init];
        model.status_ = dic[@"status"];
        model.code_ = dic[@"code"];
        model.des_ = dic[@"status_desc"];
        if ([model.code_ isEqualToString:@"200"]) {
            [self requestRersumeInfo];
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作成功"];
        }
        else {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"操作失败"];
        }

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
}

#pragma mark - AlertView
- (void)showConfirmation:(int)type
{
    NSString *string;
    switch (type) {
       
        case 103:
        {
            string = @"是否确认通知排队？";
        }
            break;
        case 104:
        {
            string = @"是否确认放弃面试?";
        }
            break;
       
        default:
            break;
    }
//    [self showChooseAlertView:type title:@"提示" msg:string okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = type;
    [alertView show];
}


/*
 发offer成功后把简历状态改为已发offer
 */
- (void)sendOfferSuccess:(NSNotification *)notification
{
    //已发offer
//    _previewModel.action_state = ResumeStateSendOffer;
 
    [self requestRersumeInfo];
}


#pragma mark - 弹出窗
/*
 * 简历不合适传 0  简历合适传 1  待确定传 2
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
            case 200:
            {
                placeholder = @"是否确认将简历设为简历不合适？";
            }
                break;
            case 1:
            case 201:
            {
                placeholder = @"是否确认将简历设为简历合适？";
            }
                break;
            case 2:
            {
                placeholder = @"是否确认将简历设为简历待确定?";
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

- (void)btnAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    if (tag == 100) {
       [self hideEvaluationView];
    }else if (tag -200 < 100){
        [self goodSelectOperationResume:tag];
    }else if (tag -200 >= 200){
        [self noGoodSelectOperationResume:tag];
    }
}

//一览精选简历操作
- (void)goodSelectOperationResume:(NSInteger)tag
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

- (void)noGoodSelectOperationResume:(NSUInteger)tag
{
    switch (tag) {
        case 400:
        {
            if (_resumeListType == ResumeTypeTranspondForMe) {
                [self updateSendToMeResume:@"5" comment_type:@"简历不合适"];
            }
            else {
                [self changeResumeSate:@"5" comment_type:@"简历不合适"];
            }
        }
            break;
        case 401:
        {
            if (_resumeListType == ResumeTypeTranspondForMe) {
                [self updateSendToMeResume:@"1" comment_type:@"简历合适"];
            }
            else {
                [self changeResumeSate:@"1" comment_type:@"简历合适"];
            }
        }
            break;
        case 402:
        {
            if (_resumeListType == ResumeTypeTranspondForMe) {
                [self updateSendToMeResume:@"1" comment_type:@"面试通过"];
            }
            else {
                [self changeResumeSate:@"40" comment_type:@"面试通过"];
            }

        }
            break;
        default:
            break;
    }
}

- (void)hideEvaluationView
{
    [_maskView removeFromSuperview];
    _maskView = nil;
    
    [_bgView removeFromSuperview];
    _bgView = nil;
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

#pragma mark - evaluationDelegate
- (void)refreshResume
{
    [self requestRersumeInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
