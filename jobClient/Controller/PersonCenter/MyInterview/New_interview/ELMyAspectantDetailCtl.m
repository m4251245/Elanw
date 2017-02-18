//
//  ELMyAspectantDetailCtl.m
//  jobClient
//
//  Created by YL1001 on 16/8/1.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELMyAspectantDetailCtl.h"
#import "ELAspectantDiscuss_Modal.h"
#import "MBProgressHUD+Add.h"
#import "ELAddInterviewRegionCtl.h"
#import "Order.h"
#import "PayCtl.h"
#import "ELInterviewFeedBackView.h"
#import "ELInterviewRefundView.h"
#import "AddAppraiseViewCtl.h"
#import "ELExpertStarView.h"

#define Margin 10
#define LeadMargin 8

@interface ELMyAspectantDetailCtl ()<paySuccessDelegate,buttonDelegate,AddInterviewRegionCtlDelegate>
{
    NSMutableArray *_titleArr;
    NSArray *_statuArr;
    
    NSMutableArray *_selectedTimeArr;
    NSMutableArray *_chooseBtnArr;
    NSMutableArray *_placeViewArr;
    NSString *_selectedYdyrStr;    /**<用户选择的时间地点 */
    
    CGFloat _contentHeight;
    
    ELAspectantDiscuss_Modal *_aspDataModal;
    ELAspectantDiscuss_Modal *_interviewModal;
    BOOL _isUser;
    BOOL isRerfesh;
    
    AddAppraiseViewCtl *addAppraiseView;
    ELExpertStarView *starView;
    UIView *_acceptBtnView;
    UIButton *_appraiseBtn;
    UIButton *_finishBtn;
    CGFloat _refundViewHeight;
    
    __weak IBOutlet UIView *_courseInfoView;
    __weak IBOutlet NSLayoutConstraint *_personImgleadSpace;
    __weak IBOutlet UIImageView *_personImg;
    __weak IBOutlet UILabel *_nameLb;
    __weak IBOutlet UILabel *_dateLb;
    __weak IBOutlet UILabel *_courseTitleLb;
    __weak IBOutlet UILabel *_courseTimeLb;
    __weak IBOutlet UILabel *_coursePriceLb;
    
    __weak IBOutlet UIView *_quetionBgView;
    __weak IBOutlet UILabel *_quetionLb;
    
    __weak IBOutlet UIView *_userInfoBgView;
    __weak IBOutlet UILabel *_userInfoLb;
 
    __weak IBOutlet UIView *_phoneBgview;
    __weak IBOutlet UILabel *_phoneLb;
    
    __weak IBOutlet UILabel *_tipsLb;
    __weak IBOutlet NSLayoutConstraint *_tipsLbTopSpace;
    
    __weak IBOutlet UIView *_regionBgView;
    __weak IBOutlet UILabel *_regionTipLb;
    
    __weak IBOutlet UIView *_payBtnView;
    __weak IBOutlet UIButton *_goPayBtn;
    __weak IBOutlet UIButton *_cancelBtn;
    __weak IBOutlet NSLayoutConstraint *_cancelBtnWidth;
    __weak IBOutlet NSLayoutConstraint *_payBtnViewHeight;
    
    __weak IBOutlet NSLayoutConstraint *_infoViewTopSpace;
    __weak IBOutlet NSLayoutConstraint *_infoViewHeight;
    __weak IBOutlet NSLayoutConstraint *_quetionBgViewHeight;
    __weak IBOutlet NSLayoutConstraint *_userInfoBgViewHeight;
    __weak IBOutlet NSLayoutConstraint *_regionBgViewHeight;
    __weak IBOutlet NSLayoutConstraint *_regionBgViewTopSpace;
    __weak IBOutlet NSLayoutConstraint *_scrollViewbottomSpace;
    
    __weak IBOutlet UILabel *statusLb;
    
}
@end

@implementation ELMyAspectantDetailCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"约谈详情"];
    _titleArr = [[NSMutableArray alloc] initWithObjects:@"约谈申请", @"行家接受", @"用户付款", @"完成约谈", @"用户评价", nil];
    _placeViewArr = [[NSMutableArray alloc] init];
    self.scrollView_.hidden = YES;
    _payBtnView.hidden = YES;
    [self configUI];
    [self getRecordInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshdetail:) name:@"refreshDetail" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_contentHeight != 0) {
        self.scrollView_.contentSize = CGSizeMake(ScreenWidth, _contentHeight);
    }
}

- (void)refreshdetail:(NSNotificationCenter *)notifi
{
    [self getRecordInfo];
}

- (void)createChatBtn
{
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatBtn.frame = CGRectMake(ScreenWidth - 50, ScreenHeight - 220, 50, 50);
    [chatBtn setImage:[UIImage imageNamed:@"interviewChat.png"] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chatBtn];
}

- (void)createFinishBtn
{
    _payBtnView.hidden = YES;
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.frame = _payBtnView.frame;
    _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_finishBtn setBackgroundColor:UIColorFromRGB(0xe4403a)];
    [_finishBtn setTitle:@"确认完成" forState:UIControlStateNormal];
    [_finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishBtn];
    
}

