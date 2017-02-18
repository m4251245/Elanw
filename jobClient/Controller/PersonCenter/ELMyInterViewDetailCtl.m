//
//  ELMyInterViewDetailCtl.m
//  jobClient
//
//  Created by YL1001 on 15/11/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELMyInterViewDetailCtl.h"
#import "ELAspectantDiscuss_Modal.h"
#import "ELRequest.h"
#import "Manager.h"
#import "Order.h"
#import "PayCtl.h"
#import "ELAddInterviewRegionCtl.h"
#import "AddAppraiseViewCtl.h"
#import "ELExpertStarView.h"
#import "ELInterviewRefundCtl.h"
#import "ELRefusedRefundCtl.h"

//#define screenHeight [UIScreen mainScreen].bounds.size.height
//#define screenWidth [UIScreen mainScreen].bounds.size.width
#define Margin 10
#define LeadMargin 8

@interface ELMyInterViewDetailCtl ()<UIAlertViewDelegate,buttonDelegate,paySuccessDelegate>
{
    AddAppraiseViewCtl *addAppraiseView;
    ELExpertStarView *starView;
    
    ELAspectantDiscuss_Modal *aspDataModal;
    ELAspectantDiscuss_Modal *interviewModal;
    NSMutableArray *regionArray;
    BOOL isRerfesh;
    
    IBOutlet UIButton *chatBtn;   /**<私信Btn */
    IBOutlet UIView *bgView2;  /**<存放约谈卡片的时间价格 */
    
    IBOutlet UIView *phoneBgView;
    IBOutlet UILabel *phoneNumLb;  /**<联系电话 */
    
    IBOutlet UIButton *finishBtn;  /**<完成约谈Btn */
    IBOutlet UIButton *appraiseBtn; /**<评价Btn */
    
    IBOutlet UIView *feedbackView;  /**<反馈View */
    IBOutlet UIButton *refundBtn;   /**<申请退款 */
    IBOutlet UIButton *helperBtn;   /**<一览小助手 */
    
    NSString *selectedYdyrStr;    /**<用户选择的时间地点 */
    NSMutableArray *selectedTimeArr; /**<存放行家提供的约谈时间地点 */
    NSMutableArray *chooseBtnArr;    /**<存放约谈时间地点选择按钮 */
    NSMutableArray *placeViewArr;
    
    UIView *refundStatuView;
    UIButton *shenSuBtn;
}
@end

@implementation ELMyInterViewDetailCtl

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"约谈详情";
    self.toolbarHolder.hidden = YES;
    chatBtn.hidden = YES;
    
    bgView.layer.cornerRadius = 4.0;
    bgView.layer.masksToBounds = YES;
    
    bgView1.layer.cornerRadius = 4.0;
    bgView1.layer.masksToBounds = YES;
    
    phoneBgView.layer.cornerRadius = 4.0;
    phoneBgView.layer.masksToBounds = YES;
    
    interviewInfoView.layer.cornerRadius = 4.0;
    interviewInfoView.layer.masksToBounds = YES;
    
    ytzRefundView.layer.cornerRadius = 4.0;
    ytzRefundView.layer.masksToBounds = YES;
    
    bytzRefundView.layer.cornerRadius = 4.0;
    bytzRefundView.layer.masksToBounds = YES;
    
    headerView.layer.cornerRadius = 4.0;
    headerView.layer.masksToBounds = YES;
    
    timeAndPlaceView.layer.cornerRadius = 4.0;
    timeAndPlaceView.layer.masksToBounds = YES;
    
    personImg.layer.cornerRadius = 19.0;
    personImg.layer.masksToBounds = YES;
    
    agreeRefundBtn.layer.cornerRadius = 4.0;
    noRefundBtn.layer.cornerRadius = 4.0;
    
    DetailBgView.layer.masksToBounds = YES;
    
    coursePriceLb.layer.cornerRadius = 4.0;
    coursePriceLb.layer.masksToBounds = YES;
    
    courseTimeLb.layer.cornerRadius = 4.0;
    courseTimeLb.layer.masksToBounds = YES;
    
    feedbackView.layer.cornerRadius = 4.0;
    feedbackView.layer.masksToBounds = YES;
    
    CGRect bgFrame = DetailBgView.frame;
    bgFrame.origin.y = 68;
    bgFrame.origin.x = 0;
    DetailBgView.frame = bgFrame;
    [self.scrollView_ addSubview:DetailBgView];
    
    placeViewArr = [[NSMutableArray alloc] init];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    aspDataModal = dataModal;
    [self getRecordInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.hidden = YES;
    if (isRerfesh) {
        [self refreshLoad:nil];
    }
    self.navigationItem.title = @"约谈详情";
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationItem.title = @"";
}

- (void)getDataFunction:(RequestCon *)con
{
    [self getRecordInfo];
}

