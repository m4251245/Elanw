//
//  ELInterviewRefundView.m
//  jobClient
//
//  Created by YL1001 on 16/8/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELInterviewRefundView.h"
#import "Manager.h"
#import "MLLinkLabel.h"
#import "ELRefusedRefundCtl.h"

@interface ELInterviewRefundView()<MLLinkLabelDelegate,UIAlertViewDelegate>
{
    UIView *_refundStatuView;
    ELAspectantDiscuss_Modal *_aspectantModel;
}
@end

@implementation ELInterviewRefundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

//申请退款状态
- (void)refundStatus:(ELAspectantDiscuss_Modal *)dataModal
{
    _aspectantModel = dataModal;
    
    if ([dataModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_]) {
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.frame.size.width - 16, 18)];
        titleLb.textColor = UIColorFromRGB(0xE4403A);
        titleLb.font = [UIFont systemFontOfSize:14.0f];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = @"申请退款";
        [self addSubview:titleLb];

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
        CGFloat width = self.frame.size.width;
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, width/2 - 16, 18)];
        titleLb.textColor = UIColorFromRGB(0xE4403A);
        titleLb.font = [UIFont systemFontOfSize:14.0f];
        titleLb.text = @"来询者申请退款";
        [self addSubview:titleLb];
        [titleLb sizeToFit];
        
        //退款状态 0申请中 1同意退款（行家） 3拒绝退款（行家）100已退款（行家同意） 110已申诉 120调解成功（已退款给用户） 130调解失败（打钱给行家）
        if ([dataModal.refund_status isEqualToString:@"0"]) {
            //申请中
            
            UILabel *timeLb = [[UILabel alloc] initWithFrame:CGRectMake(width/2, 8, width/2 - 16, 18)];
            timeLb.textColor = UIColorFromRGB(0x666666);
            timeLb.font = [UIFont systemFontOfSize:14.0f];
            timeLb.textAlignment = NSTextAlignmentRight;
            timeLb.text = dataModal.apply_idatetime;
            [self addSubview:timeLb];
            
            UILabel *reasonLb = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(titleLb.frame)+8, width - 16, 18)];
            reasonLb.textColor = UIColorFromRGB(0x666666);
            reasonLb.font = [UIFont systemFontOfSize:12.0f];
            reasonLb.text = [NSString stringWithFormat:@"申请退款的原因：%@",dataModal.refund_reason];
            [reasonLb sizeToFit];
            [self addSubview:reasonLb];
            
            CGFloat btnX = (ScreenWidth - 2*100 - 25)/2;
            
            UIButton *noRefundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            noRefundBtn.frame = CGRectMake(btnX, CGRectGetMaxY(reasonLb.frame) + 8, 100, 32);
            [noRefundBtn setBackgroundColor:[UIColor lightGrayColor]];
            [noRefundBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [noRefundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            noRefundBtn.tag = 100;
            [noRefundBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:noRefundBtn];
            
            UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            agreeBtn.frame = CGRectMake(btnX + 125, CGRectGetMaxY(reasonLb.frame) + 8, 100, 32);
            [agreeBtn setBackgroundColor:UIColorFromRGB(0xE4403A)];
            [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
            [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            agreeBtn.tag = 101;
            [agreeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:agreeBtn];
            
            CGRect frame = self.frame;
            frame.size.height = CGRectGetMaxY(agreeBtn.frame) + 10;
            self.frame = frame;
        }
        else
        {
            CGRect titleFrame = titleLb.frame;
            titleFrame.origin.x = (ScreenWidth - titleLb.frame.size.width)/2;
            titleLb.frame = titleFrame;
            
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
    
    if (_refundStatuView) {
        [_refundStatuView removeFromSuperview];
    }
    
    _refundStatuView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 120)];
    [self addSubview:_refundStatuView];
    
    if ([aspModel.refund_status isEqualToString:@"1"]) {//同意退款
        statuStrArr = [[NSArray alloc] initWithObjects:@"您的退款申请已提交", @"行家已接受申请，我们会在7个工作日内进行退款处理", nil];
        dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.acceptRefuseTime, nil];
    }
    else
    {
        if ([aspModel.refund_status isEqualToString:@"120"]) {
            statuStrArr = [[NSArray alloc] initWithObjects:@"您的退款申请已提交", @"行家拒绝您的退款申请，你可在7个工作日内提出[申诉]", @"您已提出申诉，一览会尽快进行调解，若有疑问，可私信[一览小助手]", @"申诉调解成功，请随时留意到账情况", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime,aspModel.refund_idatetime, nil];
        }
        else if ([aspModel.refund_status isEqualToString:@"130"])
        {
            statuStrArr = [[NSArray alloc] initWithObjects:@"您的退款申请已提交", @"行家拒绝您的退款申请，你可在7个工作日内提出[申诉]", @"您已提出申诉，一览会尽快进行调解，若有疑问，可私信[一览小助手]", @"申诉调解失败，一览对此深表歉意，期待与你的下次约谈", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime,aspModel.refund_idatetime, nil];
        }
        else
        {
            statuStrArr = [[NSArray alloc] initWithObjects:@"您的退款申请已提交", @"行家拒绝您的退款申请，你可在7个工作日内提出[申诉]", @"您已提出申诉，一览会尽快进行调解，若有疑问，可私信[一览小助手]", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime, nil];
        }
    }
    
    for (NSInteger i = 0; i < statuCount; i++) {
        
        MLLinkLabel *statuDateLb = [self LinkLabel];
        statuDateLb.frame = CGRectMake(25, dateLbHeight, _refundStatuView.frame.size.width - 33, 18);
        statuDateLb.text = [dateArray objectAtIndex:i];
        [_refundStatuView addSubview:statuDateLb];
        labelHeight = CGRectGetMaxY(statuDateLb.frame);
        
        MLLinkLabel *statuStrLb = [self LinkLabel];
        statuStrLb.frame = CGRectMake(25, labelHeight, _refundStatuView.frame.size.width - 33, 18);
        
        NSString *statuStr = [statuStrArr objectAtIndex:i];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:statuStr];
        if (i == 1) {
            if (![aspModel.refund_status isEqualToString:@"1"]) {//申诉
                NSRange range = [statuStr rangeOfString:@"[申诉]"];
                [attString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xe4403a), NSLinkAttributeName : @"shensu"} range:NSMakeRange(range.location, range.length)];
            }
        }
        
        if (i == 2) {
            //私信小助手
            NSRange range = [statuStr rangeOfString:@"[一览小助手]"];
            [attString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xe4403a), NSLinkAttributeName : @"xiaozhushou"} range:NSMakeRange(range.location, range.length)] ;
        }
        
        statuStrLb.attributedText = attString;
        [statuStrLb sizeToFit];
        [_refundStatuView addSubview:statuStrLb];
        dateLbHeight = CGRectGetMaxY(statuStrLb.frame) + 10;
        
        UIImageView *pointImgv = [[UIImageView alloc] initWithFrame:CGRectMake(8, statuDateLb.center.y, 10, 10)];
        if (i == statuCount - 1) {
            pointImgv.image = [UIImage imageNamed:@"applayGrayCircle.png"];
        }
        else
        {
            pointImgv.image = [UIImage imageNamed:@"applayGrayCircle.png"];
        }
        [_refundStatuView addSubview:pointImgv];
        
        if (i == 0) {
            firstPointH = CGRectGetMaxY(pointImgv.frame);
        }
        else if (i == statuCount - 1)
        {
            lastPointH = pointImgv.frame.origin.y;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(pointImgv.center.x, firstPointH, 1, lastPointH - firstPointH)];
            lineView.backgroundColor = UIColorFromRGB(0xC8C8C8);
            [_refundStatuView addSubview:lineView];
            [_refundStatuView sendSubviewToBack:lineView];
        }
    }
    
    [self setViewHeight:dateLbHeight + 8];
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
    
    if (_refundStatuView) {
        [_refundStatuView removeFromSuperview];
    }
    
    _refundStatuView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 120)];
    [self addSubview:_refundStatuView];
    
    if ([aspModel.refund_status isEqualToString:@"1"]) {//同意退款
        statuStrArr = [[NSArray alloc] initWithObjects:@"来询者申请退款", @"您已同意来询者的退款申请", nil];
        dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.acceptRefuseTime, nil];
    }
    else
    {
        if ([aspModel.refund_status isEqualToString:@"120"]) {
            statuStrArr = [[NSArray alloc] initWithObjects:@"来询者申请退款", @"您已拒绝来询者的退款申请", @"来询者提出申诉,一览会尽快进行调解,若有疑问，可私信[一览小助手]", @"申诉调解成功,款项将退还给来询者", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime,aspModel.refund_idatetime, nil];
        }
        else if ([aspModel.refund_status isEqualToString:@"130"])
        {
            statuStrArr = [[NSArray alloc] initWithObjects:@"来询者申请退款", @"您已拒绝来询者的退款申请", @"来询者提出申诉,一览会尽快进行调解,若有疑问，可私信[一览小助手]", @"申诉调解失败，款项将到达您的账户", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime,aspModel.refund_idatetime, nil];
        }
        else
        {
            statuStrArr = [[NSArray alloc] initWithObjects:@"来询者申请退款", @"您已拒绝来询者的退款申请", @"来询者提出申诉,一览会尽快进行调解,若有疑问，可私信[一览小助手]", nil];
            dateArray = [[NSArray alloc] initWithObjects:aspModel.apply_idatetime, aspModel.refuse_idatetime,aspModel.appeal_idatetime, nil];
        }
        
    }
    
    for (NSInteger i = 0; i < statuCount; i++) {
        
        MLLinkLabel *statuDateLb = [self LinkLabel];
        statuDateLb.frame = CGRectMake(25, dateLbHeight, _refundStatuView.frame.size.width - 33, 18);
        statuDateLb.text = [dateArray objectAtIndex:i];
        [_refundStatuView addSubview:statuDateLb];
        labelHeight = CGRectGetMaxY(statuDateLb.frame);
        
        MLLinkLabel *statuStrLb = [self LinkLabel];
        statuStrLb.frame = CGRectMake(25, labelHeight, _refundStatuView.frame.size.width - 33, 18);
        
        NSString *statuStr = [statuStrArr objectAtIndex:i];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:statuStr];
        
        if (i == 2) {
            //私信小助手
            NSRange range = [statuStr rangeOfString:@"[一览小助手]"];
            [attString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xe4403a), NSLinkAttributeName : @"xiaozhushou"} range:NSMakeRange(range.location, range.length)] ;
        }
        
        statuStrLb.attributedText = attString;
        [statuStrLb sizeToFit];
        [_refundStatuView addSubview:statuStrLb];
        dateLbHeight = CGRectGetMaxY(statuStrLb.frame) + 10;
        
        UIImageView *pointImgv = [[UIImageView alloc] initWithFrame:CGRectMake(8, statuDateLb.center.y, 10, 10)];
        if (i == statuCount - 1) {
            pointImgv.image = [UIImage imageNamed:@"applayGrayCircle.png"];
        }
        else
        {
            pointImgv.image = [UIImage imageNamed:@"applayGrayCircle.png"];
        }
        [_refundStatuView addSubview:pointImgv];
        
        
        if (i == 0) {
            firstPointH = CGRectGetMaxY(pointImgv.frame);
        }
        else if (i == statuCount - 1)
        {
            lastPointH = pointImgv.frame.origin.y;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(pointImgv.center.x, firstPointH, 1, lastPointH - firstPointH)];
            lineView.backgroundColor = UIColorFromRGB(0xC8C8C8);
            [_refundStatuView addSubview:lineView];
            [_refundStatuView sendSubviewToBack:lineView];
        }
    }
    
    [self setViewHeight:dateLbHeight + 8];
}