- (void)createAppraiseBtn
{
    _appraiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _appraiseBtn.frame = _payBtnView.frame;
    _appraiseBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_appraiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_appraiseBtn setBackgroundColor:UIColorFromRGB(0xe4403a)];
    [_appraiseBtn setTitle:@"评价" forState:UIControlStateNormal];
    [_appraiseBtn addTarget:self action:@selector(appriseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_appraiseBtn];
}

//初始化UI
- (void)configUI
{
    UIView *statusBackView = [[UIView alloc] initWithFrame:CGRectMake(8, 10, ScreenWidth - 2*8, 58)];
    statusBackView.backgroundColor = [UIColor whiteColor];
    statusBackView.layer.cornerRadius = 4.0;
    statusBackView.layer.masksToBounds = YES;
    [self.scrollView_ addSubview:statusBackView];
    
    CGFloat leadSpace = 9;
    CGFloat lbWidth = (statusBackView.frame.size.width - 6*leadSpace) / 5;
    
    CGFloat redPointInterval = (statusBackView.frame.size.width - 30*2 - 10*5)/4;
    
    NSMutableArray *labelArr = [[NSMutableArray alloc] init];
    NSMutableArray *redPointArr = [[NSMutableArray alloc] init];
    NSMutableArray *lineArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < _titleArr.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leadSpace, 35, lbWidth, 16)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x666666);
        label.text = [_titleArr objectAtIndex:i];
        [statusBackView addSubview:label];
        
        leadSpace = leadSpace + lbWidth + 9;
        [labelArr addObject:label];

        CGFloat redPointSpace = (redPointInterval + 10)*i + 30;
        UIImageView *redPointImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_select_off.png"]];
        redPointImg.frame = CGRectMake(redPointSpace, 15, 10, 10);
        [statusBackView addSubview:redPointImg];

        [redPointArr addObject:redPointImg];
        
        
        if (i != _titleArr.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(redPointImg.frame.origin.x + 10, 20, redPointInterval, 1)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [statusBackView addSubview:lineView];

            [lineArr addObject:lineView];
        }
    }
    
    _statuArr  = @[labelArr, redPointArr, lineArr];
    
    _infoViewTopSpace.constant = 76;
    
    _courseInfoView.layer.cornerRadius = 4.0;
    _courseInfoView.layer.masksToBounds = YES;
    
    _courseTimeLb.layer.cornerRadius = 4.0;
    _courseTimeLb.layer.masksToBounds = YES;
    
    _coursePriceLb.layer.cornerRadius = 4.0;
    _coursePriceLb.layer.masksToBounds = YES;
    
    _quetionBgView.layer.cornerRadius = 4.0;
    _quetionBgView.layer.masksToBounds = YES;
    
    _userInfoBgView.layer.cornerRadius = 4.0;
    _userInfoBgView.layer.masksToBounds = YES;
    
    _personImg.layer.cornerRadius = 4.0;
    _personImg.layer.masksToBounds = YES;
}