#pragma mark - 加载约谈数据
- (void)getRecordInfo
{
    NSString *op = @"yuetan_record_busi";
    NSString *function = @"getRecordInfo";
    
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId forKey:@"login_person_id"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"record_id=%@&conditionArr=%@",aspDataModal.recordId,conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        NSDictionary *dic = result;
        
        ELAspectantDiscuss_Modal *aspDisModal = [[ELAspectantDiscuss_Modal alloc] init];
        aspDisModal.phoneNum = dic[@"person_mobile"];
        aspDisModal.recordId = dic[@"record_id"];
        aspDisModal.YTZ_id = dic[@"person_id"];
        aspDisModal.BYTZ_Id = dic[@"yuetan_person_id"];
        aspDisModal.course_id = dic[@"course_id"];
        aspDisModal.payStatus = dic[@"yuetan_pay_status"];
        
        aspDisModal.status = dic[@"yuetan_status"];
        aspDisModal.user_confirm = dic[@"confirm_person"];
        aspDisModal.dis_confirm = dic[@"confirm_yuetan_person"];
        aspDisModal.isInCome = dic[@"is_income"];
        aspDisModal.dataTime = dic[@"idatetime"];
        aspDisModal.isComment = dic[@"_is_comment"];
        
        aspDisModal.question = dic[@"yuetan_question"];
        aspDisModal.quizzerIntro = dic[@"yuetan_intro"];
        aspDisModal.course_title = dic[@"course_info"][@"course_title"];
        aspDisModal.course_price = dic[@"course_info"][@"course_price"];
        aspDisModal.course_long = dic[@"course_info"][@"course_long"];
        
        if ([[Manager getUserInfo].userId_ isEqualToString:aspDisModal.YTZ_id]) {
            aspDisModal.user_personId = [Manager getUserInfo].userId_;
            aspDisModal.user_name = [Manager getUserInfo].name_;
            aspDisModal.user_pic = [Manager getUserInfo].img_;
            
            aspDisModal.dis_personId = dic[@"_yuetan_person_detail"][@"personId"];
            aspDisModal.dis_personName = dic[@"_yuetan_person_detail"][@"person_iname"];
            aspDisModal.dis_pic = dic[@"_yuetan_person_detail"][@"person_pic"];
        }
        else
        {
            aspDisModal.user_personId = dic[@"_person_detail"][@"personId"];
            aspDisModal.user_name = dic[@"_person_detail"][@"person_iname"];
            aspDisModal.user_pic = dic[@"_person_detail"][@"person_pic"];
            
            aspDisModal.dis_personId = [Manager getUserInfo].userId_;
            aspDisModal.dis_personName = [Manager getUserInfo].name_;
            aspDisModal.dis_pic = [Manager getUserInfo].img_;
        }

        NSArray *regionArr = dic[@"_region_list"];
        if (![regionArr isEqual:[NSNull null]]) {
            regionArray = [[NSMutableArray alloc] init];
            for (NSDictionary *regionDic in regionArr) {
                ELAspectantDiscuss_Modal *modal = [[ELAspectantDiscuss_Modal alloc] init];
                modal.ydyrId = regionDic[@"ydyr_id"];
                modal.ydyrIsmain = regionDic[@"ydyr_ismain"];  //1已选择  0未选择地点
                modal.ydyrDatetime = regionDic[@"ydyr_datetime"];
                modal.ydrId = regionDic[@"ydr_id"];
                modal.region = regionDic[@"_region"];
                
                modal.region = [MyCommon translateHTML:modal.region];
                
                [regionArray addObject:modal];
                if ([modal.ydyrIsmain isEqualToString:@"1"]) {
                    aspDisModal.ydyrIsmain = modal.ydyrIsmain;
                    [regionArray removeAllObjects];
                    [regionArray addObject:modal];
                    
                    if ([[Manager getUserInfo].userId_ isEqualToString:aspDisModal.YTZ_id]) {
                        tipsLb2.text = @"我选择的约谈时间和地点:";
                    }
                    else
                    {
                        tipsLb2.text = @"来询者选择的约谈时间和地点:";
                    }
                    break;
                }
                else
                {
                    if ([[Manager getUserInfo].userId_ isEqualToString:aspDisModal.YTZ_id])
                    {
                        tipsLb2.text = @"行家比较方便的约谈时间和地点:";
                    }
                    else
                    {
                        tipsLb2.text = @"我提供的约谈时间和地点:";
                    }
                }
            }
            tipsLb1.text = @"行家已经接收约谈，并提供了TA比较方便的时间地点供您选择";
        }
        else
        {
            tipsLb1.text = @"行家已经接收约谈，你可支付后与行家私信沟通约谈时间和地点";
        }
        
        @try {
            aspDisModal.refund_id = dic[@"_refund_info"][@"refund_id"];
            aspDisModal.ordco_id = dic[@"_refund_info"][@"ordco_id"];
            aspDisModal.refund_reason = dic[@"_refund_info"][@"refund_reason"];
            aspDisModal.refuse_reason = dic[@"_refund_info"][@"refuse_reason"];
            aspDisModal.refund_status = dic[@"_refund_info"][@"status"];
           
            aspDisModal.apply_idatetime = dic[@"_refund_info"][@"idatetime"];
            aspDisModal.refuse_idatetime = dic[@"_refund_info"][@"refuse_idatetime"];
            aspDisModal.acceptRefuseTime = dic[@"_refund_info"][@"accept_idatetime"];
            aspDisModal.appeal_idatetime = dic[@"_refund_info"][@"shenshu_idatetime"];
            aspDisModal.refund_idatetime = dic[@"_refund_info"][@"refund_idatetime"];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        aspDisModal.question = [MyCommon translateHTML:aspDisModal.question];
        aspDisModal.quizzerIntro = [MyCommon translateHTML:aspDisModal.quizzerIntro];
        aspDisModal.course_title = [MyCommon translateHTML:aspDisModal.course_title];
        aspDisModal.refund_reason = [MyCommon translateHTML:aspDisModal.refund_reason];
        aspDisModal.refuse_reason = [MyCommon translateHTML:aspDisModal.refuse_reason];
        aspDisModal.user_name = [MyCommon translateHTML:aspDisModal.user_name];
        aspDisModal.dis_personName = [MyCommon translateHTML:aspDisModal.dis_personName];
        
        interviewModal = aspDisModal;
        [self updateData:aspDisModal];
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

#pragma mark - 约谈详情内容
- (void)updateData:(ELAspectantDiscuss_Modal *)dataModal
{
    courseTimeLb.text = [NSString stringWithFormat:@"%@小时",dataModal.course_long];
    coursePriceLb.text = [NSString stringWithFormat:@"￥%@元/次",dataModal.course_price];
    dateLb.text = dataModal.dataTime;
    
    //设置interviewInfoView的frame
    titleLb.text = [NSString stringWithFormat:@"约谈主题：%@", dataModal.course_title];
    [titleLb sizeToFit];
    
    CGRect frame = bgView2.frame;
    frame.origin.y = CGRectGetMaxY(titleLb.frame) + 3;
    bgView2.frame = frame;
    
    frame = interviewInfoView.frame;
    frame.size.height = CGRectGetMaxY(bgView2.frame) + Margin;
    interviewInfoView.frame = frame;
    
    //设置contentBgView的frame
    questionLb.text = dataModal.question;
    [questionLb sizeToFit];
    
    frame = bgView1.frame;
    frame.size.height = CGRectGetMaxY(questionLb.frame) + 5;
    frame.origin.y = CGRectGetMaxY(interviewInfoView.frame) + Margin;
    bgView1.frame = frame;
    
    personInfoLb.text = dataModal.quizzerIntro;
    [personInfoLb sizeToFit];
    
    frame = bgView.frame;
    frame.origin.y = CGRectGetMaxY(bgView1.frame) + Margin;
    frame.size.height = CGRectGetMaxY(personInfoLb.frame) + 5;
    bgView.frame = frame;
    
    //设置tipLb1的frame
    frame = tipsLb1.frame;
    frame.origin.y = CGRectGetMaxY(bgView.frame) + Margin;
    tipsLb1.frame = frame;
    
    if (regionArray.count > 0) {
        timeAndPlaceView.hidden = NO;
        [self setInterviewPlaceViewWith:regionArray interviewModal:dataModal];
        
        frame = timeAndPlaceView.frame;
        frame.origin.y = CGRectGetMaxY(tipsLb1.frame) + Margin;
        timeAndPlaceView.frame = frame;
    }
    else
    {
        timeAndPlaceView.hidden = YES;
    }
    
    CGRect feedbackViewFrame = feedbackView.frame;
    feedbackViewFrame.size.width = ScreenWidth - 2*LeadMargin;
    feedbackView.frame = feedbackViewFrame;
    
    [DetailBgView addSubview:feedbackView];
    feedbackView.hidden = YES;
    
    CGRect detailViewFrame = DetailBgView.frame;
    if ([dataModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_])
    {//约谈发起者
        
        personTip.text = @"我的情况";
        goPayView.hidden = YES;
        frame = self.scrollView_.frame;
        frame.size.height = ScreenHeight - 64;
        self.scrollView_.frame = frame;
        
        nameLb.text = [NSString stringWithFormat:@"%@",dataModal.dis_personName];
        [personImg sd_setImageWithURL:[NSURL URLWithString:dataModal.dis_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        
        if ([dataModal.payStatus isEqualToString:@"100"])
        {//表示已支付
            tipsLb1.text = @"你已支付成功，可私信与行家沟通约谈具体事宜";
            CGRect  tipsFrame = tipsLb1.frame;
            tipsFrame.size.height = 18;
            tipsLb1.frame = tipsFrame;
            
            CGRect pframe = timeAndPlaceView.frame;
            pframe.origin.y = CGRectGetMaxY(tipsLb1.frame) + 10;
            timeAndPlaceView.frame = pframe;
            
            feedbackView.hidden = NO;
            frame = feedbackView.frame;
            frame.origin.y = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
            frame.origin.x = 8;
            feedbackView.frame = frame;
        }
        
        switch ([dataModal.status integerValue]) {
            case 0:
            {
                redPoint1.image = [UIImage imageNamed:@"ico_select_on.png"];
                applyLb.textColor = [UIColor redColor];
                redLine1.backgroundColor = [UIColor redColor];
                
                tipsLb1.hidden = YES;
                timeAndPlaceView.hidden = YES;
                
                detailViewFrame.size.height = CGRectGetMaxY(bgView.frame) + Margin;
                
                frame = self.scrollView_.frame;
                frame.size.height = ScreenHeight - 64 - 40;
                self.scrollView_.frame = frame;
                
                goPayView.hidden = NO;
                frame = cancelOrderBtn.frame;
                frame.size.width = ScreenWidth;
                cancelOrderBtn.frame = frame;
                [goPayView bringSubviewToFront:cancelOrderBtn];
            }
                break;
            case 1:
            {
                goPayView.hidden = NO;
                frame = self.scrollView_.frame;
                frame.size.height = ScreenHeight - 64 - 40;
                self.scrollView_.frame = frame;
                
                redPoint1.image = [UIImage imageNamed:@"ico_select_on.png"];
                applyLb.textColor = [UIColor redColor];
                redLine1.backgroundColor = [UIColor redColor];
                
                redPoint2.image = [UIImage imageNamed:@"ico_select_on.png"];
                acceptLb.textColor = [UIColor redColor];
                redLine2.backgroundColor = [UIColor redColor];
                
                detailViewFrame.size.height = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
                
                if ([dataModal.payStatus isEqualToString:@"100"])
                {//表示已支付
                    chatBtn.hidden = NO;
                    goPayView.hidden = YES;
                    feedbackView.hidden = NO;
                    detailViewFrame.size.height = CGRectGetMaxY(feedbackView.frame) + Margin;
                    
                    redPoint3.image = [UIImage imageNamed:@"ico_select_on.png"];
                    payLb.textColor = [UIColor redColor];
                    redLine3.backgroundColor = [UIColor redColor];

                    [self.view addSubview:finishBtn];
                    frame = finishBtn.frame;
                    frame.origin.x = goPayView.frame.origin.x;
                    frame.origin.y = goPayView.frame.origin.y;
                    frame.size.width = ScreenWidth;
                    finishBtn.frame = frame;
                }
            }
                break;
            case 5:
            {
                chatBtn.hidden = NO;
                
                redPoint1.image = [UIImage imageNamed:@"ico_select_on.png"];
                applyLb.textColor = [UIColor redColor];
                redLine1.backgroundColor = [UIColor redColor];
                
                redPoint2.image = [UIImage imageNamed:@"ico_select_on.png"];
                acceptLb.textColor = [UIColor redColor];
                redLine2.backgroundColor = [UIColor redColor];
                
                redPoint3.image = [UIImage imageNamed:@"ico_select_on.png"];
                payLb.textColor = [UIColor redColor];
                redLine3.backgroundColor = [UIColor redColor];
                
                if ([dataModal.user_confirm isEqualToString:@"1"]) {
                    feedbackView.hidden = YES;
                    [feedbackView removeFromSuperview];
                    detailViewFrame.size.height = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
                    
                    redPoint4.image = [UIImage imageNamed:@"ico_select_on.png"];
                    confirmLb.textColor = [UIColor redColor];
                    redLine4.backgroundColor = [UIColor redColor];
                    
                    frame = self.scrollView_.frame;
                    frame.size.height = ScreenHeight - 64 - 40;
                    self.scrollView_.frame = frame;
                    
                    [finishBtn removeFromSuperview];
                    [self.view addSubview:appraiseBtn];
                    frame = appraiseBtn.frame;
                    frame.origin.x = goPayView.frame.origin.x;
                    frame.origin.y = goPayView.frame.origin.y;
                    frame.size.width = ScreenWidth;
                    appraiseBtn.frame = frame;
                    
                    if ([dataModal.isComment isEqualToString:@"1"]) {// 已经评价
                        frame = self.scrollView_.frame;
                        frame.size.height = ScreenHeight - 64;
                        self.scrollView_.frame = frame;
                        [appraiseBtn removeFromSuperview];
                        
                        redPoint5.image = [UIImage imageNamed:@"ico_select_on.png"];
                        appraiseLb.textColor = [UIColor redColor];
                    }
                }
                else
                {
                    feedbackView.hidden = NO;
                    
                    frame = self.scrollView_.frame;
                    frame.size.height = ScreenHeight - 64 - 40;
                    self.scrollView_.frame = frame;
                    
                    [self.view addSubview:finishBtn];
                    frame = acceptBtnView.frame;
                    frame.size.width = ScreenWidth;
                    finishBtn.frame = frame;
                }
            }
                break;
            case 10:
            {
                redPoint1.image = [UIImage imageNamed:@"ico_select_off.png"];
                applyLb.textColor = UIColorFromRGB(0x666666);
                redLine1.backgroundColor = [UIColor lightGrayColor];
                tipsLb1.text = @"由于行家个人原因，拒绝本次约谈，你可关注下其它约谈话题";
            }
                break;
            case 11:
            {
                CGFloat height = 0;
                if (regionArray.count > 0) {
                    height = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
                }
                else
                {
                    height = CGRectGetMaxY(bgView.frame) + Margin;
                    tipsLb1.hidden = YES;
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, height, ScreenWidth - 16, 18)];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = UIColorFromRGB(0x666666);
                label.font = TWEELVEFONT_COMMENT;
                label.text = @"您已取消该订单";
                [DetailBgView addSubview:label];
                
                detailViewFrame.size.height = CGRectGetMaxY(label.frame) + Margin;
            }
                break;
            default:
            {
                redPoint1.image = [UIImage imageNamed:@"ico_select_off.png"];
                applyLb.textColor = UIColorFromRGB(0x666666);
                redLine1.backgroundColor = [UIColor lightGrayColor];
                
                tipsLb1.hidden = YES;
               
                CGRect placeFrame = timeAndPlaceView.frame;
                placeFrame.origin.y = CGRectGetMaxY(bgView.frame) + 10;
                timeAndPlaceView.frame = placeFrame;
            }
                break;
        }
    }
    else
    {//被约谈者
        personTip.text = @"来询者的情况";
        
        goPayView.hidden = YES;
        
        frame = self.scrollView_.frame;
        frame.size.height = ScreenHeight - 64;
        self.scrollView_.frame = frame;
        
        [DetailBgView addSubview:phoneBgView];
        frame = phoneBgView.frame;
        frame.origin.x = 8;
        frame.origin.y = CGRectGetMaxY(bgView.frame) + Margin;
        frame.size.width = ScreenWidth - 2*LeadMargin;
        phoneBgView.frame = frame;
        
        phoneNumLb.text = dataModal.phoneNum;
        
        frame = tipsLb1.frame;
        frame.origin.y = CGRectGetMaxY(phoneBgView.frame) + Margin;
        tipsLb1.frame = frame;
        
        nameLb.text = [NSString stringWithFormat:@"%@",dataModal.user_name];
        [personImg sd_setImageWithURL:[NSURL URLWithString:dataModal.user_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        
        CGRect imgFrame = personImg.frame;
        imgFrame.origin.x = 8.0;
        personImg.frame = imgFrame;
        
        imgFrame = nameLb.frame;
        imgFrame.origin.x = CGRectGetMaxX(personImg.frame) + 2;
        nameLb.frame = imgFrame;
        
        tipsLb.text = @"向我发起的约谈";
        
        if ([dataModal.payStatus isEqualToString:@"100"])
        {//表示已支付
            tipsLb1.hidden = NO;
            tipsLb1.text = @"来询者已付费，可私信沟通约谈具体事宜";
            CGRect  tipsFrame = tipsLb1.frame;
            tipsFrame.size.height = 15;
            tipsLb1.frame = tipsFrame;
            
            CGRect pframe = timeAndPlaceView.frame;
            pframe.origin.y = CGRectGetMaxY(tipsLb1.frame) + 10;
            timeAndPlaceView.frame = pframe;
            
            feedbackView.hidden = NO;
            frame = feedbackView.frame;
            frame.origin.y = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
            frame.origin.x = 8;
            feedbackView.frame = frame;
            
            [refundBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            refundBtn.userInteractionEnabled = NO;
        }
        
        switch ([dataModal.status integerValue]) {
            case 0:
            {//未接受约谈
                acceptBtnView.hidden = NO;
                frame = self.scrollView_.frame;
                frame.size.height = ScreenHeight - 64 - 40;
                self.scrollView_.frame = frame;
                
                redPoint1.image = [UIImage imageNamed:@"ico_select_on.png"];
                applyLb.textColor = [UIColor redColor];
                redLine1.backgroundColor = [UIColor redColor];
                
                tipsLb1.hidden = YES;
                timeAndPlaceView.hidden = YES;
                
                detailViewFrame.size.height = CGRectGetMaxY(phoneBgView.frame) + Margin;
            }
                break;
            case 1:
            {//接受约谈，来询者未付款
                acceptBtnView.hidden = YES;
                frame = self.scrollView_.frame;
                frame.size.height = ScreenHeight - 64;
                self.scrollView_.frame = frame;
                
                tipsLb1.hidden = YES;
                CGRect pFrame = timeAndPlaceView.frame;
                pFrame.origin.y = CGRectGetMaxY(phoneBgView.frame) + Margin;
                timeAndPlaceView.frame = pFrame;
                
                pFrame = feedbackView.frame;
                pFrame.origin.y = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
                feedbackView.frame = pFrame;
                
                redPoint1.image = [UIImage imageNamed:@"ico_select_on.png"];
                applyLb.textColor = [UIColor redColor];
                redLine1.backgroundColor = [UIColor redColor];
                
                redPoint2.image = [UIImage imageNamed:@"ico_select_on.png"];
                acceptLb.textColor = [UIColor redColor];
                redLine2.backgroundColor = [UIColor redColor];
                
                detailViewFrame.size.height = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
                
                if ([dataModal.payStatus isEqualToString:@"100"])
                {//表示已支付
                    chatBtn.hidden = NO;
                    feedbackView.hidden = NO;
                    detailViewFrame.size.height = CGRectGetMaxY(feedbackView.frame) + Margin;
                    
                    redPoint3.image = [UIImage imageNamed:@"ico_select_on.png"];
                    payLb.textColor = [UIColor redColor];
                    redLine3.backgroundColor = [UIColor redColor];
                    
                    frame = self.scrollView_.frame;
                    frame.size.height = ScreenHeight - 64 - 40;
                    self.scrollView_.frame = frame;
                    
                    [self.view addSubview:finishBtn];
                    frame = finishBtn.frame;
                    frame.origin.x = goPayView.frame.origin.x;
                    frame.origin.y = goPayView.frame.origin.y;
                    frame.size.width = ScreenWidth;
                    finishBtn.frame = frame;
                }
            }
                break;
            case 5:
            {//表示至少有一个确认
                chatBtn.hidden = NO;
                
                redPoint1.image = [UIImage imageNamed:@"ico_select_on.png"];
                applyLb.textColor = [UIColor redColor];
                redLine1.backgroundColor = [UIColor redColor];
                
                redPoint2.image = [UIImage imageNamed:@"ico_select_on.png"];
                acceptLb.textColor = [UIColor redColor];
                redLine2.backgroundColor = [UIColor redColor];
                
                redPoint3.image = [UIImage imageNamed:@"ico_select_on.png"];
                payLb.textColor = [UIColor redColor];
                redLine3.backgroundColor = [UIColor redColor];
                
                if ([dataModal.dis_confirm isEqualToString:@"1"]) {//
                    feedbackView.hidden = YES;
                    [feedbackView removeFromSuperview];
                    detailViewFrame.size.height = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
                    
                    redPoint4.image = [UIImage imageNamed:@"ico_select_on.png"];
                    confirmLb.textColor = [UIColor redColor];
                    redLine4.backgroundColor = [UIColor redColor];
                    
                    if ([dataModal.isComment isEqualToString:@"1"]) {//已评价
                        redPoint5.image = [UIImage imageNamed:@"ico_select_on.png"];
                        appraiseLb.textColor = [UIColor redColor];
                    }
                }
                else
                {
                    feedbackView.hidden = NO;
                    detailViewFrame.size.height = CGRectGetMaxY(feedbackView.frame) + Margin;
                    
                    frame = self.scrollView_.frame;
                    frame.size.height = ScreenHeight - 64 - 40;
                    self.scrollView_.frame = frame;
                    
                    [self.view addSubview:finishBtn];
                    frame = acceptBtnView.frame;
                    frame.size.width = ScreenWidth;
                    finishBtn.frame = frame;
                }
            }
                break;
            case 10:
            {//拒绝约谈
                redPoint1.image = [UIImage imageNamed:@"ico_select_off.png"];
                applyLb.textColor = UIColorFromRGB(0x666666);
                redLine1.backgroundColor = [UIColor lightGrayColor];
                tipsLb1.hidden = NO;
                tipsLb1.text = @"您已拒绝本次约谈";
            }
                break;
            case 11:
            {//来询者取消订单
                CGFloat height = 0;
                if (regionArray.count > 0) {
                    height = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
                }
                else
                {
                    height = CGRectGetMaxY(phoneBgView.frame) + Margin;
                    tipsLb1.hidden = YES;
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, height, ScreenWidth - 16, 18)];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = UIColorFromRGB(0x666666);
                label.font = TWEELVEFONT_COMMENT;
                label.text = @"来询者已取消订单";
                [DetailBgView addSubview:label];
                
                detailViewFrame.size.height = CGRectGetMaxY(label.frame) + Margin;
            }
                break;
            default:
            {
                tipsLb1.hidden = YES;
                CGRect tFrame = timeAndPlaceView.frame;
                tFrame.origin.y = CGRectGetMaxY(phoneBgView.frame) + 10;
                timeAndPlaceView.frame = tFrame;
                
                redPoint1.image = [UIImage imageNamed:@"ico_select_off.png"];
                applyLb.textColor = UIColorFromRGB(0x666666);
                redLine1.backgroundColor = [UIColor lightGrayColor];
            }
                break;
        }
    }
    
    DetailBgView.frame = detailViewFrame;
    
    if (dataModal.refund_id != nil) {
        feedbackView.hidden = NO;
        frame = feedbackView.frame;
        frame.origin.y = CGRectGetMaxY(timeAndPlaceView.frame) + Margin;
        frame.origin.x = 8;
        feedbackView.frame = frame;
        
        [refundBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        refundBtn.userInteractionEnabled = NO;
        [self refundStatus:dataModal];
    }
    
    [nameLb sizeToFit];
    if (nameLb.frame.size.height < 24) {
        frame = nameLb.frame;
        frame.size.height = 24;
        nameLb.frame = frame;
    }
    
    frame = tipsLb.frame;
    frame.origin.x = CGRectGetMaxX(nameLb.frame) + 1;
    tipsLb.frame = frame;
    
    CGFloat height = DetailBgView.frame.size.height + 70;
    self.scrollView_.contentSize = CGSizeMake(ScreenWidth, height);
    
    self.view.hidden = NO;
    
    CGFloat Interval = self.scrollView_.contentSize.height - self.scrollView_.bounds.size.height;
    if (Interval > 0) {
        self.scrollView_.contentOffset = CGPointMake(0, self.scrollView_.contentSize.height - self.scrollView_.bounds.size.height);
    }
}

//申请退款状态
- (void)refundStatus:(ELAspectantDiscuss_Modal *)dataModal
{
    finishBtn.hidden = YES;
    CGRect scrollFrame = self.scrollView_.frame;
    scrollFrame.size.height = ScreenHeight - 64;
    self.scrollView_.frame = scrollFrame;
    
    if ([dataModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_]) {
        [DetailBgView addSubview:ytzRefundView];
        CGRect frame = ytzRefundView.frame;
        frame.origin.y = CGRectGetMaxY(feedbackView.frame) + Margin;
        frame.origin.x = 8;
        frame.size.width = ScreenWidth - 2*LeadMargin;
        ytzRefundView.frame = frame;
        
        //退款状态 0申请中 1同意退款（行家） 3拒绝退款（行家）100已退款（行家同意） 110已申诉 120调解成功（已退款给用户） 130调解失败（打钱给行家）
        switch ([dataModal.refund_status integerValue]) {
            case 0:
            {//申请中
                [self YTZRefundStatus:1 aspModel:dataModal];
            }
                break;
            case 1:
            {//同意退款
                [self YTZRefundStatus:2 aspModel:dataModal];
            }
                break;
            case 3:
            {//拒绝退款
                [self YTZRefundStatus:2 aspModel:dataModal];
            }
                break;
            case 110:
            {//已申诉
                [self YTZRefundStatus:3 aspModel:dataModal];
            }
                break;
            case 120:
            {//调解成功（已退款给用户）
                [self YTZRefundStatus:4 aspModel:dataModal];
            }
                break;
            case 130:
            {//调解失败（打钱给行家）
                [self YTZRefundStatus:4 aspModel:dataModal];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        [DetailBgView addSubview:bytzRefundView];
        CGRect frame = bytzRefundView.frame;
        frame.origin.y = CGRectGetMaxY(feedbackView.frame) + Margin;
        frame.origin.x = 8;
        frame.size.width = ScreenWidth - 2*LeadMargin;
        bytzRefundView.frame = frame;
        
        refundReasonLb2.text = [NSString stringWithFormat:@"申请退款的原因：%@",dataModal.refund_reason];
        [refundReasonLb2 sizeToFit];
        refundTimeLb2.text = dataModal.apply_idatetime;
       
        //退款状态 0申请中 1同意退款（行家） 3拒绝退款（行家）100已退款（行家同意） 110已申诉 120调解成功（已退款给用户） 130调解失败（打钱给行家）
        if ([dataModal.refund_status isEqualToString:@"0"]) {
            //申请中
            frame = agreeRefundBtn.frame;
            frame.origin.y = CGRectGetMaxY(refundReasonLb2.frame) + 8;
            agreeRefundBtn.frame = frame;
            
            frame = noRefundBtn.frame;
            frame.origin.y = CGRectGetMaxY(refundReasonLb2.frame) + 8;
            noRefundBtn.frame = frame;
            
            frame = bytzRefundView.frame;
            frame.size.height = CGRectGetMaxY(agreeRefundBtn.frame) + 8;
            bytzRefundView.frame = frame;
            
        }
        else
        {
            agreeRefundBtn.hidden = YES;
            noRefundBtn.hidden = YES;
            refundTimeLb2.hidden = YES;
            refundReasonLb2.hidden = YES;
            
            CGRect titleFrame = refundTitleLb.frame;
            titleFrame.origin.x = 98;
            refundTitleLb.frame = titleFrame;
            
            switch ([dataModal.refund_status integerValue]) {
                case 1:
                {//同意退款
                    [self BYTZRefundStatus:2 aspModel:dataModal];
                }
                    break;
                case 3:
                {//拒绝退款
                    [self BYTZRefundStatus:2 aspModel:dataModal];
                }
                    break;
                case 110:
                {//已申诉
                    [self BYTZRefundStatus:3 aspModel:dataModal];
                }
                    break;
                case 120:
                {//调解成功（已退款给用户）
                    [self BYTZRefundStatus:4 aspModel:dataModal];
                }
                    break;
                case 130:
                {//调解失败（打钱给行家）
                    [self BYTZRefundStatus:4 aspModel:dataModal];
                }
                    break;
                default:
                    break;
            }
        }
        
        frame = DetailBgView.frame;
        frame.size.height = CGRectGetMaxY(bytzRefundView.frame) + 8;
        DetailBgView.frame = frame;
    }
}

#pragma mark - 约谈者申请退款状态
- (void)YTZRefundStatus:(NSInteger)statuCount aspModel:(ELAspectantDiscuss_Modal *)aspModel
{
    CGFloat labelHeight = 0;
    CGFloat dateLbHeight = 0;
    CGFloat firstPointH = 0;
    CGFloat lastPointH = 0;
    
    NSArray *statuStrArr;
    NSArray *dateArray;
    
    if (refundStatuView) {
        [refundStatuView removeFromSuperview];
    }
    
    refundStatuView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 304, 120)];
    [ytzRefundView addSubview:refundStatuView];
    
    if ([aspModel.refund_status isEqualToString:@"1"]) {//同意退款
        statuStrArr = [[NSArray alloc] initWithObjects:@"您的退款申请已提交",@"行家已接受申请，我们会在7个工作日内进行退款处理", nil];
        dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.acceptRefuseTime, nil];
    }
    else
    {
        if ([aspModel.refund_status isEqualToString:@"120"]) {
            statuStrArr = [[NSArray alloc] initWithObjects:@"您的退款申请已提交",@"行家拒绝您的退款申请，你可在7个工作日内提出",@"您已提出申诉，一览会尽快进行调解，若有疑",@"申诉调解成功，请随时留意到账情况", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime,aspModel.refund_idatetime, nil];
        }
        else if ([aspModel.refund_status isEqualToString:@"130"])
        {
            statuStrArr = [[NSArray alloc] initWithObjects:@"您的退款申请已提交",@"行家拒绝您的退款申请，你可在7个工作日内提出",@"您已提出申诉，一览会尽快进行调解，若有疑",@"申诉调解失败，一览对此深表歉意，期待与你的下次约谈", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime,aspModel.refund_idatetime, nil];
        }
        else
        {
            statuStrArr = [[NSArray alloc] initWithObjects:@"您的退款申请已提交",@"行家拒绝您的退款申请，你可在7个工作日内提出",@"您已提出申诉，一览会尽快进行调解，若有疑", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime, nil];
        }
    }
    
    for (NSInteger i = 0; i < statuCount; i++) {
        
        UILabel *statuDateLb = [[UILabel alloc] initWithFrame:CGRectMake(25, dateLbHeight, 250, 18)];
        statuDateLb.text = [dateArray objectAtIndex:i];;
        statuDateLb.font = TWEELVEFONT_COMMENT;
        statuDateLb.textColor = UIColorFromRGB(0x666666);
        [refundStatuView addSubview:statuDateLb];
        labelHeight = CGRectGetMaxY(statuDateLb.frame);
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, labelHeight, 260, 18)];
        label1.text = [statuStrArr objectAtIndex:i];
        label1.font = TWEELVEFONT_COMMENT;
        label1.textColor = UIColorFromRGB(0x666666);
        label1.numberOfLines = 0;
        [label1 sizeToFit];
        [refundStatuView addSubview:label1];
        dateLbHeight = CGRectGetMaxY(label1.frame) + 10;

        if (i == 1) {
            if (![aspModel.refund_status isEqualToString:@"1"]) {
                shenSuBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label1.frame), 48, 18)];
                [shenSuBtn setTitle:@"[申诉]" forState:UIControlStateNormal];
                shenSuBtn.titleLabel.font = TWEELVEFONT_COMMENT;
                [shenSuBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [shenSuBtn addTarget:self action:@selector(shenSuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [refundStatuView addSubview:shenSuBtn];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(68, CGRectGetMaxY(label1.frame), 100, 18)];
                label2.text = @"，让一览进行调解";
                label2.font = TWEELVEFONT_COMMENT;
                label2.textColor = UIColorFromRGB(0x666666);
                [refundStatuView addSubview:label2];
                
                dateLbHeight = CGRectGetMaxY(label2.frame) + 10;
            }
        }
        
        if (i == 2) {
            [shenSuBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            shenSuBtn.userInteractionEnabled = NO;
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label1.frame), 62, 18)];
            label2.text = @"问，可私信";
            label2.font = TWEELVEFONT_COMMENT;
            label2.textColor = UIColorFromRGB(0x666666);
            [refundStatuView addSubview:label2];
            
            dateLbHeight = CGRectGetMaxY(label2.frame) + 10;
            
            CGRect btnFrame = helperBtn.frame;
            btnFrame.origin.x = 87;
            btnFrame.origin.y = CGRectGetMaxY(label1.frame);
            helperBtn.frame = btnFrame;
            [refundStatuView addSubview:helperBtn];
        }
        
        UIImageView *pointImgv = [[UIImageView alloc] initWithFrame:CGRectMake(8, statuDateLb.center.y, 10, 10)];
        if (i == statuCount - 1) {
            pointImgv.image = [UIImage imageNamed:@"applayGrayCircle.png"];
        }
        else
        {
            pointImgv.image = [UIImage imageNamed:@"applayGrayCircle.png"];
        }
        [refundStatuView addSubview:pointImgv];
        
        
        if (i == 0) {
            firstPointH = CGRectGetMaxY(pointImgv.frame);
        }
        else if (i == statuCount - 1)
        {
            lastPointH = pointImgv.frame.origin.y;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(pointImgv.center.x, firstPointH, 1, lastPointH - firstPointH)];
            lineView.backgroundColor = UIColorFromRGB(0xC8C8C8);
            [refundStatuView addSubview:lineView];
            [refundStatuView sendSubviewToBack:lineView];
        }
    }
    
    CGRect frame = refundStatuView.frame;
    frame.size.height = dateLbHeight + 8;
    refundStatuView.frame = frame;
    
    frame = ytzRefundView.frame;
    frame.size.height = CGRectGetMaxY(refundStatuView.frame);
    ytzRefundView.frame = frame;
    
    frame = DetailBgView.frame;
    frame.size.height = CGRectGetMaxY(ytzRefundView.frame) + 8;
    DetailBgView.frame = frame;
}