- (void)setViewHeight:(CGFloat)dateLbHeight
{
    CGRect frame = _refundStatuView.frame;
    frame.size.height = dateLbHeight + 8;
    _refundStatuView.frame = frame;
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_refundStatuView.frame);
    self.frame = frame;
}

- (MLLinkLabel *)LinkLabel
{
    MLLinkLabel *mlLinkLabel;
    if (!mlLinkLabel) {
        mlLinkLabel = [[MLLinkLabel alloc] init];
        mlLinkLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
        mlLinkLabel.textColor = UIColorFromRGB(0x666666);
        mlLinkLabel.numberOfLines = 0;
        mlLinkLabel.lineHeightMultiple = 0.0f;
        mlLinkLabel.lineSpacing = 3.0f;
        mlLinkLabel.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
        mlLinkLabel.allowLineBreakInsideLinks = YES;
        mlLinkLabel.delegate = self;
    }
    return mlLinkLabel;
}

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    if ([link.linkValue isEqualToString:@"shensu"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"提交申诉后，一览小助手会协助调解此次约谈，确认提交申诉？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1001;
        [alertView show];
    }
    else if ([link.linkValue isEqualToString:@"xiaozhushou"])
    {
        MessageDailogListCtl *messageCtl = [[MessageDailogListCtl alloc] init];
        MessageContact_DataModel *contactModal = [[MessageContact_DataModel alloc] init];
        contactModal.userId = @"15476338";
        contactModal.userIname = @"一览小助手";
        
        [messageCtl beginLoad:contactModal exParam:nil];
        [superController.navigationController pushViewController:messageCtl animated:YES];
    }
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 101) {
        [self acceptRefundApply];
    }
    else if (sender.tag == 100)
    {
        id object = [self nextResponder];
        while (![object isKindOfClass:[UIViewController class]] && object != nil) {
            object = [object nextResponder];
        }
        UIViewController *superController = (UIViewController*)object;
        
        ELRefusedRefundCtl *refundCtl = [[ELRefusedRefundCtl alloc] init];
        [refundCtl beginLoad:_aspectantModel exParam:nil];
        [superController.navigationController pushViewController:refundCtl animated:YES];
        
    }
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
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@", _aspectantModel.dis_personId, _aspectantModel.recordId];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        Status_DataModal *modal = [[Status_DataModal alloc] init];
        modal.status_ = result[@"status"];
        modal.code_ = result[@"code"];
        modal.status_desc = result[@"status_desc"];
        if ([modal.code_ isEqualToString:@"200"]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:modal.status_desc];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDetail" object:nil];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:nil msg:modal.status_desc];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&record_id=%@",[Manager getUserInfo].userId_, _aspectantModel.recordId];
        
        [ELRequest postbodyMsg:bodyMsg op:@"yuetan_refund_busi" func:@"addRefundShenshu" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            
            Status_DataModal *statuModel = [[Status_DataModal alloc] init];
            statuModel.status_ = result[@"status"];
            statuModel.code_ = result[@"code"];
            statuModel.status_desc = result[@"status_desc"];
            if ([statuModel.code_ isEqualToString:@"200"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDetail" object:nil];
            }
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
    }
}

@end