#pragma mark 加载数据
- (void)changeStatuColorWithModal:(ELAspectantDiscuss_Modal *)dataModal
{
    if ([dataModal.payStatus isEqualToString:@"100"] && [dataModal.status integerValue] < 10) {
        [self createChatBtn];
    }
    
    //进度红点处理
    NSMutableArray *labelArr = _statuArr[0];
    NSMutableArray *redPointArr = _statuArr[1];
    NSMutableArray *lineArr = _statuArr[2];
    
    switch ([dataModal.status integerValue]) {
        case 0:
        {//未接受约谈
            UILabel *label = labelArr[0];
            label.textColor = [UIColor redColor];

            UIImageView *redPointImg = redPointArr[0];
            redPointImg.image = [UIImage imageNamed:@"ico_select_on.png"];
            
            UIView *lineView = lineArr[0];
            lineView.backgroundColor = [UIColor redColor];
        }
            break;
        case 1:
        {//接受约谈，来询者未付款
            for (NSInteger i = 0; i < 2; i++) {
                UILabel *label = labelArr[i];
                label.textColor = [UIColor redColor];
                
                UIImageView *redPointImg = redPointArr[i];
                redPointImg.image = [UIImage imageNamed:@"ico_select_on.png"];
                
                UIView *lineView = lineArr[i];
                lineView.backgroundColor = [UIColor redColor];
            }
            
            if ([dataModal.payStatus isEqualToString:@"100"])
            {//表示已支付
                UILabel *label = labelArr[2];
                label.textColor = [UIColor redColor];
                
                UIImageView *redPointImg = redPointArr[2];
                redPointImg.image = [UIImage imageNamed:@"ico_select_on.png"];
                
                UIView *lineView = lineArr[2];
                lineView.backgroundColor = [UIColor redColor];
            }
        }
            break;
        case 5:
        {//表示至少有一个确认
            for (NSInteger i = 0; i < 3; i++) {
                UILabel *label = labelArr[i];
                label.textColor = [UIColor redColor];
                
                UIImageView *redPointImg = redPointArr[i];
                redPointImg.image = [UIImage imageNamed:@"ico_select_on.png"];
                
                UIView *lineView = lineArr[i];
                lineView.backgroundColor = [UIColor redColor];
            }
            
            if (_isUser)
            {//约谈者
                if ([dataModal.user_confirm isEqualToString:@"1"])
                {//完成约谈
                    /**点亮第四个小红点 */
                    UILabel *label = labelArr[3];
                    label.textColor = [UIColor redColor];
                    UIImageView *redPointImg = redPointArr[3];
                    redPointImg.image = [UIImage imageNamed:@"ico_select_on.png"];
                    UIView *lineView = lineArr[3];
                    lineView.backgroundColor = [UIColor redColor];
                }
            }
            else {
                if ([dataModal.dis_confirm isEqualToString:@"1"])
                {//完成约谈
                    /**点亮第四个小红点 */
                    UILabel *label = labelArr[3];
                    label.textColor = [UIColor redColor];
                    UIImageView *redPointImg = redPointArr[3];
                    redPointImg.image = [UIImage imageNamed:@"ico_select_on.png"];
                    UIView *lineView = lineArr[3];
                    lineView.backgroundColor = [UIColor redColor];
                }
            }
            
            if ([dataModal.isComment isEqualToString:@"1"])
            {// 已经评价
                /**点亮第五个小红点 */
                UILabel *label = labelArr[4];
                label.textColor = [UIColor redColor];
                
                UIImageView *redPointImg = redPointArr[4];
                redPointImg.image = [UIImage imageNamed:@"ico_select_on.png"];
            }

        }
            break;
        default:
            break;
    }
    
    //填充约谈数据
    if (_isUser) {
        
        [_personImg sd_setImageWithURL:[NSURL URLWithString:dataModal.dis_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@发起的约谈", dataModal.dis_personName]];
        [attString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE4403A) range:NSMakeRange(0, dataModal.dis_personName.length)];
        
        _nameLb.attributedText = attString;
    }
    else {
        
        [_personImg sd_setImageWithURL:[NSURL URLWithString:dataModal.user_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        _personImgleadSpace.constant = 8.0f;
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@向我发起的约谈", dataModal.user_name]];
        [attString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE4403A) range:NSMakeRange(0, dataModal.user_name.length)];
        
        _nameLb.attributedText = attString;
    }
    
    _courseTitleLb.text = [NSString stringWithFormat:@"约谈主题：%@", dataModal.course_title];
    [_courseTitleLb sizeToFit];
    _infoViewHeight.constant = CGRectGetMaxY(_courseTitleLb.frame) + 46;
    [_courseInfoView layoutIfNeeded];
    
    _courseTimeLb.text = [NSString stringWithFormat:@" %@小时 ",dataModal.course_long];
    _coursePriceLb.text = [NSString stringWithFormat:@" ￥%@元/次 ",dataModal.course_price];
    _dateLb.text = dataModal.dataTime;
    
    _quetionLb.text = dataModal.question;
    [_quetionLb sizeToFit];
    _quetionBgViewHeight.constant = CGRectGetMaxY(_quetionLb.frame) + 8;
    [_quetionBgView layoutIfNeeded];
    
    _userInfoLb.text = dataModal.quizzerIntro;
    [_userInfoLb sizeToFit];
    _userInfoBgViewHeight.constant = CGRectGetMaxY(_userInfoLb.frame) + 8;
    [_userInfoBgView layoutIfNeeded];
    
    _phoneLb.text = dataModal.phoneNum;
    
    
    if (dataModal.regionArray.count > 0) {
        _regionBgView.hidden = NO;
        [self setInterviewPlaceViewWith:dataModal.regionArray interviewModal:dataModal];
    }
    else {
        _regionBgView.hidden = YES;
    }
    
    [_courseInfoView layoutIfNeeded];
    [_quetionBgView layoutIfNeeded];
    [_userInfoBgView layoutIfNeeded];
    [_phoneBgview layoutIfNeeded];
    [_tipsLb layoutIfNeeded];
    [_regionBgView layoutIfNeeded];
    
    [self isUserIdentifier:_interviewModal];
    
    if (dataModal.refund_id != nil) {
        _finishBtn.hidden = YES;
        [self addRefundView:dataModal];
        _scrollViewbottomSpace.constant = 0;
    }
    
    self.scrollView_.contentSize = CGSizeMake(ScreenWidth, _contentHeight);
}

//判断是约谈者还是被约谈者
- (void)isUserIdentifier:(ELAspectantDiscuss_Modal *)dataModal
{
    if (_isUser)
    {
        _phoneBgview.hidden = YES;
        _cancelBtnWidth.constant = ScreenWidth/2;
        
        _tipsLbTopSpace.constant = 8;
        [_tipsLb layoutIfNeeded];
        if (_tipsLb.hidden) {
            _regionBgViewTopSpace.constant = 8;
        }
        else {
            _regionBgViewTopSpace.constant = (_tipsLb.frame.size.height + 16);
        }
        [_regionBgView layoutIfNeeded];
        
        if ([dataModal.payStatus isEqualToString:@"100"])
        {//表示已支付
            _tipsLb.text = @"你已支付成功，可私信与行家沟通约谈具体事宜";
        }
        
        switch ([dataModal.status integerValue]) {
            case 0:
            {
                _payBtnView.hidden = NO;
                _tipsLb.hidden = YES;
                _goPayBtn.hidden = YES;
                _cancelBtnWidth.constant = ScreenWidth;
            }
                break;
            case 1:
            {//接受约谈，来询者未付款
                _tipsLb.text = @"行家已经接收约谈，并提供了TA比较方便的时间地点供您选择";
                _payBtnView.hidden = NO;
                
                if ([dataModal.payStatus isEqualToString:@"100"])
                {//表示已支付
                    _tipsLb.text = @"你已支付成功，可私信与行家沟通约谈具体事宜";
                    [self addFeedBackView:dataModal];
                }
            }
                break;
            case 5:
            {//表示至少有一个确认
                if ([dataModal.user_confirm isEqualToString:@"1"]) {
                    
                    [self createAppraiseBtn];
                    if ([dataModal.isComment isEqualToString:@"1"]) {// 已经评价
                        [_appraiseBtn removeFromSuperview];
                        _scrollViewbottomSpace.constant = 0;
                        _contentHeight = CGRectGetMaxY(_regionBgView.frame) + Margin;
                    }
                }
                else {
                    [self addFeedBackView:dataModal];
                }
            }
                break;
            case 10:
            {//拒绝约谈
                _tipsLb.text = @"由于行家个人原因，拒绝本次约谈，你可关注下其它约谈话题";
            }
                break;
            default:
                break;
        }
    }
    else {
        
        if ([dataModal.payStatus isEqualToString:@"100"]) {//表示已支付
            _tipsLb.text = @"来询者已付费，可私信沟通约谈具体事宜";
        }
        
        switch ([dataModal.status integerValue]) {
            case 0:
            {
                _tipsLb.hidden = YES;
                _acceptBtnView = [[UIView alloc] init];
                _acceptBtnView.frame = _payBtnView.frame;
                _acceptBtnView.backgroundColor = [UIColor whiteColor];;
                [self.view addSubview:_acceptBtnView];
                
                for (NSInteger i = 0; i < 2; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                    btn.tag = 100 + i;
                    [btn addTarget:self action:@selector(acceptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    if (i == 0) {
                        btn.frame = CGRectMake(0, 0, ScreenWidth/2, _acceptBtnView.frame.size.height);
                        [btn setTitle:@"拒绝约谈" forState:UIControlStateNormal];
                        [btn setBackgroundColor:[UIColor lightGrayColor]];
                    }
                    else
                    {
                        btn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, _acceptBtnView.frame.size.height);
                        [btn setTitle:@"接受约谈" forState:UIControlStateNormal];
                        [btn setBackgroundColor:UIColorFromRGB(0xE4403A)];
                    }
                    [_acceptBtnView addSubview:btn];
                }
            }
                break;
            case 1:
            {//接受约谈，来询者未付款
                _scrollViewbottomSpace.constant = 0;
                [_acceptBtnView removeFromSuperview];
                _acceptBtnView = nil;

                _tipsLb.hidden = YES;
                _regionBgViewTopSpace.constant -= (_tipsLb.frame.size.height + 10);
                [_regionBgView layoutIfNeeded];
                _contentHeight = CGRectGetMaxY(_regionBgView.frame) + Margin;
                
                if ([dataModal.payStatus isEqualToString:@"100"])
                {//表示已支付
                    _tipsLb.text = @"来询者已付费，可私信沟通约谈具体事宜";
                    [self createFinishBtn];
                }
            }
                break;
            case 5:
            {//表示至少有一个确认
                if ([dataModal.dis_confirm isEqualToString:@"1"]) {
                    _scrollViewbottomSpace.constant = 0;
                    
                    if ([dataModal.isComment isEqualToString:@"1"]) {// 已经评价
                        _scrollViewbottomSpace.constant = 0;
                    }
                }
                else {
                    [self createFinishBtn];
                }
                
            }
                break;
            case 10:
            {//拒绝约谈
                _tipsLb.text = @"您已拒绝本次约谈";
            }
                break;
            default:
                break;
        }
        
        _phoneBgview.hidden = NO;
        [_tipsLb layoutIfNeeded];
        if (_tipsLb.hidden) {
            _regionBgViewTopSpace.constant = 2*Margin + _phoneBgview.frame.size.height;
        }
        else {
            _regionBgViewTopSpace.constant = 3*Margin + _phoneBgview.frame.size.height + _tipsLb.frame.size.height;
        }
        [_regionBgView layoutIfNeeded];
    }
    
    
    if ([dataModal.status integerValue] == 10) {
        //拒绝约谈
        _scrollViewbottomSpace.constant = 0;
    }
    else if ([dataModal.status integerValue] == 11)
    {
        //来询者取消订单
        CGFloat height = 0;
        if (dataModal.regionArray.count > 0) {
            height = CGRectGetMaxY(_regionBgView.frame) + Margin;
        }
        else {
            if (_isUser) {
                height = CGRectGetMaxY(_userInfoBgView.frame) + Margin;
                
            }
            else {
                height = CGRectGetMaxY(_phoneBgview.frame) + Margin;
            }
            _tipsLb.hidden = YES;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, height, ScreenWidth - 16, 18)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x666666);
        label.font = TWEELVEFONT_COMMENT;
        if (_isUser) {
            label.text = @"您已取消该订单";
        }
        else {
            label.text = @"来询者已取消该订单";
        }
        [self.scrollView_ addSubview:label];
        
        _contentHeight = CGRectGetMaxY(label.frame) + Margin;
        _scrollViewbottomSpace.constant = 0;
    }
    
    self.scrollView_.hidden = NO;
}

#pragma mark - 显示行家提供的时间、地点
- (void)setInterviewPlaceViewWith:(NSMutableArray *)placeArray interviewModal:(ELAspectantDiscuss_Modal *)interModal
{
    CGFloat height = 30;
    _selectedTimeArr = [[NSMutableArray alloc] init];
    _chooseBtnArr = [[NSMutableArray alloc] init];
    
    CGFloat imgMarGinX = 8;
    CGFloat lbMarginX = 28;
    
    for (UIView *view in _placeViewArr) {
        [view removeFromSuperview];
    }
    if (_placeViewArr.count > 0) {
        [_placeViewArr removeAllObjects];
    }
    
    NSInteger isSelectNum = 0;
    if ([interModal.payStatus isEqualToString:@"100"]) {
        for (ELAspectantDiscuss_Modal *modal in interModal.regionArray) {
            if ([modal.ydyrIsmain isEqualToString:@"0"]) {
                isSelectNum ++;
            }
        }
        
        UIView *interviewPlaceView = [[UIView alloc] initWithFrame:CGRectMake(8, height, (_regionBgView.frame.size.width - 2*LeadMargin), 55)];
        interviewPlaceView.backgroundColor = [UIColor clearColor];
        interviewPlaceView.layer.cornerRadius = 8.0;
        interviewPlaceView.layer.borderWidth = 1.0;
        interviewPlaceView.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
        [_regionBgView addSubview:interviewPlaceView];
        [_placeViewArr addObject:interviewPlaceView];
        
        UILabel *timeLb = [[UILabel alloc] initWithFrame:CGRectMake(lbMarginX, 30, 230, 18)];
        timeLb.textColor = UIColorFromRGB(0x666666);
        timeLb.font = TWEELVEFONT_COMMENT;
        [interviewPlaceView addSubview:timeLb];
        
        UILabel *placeLb = [[UILabel alloc] initWithFrame:CGRectMake(imgMarGinX, 8, 250, 18)];
        placeLb.textColor = UIColorFromRGB(0x333333);
        placeLb.font = TWEELVEFONT_COMMENT;
        [interviewPlaceView addSubview:placeLb];
        
        if (isSelectNum == placeArray.count) {//用户自定义时间地点
            
            timeLb.frame = CGRectMake(8, 30, 278, 18);
            timeLb.text = @"行家提供的时间地点若不合适，可支付后私信沟通";
            placeLb.text = @"自行与行家沟通";
        }
        else
        {//用户选择行家提供的时间地点
            ELAspectantDiscuss_Modal *modal = [interModal.regionArray firstObject];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgMarGinX, 33, 12, 12)];
            imageView.image = [UIImage imageNamed:@"interview_time.png"];
            [interviewPlaceView addSubview:imageView];
            
            timeLb.text = modal.ydyrDatetime;
            placeLb.text = modal.region;
            
        }
        
        _regionBgViewHeight.constant = CGRectGetMaxY(interviewPlaceView.frame) + Margin;
    }
    else
    {//未支付
        NSInteger count;
        if ([interModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_])
        {//约谈发起者
            count = placeArray.count + 1;
        }
        else {
            count = placeArray.count;
        }
        
        for (NSInteger i = 0; i < count; i++) {
            ELAspectantDiscuss_Modal *modal = [[ELAspectantDiscuss_Modal alloc] init];
            if (i < placeArray.count) {
                modal = [interModal.regionArray objectAtIndex:i];
            }
            
            UIView *interviewPlaceView = [[UIView alloc] initWithFrame:CGRectMake(8, height, (_regionBgView.frame.size.width - 2*LeadMargin), 55)];
            interviewPlaceView.backgroundColor = [UIColor clearColor];
            interviewPlaceView.layer.cornerRadius = 8.0;
            interviewPlaceView.layer.borderWidth = 1.0;
            interviewPlaceView.tag = 10000 + i;
            interviewPlaceView.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
            [_regionBgView addSubview:interviewPlaceView];
            [_placeViewArr addObject:interviewPlaceView];
            
            if ([interModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_])
            {//约谈发起者
                CGFloat btnX = CGRectGetMaxX(interviewPlaceView.frame) - LeadMargin - 18 - 9;
                UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 14, 18, 18)];
                [chooseBtn setImage:[UIImage imageNamed:@"interview_no_select.png"] forState:UIControlStateNormal];
                [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                chooseBtn.tag = 10000 + i;
                [interviewPlaceView addSubview:chooseBtn];
                [_chooseBtnArr addObject:chooseBtn];
            }
            
            if (i < placeArray.count) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgMarGinX, 33, 12, 12)];
                imageView.image = [UIImage imageNamed:@"interview_time.png"];
                [interviewPlaceView addSubview:imageView];
            }
            
            UILabel *timeLb = [[UILabel alloc] initWithFrame:CGRectMake(lbMarginX, 30, 230, 18)];
            if (i == placeArray.count) {
                timeLb.frame = CGRectMake(8, 30, 278, 18);
                timeLb.text = @"行家提供的时间地点若不合适，可支付后私信沟通";
            }
            else {
                timeLb.text = modal.ydyrDatetime;
            }
            
            timeLb.textColor = UIColorFromRGB(0x666666);
            timeLb.font = TWEELVEFONT_COMMENT;
            [interviewPlaceView addSubview:timeLb];
            
            UILabel *placeLb = [[UILabel alloc] initWithFrame:CGRectMake(imgMarGinX, 8, 250, 18)];
            if (i == placeArray.count) {
                placeLb.frame = CGRectMake(8, 8, 230, 18);
                placeLb.text = @"自行与行家沟通";
            }
            else {
                placeLb.text = modal.region;
            }
            
            placeLb.textColor = UIColorFromRGB(0x333333);
            placeLb.font = TWEELVEFONT_COMMENT;
            [interviewPlaceView addSubview:placeLb];
            
            [_selectedTimeArr addObject:modal];
            height = CGRectGetMaxY(interviewPlaceView.frame) + 8;
            
            _regionBgViewHeight.constant = height;
        }
    }
    
    [_regionBgView layoutIfNeeded];
    _contentHeight = _regionBgView.frame.origin.y + _regionBgView.frame.size.height + Margin;
}