- (void)shenSuBtnClick:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"提交申诉后，一览小助手会协助调解此次约谈，确认提交申诉？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1001;
    [alertView show];
    
}

#pragma mark - 被约谈者退款状态
- (void)BYTZRefundStatus:(NSInteger)statuCount aspModel:(ELAspectantDiscuss_Modal *)aspModel
{
    CGFloat labelHeight = 0;
    CGFloat dateLbHeight = 0;
    CGFloat firstPointH = 0;
    CGFloat lastPointH = 0;
    
    NSArray *statuStrArr;
    NSArray *dateArray;
    
    if (refundStatuView) {
        [refundStatuView removeFromSuperview];
    }
    
    refundStatuView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 304, 120)];
    [bytzRefundView addSubview:refundStatuView];
    
    if ([aspModel.refund_status isEqualToString:@"1"]) {//同意退款
        statuStrArr = [[NSArray alloc] initWithObjects:@"来询者申请退款",@"您已同意来询者的退款申请", nil];
        dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.acceptRefuseTime, nil];
    }
    else
    {
        if ([aspModel.refund_status isEqualToString:@"120"]) {
            statuStrArr = [[NSArray alloc] initWithObjects:@"来询者申请退款",@"您已拒绝来询者的退款申请",@"来询者提出申诉,一览会尽快进行调解,若有疑",@"申诉调解成功,款项将退还给来询者", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime,aspModel.refund_idatetime, nil];
        }
        else if ([aspModel.refund_status isEqualToString:@"130"])
        {
            statuStrArr = [[NSArray alloc] initWithObjects:@"来询者申请退款",@"您已拒绝来询者的退款申请",@"来询者提出申诉,一览会尽快进行调解,若有疑",@"申诉调解失败，款项将到达您的账户", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime,aspModel.refund_idatetime, nil];
        }
        else
        {
            statuStrArr = [[NSArray alloc] initWithObjects:@"来询者申请退款",@"您已拒绝来询者的退款申请",@"来询者提出申诉,一览会尽快进行调解,若有疑", nil];
             dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime, nil];
        }
        
    }
    
    for (NSInteger i = 0; i < statuCount; i++) {
        
        UILabel *statuDateLb = [[UILabel alloc] initWithFrame:CGRectMake(25, dateLbHeight, 250, 18)];
        statuDateLb.text = [dateArray objectAtIndex:i];;
        statuDateLb.font = TWEELVEFONT_COMMENT;
        statuDateLb.textColor = UIColorFromRGB(0x666666);
        [refundStatuView addSubview:statuDateLb];
        labelHeight = CGRectGetMaxY(statuDateLb.frame);
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, labelHeight, 260, 18)];
        label1.text = [statuStrArr objectAtIndex:i];
        label1.font = TWEELVEFONT_COMMENT;
        label1.textColor = UIColorFromRGB(0x666666);
        label1.numberOfLines = 0;
        [label1 sizeToFit];
        [refundStatuView addSubview:label1];
        dateLbHeight = CGRectGetMaxY(label1.frame) + 10;
        
        if (i == 2) {
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label1.frame), 62, 18)];
            label2.text = @"问，可私信";
            label2.font = TWEELVEFONT_COMMENT;
            label2.textColor = UIColorFromRGB(0x666666);
            [refundStatuView addSubview:label2];
            
            dateLbHeight = CGRectGetMaxY(label2.frame) + 10;
            
            CGRect btnFrame = helperBtn.frame;
            btnFrame.origin.x = 87;
            btnFrame.origin.y = CGRectGetMaxY(label1.frame);
            helperBtn.frame = btnFrame;
            [refundStatuView addSubview:helperBtn];
        }
        
        UIImageView *pointImgv = [[UIImageView alloc] initWithFrame:CGRectMake(8, statuDateLb.center.y, 10, 10)];
        if (i == statuCount - 1) {
            pointImgv.image = [UIImage imageNamed:@"applayGrayCircle.png"];
        }
        else
        {
            pointImgv.image = [UIImage imageNamed:@"applayGrayCircle.png"];
        }
        [refundStatuView addSubview:pointImgv];
        
        
        if (i == 0) {
            firstPointH = CGRectGetMaxY(pointImgv.frame);
        }
        else if (i == statuCount - 1)
        {
            lastPointH = pointImgv.frame.origin.y;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(pointImgv.center.x, firstPointH, 1, lastPointH - firstPointH)];
            lineView.backgroundColor = UIColorFromRGB(0xC8C8C8);
            [refundStatuView addSubview:lineView];
            [refundStatuView sendSubviewToBack:lineView];
        }
    }
    
    CGRect frame = refundStatuView.frame;
    frame.size.height = dateLbHeight + 8;
    refundStatuView.frame = frame;
    
    frame = bytzRefundView.frame;
    frame.size.height = CGRectGetMaxY(refundStatuView.frame);
    bytzRefundView.frame = frame;
}

#pragma mark - 显示行家提供的时间、地点
- (void)setInterviewPlaceViewWith:(NSMutableArray *)placeArray interviewModal:(ELAspectantDiscuss_Modal *)interModal
{
    CGFloat height = 30;
    selectedTimeArr = [[NSMutableArray alloc] init];
    chooseBtnArr = [[NSMutableArray alloc] init];
    
    CGFloat imgMarGinX = 8;
    CGFloat lbMarginX = 28;
    
    for (UIView *view in placeViewArr) {
        [view removeFromSuperview];
    }
    if (placeViewArr.count > 0) {
        [placeViewArr removeAllObjects];
    }
    
    NSInteger isSelectNum = 0;
    if ([interModal.payStatus isEqualToString:@"100"]) {
        for (ELAspectantDiscuss_Modal *modal in regionArray) {
            if ([modal.ydyrIsmain isEqualToString:@"0"]) {
                isSelectNum ++;
            }
        }
        
        UIView *interviewPlaceView = [[UIView alloc] initWithFrame:CGRectMake(8, height, (timeAndPlaceView.frame.size.width - 2*LeadMargin), 55)];
        interviewPlaceView.backgroundColor = [UIColor clearColor];
        interviewPlaceView.layer.cornerRadius = 8.0;
        interviewPlaceView.layer.borderWidth = 1.0;
        interviewPlaceView.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
        [timeAndPlaceView addSubview:interviewPlaceView];
        [placeViewArr addObject:interviewPlaceView];
        
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
            ELAspectantDiscuss_Modal *modal = [regionArray firstObject];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgMarGinX, 33, 12, 12)];
            imageView.image = [UIImage imageNamed:@"interview_time.png"];
            [interviewPlaceView addSubview:imageView];
            
            timeLb.text = modal.ydyrDatetime;
            placeLb.text = modal.region;
            
        }
        
        CGRect frame;
        frame = timeAndPlaceView.frame;
        frame.size.height = CGRectGetMaxY(interviewPlaceView.frame) + Margin;
        timeAndPlaceView.frame = frame;
    }
    else
    {//未支付
        NSInteger count;
        if ([interModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_])
        {//约谈发起者
            count = placeArray.count + 1;
        }
        else
        {
            count = placeArray.count;
        }
        
        for (NSInteger i = 0; i < count; i++) {
            ELAspectantDiscuss_Modal *modal = [[ELAspectantDiscuss_Modal alloc] init];
            if (i < placeArray.count) {
                modal = [regionArray objectAtIndex:i];
            }
            
            UIView *interviewPlaceView = [[UIView alloc] initWithFrame:CGRectMake(8, height, (timeAndPlaceView.frame.size.width - 2*LeadMargin), 55)];
            interviewPlaceView.backgroundColor = [UIColor clearColor];
            interviewPlaceView.layer.cornerRadius = 8.0;
            interviewPlaceView.layer.borderWidth = 1.0;
            interviewPlaceView.tag = 10000 + i;
            interviewPlaceView.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
            [timeAndPlaceView addSubview:interviewPlaceView];
            [placeViewArr addObject:interviewPlaceView];
            
            if ([interModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_])
            {//约谈发起者
                CGFloat btnX = CGRectGetMaxX(interviewPlaceView.frame) - LeadMargin - 18 - 9;
                UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 14, 18, 18)];
                [chooseBtn setImage:[UIImage imageNamed:@"interview_no_select.png"] forState:UIControlStateNormal];
                [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                chooseBtn.tag = 10000 + i;
                [interviewPlaceView addSubview:chooseBtn];
                [chooseBtnArr addObject:chooseBtn];
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
            else
            {
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
            else
            {
                placeLb.text = modal.region;
            }
            
            placeLb.textColor = UIColorFromRGB(0x333333);
            placeLb.font = TWEELVEFONT_COMMENT;
            [interviewPlaceView addSubview:placeLb];
            
            [selectedTimeArr addObject:modal];
            height = CGRectGetMaxY(interviewPlaceView.frame) + 8;
            
            CGRect frame;
            frame = timeAndPlaceView.frame;
            frame.size.height = height;
            timeAndPlaceView.frame = frame;
        }
    }
}