//增加退款的view
- (void)addRefundView:(ELAspectantDiscuss_Modal *)dataModal
{
    UIView *view = [self.view viewWithTag:990];
    if (view) {
        [view removeFromSuperview];
    }
    [_regionBgView layoutIfNeeded];

    ELInterviewRefundView *refundView = [[ELInterviewRefundView alloc] init];
    refundView.tag = 990;
    refundView.frame = CGRectMake(Margin, _regionBgView.origin.y + _regionBgView.size.height + Margin, ScreenWidth - 2*Margin, 80);
    [refundView refundStatus:dataModal];
    [self.scrollView_ addSubview:refundView];
    
    _contentHeight = refundView.origin.y + refundView.size.height + Margin;
}

//显示反馈View
- (void)addFeedBackView:(ELAspectantDiscuss_Modal *)dataModal
{
    ELInterviewFeedBackView *feedBackView = [[ELInterviewFeedBackView alloc] initWithFrame:CGRectMake(LeadMargin, Margin, ScreenWidth-2*LeadMargin, 94) Modal:dataModal];
    feedBackView.frame = CGRectMake(LeadMargin, CGRectGetMaxY(_regionBgView.frame) + Margin, ScreenWidth-2*LeadMargin, 94);
    feedBackView.tag = 100;
    feedBackView.layer.cornerRadius = 4.0f;
    feedBackView.layer.masksToBounds = YES;
    [self.scrollView_ addSubview:feedBackView];
    
    _contentHeight = CGRectGetMaxY(feedBackView.frame) + Margin;
    if (_isUser) {
        [self createFinishBtn];
    }
}