//用户选择时间地点 按钮点击事件
- (void)chooseBtnClick:(UIButton *)sender
{
    for (UIButton *btn in chooseBtnArr) {
        if (btn.tag == sender.tag) {
            [sender setImage:[UIImage imageNamed:@"interview_select.png"] forState:UIControlStateNormal];
            ELAspectantDiscuss_Modal *modal = [selectedTimeArr objectAtIndex:sender.tag - 10000];
            if (modal.ydyrId == nil) {
                modal.ydyrId = @"";
            }
            selectedYdyrStr = modal.ydyrId;
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"interview_no_select.png"] forState:UIControlStateNormal];
        }
    }
}
 
- (void)btnResponse:(id)sender
{
    if (sender == goPayBtn) {//用户支付
        if (selectedYdyrStr == nil) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请选择时间和地点"];
            self.scrollView_.contentOffset = CGPointMake(0, self.scrollView_.contentSize.height - self.scrollView_.bounds.size.height);
        }
        else
        {
            isRerfesh = YES;
            [Manager shareMgr].yuetanBackCtl = self;
            [self payInterviewCourse];
           
        }
    }
    else if (sender == cancelOrderBtn)
    {//用户取消订单
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定取消该订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        [alertView show];
    }
    else if (sender == chatBtn)
    {//私信
        isRerfesh = YES;
        MessageDailogListCtl *messageCtl = [[MessageDailogListCtl alloc] init];
        MessageContact_DataModel *contactModal = [[MessageContact_DataModel alloc] init];
        
        if ([aspDataModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_]) {
            contactModal.userId = aspDataModal.dis_personId;
            contactModal.userIname = aspDataModal.dis_personName;
        }else
        {//被约谈者
            contactModal.userId = aspDataModal.user_personId;
            contactModal.userIname = aspDataModal.user_name;
        }
        messageCtl.productType = @"1";
        messageCtl.recordId = aspDataModal.recordId;
        [self.navigationController pushViewController:messageCtl animated:YES];
        [messageCtl beginLoad:contactModal exParam:nil];
    }
}