#pragma mark - 点击事件
//支付、取消订单
- (IBAction)payBtnClick:(id)sender {
    
    if (sender == _goPayBtn) {//用户支付
        if (_selectedYdyrStr == nil) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请选择时间和地点"];
            self.scrollView_.contentOffset = CGPointMake(0, self.scrollView_.contentSize.height - self.scrollView_.bounds.size.height);
        }
        else {
            isRerfesh = YES;
            [Manager shareMgr].yuetanBackCtl = self;
            [self payInterviewCourse];
        }
    }
    else {//用户取消订单
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定取消该订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        [alertView show];
    }
}


//用户选择时间地点 按钮点击事件
- (void)chooseBtnClick:(UIButton *)sender
{
    for (UIButton *btn in _chooseBtnArr) {
        if (btn.tag == sender.tag) {
            [sender setImage:[UIImage imageNamed:@"interview_select.png"] forState:UIControlStateNormal];
            ELAspectantDiscuss_Modal *modal = [_selectedTimeArr objectAtIndex:sender.tag - 10000];
            if (modal.ydyrId == nil) {
                modal.ydyrId = @"";
            }
            _selectedYdyrStr = modal.ydyrId;
        }
        else {
            [btn setImage:[UIImage imageNamed:@"interview_no_select.png"] forState:UIControlStateNormal];
        }
    }
}

//行家接受或拒绝约谈
- (void)acceptBtnClick:(UIButton *)sender
{
    if (sender.tag == 101) {
        isRerfesh = YES;
        ELAddInterviewRegionCtl *ctl = [[ELAddInterviewRegionCtl alloc] init];
        ctl.delegate = self;
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:_aspDataModal exParam:nil];
    }
    else if (sender.tag == 100) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否确定拒绝该约谈" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        [alertView show];
    }
}

//确认完成
- (void)finishBtnClick
{
    NSString *userId = [Manager getUserInfo].userId_;
    NSString * function = @"finishYuetan";
    NSString * op = @"yuetan_record_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@",userId,_aspDataModal.recordId];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        
        Status_DataModal *statusModal = [[Status_DataModal alloc] init];
        statusModal.status_ = [dic objectForKey:@"status_desc"];
        statusModal.code_ = [dic objectForKey:@"code"];
        
        if ([statusModal.code_ isEqualToString:@"200"]) {
            if ([_interviewModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_]) {
                
                UIView *feedView = [self.view viewWithTag:100];
                if ([feedView isKindOfClass:[ELInterviewFeedBackView class]]) {
                    [feedView removeFromSuperview];
                }
                [_finishBtn removeFromSuperview];
            }
            else {
                [_finishBtn removeFromSuperview];
            }
            
            [self getRecordInfo];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

//评价
- (void)appriseBtnClick
{
    if (!addAppraiseView) {
        addAppraiseView = [[AddAppraiseViewCtl alloc] init];
        addAppraiseView.view.frame = [UIScreen mainScreen].bounds;
        addAppraiseView.btnDelegate = self;
    }
    [addAppraiseView showViewCtl];
    if (!starView) {
        starView = [[ELExpertStarView alloc] initWithFrame:CGRectMake(10,25,200,30)];
        starView.selectedBtn = YES;
        [addAppraiseView.bgView_ addSubview:starView];
    }
    [starView giveDataWithStar:5];
}

- (void)chatBtnClick
{
    isRerfesh = YES;
    MessageDailogListCtl *messageCtl = [[MessageDailogListCtl alloc] init];
    MessageContact_DataModel *contactModal = [[MessageContact_DataModel alloc] init];
    
    if ([_aspDataModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_]) {
        contactModal.userId = _aspDataModal.dis_personId;
        contactModal.userIname = _aspDataModal.dis_personName;
    }else
    {//被约谈者
        contactModal.userId = _aspDataModal.user_personId;
        contactModal.userIname = _aspDataModal.user_name;
    }
    messageCtl.productType = @"1";
    messageCtl.recordId = _aspDataModal.recordId;
    [self.navigationController pushViewController:messageCtl animated:YES];
    [messageCtl beginLoad:contactModal exParam:nil];
    
  
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1000:
        {//确认是否取消订单
            if (buttonIndex == 1) {
                [self cannelMyCourseRecord];
            }
        }
            break;
        case 100:
        {//确认是否拒绝约谈
            if (buttonIndex == 1) {
                [self acceptOrrefuseInterview:@"reject"];
            }
        }
            break;
        case 1001:
        {//是否提出申诉
            if (buttonIndex == 1) {
                NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@",[Manager getUserInfo].userId_,_aspDataModal.recordId];
                
                [ELRequest postbodyMsg:bodyMsg op:@"yuetan_refund_busi" func:@"addRefundShenshu" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                    
                    Status_DataModal *statuModel = [[Status_DataModal alloc] init];
                    statuModel.status_ = result[@"status"];
                    statuModel.code_ = result[@"code"];
                    statuModel.status_desc = result[@"status_desc"];
                    if ([statuModel.code_ isEqualToString:@"200"]) {
                        [BaseUIViewController showAutoDismissSucessView:nil msg:@"提交申诉成功" seconds:2.0];
                    }
                    
                } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark AddInterviewRegionSuccess
- (void)addInterviewRegionSuccess
{
    [self getRecordInfo];
}

#pragma mark 支付成功回调
- (void)interviewPaySuccess
{
    if (![_selectedYdyrStr isEqualToString:@""]) {
        [self chooseTheTiemAndRegion];
    }
}

#pragma mark AddAppraiseViewCtlDelegate
- (void)btnResponeWitnIndex:(NSInteger)index
{
    if (index == 111) {
        
        [self hideView];
        
        if ([addAppraiseView.textView_.text isEqualToString:@""]) {
            [addAppraiseView showTextOnly];
        }
        else {
            NSString *userId = [Manager getUserInfo].userId_;
            NSString * function = @"addComment";
            NSString * op = @"yuetan_record_busi";
            
            NSMutableDictionary *commentInfoDic = [[NSMutableDictionary alloc] init];
            [commentInfoDic setObject:addAppraiseView.textView_.text forKey:@"content"];
            
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *commentInfoStr = [jsonWriter stringWithObject:commentInfoDic];
            
            NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&commentInfo=%@",userId,_aspDataModal.recordId,commentInfoStr];
            
            [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                NSDictionary *dic = result;
                
                Status_DataModal *statusModal = [[Status_DataModal alloc] init];
                
                statusModal.status_ = [dic objectForKey:@"status_desc"];
                statusModal.code_ = [dic objectForKey:@"code"];
                if ([statusModal.code_ isEqualToString:@"200"]) {
                    [BaseUIViewController showAutoDismissSucessView:nil msg:@"评价成功"];
                    
                    [_appraiseBtn removeFromSuperview];
                    [self getRecordInfo];
                }
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                
            }];
        }
    }
    else {
        [self hideView];
    }
}

- (void)setTextViewLayout
{
    CGFloat height = 120;
    if (ScreenHeight > 480) {
        height = 220;
    }
    if (addAppraiseView.isEdit)
    {
        addAppraiseView.bgViewCenterY.constant = height-(ScreenHeight/2);
        [UIView animateWithDuration:0.26 animations:^{
            [addAppraiseView.view layoutIfNeeded];
        }];
        addAppraiseView.tipLb_.text = @"";
        addAppraiseView.isEdit = NO;
    }
}

- (void)hideView
{
    if (!addAppraiseView.isEdit) {
        CGRect frame = addAppraiseView.bgView_.frame;
        frame.origin.y = 150;
        addAppraiseView.bgView_.frame = frame;
        addAppraiseView.isEdit = YES;
        
        if ([addAppraiseView.textView_.text isEqualToString:@""]) {
            addAppraiseView.textView_.text = @"";
            addAppraiseView.tipLb_.text = @"输入对行家回答的看法";
        }
    }
    [addAppraiseView.view removeFromSuperview];
}

#pragma mark - 请求约谈数据
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    _aspDataModal = dataModal;
//    [self getRecordInfo];
}

- (void)getRecordInfo
{
    NSString *op = @"yuetan_record_busi";
    NSString *function = @"getRecordInfo";
    
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId forKey:@"login_person_id"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"record_id=%@&conditionArr=%@", _aspDataModal.recordId,conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:YES progressMsg:nil success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        
        ELAspectantDiscuss_Modal *aspDisModal = [[ELAspectantDiscuss_Modal alloc] initWithAspectantDictionary:dic];
        _interviewModal = aspDisModal;
        
        if ([[Manager getUserInfo].userId_ isEqualToString:_interviewModal.YTZ_id]) {
            _isUser = YES;
        }
        else {
            _isUser = NO;
        }
        if([[Manager getUserInfo].userId_ isEqualToString:_interviewModal.user_personId]){
            statusLb.text = @"我的情况";
        }
        else{
            statusLb.text = @"TA的情况";
        }

        
        [self changeStatuColorWithModal:_interviewModal];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

/**
 * 用户取消约谈的订单
 * @param  interger $person_id    用户
 * @param  interger $record_id    约谈记录
 * @param  array    外部条件数组
 * @return
 */
#pragma mark 用户取消约谈的订单
- (void)cannelMyCourseRecord
{
    NSString *op = @"yuetan_record_busi";
    NSString *function= @"cannelMyCourseRecord";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&conditionArr=%@", [Manager getUserInfo].userId_, _aspDataModal.recordId, nil];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        if ([result[@"status"] isEqualToString:@"OK"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}


/**
 * 行家处理约谈请求
 * @param  integer $hangjia_id
 * @param  integer $record_id   约谈记录
 * @param  string  $deal_type   accept表示接受
 *                              reject表示拒绝
 * @return {"status":"OK","code":"200","status_desc":"您已接受该约谈！"}
 *         {"status":"OK","code":"201","status_desc":"您已拒绝该约谈！"}
 */
#pragma mark 行家接受或拒接约谈
- (void)acceptOrrefuseInterview:(NSString *)flag
{
    NSString *op = @"yuetan_record_busi";
    NSString *function= @"hangjiaDoCourseRequest";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"hangjia_id=%@&record_id=%@&deal_type=%@", _aspDataModal.dis_personId, _aspDataModal.recordId, flag];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        Status_DataModal *dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = result[@"status"];
        dataModal.code_ = result[@"code"];
        dataModal.status_desc = result[@"status_desc"];
        if ([dataModal.code_ isEqualToString:@"201"]){
            [BaseUIViewController showAutoDisappearAlertView:nil msg:@"您已拒绝该约谈！" seconds:1.5];
            _tipsLb.text = @"行家拒绝您的请求，若对处理结果不满意，您可私信一览小助手进行调解";
            [self.navigationController popViewControllerAnimated:YES];
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

/**
 * 用户选择行家提供的（时间+地点）组合
 * @param  interger $person_id    普通用户
 * @param  interger $record_id    约谈记录
 * @param  interger $ydyr_id      选择的地点
 * @param  array    $conditionArr 外部条件数组
 * @return {"status":"OK","code":"200"}
 */
#pragma mark 用户选择行家提供的（时间+地点）组合
- (void)chooseTheTiemAndRegion
{
    NSString *func = @"chooseTheTiemAndRegion";
    NSString *op = @"yl_daoshi_yuetan_region_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&ydyr_id=%@&conditionArr=%@", [Manager getUserInfo].userId_, _aspDataModal.recordId, _selectedYdyrStr, nil];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        if ([result[@"status"] isEqualToString:@"OK"])
        {
            [self getRecordInfo];
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

/**
 * 确认支付
 *
 * @param  interger $person_id    当前用户
 * @param  interger $record_id    生成的约谈记录（使用之前需先执行addYuetan()，然后根据返回值中的["info"]["record_id"]来获取)
 * @param  array    $conditionArr
 * @return 参考原来的ordco_service_comm->addgwc 返回值
 */
#pragma mark 用户支付订单
- (void)payInterviewCourse
{
    NSString *op = @"yuetan_record_busi";
    NSString *function= @"payMyYuetanCourse";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&conditionArr=%@", [Manager getUserInfo].userId_, _aspDataModal.recordId, nil];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        if ([result[@"status"] isEqualToString:@"SUCCESS"])
        {
            NSString *orderId = result[@"gwc_id"];
            Order *order = [[Order alloc]init];
            order.tradeNO = orderId;
            order.productName = result[@"subject"];
            order.productDescription = result[@"body"];
            order.amount = result[@"payfree"];
            
            PayCtl *payctl = [[PayCtl alloc] init];
            payctl.delegate = self;
            [Manager shareMgr].payType = PayTypeDiscuss;
            payctl.order = order;
            [self.navigationController pushViewController:payctl animated:YES];
            [payctl beginLoad:nil exParam:nil];
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