#pragma mark - 行家接受或拒绝约谈
- (IBAction)acceptBtnClick:(id)sender {
    if (sender == acceptBtn) {
        isRerfesh = YES;
        ELAddInterviewRegionCtl *ctl = [[ELAddInterviewRegionCtl alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:aspDataModal exParam:nil];
    }
    else if (sender == refuseBtn)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否确定拒绝该约谈" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        [alertView show];
    }
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
                NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@",[Manager getUserInfo].userId_,aspDataModal.recordId];
                
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

//评价
- (IBAction)appraiseBtnClick:(id)sender {
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

//反馈卡片 Button
- (IBAction)feedbackBtnClick:(id)sender {
    
    if (sender == refundBtn) {//申请退款
        isRerfesh = YES;
        ELInterviewRefundCtl *refundCtl = [[ELInterviewRefundCtl alloc] init];
        [refundCtl beginLoad:interviewModal exParam:nil];
        [self.navigationController pushViewController:refundCtl animated:YES];
    }
    else if (sender == helperBtn)
    {//一览小助手
        isRerfesh = YES;
        MessageDailogListCtl *messageCtl = [[MessageDailogListCtl alloc] init];
        MessageContact_DataModel *contactModal = [[MessageContact_DataModel alloc] init];
        contactModal.userId = @"15476338";
        contactModal.userIname = @"一览小助手";
        
        [messageCtl beginLoad:contactModal exParam:nil];
        [self.navigationController pushViewController:messageCtl animated:YES];
    }
    
}

- (IBAction)RefundBtnClick:(id)sender {
    
    if (sender == agreeRefundBtn) {
        [self acceptRefundApply];
    }
    else if (sender == noRefundBtn)
    {
        isRerfesh = YES;
        ELRefusedRefundCtl *refundCtl = [[ELRefusedRefundCtl alloc] init];
        [refundCtl beginLoad:interviewModal exParam:nil];
        [self.navigationController pushViewController:refundCtl animated:YES];
        
    }
}

#pragma mark - 数据请求
/**
 * 确认支付
 *
 * @param  interger $person_id    当前用户
 * @param  interger $record_id    生成的约谈记录（使用之前需先执行addYuetan()，然后根据返回值中的["info"]["record_id"]来获取)
 * @param  array    $conditionArr
 * @return 参考原来的ordco_service_comm->addgwc 返回值
 */
- (void)payInterviewCourse
{
    NSString *op = @"yuetan_record_busi";
    NSString *function= @"payMyYuetanCourse";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&conditionArr=%@", [Manager getUserInfo].userId_, aspDataModal.recordId, nil];
    
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

- (void)interviewPaySuccess
{
    if (![selectedYdyrStr isEqualToString:@""]) {
        [self chooseTheTiemAndRegion];
    }
}

/**
 * 用户取消约谈的订单
 * @param  interger $person_id    用户
 * @param  interger $record_id    约谈记录
 * @param  array    外部条件数组
 * @return
 */
- (void)cannelMyCourseRecord
{
    NSString *op = @"yuetan_record_busi";
    NSString *function= @"cannelMyCourseRecord";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&conditionArr=%@", [Manager getUserInfo].userId_, aspDataModal.recordId, nil];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        if ([result[@"status"] isEqualToString:@"OK"])
        {
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
- (void)chooseTheTiemAndRegion
{
    NSString *func = @"chooseTheTiemAndRegion";
    NSString *op = @"yl_daoshi_yuetan_region_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&ydyr_id=%@&conditionArr=%@", [Manager getUserInfo].userId_, aspDataModal.recordId, selectedYdyrStr, nil];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        if ([result[@"status"] isEqualToString:@"OK"])
        {
//            [self payInterviewCourse];
            [self getRecordInfo];
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
- (void)acceptOrrefuseInterview:(NSString *)flag
{
    NSString *op = @"yuetan_record_busi";
    NSString *function= @"hangjiaDoCourseRequest";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"hangjia_id=%@&record_id=%@&deal_type=%@", aspDataModal.dis_personId, aspDataModal.recordId, flag];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        Status_DataModal *dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = result[@"status"];
        dataModal.code_ = result[@"code"];
        dataModal.status_desc = result[@"status_desc"];
        if ([dataModal.code_ isEqualToString:@"201"]){
            [BaseUIViewController showAutoDisappearAlertView:nil msg:@"您已拒绝该约谈！" seconds:1.5];
            tipsLb1.text = @"行家拒绝您的请求，若对处理结果不满意，您可私信一览小助手进行调解";
            [self.navigationController popViewControllerAnimated:YES];
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

/**
 对象：yuetan_refund_busi
 接口：acceptRefundApply
 * 接受退款申请
 * @param   $person_id   integer  用户编号
 * @param   $record_id   integer  约谈编号
 *返回值：array('status'=> 'OK','code'=> 200,'status_desc'=> '确认成功！',);
 **/
- (void)acceptRefundApply
{
    NSString *op = @"yuetan_refund_busi";
    NSString *func = @"acceptRefundApply";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@", aspDataModal.dis_personId, aspDataModal.recordId];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        Status_DataModal *modal = [[Status_DataModal alloc] init];
        modal.status_ = result[@"status"];
        modal.code_ = result[@"code"];
        modal.status_desc = result[@"status_desc"];
        if ([modal.code_ isEqualToString:@"200"]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:modal.status_desc];
            [self getRecordInfo];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:nil msg:modal.status_desc];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

//确认完成
- (IBAction)finishBtnClick:(id)sender {
    
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSString * function = @"finishYuetan";
    NSString * op = @"yuetan_record_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@",userId,aspDataModal.recordId];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        
        Status_DataModal *statusModal = [[Status_DataModal alloc] init];
        
        statusModal.status_ = [dic objectForKey:@"status_desc"];
        statusModal.code_ = [dic objectForKey:@"code"];
        
        if ([statusModal.code_ isEqualToString:@"200"]) {
            if ([interviewModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_]) {
                [self.view addSubview:appraiseBtn];
                [finishBtn removeFromSuperview];
                CGRect frame = finishBtn.frame;
                appraiseBtn.frame = frame;
            }
            else
            {
                [finishBtn removeFromSuperview];
                CGRect frame = self.scrollView_.frame;
                frame.size.height = ScreenHeight - 64;
                self.scrollView_.frame = frame;
            }
            
            [self getRecordInfo];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}

#pragma mark - AddAppraiseViewCtlDelegate
- (void)btnResponeWitnIndex:(NSInteger)index
{
    if (index == 111) {
        
        [self hideView];
        
        if ([addAppraiseView.textView_.text isEqualToString:@""]) {
            [addAppraiseView showTextOnly];
        }
        else
        {
            NSString *userId = [Manager getUserInfo].userId_;
            
            NSString * function = @"addComment";
            NSString * op = @"yuetan_record_busi";
            
            NSMutableDictionary *commentInfoDic = [[NSMutableDictionary alloc] init];
            [commentInfoDic setObject:addAppraiseView.textView_.text forKey:@"content"];
            
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *commentInfoStr = [jsonWriter stringWithObject:commentInfoDic];
            
            NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@&commentInfo=%@",userId,aspDataModal.recordId,commentInfoStr];
            
            [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                NSDictionary *dic = result;
                
                Status_DataModal *statusModal = [[Status_DataModal alloc] init];
                
                statusModal.status_ = [dic objectForKey:@"status_desc"];
                statusModal.code_ = [dic objectForKey:@"code"];
                if ([statusModal.code_ isEqualToString:@"200"]) {
                    [BaseUIViewController showAutoDismissSucessView:nil msg:@"评价成功"];
                    
                    [appraiseBtn removeFromSuperview];
//                    CGRect frame = self.scrollView_.frame;
//                    frame.size.height = screenHeight - 64;
//                    self.scrollView_.frame = frame;
                    
                    [self getRecordInfo];
                }
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                
            }];
        }
    }
    else
    {
        [self hideView];
    }
}

- (void)setTextViewLayout
{
    CGFloat height = 20;
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        height = 100;
    }
    if (addAppraiseView.isEdit)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = addAppraiseView.bgView_.frame;
            frame.origin.y = height;
            addAppraiseView.bgView_.frame = frame;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
